import 'package:flutter/material.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:flutter/services.dart';



class EditCategory extends StatelessWidget {
  // EditCategory({super.key});
  Category category;
  EditCategory({required this.category, super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = category.name;
    budgetController.text = category.budget.toString();
    String name = category.name;
    String budget = category.budget.toString();
    return Scaffold(
      body: Form (
        key: _formKey,
        child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              // To-Do set value from the given Category
              controller: nameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Kategorienname',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Category';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              // To-Do set value from the given Category
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: budgetController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Budget',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Description';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text('Icons',
              style: const TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.car_repair),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.local_grocery_store),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.local_bar),
                    onPressed: () {
                      // ...
                    },
                  ),
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.flight),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.business),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.album),
                    onPressed: () {
                      // ...
                    },
                  ),
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.black,
                    icon: const Icon(Icons.pets),
                    onPressed: () {
                      // ...
                    },
                  ),
                ]
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon
                      (
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      icon: Icon( // <-- Icon
                        Icons.cancel ,
                        size: 24.0,
                      ),
                      label: Text('Cancel'), // <-- Text
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon
                      (
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          UserState.of(context).updateCategory(category: category, name: nameController.value.text, budget: int.parse(budgetController.text));
                          // UserState.of(context).updateCategory(category: UserState.of(context).categoryList.last, name: nameController.value.text, budget: int.parse(budgetController.text));
                          Navigator.pop(context, 'OK');
                        }
                      },
                      icon: Icon( // <-- Icon
                        Icons.save_as_outlined ,
                        size: 24.0,
                      ),
                      label: Text('Change'), // <-- Text
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    )
    );
  }
}

