import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Core/commn_widgets/side_nav/side_nav.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/commn_widgets/side_nav/function_card.dart';
import 'package:new_project/Core/commn_widgets/side_nav/logout_button.dart';
import 'package:new_project/Core/commn_widgets/side_nav/user_header.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/data/repositories/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/add_child.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_child_details_usecase.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_children_usecase.dart';
import 'package:new_project/features/children_managment/presentation/pages/child_vaccinations_page.dart';
import '../../../../features/children_managment/data/model/displayed_child_model.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';
import 'package:new_project/Core/networking/api_services.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart'; // Note: ChildRemoteDataSourceImpl is imported above, this might be for the interface
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ViewChildrenPage extends StatelessWidget {
  const ViewChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.baseUrl = ApiConfig.baseUrl;

    final apiService = ApiServiceManual(dio: dio);
    final ChildRemoteDataSource childRemoteDataSource =
        ChildRemoteDataSourceImpl(apiService);
    final ChildRepository childRepository = ChildRepositoryImpl(
        childRemoteDataSource); // Ensure ChildRepositoryImpl is correctly imported
    final getChildrenUseCase = GetChildrenUseCase(childRepository);
    final getChildDetailsUseCase = GetChildDetailsUseCase(childRepository);
    final addChildUseCase = AddChildUseCase(childRepository);
    return BlocProvider(
      // استرجع ChildCubit المسجل في GetIt
      create: (context) => GetIt.I<ChildCubit>()..fetchChildrenList(),
      child: const ViewChildrenPageContent(),
    );
  }
}

class ViewChildrenPageContent extends StatefulWidget {
  const ViewChildrenPageContent({super.key});

  @override
  State<ViewChildrenPageContent> createState() =>
      _ViewChildrenPageContentState();
}

class _ViewChildrenPageContentState extends State<ViewChildrenPageContent> {
  List<DisplayedChildModel> _allChildren = [];
  List<DisplayedChildModel> _paginatedChildren = [];
  int _apiTotalChildrenCount = 0;
  int _totalDisplayedChildren = 0;

