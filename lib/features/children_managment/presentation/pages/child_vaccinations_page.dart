import 'dart:io'; // For File operations
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load fonts
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl_pkg;
import 'package:new_project/Core/theme/colors.dart';
import '../../data/model/child_vaccination_details_model.dart';

// PDF Generation
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Note the 'as pw' to avoid conflicts
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:permission_handler/permission_handler.dart'; // Uncomment if needed

const String gorahLogoPath = 'assets/images/logo.png';

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
  Map<String, TextEditingController> _notesControllers = {};
  Map<String, FocusNode> _notesFocusNodes = {};

  pw.Font? _arabicFont; // To store the loaded Arabic font

  @override
  void initState() {
    super.initState();
    _loadArabicFont(); // Load font on init
    _fetchVaccinationDetails();
  }

  // Load the Arabic font from assets
  Future<void> _loadArabicFont() async {
    try {
      final fontData = await rootBundle
          .load("assets/fonts/Amiri-Regular.ttf"); // تأكد من أن المسار صحيح
      _arabicFont = pw.Font.ttf(fontData);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading Arabic font: $e");
      }
      // Handle font loading error if necessary, e.g., fallback to a default font
    }
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

  Future<void> _saveChanges() async {
    if (_vaccinationDetails == null || widget.childId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("لا توجد بيانات لحفظها أو خطأ في معرّف الطفل.")),
        );
      }
      return;
    }

    // 1. جمع الجرعات التي تم تعديلها
    List<Map<String, dynamic>> updatedDosesData = [];
    for (var stage in _vaccinationDetails!.stages) {
      for (var vaccine in stage.vaccines) {
        // تحقق مما إذا كانت الجرعة قد تغيرت وهل هي من النوع القابل للتعديل (isDelay)
        // إذا لم تكن isDelay، يجب ألا يتم تضمينها حتى لو تغيرت (حسب منطق التطبيق)
        if (vaccine.hasChanged && vaccine.isDelay) {
          updatedDosesData.add({
            "svd_id": vaccine.svdId, //  معرّف الجرعة الفريد
            "status": vaccine.status,
            "visit_date": vaccine.status == 1 && vaccine.visitDate != null
                ? intl_pkg.DateFormat('yyyy-MM-dd')
                    .format(vaccine.visitDate!) // تنسيق YYYY-MM-DD
                : null, // أرسل null إذا لم يكن هناك تاريخ أو الحالة ليست 1
            "notes": vaccine.notes?.trim().isEmpty ?? true
                ? null
                : vaccine.notes!.trim(), // أرسل null إذا كانت الملاحظات فارغة
          });
        }
      }
    }

    if (updatedDosesData.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لا توجد تغييرات لحفظها.")),
        );
      }
      return;
    }

    // 2. بناء الـ Payload النهائي
    // محاولة تحويل child_id إلى int. تأكد أن widget.childId يمكن تحويله.
    final int? childIdInt = int.tryParse(widget.childId);
    if (childIdInt == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("خطأ: معرّف الطفل غير صالح.")),
        );
      }
      return;
    }

    final Map<String, dynamic> payload = {
      "child_id": childIdInt,
      "doses": updatedDosesData,
    };

    if (kDebugMode) {
      // طباعة الـ payload فقط في وضع الـ debug
      print("الـ Payload الذي سيتم إرساله:");
      print(payload);
    }

    if (mounted) {
      // إظهار مؤشر التحميل
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("جاري حفظ التعديلات...")),
      );
    }

    try {
      // 3. إجراء طلب الـ API
      const String updateApiUrl =
          "http://127.0.0.1:8000/api/childVaccination/update";

      // استخدم dio.put أو dio.post حسب تصميم الـ API.
      // بما أنه "update"، فـ PUT هو الأنسب عادةً.
      final response = await _dio.put(
        updateApiUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': 'Bearer YOUR_TOKEN_IF_NEEDED' // إذا كان الـ API يتطلب توثيق
          },
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false; // إخفاء مؤشر التحميل
        });
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // أو أي status code للنجاح يرسله الـ API
        // 4. التعامل مع النجاح
        // تحديث القيم الأصلية في النموذج بعد الحفظ الناجح
        for (var stage in _vaccinationDetails!.stages) {
          for (var vaccine in stage.vaccines) {
            if (vaccine.hasChanged && vaccine.isDelay) {
              vaccine
                  .updateOriginals(); // لتحديث _originalStatus, _originalNotes, _originalVisitDate
            }
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("تم حفظ التعديلات بنجاح!"),
                backgroundColor: Colors.green),
          );
          // يمكنك اختيارياً إعادة جلب البيانات لتحديث الواجهة بالكامل من الخادم:
          // _fetchVaccinationDetails();
        }
      } else {
        // 5. التعامل مع خطأ من الـ API (ولكن الطلب تم بنجاح)
        if (mounted) {
          String serverMessage = "فشل حفظ التعديلات.";
          if (response.data != null &&
              response.data is Map &&
              response.data['message'] != null) {
            serverMessage += " السبب: ${response.data['message']}";
          } else {
            serverMessage += " (Code: ${response.statusCode})";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(serverMessage), backgroundColor: Colors.orange),
          );
        }
      }
    } on DioError catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // إخفاء مؤشر التحميل
        });
        String errorMessage = "خطأ في الشبكة أو من الخادم عند الحفظ: ";
        if (e.response != null &&
            e.response?.data != null &&
            e.response?.data is Map) {
          errorMessage += (e.response?.data['message'] ??
              e.response?.statusMessage ??
              e.message ??
              "Error");
        } else if (e.message != null) {
          errorMessage += e.message!;
        } else {
          errorMessage += "Unknown Dio error";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
        if (kDebugMode) {
          print("DioError during save: $e");
          if (e.response != null) print("DioError response: ${e.response}");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // إخفاء مؤشر التحميل
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("حدث خطأ غير متوقع أثناء الحفظ: $e"),
              backgroundColor: Colors.red),
        );
        if (kDebugMode) {
          print("Generic error during save: $e");
        }
      }
    }
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

  // Future<void> _saveChanges() async {
  //   if (_vaccinationDetails == null) return;

  //   List<Map<String, dynamic>> updatedVaccinesData = [];
  //   for (var stage in _vaccinationDetails!.stages) {
  //     for (var vaccine in stage.vaccines) {
  //       // Check if anything actually changed for this vaccine
  //       if (vaccine.hasChanged) {
  //         updatedVaccinesData.add({
  //           "child_id": widget.childId, // Important to identify the child
  //           "stage_id":
  //               stage.stageId, // Important to identify the vaccine record
  //           "vaccine_name":
  //               vaccine.vaccineName, // Or some unique vaccine ID from your DB
  //           "dose_number": vaccine.doseNumber, // Or some unique dose ID
  //           "status": vaccine.status,
  //           "visit_date": vaccine.status == 1 && vaccine.visitDate != null
  //               ? intl_pkg.DateFormat('yyyy-MM-dd')
  //                   .format(vaccine.visitDate!) // Format for backend
  //               : null,
  //           "notes": vaccine.notes,
  //         });
  //       }
  //     }
  //   }

  //   if (updatedVaccinesData.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("لا توجد تغييرات لحفظها.")),
  //     );
  //     return;
  //   }

  //   // TODO: Implement the actual API call to save data
  //   print("سيتم إرسال البيانات التالية للباك اند:");
  //   print(updatedVaccinesData);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("جاري حفظ التعديلات... (محاكاة)")),
  //   );

  //   // --- SIMULATE API CALL ---
  //   await Future.delayed(Duration(seconds: 2)); // Simulate network delay
  //   bool success = true; // Simulate API success

  //   if (success) {
  //     // Update original values in the model after successful save
  //     for (var stage in _vaccinationDetails!.stages) {
  //       for (var vaccine in stage.vaccines) {
  //         if (vaccine.hasChanged) {
  //           vaccine.updateOriginals();
  //         }
  //       }
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("تم حفظ التعديلات بنجاح!"),
  //           backgroundColor: Colors.green),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("فشل حفظ التعديلات. الرجاء المحاولة مرة أخرى."),
  //           backgroundColor: Colors.red),
  //     );
  //   }
  //   // After API call (success or failure), you might want to refresh or update UI state
  // }
  Future<void> _exportToPdf() async {
    if (_vaccinationDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا توجد بيانات لتصديرها.")),
      );
      return;
    }
    if (_arabicFont == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "جاري تحميل الخط العربي، يرجى المحاولة مرة أخرى بعد لحظات.")),
      );
      // Attempt to load font again or handle more gracefully
      await _loadArabicFont();
      if (_arabicFont == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "فشل تحميل الخط العربي. لا يمكن إنشاء PDF بالنصوص العربية.")),
        );
        return;
      }
    }

    final pdf = pw.Document();
    final ByteData logoData = await rootBundle.load(gorahLogoPath);
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    // Define styles with Arabic font
    final baseStyle = pw.TextStyle(font: _arabicFont, fontSize: 10);
    final boldStyle = pw.TextStyle(
        font: _arabicFont, fontWeight: pw.FontWeight.bold, fontSize: 11);
    final headerStyle = pw.TextStyle(
        font: _arabicFont,
        fontWeight: pw.FontWeight.bold,
        fontSize: 14,
        color: PdfColors.white);
    final tableHeaderStyle = pw.TextStyle(
        font: _arabicFont,
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
        color: PdfColors.white);
    final tableCellStyle = pw.TextStyle(font: _arabicFont, fontSize: 8);

    // Helper function to build info rows for PDF, similar to _buildInfoRow
    pw.Widget _buildPdfInfoRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(value,
                style: baseStyle.copyWith(fontWeight: pw.FontWeight.bold),
                textDirection: pw.TextDirection.rtl),
            pw.Text(label,
                style: baseStyle, textDirection: pw.TextDirection.rtl),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection:
            pw.TextDirection.rtl, // Set text direction for the whole page
        theme: pw.ThemeData.withFont(
          base: _arabicFont!, // Default font for the page
          bold: _arabicFont!, // Font for bold text
        ),
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('بطاقة تطعيمات الطفل',
                        style: boldStyle.copyWith(fontSize: 18),
                        textDirection: pw.TextDirection.rtl),
                    pw.SizedBox(
                      height: 50,
                      width: 80,
                      child: pw.Image(logoImage),
                    ),
                  ]));
        },
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text('بيانات الطفل',
                style: boldStyle.copyWith(fontSize: 16),
                textDirection: pw.TextDirection.rtl),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey600, width: 0.5),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfInfoRow(
                        _vaccinationDetails!.childName, "اسم الطفل:"),
                    _buildPdfInfoRow(
                        _formatDate(_vaccinationDetails!.birthDate),
                        "تاريخ الميلاد:"),
                    _buildPdfInfoRow(
                        _vaccinationDetails!.countryName, "محل الميلاد:"),
                    _buildPdfInfoRow(
                        _vaccinationDetails!.healthCenters, "المركز الصحي:"),
                    _buildPdfInfoRow(
                        _formatDate(_vaccinationDetails!.renderDate),
                        "تاريخ الاصدار:"),
                    _buildPdfInfoRow(
                        _vaccinationDetails!.vaccineCardNumber, "رقم البطاقة:"),
                  ])),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 0,
            child: pw.Text('جدول التطعيمات',
                style: boldStyle.copyWith(fontSize: 16),
                textDirection: pw.TextDirection.rtl),
          ),
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF56A8D8)), // لون الهيدر الأزرق
            headerHeight: 25,
            cellHeight: 20,
            cellAlignments: {
              0: pw.Alignment.centerRight,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
              6: pw.Alignment.center,
              7: pw.Alignment.center,
              8: pw.Alignment.centerRight,
            },
            headerStyle: tableHeaderStyle,
            cellStyle: tableCellStyle,
            columnWidths: {
              // Adjust column widths as needed
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(0.8),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(1.5),
              8: const pw.FlexColumnWidth(1.5),
            },
            headers: [
              'ملاحظات',
              'الحالة',
              'تاريخ الزيارة',
              'اخر موعد',
              'موعد الجرعة',
              'الجرعة',
              'اللقاح',
              'العمر الموصى به',
              'المرحلة'
            ]
                .map((header) => header)
                .toList(), // Map to ensure TextDirection is applied if needed by headerStyle
            data: _vaccinationDetails!.stages.expand((stage) {
              return stage.vaccines.map((vaccine) {
                return [
                  vaccine.notes ?? '---',
                  vaccine.status == 1 ? 'تم' : 'لم يتم',
                  _formatDate(vaccine.visitDate,
                      fallback: vaccine.status == 1
                          ? _formatDate(DateTime.now())
                          : '---'),
                  _formatDate(vaccine.lastDateForVaccine),
                  _formatDate(vaccine.vaccinationDate),
                  vaccine.doseNumber,
                  vaccine.vaccineName,
                  stage.recommendedAge,
                  stage.stageName,
                ];
              }).toList();
            }).toList(),
          ),
          pw.SizedBox(height: 30),
          pw.Paragraph(
            text:
                "ملاحظة: هذه البطاقة تم إنشاؤها إلكترونياً وقد لا تغني عن البطاقة الورقية الرسمية حسب متطلبات الجهات المعنية.",
            style: baseStyle.copyWith(fontSize: 8, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
        ],
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'صفحة ${context.pageNumber} من ${context.pagesCount}',
                  style: baseStyle.copyWith(color: PdfColors.grey)));
        },
      ),
    );

    try {
      // /*  // Uncomment if you need storage permissions
      // if (Platform.isAndroid) {
      //   var status = await Permission.storage.status;
      //   if (!status.isGranted) {
      //     status = await Permission.storage.request();
      //   }
      //   if (!status.isGranted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("إذن التخزين مطلوب لحفظ الملف.")),
      //     );
      //     return;
      //   }
      // }
      // */

      final outputDir =
          await getTemporaryDirectory(); // Or getApplicationDocumentsDirectory()
      final outputFile =
          File('${outputDir.path}/vaccination_card_${widget.childId}.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      if (kDebugMode) {
        print('PDF сохранен в: ${outputFile.path}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ الـ PDF في: ${outputFile.path}')),
      );

      // Open the PDF file
      final result = await OpenFilex.open(outputFile.path);
      if (result.type != ResultType.done) {
        if (kDebugMode) {
          print('Could not open file: ${result.message}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'لم يتم العثور على تطبيق لفتح ملف PDF: ${result.message}')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving or opening PDF: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء إنشاء أو حفظ الـ PDF: $e')),
      );
    }
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
                                      onPressed: _exportToPdf,
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
