import 'package:flutter/material.dart';
import '../UserState.dart';
import 'package:flutter/services.dart';
import '../main.dart';


class AddCategory extends StatelessWidget {
  AddCategory({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  String testIcon = 'home';


  ///Method to get the Icon
  /// Switch Case

  ///Set the int through the Buttons
  /// This method seems to work
  int iconCase = 0;

  String getIcon(iconCase){
    String result = '';
    switch( iconCase) {
      case 0:
        result = 'square';
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
        return 'square';
    }
    return result;
  }

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
                  hintText: 'Name',
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                /// Maybe change IconButton to IconButton.filled when pressed
                /// To-Do this its must be a Stateful Widget
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Hud()),);
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await UserState.of(context).addCategory(name: nameController.value.text, budget: int.parse(budgetController.text), icon: getIcon(iconCase));
                      // await UserState.of(context).addCategory(name: nameController.value.text, budget: int.parse(budgetController.text), icon: testIcon);
                      /// Adding a Category without an Icon causes trouble
                      /// check code if somewhere icon is not assigned as String?
                      // await UserState.of(context).addCategory(name: nameController.value.text, budget: int.parse(budgetController.text));
                      await UserState.of(context).initListCategoryList();
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesOverview()),);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Hud()),);
                    }
                  },
                  icon: Icon( // <-- Icon
                    Icons.add ,
                    size: 24.0,
                  ),
                  label: Text('Add'), // <-- Text
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
