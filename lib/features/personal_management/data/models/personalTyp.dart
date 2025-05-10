enum PersonType {
  mother,
  father,
  employee,
  guardian,
  child,
}

extension PersonTypeExtension on PersonType {
  String get endpoint {
    switch (this) {
      case PersonType.mother:
        return motherEndpoint;
      case PersonType.father:
        return fatherEndpoint;
      case PersonType.employee:
        return employeeEndpoint;
      case PersonType.guardian:
        return guardianEndpoint;
      case PersonType.child:
        return childEndpoint;
    }
  }
}

const String motherEndpoint = 'mother';
const String fatherEndpoint = 'father';
const String employeeEndpoint = 'employee';
const String guardianEndpoint = 'guardian';
const String childEndpoint = 'child';
