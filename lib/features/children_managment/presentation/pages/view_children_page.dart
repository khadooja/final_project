import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/Core/commn_widgets/sideNav.dart';
import 'package:new_project/Core/networking/config/api_config.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/features/children_managment/data/dataSources/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/domain/repositories/child_repository.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_children_usecase.dart';
// Adjust path to your DisplayedChildModel
import '../../../../features/children_managment/data/model/displayed_child_model.dart';
// Adjust path to your ChildCubit and ChildState
import 'package:new_project/features/children_managment/logic/child_bloc/child_cubit.dart';
import 'package:new_project/features/children_managment/logic/child_bloc/child_state.dart';
// You might need to import GetChildrenUseCase and ChildRepository if you are instantiating ChildCubit directly here
// For example, if you don't have a global DI setup for this page yet:
import 'package:new_project/Core/networking/api_services.dart'; // For ApiServiceManual
import 'package:new_project/features/children_managment/data/dataSources/child_data_source.dart';
import 'package:new_project/features/children_managment/data/repositories/child_remote_data_source_impl.dart';
import 'package:new_project/features/children_managment/domain/usecase/get_child.dart';
import 'package:dio/dio.dart'; // If ApiServiceManual needs Dio
import 'package:new_project/features/children_managment/data/repositories/child_remote_data_source_impl.dart'; // CORRECT IMPORT

class ViewChildrenPage extends StatelessWidget {
  // Changed to StatelessWidget for BlocProvider
  const ViewChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    // *** IMPORTANT: SET THE BASE URL FOR DIO ***
    dio.options.baseUrl = ApiConfig.baseUrl;
    // You can also add interceptors here if needed (for auth tokens, logging, etc.)
    // dio.interceptors.add(YourAuthInterceptor());

    final apiService = ApiServiceManual(dio: dio);
    final ChildRemoteDataSource childRemoteDataSource =
        ChildRemoteDataSourceImpl(apiService);
    final ChildRepository childRepository =
        ChildRepositoryImpl(childRemoteDataSource);
    final getChildrenUseCase = GetChildrenUseCase(childRepository);

