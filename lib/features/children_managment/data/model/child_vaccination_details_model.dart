import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:intl/intl.dart'; // For parsing dates with specific format if needed

// Helper function to parse date strings safely, can be top-level or static
DateTime? _parseDateSafe(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;
  try {
    // If your dates are always YYYY-MM-DD, DateTime.parse is fine.
    // If they might have other formats, you might need DateFormat.
    return DateTime.parse(dateString);
  } catch (e) {
    if (kDebugMode) {
      print("Error parsing date: $dateString, error: $e");
    }
    return null;
  }
}

class ChildVaccinationDetails {
  final String childId;
  final String childName;
  final DateTime? birthDate;
  final DateTime? renderDate; // تاريخ الاصدار
  final String countryName; // محل الميلاد
  final String healthCenters;
  final String vaccineCardNumber;
  final List<Stage> stages;

  ChildVaccinationDetails({
    required this.childId,
    required this.childName,
    this.birthDate,
    this.renderDate,
    required this.countryName,
    required this.healthCenters,
    required this.vaccineCardNumber,
    required this.stages,
  });

  factory ChildVaccinationDetails.fromJson(Map<String, dynamic> json) {
    return ChildVaccinationDetails(
      childId: json['child_id'] as String? ?? '',
      childName: json['child_name'] as String? ?? 'N/A',
      birthDate: _parseDateSafe(json['birth_date'] as String?),
      renderDate: _parseDateSafe(json['render_date'] as String?),
      countryName: json['country_name'] as String? ?? 'N/A',
      healthCenters: json['health_centers'] as String? ?? 'N/A',
      vaccineCardNumber: json['vaccine_card_number'] as String? ?? 'N/A',
      stages: (json['Stages'] as List<dynamic>? ?? [])
          .map((stageJson) => Stage.fromJson(stageJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Stage {
  final int stageId;
  final String stageName;
  final String recommendedAge;
  List<Vaccine>
      vaccines; // Made non-final to allow modification of vaccines within it

  Stage({
    required this.stageId,
    required this.stageName,
    required this.recommendedAge,
    required this.vaccines,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stage_id'] as int? ?? 0,
      stageName: json['stage_name'] as String? ?? 'N/A',
      recommendedAge: json['recommended_age'] as String? ?? 'N/A',
      vaccines: (json['vaccines'] as List<dynamic>? ?? [])
          .map((vaccineJson) =>
              Vaccine.fromJson(vaccineJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Vaccine {
  final int svdId; // <--- ****** أضف هذا الحقل ******
  final String vaccineName;
  final String doseNumber;
  final DateTime? vaccinationDate; // موعد الجرعة
  DateTime? visitDate; // تاريخ الزيارة (Mutable)
  final DateTime? lastDateForVaccine; // اخر موعد للجرعة
  int status; // الحالة (Mutable: 0 or 1)
  String? notes; // ملاحظات (Mutable)
  final bool isDelay;

  // To keep track of original values
  late int _originalStatus;
  late String? _originalNotes;
  late DateTime? _originalVisitDate;

  Vaccine({
    required this.svdId, // <--- ****** أضف هذا إلى الكونستركتور ******
    required this.vaccineName,
    required this.doseNumber,
    this.vaccinationDate,
    this.visitDate,
    this.lastDateForVaccine,
    required this.status,
    this.notes,
    required this.isDelay,
  }) {
    _originalStatus = status;
    _originalNotes = notes;
    _originalVisitDate = visitDate;
  }

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      svdId: json['svd_id']
          as int, // <--- ****** أضف قراءة هذا الحقل ****** (تأكد من أنه دائمًا int وليس null)
      vaccineName: json['vaccine_name'] as String? ?? 'N/A',
      doseNumber: json['dose_number'] as String? ?? 'N/A',
      vaccinationDate: _parseDateSafe(json['vaccination_date'] as String?),
      visitDate: _parseDateSafe(json['visit_date'] as String?),
      lastDateForVaccine:
          _parseDateSafe(json['last_date_for_vaccine'] as String?),
      status: json['status'] as int? ?? 0,
      notes: json['notes'] as String?,
      isDelay: json['isDelay'] as bool? ?? false,
    );
  }

  // Helper to check if vaccine data has changed
  bool get hasChanged {
    // تحسين مقارنة التواريخ لتجنب المشاكل مع المنطقة الزمنية أو الجزء من الثانية إذا كان التاريخ فقط هو المهم
    bool visitDateIsDifferent = false;
    if (_originalVisitDate == null && visitDate != null) {
      visitDateIsDifferent = true;
    } else if (_originalVisitDate != null && visitDate == null) {
      visitDateIsDifferent = true;
    } else if (_originalVisitDate != null && visitDate != null) {
      // قارن فقط اليوم والشهر والسنة إذا كان هذا هو المطلوب
      visitDateIsDifferent = !(_originalVisitDate!.year == visitDate!.year &&
          _originalVisitDate!.month == visitDate!.month &&
          _originalVisitDate!.day == visitDate!.day);
    }

    // تطبيع الملاحظات للمقارنة (null مقابل سلسلة فارغة)
    String? currentNotesNormalized =
        notes?.trim().isEmpty ?? true ? null : notes!.trim();
    String? originalNotesNormalized =
        _originalNotes?.trim().isEmpty ?? true ? null : _originalNotes!.trim();

    return status != _originalStatus ||
        currentNotesNormalized != originalNotesNormalized ||
        visitDateIsDifferent;
  }

  // Resets to original values (e.g., if save fails or user cancels)
  void reset() {
    status = _originalStatus;
    notes = _originalNotes;
    visitDate = _originalVisitDate;
  }

  // Call this after a successful save to update original values
  void updateOriginals() {
    _originalStatus = status;
    _originalNotes = notes;
    _originalVisitDate = visitDate;
  }
}
