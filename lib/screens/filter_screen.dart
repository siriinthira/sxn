import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilterScreen extends StatefulWidget {
  final FilterOptions filterOptions;
  final ValueChanged<FilterOptions> onFilterChanged;
  

  FilterScreen({required this.filterOptions, required this.onFilterChanged});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> skills = ["programming", "cooking", "translating"];
  List<String> occupation = ["programmer", "translator", "food artist"];
  List<String> hobbies = ["photography", "watch movie", "reading", "work out", "listen to music"];
  List<String> schools = ["abc", "defg", "hijk", "lmno"];
  List<String> universities = ["CU", "TU", "UTCC", "KU"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(labelText: 'Skills'),
              ),
              suggestionsCallback: (pattern) {
                return skills.where((item) => item.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  widget.filterOptions.selectedSkills = suggestion;
                });
              },
            ),
            // Similar TypeAheadField widgets for other filter options
            ElevatedButton(
              onPressed: () {
                widget.onFilterChanged(widget.filterOptions);
                Navigator.of(context).pop();
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOptions {
  String selectedSkills = "";
  String selectedOccupation = "";
  String selectedHobbies = "";
  String selectedUniversities = "";
  String selectedSchools = "";

  bool get hasFilters {
    return selectedSkills.isNotEmpty ||
        selectedOccupation.isNotEmpty ||
        selectedHobbies.isNotEmpty ||
        selectedUniversities.isNotEmpty ||
        selectedSchools.isNotEmpty;
  }
}