  int _currentPage = 1;
  int _itemsPerPage = 5;
  final List<int> _itemsPerPageOptions = [5, 10, 15, 20];

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {}); // Not strictly needed if using didChangeDependencies or BlocListener
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
        _applyFilterAndPagination();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initial fetch is handled by BlocProvider's create method.
    // This could be used for subsequent fetches if needed, but careful with multiple calls.
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _processLoadedChildren(
      List<DisplayedChildModel> children, int totalCountFromApi) {
    setState(() {
      _allChildren = children;
      _apiTotalChildrenCount = totalCountFromApi;
      _isLoading = false;
      _applyFilterAndPagination();
    });
  }

  void _applyFilterAndPagination() {
    List<DisplayedChildModel> filteredChildren = _allChildren;

    if (_searchTerm.isNotEmpty) {
      filteredChildren = _allChildren.where((child) {
        final searchTermLower = _searchTerm.toLowerCase();
        return child.firstName.toLowerCase().contains(searchTermLower) ||
            child.lastName.toLowerCase().contains(searchTermLower) ||
            child.vaccineCardNumber.toLowerCase().contains(searchTermLower) ||
            child.fatherName.toLowerCase().contains(searchTermLower) ||
            child.motherName.toLowerCase().contains(searchTermLower) ||
            child.nationalityName.toLowerCase().contains(searchTermLower);
      }).toList();
    }

    _totalDisplayedChildren = filteredChildren.length;

    if ((_currentPage - 1) * _itemsPerPage >= _totalDisplayedChildren &&
        _totalDisplayedChildren > 0) {
      _currentPage = (_totalDisplayedChildren / _itemsPerPage).ceil();
    } else if (_totalDisplayedChildren == 0) {
      _currentPage = 1;
    }
    if (_currentPage < 1) _currentPage = 1;

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > filteredChildren.length) {
      endIndex = filteredChildren.length;
    }

    if (startIndex < 0 ||
        startIndex > filteredChildren.length ||
        endIndex < startIndex) {
      _paginatedChildren = [];
    } else {
      _paginatedChildren = filteredChildren.sublist(startIndex, endIndex);
    }
    if (mounted) {
      // Check if widget is still in the tree
      setState(() {});
    }
  }

  void _goToPage(int page) {
    final totalPages = (_totalDisplayedChildren / _itemsPerPage).ceil();
    if (totalPages == 0) {
      // Handle case with no data or no pages
      if (mounted) {
        setState(() {
          _currentPage = 1;
          _applyFilterAndPagination();
        });
      }
      return;
    }

    if (page >= 1 && page <= totalPages) {
      if (mounted) {
        setState(() {
          _currentPage = page;
          _applyFilterAndPagination();
        });
      }
    } else if (page < 1) {
      if (mounted) {
        setState(() {
          _currentPage = 1;
          _applyFilterAndPagination();
        });
      }
    } else if (page > totalPages) {
      if (mounted) {
        setState(() {
          _currentPage = totalPages;
          _applyFilterAndPagination();
        });
      }
    }
  }

  Widget _buildPaginationControls() {
    final totalPages = (_totalDisplayedChildren / _itemsPerPage).ceil();
    if (totalPages <= 0 && _allChildren.isNotEmpty) {
      return const SizedBox.shrink();
    }
    if (_allChildren.isEmpty && !_isLoading) {
      return const SizedBox.shrink();
    }

    List<Widget> pageNumberWidgets = [];
    const int maxVisiblePageNumbers = 5;
    int startPage, endPage;

    if (totalPages <= maxVisiblePageNumbers) {
      startPage = 1;
      endPage = totalPages;
    } else {
      if (_currentPage <= (maxVisiblePageNumbers / 2).ceil()) {
        startPage = 1;
        endPage = maxVisiblePageNumbers;
      } else if (_currentPage + (maxVisiblePageNumbers / 2).floor() >=
          totalPages) {
        startPage = totalPages - maxVisiblePageNumbers + 1;
        endPage = totalPages;
      } else {
        startPage = _currentPage - (maxVisiblePageNumbers / 2).floor();
        endPage = _currentPage + (maxVisiblePageNumbers / 2).floor();
        if (maxVisiblePageNumbers % 2 == 0 && endPage < totalPages)
          endPage--; // Adjust for even numbers
      }
    }
    if (startPage < 1) startPage = 1;
    if (endPage > totalPages) endPage = totalPages;
    if (endPage < startPage && totalPages > 0)
      endPage = startPage; // Avoid negative range
    else if (totalPages == 0) {
      startPage = 1;
      endPage = 0;
    }

    for (int i = startPage; i <= endPage; i++) {
      pageNumberWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: InkWell(
            onTap: () => _goToPage(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.primaryColor
                      : AppColors.textBox,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.textColor1)),
              child: Text(
                '$i',
                style: TextStyle(
                  color: _currentPage == i
                      ? AppColors.white
                      : AppColors.textColor2,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: _currentPage > 1 ? () => _goToPage(1) : null,
            tooltip: "الصفحة الأولى"),
        IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            tooltip: "الصفحة السابقة"),
        ...pageNumberWidgets,
        IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () => _goToPage(_currentPage + 1)
                : null,
            tooltip: "الصفحة التالية"),
        IconButton(
            icon: const Icon(Icons.last_page),
            onPressed:
                _currentPage < totalPages ? () => _goToPage(totalPages) : null,
            tooltip: "الصفحة الأخيرة"),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textBox),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _itemsPerPage,
              icon: const Icon(Icons.arrow_drop_down),
              items:
                  _itemsPerPageOptions.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString(),
                      style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  if (mounted) {
                    setState(() {
                      _itemsPerPage = newValue;
                      _currentPage = 1;
                      _applyFilterAndPagination();
                    });
                  }
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text('الصفوف', style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // --- Helper function to build navigable cells ---
  DataCell _buildNavigableCell(
      BuildContext context, String text, String childId) {
    return DataCell(
      InkWell(
        onTap: () {
          // print("DataCell: Navigating to edit child with ID: $childId");
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AddEditChildPage(
          //       childIdToEdit: childId,
          //     ),
          //   ),
          // ).then((wasSuccessful) {
          //   // print("Returned from AddEditChildPage (EDIT). Success: $wasSuccessful");
          //   if (wasSuccessful == true) {
          //     context.read<ChildCubit>().fetchChildrenList();
          //   }
          // });
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              // Add padding to mimic default DataCell text padding
              padding: const EdgeInsets.symmetric(
                  vertical: 0.0, horizontal: 0.0), // Adjust as needed
              child: Text(text, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: TopBar(
            title: "مستوصف باشراحيل",
          ),
        ),
        body: Row(children: [
          const SizedBox(width: 300, child: SideNav()),

          // SizedBox(
          //   width: 250,
          //   child: SideNav(
          //     userName: 'مرحباً محمد صالح',
          //     userRole: 'muhammed@gmail.com',
          //     menuItems: [
          //       {
          //         'title': 'إضافة موظف',
          //         'icon': Icons.person_add_alt_1_outlined,
          //         'isSelected': false,
          //         'onTap': () {}
          //       },
          //       {
          //         'title': 'إضافة أطفال',
          //         'icon': Icons.escalator_warning_outlined,
          //         'isSelected': false,
          //         'onTap': () {}
          //       },
          //       {
          //         'title': 'عرض بيانات الموظفين',
          //         'icon': Icons.group_outlined,
          //         'isSelected': false,
          //         'onTap': () {}
          //       },
          //       {
          //         'title': 'عرض بيانات الأطفال',
          //         'icon': Icons.child_care_outlined,
          //         'isSelected': true,
          //         'onTap': () {}
          //       },
          //     ],
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: BlocConsumer<ChildCubit, ChildState>(
                listener: (context, state) {
                  if (state is ChildrenListLoaded) {
                    _processLoadedChildren(state.childrenResponse.data,
                        state.childrenResponse.count);
                  } else if (state is ChildrenListError) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('خطأ في تحميل البيانات: ${state.message}')),
                    );
                  } else if (state is ChildrenListLoading) {
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'قائمة الأطفال العامة',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _searchController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    hintText: 'ابحث عن طفل معين',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                    prefixIcon: Icon(Icons.search,
                                        color: Colors.grey[700], size: 20),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('إضافة طفل جديد',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            onPressed: () {
                              // print("Attempting to navigate to AddEditChildPage (for NEW child)...");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const AddEditChildPage(), // No childIdToEdit
                              //   ),
                              // ).then((wasSuccessful) {
                              //   // print("Returned from AddEditChildPage (NEW). Success: $wasSuccessful");
                              //   if (wasSuccessful == true) {
                              //     context.read<ChildCubit>().fetchChildrenList();
                              //   }
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'عدد الأطفال: $_totalDisplayedChildren',
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.navColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: _isLoading && _allChildren.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : state is ChildrenListError && _allChildren.isEmpty
                                ? Center(
                                    child: Text(
                                        'حدث خطأ: ${state.message} \n الرجاء المحاولة مرة أخرى'))
                                : _allChildren.isEmpty && !_isLoading
                                    ? const Center(
                                        child: Text('لا يوجد أطفال لعرضهم.'))
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: DataTable(
                                                headingRowColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.grey[100]!),
                                                headingTextStyle:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 10),
                                                dataTextStyle: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black87),
                                                dataRowMinHeight: 48,
                                                dataRowMaxHeight: 52,
                                                columnSpacing: 15,
                                                // Remove showCheckboxColumn: false if you don't want checkboxes at all
                                                // This is implicitly false if onSelectChanged is null for all rows.
                                                // showCheckboxColumn: false, // <--- explicit way to hide checkbox column header if DataRow.onSelectChanged is null
                                                columns: const [
                                                  DataColumn(
                                                      label: Text(
                                                          'رقم بطاقة التطعيم')),
                                                  DataColumn(
                                                      label:
                                                          Text('الاسم الاول')),
                                                  DataColumn(
                                                      label:
                                                          Text('الاسم الاخير')),
                                                  DataColumn(
                                                      label: Text('الجنس')),
                                                  DataColumn(
                                                      label: Text('اسم الاب')),
                                                  DataColumn(
                                                      label:
                                                          Text('ايميل الاب')),
                                                  DataColumn(
                                                      label: Text('اسم الام')),
                                                  DataColumn(
                                                      label:
                                                          Text('ايميل الام')),
                                                  DataColumn(
                                                      label: Text(
                                                          'هل لديه حالة خاصة')),
                                                  DataColumn(
                                                      label: Text('الجنسية')),
                                                  DataColumn(
                                                      label: Text(
                                                          "رقم شهادة الميلاد")),
                                                  DataColumn(
                                                      label:
                                                          Text('نوع الشهادة')),
                                                  DataColumn(
                                                      label: Text(
                                                          'بلد اصدار الشهادة')),
                                                  DataColumn(
                                                      label: Text('التطعيمات')),
                                                ],
                                                rows: _paginatedChildren
                                                    .map((child) {
                                                  final String childIdString =
                                                      child.childId.toString();
                                                  return DataRow(
                                                    // onSelectChanged: null, // <--- Ensures no checkbox is shown for the row
                                                    // No onSelectChanged means no checkbox for this row
                                                    cells: [
                                                      _buildNavigableCell(
                                                          context,
                                                          child
                                                              .vaccineCardNumber,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.firstName,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.lastName,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.gender,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.fatherName,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.fatherEmail,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.motherName,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.motherEmail,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.hasSpecialCase
                                                              .toString(),
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.nationalityName,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child
                                                              .birthCertificateNumber,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child
                                                              .birthCertificateType,
                                                          childIdString),
                                                      _buildNavigableCell(
                                                          context,
                                                          child.countryName,
                                                          childIdString),
                                                      DataCell(
                                                        // Cell for actions
                                                        IconButton(
                                                          // Icon suggestion: Icons.vaccines_outlined or Icons.medical_services_outlined
                                                          icon: const Icon(
                                                            Icons
                                                                .vaccines_outlined, // <--- Icon for vaccinations
                                                            color: AppColors
                                                                .primaryColor,
                                                            size: 22,
                                                          ),
                                                          tooltip:
                                                              "عرض التطعيمات", // <--- Updated tooltip
                                                          onPressed: () {
                                                            print(
                                                                "IconButton: Navigating to VACCINATIONS page for child ID: $childIdString");
                                                            // TODO: Implement navigation to the child's vaccinations page
                                                            // Example:
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChildVaccinationsPage(
                                                                        childId:
                                                                            childIdString),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                      ),
                      const SizedBox(height: 16),
                      if (!_isLoading && _allChildren.isNotEmpty)
                        _buildPaginationControls(),
                    ],
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
