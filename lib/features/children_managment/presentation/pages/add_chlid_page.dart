/*import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/sidebar.dart';
import 'package:new_project/Core/commn_widgets/top_bar.dart';
import 'package:new_project/features/children_managment/presentation/widget/addChildForm.dart';

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          //Sidebar(
            
         // ), // الشريط الجانبي
          Expanded(
            child: Column(
              children: [
                TopBar(
                  title: "إضافة طفل",
                ),
                SizedBox(height: 16),
                Text(
                  "بيانات الطفل",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: AddChildForm(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
