class Employee {
  String name;
  String role;

  Employee(this.name, this.role);

  factory Employee.fromJSON(Map<String, dynamic> json) {
    return Employee(json['name'], json['role']);
  }

  Map<String, dynamic> toJSON() {
    return {'name': name, 'role': role};
  }
}
