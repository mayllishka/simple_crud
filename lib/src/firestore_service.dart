import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_crud/src/employee.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    try {
      final querySnapshot = await _firestore.collection('employees').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addEmployee(Employee employee) async {

    await _firestore.collection('employees').add(employee.toJSON());
  }
}