    return BlocProvider(
      create: (context) =>
          ChildCubit(childRepository, getChildrenUseCase)..fetchChildrenList(),
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
  int _apiTotalChildrenCount = 0; // Total count from API
  int _totalDisplayedChildren =
      0; // Count of children after client-side filtering

  int _currentPage = 1;
  int _itemsPerPage = 5;
  final List<int> _itemsPerPageOptions = [5, 10, 15, 20];

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  bool _isLoading = true; // General loading state for initial fetch

  @override
  void initState() {
    super.initState();
    // Fetch children when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {});

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
    if (_allChildren.isEmpty && _isLoading) {
      // only fetch if not already loaded
      context.read<ChildCubit>().fetchChildrenList();
    }
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
      _apiTotalChildrenCount =
          totalCountFromApi; // Use this if API does pagination
      _isLoading = false; // Stop global loading
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

    if ((_currentPage - 1) * _itemsPerPage >= _totalDisplayedChildren) {
      _currentPage = (_totalDisplayedChildren / _itemsPerPage).ceil();
      if (_currentPage == 0 && _totalDisplayedChildren == 0) {
        _currentPage = 1;
      } else if (_currentPage == 0 && _totalDisplayedChildren > 0)
        // ignore: curly_braces_in_flow_control_structures
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
    setState(() {});
  }

//للتنقل بين بيانات الأطفال في الجدول
  void _goToPage(int page) {
    final totalPages = (_totalDisplayedChildren / _itemsPerPage).ceil();
    // Logic from previous response
    if (page >= 1 && page <= totalPages) {
      setState(() {
        _currentPage = page;
        _applyFilterAndPagination();
      });
    } else if (page < 1 && totalPages > 0) {
      setState(() {
        _currentPage = 1;
        _applyFilterAndPagination();
      });
    } else if (page > totalPages && totalPages > 0) {
      setState(() {
        _currentPage = totalPages;
        _applyFilterAndPagination();
      });
    } else if (totalPages == 0) {
      setState(() {
        _currentPage = 1;
        _applyFilterAndPagination();
      });
    }
  }

  Widget _buildPaginationControls() {
    // Same as previous response
    final totalPages = (_totalDisplayedChildren / _itemsPerPage).ceil();
    if (totalPages <= 0 && _allChildren.isNotEmpty) {
      return const SizedBox
          .shrink(); // No controls if no pages, but show if data exists
    }
    if (_allChildren.isEmpty && !_isLoading) {
      return const SizedBox.shrink(); // No controls if no data and not loading
    }

    List<Widget> pageNumberWidgets = [];
    const int maxVisiblePageNumbers = 5;

    int startPage;
    int endPage;

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
        if (maxVisiblePageNumbers % 2 == 0) endPage--;
      }
    }
    if (startPage < 1) startPage = 1;
    if (endPage > totalPages) endPage = totalPages;
    if (endPage < startPage && totalPages > 0) {
      endPage = startPage - 1;
    } else if (totalPages == 0) endPage = 0;

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
                  setState(() {
                    _itemsPerPage = newValue;
                    _currentPage = 1;
                    _applyFilterAndPagination();
                  });
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
          SizedBox(
            width: 250,
            //القائمة الجانبية (حساب الموظف)
            child: SideNav(
              userName: 'مرحباً محمد صالح',
              userRole: 'muhammed@gmail.com',
              menuItems: [
                // Example, adapt to your SideNav's capabilities
                {
                  'title': 'إضافة موظف',
                  'icon': Icons.person_add_alt_1_outlined,
                  'isSelected': false,
                  'onTap': () {}
                },
                {
                  'title': 'إضافة أطفال',
                  'icon': Icons.escalator_warning_outlined,
                  'isSelected': false,
                  'onTap': () {}
                },
                {
                  'title': 'عرض بيانات الموظفين',
                  'icon': Icons.group_outlined,
                  'isSelected': false,
                  'onTap': () {}
                },
                {
                  'title': 'عرض بيانات الأطفال',
                  'icon': Icons.child_care_outlined,
                  'isSelected': true,
                  'onTap': () {}
                },
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: BlocConsumer<ChildCubit, ChildState>(
                // Use BlocConsumer
                listener: (context, state) {
                  if (state is ChildrenListLoaded) {
                    _processLoadedChildren(state.childrenResponse.data,
                        state.childrenResponse.count);
                  } else if (state is ChildrenListError) {
                    setState(() {
                      _isLoading = false; // Stop loading on error
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('خطأ في تحميل البيانات: ${state.message}')),
                    );
                  } else if (state is ChildrenListLoading) {
                    setState(() {
                      _isLoading = true; // Start global loading
                    });
                  }
                },
                builder: (context, state) {
                  // Main column for content
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top row: Add Child Button and Search Bar

                      Row(
                        // ... (same as previous response)
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'قائمة الأطفال العامة',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          //مربع البحث
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

                          //زر الأضافة
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('إضافة طفل جديد',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            onPressed: () {/* أذهب الى واجهة الأضافة */},
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

                      //نص لعرض عدد الأطفال
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            // Use _totalDisplayedChildren for count after client-side filter,
                            // or _apiTotalChildrenCount if API handles filtering.
                            'عدد الأطفال: $_totalDisplayedChildren',
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.navColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Children Table or Loading/Error
                      //جدول عرض بيانات الأطفال
                      Expanded(
                        child: _isLoading &&
                                _allChildren
                                    .isEmpty // Show loading only if data isn't there yet
                            ? const Center(child: CircularProgressIndicator())
                            : state is ChildrenListError && _allChildren.isEmpty
                                ? Center(
                                    child: Text(
                                        'حدث خطأ: ${(state).message} \n الرجاء المحاولة مرة أخرى'))
                                : _allChildren.isEmpty && !_isLoading
                                    ? const Center(
                                        child: Text('لا يوجد أطفال لعرضهم.'))
                                    : Container(
                                        // Table Container
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
                                                // ... DataTable columns and rows from previous response ...
                                                headingRowColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.grey[100]!),
                                                headingTextStyle:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 13),
                                                dataTextStyle: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                                dataRowMinHeight: 48,
                                                dataRowMaxHeight: 52,
                                                columnSpacing: 20,
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
                                                          'رقم شهادة الميلاد')),
                                                  DataColumn(
                                                      label: Text(
                                                          'نوع شهادة الميلاد')),
                                                  DataColumn(
                                                      label: Text(
                                                          'بلد اصدار الشهادة')),
                                                  DataColumn(
                                                      label: Text('إجراءات')),
                                                ],
                                                rows: _paginatedChildren
                                                    .map((child) {
                                                  return DataRow(cells: [
                                                    DataCell(Text(child
                                                        .vaccineCardNumber)),
                                                    DataCell(
                                                        Text(child.firstName)),
                                                    DataCell(
                                                        Text(child.lastName)),
                                                    DataCell(
                                                        Text(child.gender)),
                                                    DataCell(
                                                        Text(child.fatherName)),
                                                    DataCell(Text(
                                                        child.fatherEmail)),
                                                    DataCell(
                                                        Text(child.motherName)),
                                                    DataCell(Text(
                                                        child.motherEmail)),
                                                    DataCell(Text(
                                                        child.hasSpecialCase)),
                                                    DataCell(Text(
                                                        child.nationalityName)),
                                                    DataCell(Text(child
                                                        .birthCertificateNumber)),
                                                    DataCell(Text(child
                                                        .birthCertificateType)),
                                                    DataCell(Text(
                                                        child.countryName)),
                                                    DataCell(IconButton(
                                                      icon: const Icon(
                                                          Icons
                                                              .edit_note_outlined,
                                                          color: AppColors
                                                              .textColor2,
                                                          size: 22),
                                                      tooltip: "تعديل/عرض",
                                                      onPressed: () {
                                                        /* TODO: Handle edit/view */
                                                      },
                                                    )),
                                                  ]);
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                      ),
                      const SizedBox(height: 16),
                      // Pagination Controls
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
