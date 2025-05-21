import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/data/models/searchPersonResponse.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/logic/personal_state.dart';

class SearchIdentitySection extends StatefulWidget {
  final Function(SearchPersonResponse? result) onSearchCompleted;
  final String type;

  const SearchIdentitySection({
    super.key,
    required this.onSearchCompleted,
    required this.type,
  });

  @override
  State<SearchIdentitySection> createState() => _SearchIdentitySectionState();
}

class _SearchIdentitySectionState extends State<SearchIdentitySection> {
  final TextEditingController _identityController = TextEditingController();
  late PersonCubit _personalCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _personalCubit = BlocProvider.of<PersonCubit>(context);
  }

  Future<void> _search() async {
    final identity = _identityController.text.trim();
    if (identity.isEmpty) return;

    await _personalCubit.searchPersonById(
      identity,
      PersonType.values.byName(widget.type),
    );

    final state = _personalCubit.state;
    if (state is PersonSearchSuccess) {
      widget.onSearchCompleted(state.response);
    } else {
      widget.onSearchCompleted(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _search,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text("ابحث"),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 200,
            child: TextField(
              controller: _identityController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "أدخل رقم الهوية",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "يجب التحقق إذا كان الشخص مضاف سابقاً",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }
}
