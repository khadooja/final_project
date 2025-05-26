/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/guardian_management.dart/data/model/gurdian_model.dart';
import 'package:new_project/features/guardian_management.dart/data/model/relationship_type_model.dart';
import 'package:new_project/features/guardian_management.dart/logic/ChildGuardianCubit.dart';
import 'package:new_project/features/guardian_management.dart/logic/child_guardian_state.dart';
import 'package:new_project/features/guardian_management.dart/logic/guardian_state.dart';
import 'package:new_project/features/guardian_management.dart/presentation/wedgit/guardianForm.dart';
import 'package:new_project/features/guardian_management.dart/presentation/wedgit/guardianRelationshipSection.dart';
import 'package:new_project/features/guardian_management.dart/presentation/wedgit/submitButton.dart';
import 'package:new_project/features/personal_management/data/models/area_model.dart';
import 'package:new_project/features/personal_management/data/models/city_model.dart';
import 'package:new_project/features/personal_management/data/models/nationality_model.dart';
import 'package:new_project/features/personal_management/data/models/personalTyp.dart';
import 'package:new_project/features/personal_management/logic/personal_cubit.dart';
import 'package:new_project/features/personal_management/logic/personal_state.dart';
import 'package:new_project/features/personal_management/presentation/screens/search_Identity_Section.dart';

class GuardianScreen extends StatefulWidget {
  final String childId;
  final String source; 

  const GuardianScreen({
    super.key,
    required this.childId,
    required this.source, 
  });

  @override
  State<GuardianScreen> createState() => _GuardianScreenState();
}

class _GuardianScreenState extends State<GuardianScreen> {
  final TextEditingController _proofController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _childCountController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _showForm = false;

  GurdianModel _guardian = GurdianModel.empty();
  String? _relationshipTypeId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  // المتغيرات المفقودة
  String? _selectedGender;
  String? _selectedNationalityId;
  String? _selectedLocationId;
  List<String> _locations = [];
  bool _isDeceased = false;

  List<NationalityModel> _nationalities = [];
  List<CityModel> _cities = [];
  List<AreaModel> _areas = [];
  List<RelationshipTypeModel> _relationshipTypes = [];

  @override
  void initState() {
    super.initState();
    context.read<ChildGuardianCubit>().getRelationshipTypes();
    context.read<PersonCubit>().getNationalitiesAndCities(PersonType.guardian);
  }

  void _onSearch(String identity) {
    context.read<PersonCubit>().searchPersonById(PersonType.guardian as String, identity as PersonType);
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate() || _relationshipTypeId == null) return;

    final cubit = context.read<ChildGuardianCubit>();

    cubit.linkGuardianToChild(
      _guardian.id.toString(), 
      widget.childId,
      _relationshipTypeId!,
    );
  }

  void _onCityChanged(String cityName) {
    context.read<PersonCubit>().loadAreasByCityId(PersonType.guardian, cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة كفيل')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MultiBlocListener(
          listeners: [
           BlocListener<PersonCubit, PersonState>(
  listener: (context, state) {
    if (state is GuardianNotFound) {
      setState(() {
        _guardian = GurdianModel.empty();
      });
    } 
  },
),
            BlocListener<ChildGuardianCubit, ChildGuardianState>(
              listener: (context, state) {
                if (state is ChildGuardianLoadedRelationships) {
                  setState(() {
                    _relationshipTypes = state.relationships;
                  });
                } else if (state is ChildGuardianSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم ربط الكفيل بنجاح')),
                  );
                  Navigator.pop(context);
                } else if (state is ChildGuardianFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchIdentitySection(
                  type: 'guardian',
                  onSearchCompleted: (found) {
                    setState(() {
                      _showForm = true;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (_showForm) ...[
                  const SizedBox(height: 20),
                  GuardianForm(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    identityNumberController: _identityNumberController,
                    phoneNumberController: _phoneNumberController,
                    emailController: _emailController,
                    addressController: _addressController,
                    childCountController: _childCountController,
                    endDateController: _endDateController,
                    selectedGender: _selectedGender,
                    selectedLocationId: int.parse(_selectedLocationId ?? '0'),
                    selectedNationalityId:int.tryParse(_selectedNationalityId ?? '') ,
                    nationalities: const [],
                    onGenderChanged: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                    //selectedNationalityId: _selectedNationalityId,
                    onNationalityChanged: (id) {
                      setState(() {
                        _selectedNationalityId = id;
                      });
                    },
                    //selectedLocationId: _selectedLocationId,
                    locations: _locations,
                    onLocationChanged: (id) {
                      setState(() {
                        _selectedLocationId = id;
                      });
                    },
                    isDeceased: _isDeceased,
                    isActive: _isActive,
                    onIsDeceasedChanged: (val) {
                      setState(() {
                        _isDeceased = val ?? false;
                      });
                    },
                    onIsActiveChanged: (val) {
                      setState(() {
                        _isActive = val ?? true;
                      });
                    },
                    enabled: true,
                  ),
                  const SizedBox(height: 20),
                  GuardianRelationshipSection(
                    relationshipTypes: _relationshipTypes,
                    selectedTypeId: int.tryParse(_relationshipTypeId ?? ''), // Try to parse the string to an integer
                    onChanged: (id) => setState(() => _relationshipTypeId = id?.toString()),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<ChildGuardianCubit, ChildGuardianState>(
                    builder: (context, state) {
                      return SubmitButton(
                        onPressed: _onSubmit,
                        isLoading: state is ChildGuardianLoading,
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
              ],                              
            ),
          ),
        ),
      ),
    );
  }
}*/
