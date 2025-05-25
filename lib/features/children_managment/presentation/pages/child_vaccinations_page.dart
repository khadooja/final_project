import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl_pkg;
import 'package:new_project/Core/theme/colors.dart'; // Your AppColors
import '../../data/model/child_vaccination_details_model.dart'; // Adjust path

// Placeholder for your logo asset - replace with actual path
const String gorahLogoPath = 'assets/images/logo.png'; // مثال

class ChildVaccinationsPage extends StatefulWidget {
  final String childId;

  const ChildVaccinationsPage({Key? key, required this.childId})
      : super(key: key);

  @override
  _ChildVaccinationsPageState createState() => _ChildVaccinationsPageState();
}

class _ChildVaccinationsPageState extends State<ChildVaccinationsPage> {
  ChildVaccinationDetails? _vaccinationDetails;
  bool _isLoading = true;
  String? _errorMessage;
  final Dio _dio = Dio();

  // For editable notes
  Map<String, TextEditingController> _notesControllers = {};
  // To manage focus for TextFields
  Map<String, FocusNode> _notesFocusNodes = {};

  @override
  void initState() {
    super.initState();
    _fetchVaccinationDetails();
  }

  @override
  void dispose() {
    _notesControllers.forEach((_, controller) => controller.dispose());
    _notesFocusNodes.forEach((_, node) => node.dispose());
    super.dispose();
  }

