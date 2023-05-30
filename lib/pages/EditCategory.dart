import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:flutter/services.dart';
import '../main.dart';


class EditCategory extends StatelessWidget {
  // EditCategory({super.key});
  Category category;
  EditCategory({required this.category, super.key});



  /*late final List<Category> categoryListOverview;

  EditCategory({required BuildContext context, super.key}) {
    categoryListOverview = UserState.of(context).categoryList;
  }*/

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form (
        key: _formKey,
        child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
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
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: budgetController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Betrag',
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
                          // UserState.of(context).updateCategory(category: category, name: nameController.value.text, budget: int.parse(budgetController.text));
                          Navigator.pop(context, 'OK');
                        }
                      },
                      icon: Icon( // <-- Icon
                        Icons.download ,
                        size: 24.0,
                      ),
                      label: Text('Hinzufügen'), // <-- Text
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

