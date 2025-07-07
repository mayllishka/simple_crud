import 'package:flutter/material.dart';
import 'package:simple_crud/src/firestore_service.dart';
import 'employee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> roles = [
    "Tutor",
    "Dozent",
    "Operations",
    "Manager",
    "CEO",
    "Praktikant",
  ];
  String? _selectedTag;
  final TextEditingController nameController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  Future<void> _addEmployee() async {
    final name = nameController.text.trim();
    final role = _selectedTag;
    if (name.isEmpty || role == null) return;
    await firestoreService.addEmployee(Employee(name, role));
    nameController.clear();
    setState(() {
      _selectedTag = null; // Reset selection after adding
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple CRUD-App")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: roles.map((role) {
                return ChoiceChip(
                  label: Text(role),
                  selected: _selectedTag == role,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedTag = selected ? role : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              onSubmitted: (_) => _addEmployee(),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _addEmployee,
              child: const Text("Hinzufügen"),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: firestoreService.getAllEmployees(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Keine Einträge gefunden."),
                    );
                  }
                  final rolesList = snapshot.data!
                      .map((data) => Employee.fromJSON(data))
                      .toList();
                  return ListView.separated(
                    itemCount: rolesList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final role = rolesList[index];
                      return ListTile(
                        title: Text(role.name),
                        subtitle: Text(role.role),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
