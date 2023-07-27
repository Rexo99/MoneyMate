import 'package:flutter/material.dart';
import '../UserState.dart';
import '../main.dart';
import '../models/models.dart';
import 'package:flutter/services.dart';


/// Used to update an instance of a category
/// The user changed the category name and budget through the two [TextFormField]s
/// and updates the Icon through an [IconButton]
///
/// Code in [EditCategory.dart] by Daniel Ottolien
class EditCategory extends StatelessWidget {
  Category category;
  EditCategory({required this.category, super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();


  ///Method to change the icon
  /// the int iconCase is changed on the Press of an [IconButton]
  int iconCase = 0;

  String? getIcon(iconCase){
    String? result = '';
    switch( iconCase) {
      case 0:
        result = category.icon;
        break;
      case 1:
        result = 'home';
        break;
      case 2:
        result = 'car_repair';
        break;
      case 3:
        result = 'local_grocery_store';
        break;
      case 4:
        result = 'local_bar';
        break;
      case 5:
        result = 'flight';
        break;
      case 6:
        result = 'business';
        break;
      case 7:
        result = 'album';
        break;
      case 8:
        result = 'pets';
        break;
      default:
        return category.icon;
    }
    return result;
  }

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
                    hintText: 'Budget',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Budget';
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
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.home),
                        onPressed: () {
                          iconCase = 1;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.car_repair),
                        onPressed: () {
                          iconCase = 2;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.local_grocery_store),
                        onPressed: () {
                          iconCase = 3;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.local_bar),
                        onPressed: () {
                          iconCase = 4;
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
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.flight),
                        onPressed: () {
                          iconCase = 5;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.business),
                        onPressed: () {
                          iconCase = 6;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.album),
                        onPressed: () {
                          iconCase = 7;
                          },
                      ),
                      IconButton(
                        iconSize: 50.0,
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(Icons.pets),
                        onPressed: () {
                          iconCase = 8;
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
                          icon: Icon(
                            Icons.cancel ,
                            size: 24.0,
                          ),
                          label: Text('Cancel'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            UserState.of(context).updateCategory(category: category, name: nameController.value.text, budget: int.parse(budgetController.text), icon: getIcon(iconCase));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Hud()),);
                          }
                          },
                          icon: Icon(
                            Icons.save_as_outlined ,
                            size: 24.0,
                          ),
                          label: Text('Change'),
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

