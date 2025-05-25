import 'package:flutter/material.dart';
import 'package:new_project/features/guardian_management.dart/presentation/screens/guardian_screen.dart';

class ChildGuardiansScreen extends StatefulWidget {
  final String childId;

  const ChildGuardiansScreen({super.key, required this.childId});

  @override
  State<ChildGuardiansScreen> createState() => _ChildGuardiansScreenState();
}

class _ChildGuardiansScreenState extends State<ChildGuardiansScreen> {
  bool addedFromFather = false;
  bool addedFromMother = false;

  void _openAddGuardian(String source) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuardianScreen(
          childId: widget.childId,
          source: source,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        if (source == 'father') addedFromFather = true;
        if (source == 'mother') addedFromMother = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = !(addedFromFather && addedFromMother);

    return Scaffold(
      appBar: AppBar(title: const Text('الكفلاء')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('قائمة الكفلاء المرتبطين بالطفل:',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            // لاحقًا: استبدل هذا بقائمة الكفلاء الفعلية المرتبطين بالطفل
            const Placeholder(
              fallbackHeight: 100,
              color: Colors.grey,
            ),

            const Spacer(),

            if (canAddMore) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addedFromFather
                          ? null
                          : () => _openAddGuardian('father'),
                      child: const Text('إضافة كفيل من جهة الأب'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addedFromMother
                          ? null
                          : () => _openAddGuardian('mother'),
                      child: const Text('إضافة كفيل من جهة الأم'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // الرجوع للطفل أو صفحة الأطفال
                },
                child: const Text('تمت إضافة الكفلاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
