/*import 'package:flutter/material.dart';
import 'package:new_project/Core/commn_widgets/custom_text_field.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';

class GuardianRelationshipSection extends StatelessWidget {
  final List<RelationshipTypeModel> relationshipTypes;
  final int? selectedTypeId;
  final ValueChanged<int?> onChanged;

  const GuardianRelationshipSection({
    super.key,
    required this.relationshipTypes,
    required this.selectedTypeId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: 'نوع العلاقة',
      keyboardType: InputType.dropdown,
      dropdownItems: relationshipTypes.map((type) => type.name).toList(),
      selectedValue: relationshipTypes
          .firstWhere((type) => type.id == selectedTypeId,
              orElse: () => relationshipTypes.first)
          .name,
      onChanged: (value) {
        final selected = relationshipTypes.firstWhere(
          (type) => type.name == value,
          orElse: () => relationshipTypes.first,
        );
        onChanged(selected.id);
      },
    );
  }
}
*/