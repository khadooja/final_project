import 'package:flutter/material.dart';
import 'employee_form_fields.dart';

class EmployeeRegistrationForm extends StatefulWidget {
  const EmployeeRegistrationForm({super.key});

  @override
  State<EmployeeRegistrationForm> createState() =>
      _EmployeeRegistrationFormState();
}

class _EmployeeRegistrationFormState extends State<EmployeeRegistrationForm> {
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController hireDateController = TextEditingController();

  // محاكاة للبيانات اللي تجيك من الـ API
  EmployeeModel? fetchedEmployee;

  void fetchEmployeeData() async {
    // هذا مثال فقط، استبدله بطلبك الحقيقي
    fetchedEmployee = await fetchEmployeeFromAPI(idNumberController.text);

    if (fetchedEmployee != null && fetchedEmployee!.personData != null) {
      setState(() {
        firstNameController.text = fetchedEmployee!.personData!.firstName ?? '';
        lastNameController.text = fetchedEmployee!.personData!.lastName ?? '';
        emailController.text = fetchedEmployee!.personData!.email ?? '';
        birthDateController.text = fetchedEmployee!.personData!.birthDate ?? '';
        // لا نملأ بيانات الموظف مثل hireDate
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل موظف')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchEmployeeData,
              child: const Text('بحث برقم الهوية'),
            ),
            const SizedBox(height: 16),
            EmployeeFormFields(
              controllerIDNumber: idNumberController,
              controllerFirstName: firstNameController,
              controllerLastName: lastNameController,
              controllerEmail: emailController,
              controllerBirthDate: birthDateController,
              controllerPhone: phoneController,
              controllerHireDate: hireDateController,
            ),
          ],
        ),
      ),
    );
  }
}

// نموذج تجريبي
class EmployeeModel {
  final PersonData? personData;

  EmployeeModel({this.personData});
}

class PersonData {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthDate;

  PersonData({this.firstName, this.lastName, this.email, this.birthDate});
}

// استبدله بـ API الحقيقي
Future<EmployeeModel> fetchEmployeeFromAPI(String idNumber) async {
  await Future.delayed(const Duration(seconds: 1)); // تمثيل انتظار الشبكة
  if (idNumber == "1234567890") {
    return EmployeeModel(
      personData: PersonData(
        firstName: "أحمد",
        lastName: "العتيبي",
        email: "ahmad@example.com",
        birthDate: "1990-01-01",
      ),
    );
  } else {
    return EmployeeModel(personData: null);
  }
}
