import 'package:flutter/material.dart';
import 'package:app/models/attribute.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilterScreenTest extends StatefulWidget {
  const FilterScreenTest({super.key});

  @override
  State<FilterScreenTest> createState() => _FilterScreenTestState();
}

class _FilterScreenTestState extends State<FilterScreenTest> {
  final List<String> categories = ['technology','languages','art','business'];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {

    final filterSkills = skillsList.where((attribute) {
      return selectedCategories.isEmpty || 
             selectedCategories.contains(attribute.categories);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Record'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories
                  .map((category) => FilterChip(
                    selected: selectedCategories.contains(category),
                      label: Text(category), 
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                          selectedCategories.add(category);

                        } else {
                          selectedCategories.remove(category);
                        }
                        });
                      }))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filterSkills.length,
                itemBuilder: (context, index) {
                  final attribute = filterSkills[index];
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.indigoAccent),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        title: Text(
                          attribute.skills,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          attribute.categories,
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