  Future<void> _fetchVaccinationDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final String apiUrl =
          "http://127.0.0.1:8000/api/childVaccination/${widget.childId}";
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _vaccinationDetails =
                ChildVaccinationDetails.fromJson(response.data);
            _initializeNotesControllers();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = "فشل في تحميل البيانات: ${response.statusCode}";
            _isLoading = false;
          });
        }
      }
    } on DioError catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "خطأ في الشبكة أو من الخادم: ";
          if (e.response != null &&
              e.response?.data != null &&
              e.response?.data is Map) {
            _errorMessage = (_errorMessage ?? "") +
                (e.response?.data['message'] ?? e.message ?? "Error");
          } else {
            _errorMessage =
                (_errorMessage ?? "") + (e.message ?? "Unknown Dio error");
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "حدث خطأ غير متوقع: $e";
          _isLoading = false;
        });
      }
    }
  }

  void _initializeNotesControllers() {
    // Dispose existing controllers and focus nodes first
    _notesControllers.forEach((_, controller) => controller.dispose());
    _notesFocusNodes.forEach((_, node) => node.dispose());
    _notesControllers = {};
    _notesFocusNodes = {};

    if (_vaccinationDetails != null) {
      for (var stage in _vaccinationDetails!.stages) {
        for (var vaccine in stage.vaccines) {
          String key =
              "${stage.stageId}-${vaccine.vaccineName}-${vaccine.doseNumber}";
          _notesControllers[key] =
              TextEditingController(text: vaccine.notes ?? '');
          _notesFocusNodes[key] = FocusNode();

          // Add listener to update model when text changes
          _notesControllers[key]!.addListener(() {
            if (mounted && _notesFocusNodes[key]!.hasFocus) {
              // Update only if focused to avoid issues
              vaccine.notes = _notesControllers[key]!.text;
              // No need for setState here unless you want real-time UI updates based on note changes elsewhere
            }
          });
        }
      }
    }
  }

  String _formatDate(DateTime? date, {String fallback = '---'}) {
    if (date == null) return fallback;
    // العميل يريد صيغة 2025/1/1 م
    return "${date.year}/${date.month}/${date.day} م";
  }

  Widget _buildInfoRow(String label, String value, {double valueFlex = 2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor2),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            flex: valueFlex.toInt(), // Cast to int
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor2),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _handleStatusChange(Vaccine vaccine, bool? newValue) {
    if (newValue != null && vaccine.isDelay) {
      setState(() {
        vaccine.status = newValue ? 1 : 0;
        if (vaccine.status == 1) {
          vaccine.visitDate = DateTime.now(); // Set visit date to today
        } else {
          vaccine.visitDate = null; // Clear visit date
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_vaccinationDetails == null) return;

    List<Map<String, dynamic>> updatedVaccinesData = [];
    for (var stage in _vaccinationDetails!.stages) {
      for (var vaccine in stage.vaccines) {
        // Check if anything actually changed for this vaccine
        if (vaccine.hasChanged) {
          updatedVaccinesData.add({
            "child_id": widget.childId, // Important to identify the child
            "stage_id":
                stage.stageId, // Important to identify the vaccine record
            "vaccine_name":
                vaccine.vaccineName, // Or some unique vaccine ID from your DB
            "dose_number": vaccine.doseNumber, // Or some unique dose ID
            "status": vaccine.status,
            "visit_date": vaccine.status == 1 && vaccine.visitDate != null
                ? intl_pkg.DateFormat('yyyy-MM-dd')
                    .format(vaccine.visitDate!) // Format for backend
                : null,
            "notes": vaccine.notes,
          });
        }
      }
    }

    if (updatedVaccinesData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا توجد تغييرات لحفظها.")),
      );
      return;
    }

    // TODO: Implement the actual API call to save data
    print("سيتم إرسال البيانات التالية للباك اند:");
    print(updatedVaccinesData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("جاري حفظ التعديلات... (محاكاة)")),
    );

    // --- SIMULATE API CALL ---
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    bool success = true; // Simulate API success

    if (success) {
      // Update original values in the model after successful save
      for (var stage in _vaccinationDetails!.stages) {
        for (var vaccine in stage.vaccines) {
          if (vaccine.hasChanged) {
            vaccine.updateOriginals();
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("تم حفظ التعديلات بنجاح!"),
            backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("فشل حفظ التعديلات. الرجاء المحاولة مرة أخرى."),
            backgroundColor: Colors.red),
      );
    }
    // After API call (success or failure), you might want to refresh or update UI state
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Define column widths based on screen size or fixed values
    // These are illustrative, adjust them to fit your content and design
    final double stageColWidth = screenWidth > 800 ? 120 : 100;
    final double ageColWidth = screenWidth > 800 ? 120 : 100;
    final double vaccineColWidth = screenWidth > 800 ? 150 : 120;
    final double doseColWidth = screenWidth > 800 ? 100 : 90;
    final double dateColWidth = screenWidth > 800 ? 120 : 100;
    final double statusColWidth = screenWidth > 800 ? 80 : 70;
    final double notesColWidth = screenWidth > 800 ? 200 : 150;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white, // Page background
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove default back button
          titleSpacing: 0,
          elevation: 1,
          backgroundColor: AppColors.white,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo on the left (for RTL, it appears right)
                Image.asset(gorahLogoPath,
                    width: 90,
                    height: 55,
                    errorBuilder: (context, error, stackTrace) => Text("Gorah",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight
                                .bold))), // Replace with your actual logo asset

                // Back button on the right (for RTL, it appears left)
                TextButton.icon(
                  // Arrow points to "page content" in RTL
                  label: Text("رجوع",
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 16)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor))
            : _errorMessage != null
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center),
                  ))
                : _vaccinationDetails == null
                    ? Center(
                        child: Text("لا توجد بيانات تطعيمات لهذا الطفل.",
                            style: TextStyle(fontSize: 16)))
                    : Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .stretch, // Stretch children horizontally
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              // Child Info Section (Styled like the image)
                              IntrinsicHeight(
                                // To make all columns in the Row have the same height
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoRow("اسم الطفل:",
                                              _vaccinationDetails!.childName),
                                          _buildInfoRow("محل الميلاد:",
                                              _vaccinationDetails!.countryName),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                        thickness: 0.5,
                                        color: Colors.grey[300]),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      flex: 4, // Adjusted flex
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoRow(
                                              "تاريخ الميلاد:",
                                              _formatDate(_vaccinationDetails!
                                                  .birthDate)),
                                          _buildInfoRow(
                                              "المركز الصحي:",
                                              _vaccinationDetails!
                                                  .healthCenters),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                        thickness: 0.5,
                                        color: Colors.grey[300]),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      flex: 4, // Adjusted flex
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoRow(
                                              "تاريخ الاصدار:",
                                              _formatDate(_vaccinationDetails!
                                                  .renderDate)),
                                          _buildInfoRow(
                                              "رقم البطاقة:",
                                              _vaccinationDetails!
                                                  .vaccineCardNumber),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),

                              // Vaccinations Table
                              LayoutBuilder(builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth),
                                    child: DataTable(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(
                                            0), // No border radius for table itself if header is outside
                                      ),
                                      headingRowColor: MaterialStateProperty
                                          .resolveWith<Color?>((_) => const Color(
                                              0xFF56A8D8)), // Light blue from image
                                      headingTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      dataRowColor: MaterialStateProperty
                                          .resolveWith<Color?>((states) {
                                        // if (states.contains(MaterialState.selected)) return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                                        return Colors
                                            .white; // Default row color
                                      }),
                                      dataTextStyle: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textColor2),
                                      columnSpacing: 18.0, // Adjust spacing
                                      horizontalMargin:
                                          12.0, // Margin for the whole table
                                      headingRowHeight: 45.0,
                                      dataRowMinHeight: 45.0,
                                      dataRowMaxHeight:
                                          55.0, // Allow for multiline notes if needed
                                      columns: const [
                                        DataColumn(
                                            label:
                                                Center(child: Text('المرحلة'))),
                                        DataColumn(
                                            label: Center(
                                                child:
                                                    Text('العمر الموصى به'))),
                                        DataColumn(
                                            label:
                                                Center(child: Text('اللقاح'))),
                                        DataColumn(
                                            label:
                                                Center(child: Text('الجرعة'))),
                                        DataColumn(
                                            label: Center(
                                                child: Text('موعد الجرعة'))),
                                        DataColumn(
                                            label: Center(
                                                child:
                                                    Text('اخر موعد للجرعة'))),
                                        DataColumn(
                                            label: Center(
                                                child: Text('تاريخ الزيارة'))),
                                        DataColumn(
                                            label:
                                                Center(child: Text('الحالة'))),
                                        DataColumn(
                                            label:
                                                Center(child: Text('ملاحظات'))),
                                      ],
                                      rows: _vaccinationDetails!.stages
                                          .expand((stage) {
                                        // Use expand to flatten the list
                                        return stage.vaccines.map((vaccine) {
                                          String noteKey =
                                              "${stage.stageId}-${vaccine.vaccineName}-${vaccine.doseNumber}";
                                          return DataRow(
                                              color: MaterialStateProperty
                                                  .resolveWith<Color?>(
                                                      (states) {
                                                // You can add row-specific coloring if needed
                                                return Colors.white; // Default
                                              }),
                                              cells: [
                                                DataCell(Center(
                                                    child:
                                                        Text(stage.stageName))),
                                                DataCell(Center(
                                                    child: Text(
                                                        stage.recommendedAge))),
                                                DataCell(Center(
                                                    child: Text(
                                                        vaccine.vaccineName))),
                                                DataCell(Center(
                                                    child: Text(
                                                        vaccine.doseNumber))),
                                                DataCell(Center(
                                                    child: Text(_formatDate(
                                                        vaccine
                                                            .vaccinationDate)))),
                                                DataCell(Center(
                                                    child: Text(_formatDate(vaccine
                                                        .lastDateForVaccine)))),
                                                DataCell(Center(
                                                    child: Text(_formatDate(
                                                        vaccine.visitDate,
                                                        fallback: vaccine
                                                                    .status ==
                                                                1
                                                            ? _formatDate(
                                                                DateTime.now())
                                                            : '---')))),
                                                DataCell(Center(
                                                  child: Checkbox(
                                                    value: vaccine.status == 1,
                                                    onChanged: vaccine.isDelay
                                                        ? (bool? newValue) =>
                                                            _handleStatusChange(
                                                                vaccine,
                                                                newValue)
                                                        : null,
                                                    activeColor: Color(
                                                        0xFF5cb85c), // Green color from image
                                                    checkColor: Colors.white,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                    Color?>(
                                                                (states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .disabled)) {
                                                        return Colors
                                                            .grey.shade300;
                                                      }
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return Color(
                                                            0xFF5cb85c); // Green for selected
                                                      }
                                                      return Colors.grey
                                                          .shade400; // Default border for unchecked
                                                    }),
                                                  ),
                                                )),
                                                DataCell(
                                                  SizedBox(
                                                    width:
                                                        notesColWidth, // Give notes a good width
                                                    child: TextField(
                                                      controller:
                                                          _notesControllers[
                                                              noteKey],
                                                      focusNode:
                                                          _notesFocusNodes[
                                                              noteKey],
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "لا توجد ملاحظات",
                                                        border: InputBorder
                                                            .none, // No border for cleaner look in cell
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 4,
                                                                vertical:
                                                                    8), // Adjust padding
                                                      ),
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      maxLines:
                                                          1, // Or null for multiline
                                                      textAlign:
                                                          TextAlign.center,
                                                      onChanged: (value) {
                                                        // Update model as user types
                                                        vaccine.notes =
                                                            value.trim().isEmpty
                                                                ? null
                                                                : value.trim();
                                                        // setState(() {}); // Not strictly needed if only model is updated
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                        }).toList();
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 80),
                              // Action Buttons
                              Center(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: _saveChanges,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF56A8D8), // Blue from image
                                        minimumSize: Size(screenWidth * 0.35,
                                            50), // Responsive width
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        elevation: 2,
                                      ),
                                      child: const Text("حفظ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        // TODO: Implement PDF export functionality
                                        print("تصدير PDF...");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "وظيفة تصدير PDF لم تنفذ بعد.")),
                                        );
                                      },
                                      child: Text("تصدير pdf",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF56A8D8),
                                              fontWeight: FontWeight
                                                  .bold)), // Blue text
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Color(0xFF56A8D8),
                                            width: 1.5), // Blue border
                                        minimumSize: Size(screenWidth * 0.35,
                                            50), // Responsive width
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20), // Footer padding
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
