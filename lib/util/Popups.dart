import 'dart:core';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:money_mate/UserState.dart';
import '../main.dart';
import '../models/models.dart';
import 'Camera.dart';
import 'StateManagement.dart';

/// [Popups.dart] consists of all frequently used popups and overlays,
/// so that they don't have to be created from scratch over and over again.

/// A popup that allows the user to change the name and amount of an expense.
Future<void> updateExpensePopup(
    {required Prop<Expense> expense, required BuildContext context}) async {
  FilePickerResult? result;
  Prop<Uint8List> imageBytes = Prop(Uint8List(0));
  if (expense.value.imageId != null)
    imageBytes.value = await UserState.of(context).builder.getImage(imageId: expense.value.imageId);
  String name = expense.value.name;
  int? imageId = expense.value.imageId;
  String amount = expense.value.amount.toString();
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Edit Expense'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.shopping_cart),
                labelText: 'Name',
              ),
              initialValue: expense.value.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  name = value;
                }
                return null;
              },
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                labelText: 'Amount',
              ),
              initialValue: expense.value.amount.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                } else if (num.tryParse(value) == null) {
                  return "Please enter a valid number";
                } else {
                  amount = value;
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result != null) {
                    // Get the selected file path
                    String filePath = result!.files.single.path!;

                    // Read the file as bytes
                    File image = File(filePath);

                    imageId = await UserState.of(context).builder.createImage(file: image);

                    imageBytes.value = await File(filePath).readAsBytes();
                  }
                },
                child: const Text('Select Image'),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (imageBytes.value.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.memory(
                        imageBytes.value,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 100,
                width: 100,
                child: $(imageBytes, (p0) => imageBytes.value.isNotEmpty
                    ? Image.memory(
                  imageBytes.value,
                  fit: BoxFit.cover,
                )
                    : const Text(''),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subContext).showSnackBar(
                uniformSnackBar('Updated Expense'),
              );
              UserState.of(context).expendList.updateItem(
                  expense: expense, name: name, amount: double.parse(amount), imageId: imageId);
              Navigator.pop(subContext, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// A popup that allows the user to create an expense.
/// Code by ...
void createExpensePopup({required BuildContext context}) {
  String name = "";
  String amount = "";
  int? imageId;
  Prop<Uint8List> imageBytes = Prop(Uint8List(0));
  late int categoryId;
  late String imagePath;
  final formKey = GlobalKey<FormState>();
  FilePickerResult? result;
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Add Expense'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.shopping_cart),
                hintText: 'Name of your Expense?',
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  name = value;
                }
                return null;
              },
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                hintText: 'Amount of your Expense',
                labelText: 'Amount',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pleas enter a number';
                } else if (double.tryParse(value) == null) {
                  return "Pleas enter a valid number";
                } else {
                  amount = value;
                }
                return null;
              },
            ),
            DropdownButtonFormField<Category>(
              items: UserState.of(context).categoryList.map<DropdownMenuItem<Category>>((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (selectedCategory) {
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.category),
                hintText: 'Category of your Expense',
                hintStyle: TextStyle(overflow: TextOverflow.fade),
                labelText: 'Category',

              ),
              validator: (value) {
                if (value == null || value.id == null) {
                  return 'Please choose a category';
                }
                categoryId = value.id!;
                return null;
              },
            ),
            DropdownButtonFormField(
              items: <String>['Take Picture', 'Choose existing Image'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selectedAction) async {
                if(selectedAction == "Take Picture") {
                  final cameras = await availableCameras();
                  Widget camera = InitializeCamera(camera: cameras.first);
                  imagePath = await Navigator.push(context, MaterialPageRoute(builder: (context) => camera));
                  if(imagePath != null && imagePath.isNotEmpty) {
                    // Read the file as bytes
                    File image = File(imagePath);

                    imageId = await UserState.of(context).builder.createImage(file: image);

                    imageBytes.value = await File(imagePath).readAsBytes();
                  }
                } else if(selectedAction == "Choose existing Image") {
                  result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result != null) {
                    // Get the selected file path
                    String filePath = result!.files.single.path!;

                    // Read the file as bytes
                    File image = File(filePath);

                    imageId = await UserState.of(context).builder.createImage(file: image);

                    imageBytes.value = await File(filePath).readAsBytes();
                  }
                }
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.image),
                hintText: 'Select image',
                hintStyle: TextStyle(overflow: TextOverflow.fade),
                labelText: 'Image',
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                if (imageBytes.value.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0))
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.memory(
                        imageBytes.value,
                        fit: BoxFit.fill,
                        ),
                    ),
                  );
                }
              },
              child: Container(
                height: 100,
                width: 100,
                child: $(imageBytes, (p0) => imageBytes.value.isNotEmpty
                    ? Image.memory(
                  imageBytes.value,
                  fit: BoxFit.cover,
                )
                    : const Text(''),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subContext).showSnackBar(
                uniformSnackBar('Created Expense'),
              );
              UserState.of(context).expendList.addExpense(
                  name: name,
                  amount: num.parse(amount),
                  categoryId: categoryId,
                  imageId: imageId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Hud()));
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

///
/// Code by Daniel Ottolien
void connectivityPopup({required BuildContext context}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('No connectivity found'),
          content: const Text('If this error persists, check your phones network connection  \n  \nYour Data will not be saved'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
  );
}

/// Popup used in [Info.dart] to show
/// the implemented features of a team member
///
/// Code by Dorian Zimmermann
void infoPopup({required List featureList, required BuildContext context}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Implemented Features'),
      content: Column(
        children: [...featureList],
        mainAxisSize: MainAxisSize.min,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Determines which theme is currently in use
/// and returns the according color palette
///
/// Code by Dorian Zimmermann
List<Color> getSystemColor(context) {
  if(SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark) {
    return [Color(0xff201a18), Color(0xffe8e2d9)]; //dark (first is backgroundColor, second is textColor)
  } else {
    return [Color(0xfffffbff), Color(0xff1d1b16)]; //light (first is backgroundColor, second is textColor)
  }
}

/// [themePicker] popup, that lets the user change the accent color of the app,
/// as well as switching between light, dark and system mode.
///
/// Code by Dorian Zimmermann
void themePicker(
    {required Color currentColor, required ThemeMode currentThemeMode, required BuildContext context}) {
  List<Color> _colors = MyApp.of(context).getThemeColors();
  List<bool> _selection = List.generate(3, (index) => false); //List for switching app design
  _selection[MyApp.of(context).getThemeModes().indexOf(MyApp.of(context).getCurrentThemeMode())] = true;

  Color _newColor = MyApp.of(context).getCurrentThemeColor();
  ThemeMode _newTheme = MyApp.of(context).getCurrentThemeMode();
  Color _backgroundColor = Theme.of(context).dialogBackgroundColor;
  Color? _textColor = Theme.of(context).textTheme.displayLarge?.color;

  bool _isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: _backgroundColor,
              surfaceTintColor: _newColor,
              iconColor: _newColor,
              titleTextStyle: TextStyle(color: _textColor),
              contentTextStyle: TextStyle(color: _textColor),
              title: const Text('Theme Settings', style: TextStyle(fontSize: 20),),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 25),
                    Text(
                        'Choose your Theme Color', textAlign: TextAlign.center, style: TextStyle(color: _textColor)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[0];}),
                            child: Text('Red', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[0],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[1];}),
                            child: Text('Purple', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[1],
                                shape: CircleBorder())
                        ),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[2];}),
                            child: Text('Blue', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[2],
                                shape: CircleBorder())
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[3];}),
                            child: Text('Green', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[3],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[4];}),
                            child: Text('Yellow', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[4],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[5];}),
                            child: Text('Brown', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[5],
                                shape: CircleBorder())),

                      ],
                    ),
                    const SizedBox(height: 25),
                    Divider(color: _newColor.withAlpha(100)),
                    const SizedBox(height: 25),
                    Text('Choose your Theme Mode', textAlign: TextAlign.center, style: TextStyle(color: _textColor)),
                    const SizedBox(height: 10),
                    Center(
                        child: ToggleButtons(
                          color: _isDark ? Colors.white70 : Colors.black87,
                          selectedColor: _newColor,
                          borderColor: _isDark ? Colors.white10 : Colors.black12,
                          selectedBorderColor: _isDark ? Colors.white12 : Colors.black12,
                          fillColor: _newColor.withAlpha(30),
                          children: [
                            Icon(Icons.light_mode),
                            Icon(Icons.dark_mode),
                            Icon(Icons.app_shortcut)
                          ],
                          isSelected: _selection,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)),
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selection.length; i++) {
                                _selection[i] = i == index;
                              }
                              switch (index) {
                                case 0:
                                  setState(() {_newTheme = ThemeMode.light;
                                  _backgroundColor = Color(0xfffffbff);
                                  _textColor = Color(0xff1d1b16);
                                  _isDark = false;
                                  });
                                  break;
                                case 1:
                                  setState(() {_newTheme = ThemeMode.dark;
                                  _backgroundColor = Color(0xff201a18);
                                  _textColor = Color(0xffe8e2d9);
                                  _isDark = true;
                                  });
                                  break;
                                case 2:
                                  setState(() {_newTheme = ThemeMode.system;
                                  _backgroundColor = getSystemColor(context)[0];
                                  _textColor = getSystemColor(context)[1];
                                  _isDark = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
                                  });
                                  break;
                              }
                            });
                          },
                        )
                    ),
                    const SizedBox(height: 25),
                  ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                  child: Text('Cancel', selectionColor: _newColor, style: TextStyle(color: _newColor)),
                ),
                TextButton(
                  onPressed: () {
                    int count = 0;
                    MyApp.of(context).changeTheme(_newColor, _newTheme);
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                  child: Text('Confirm', style: TextStyle(color: _newColor)),
                ),
              ],
            );
          });
    });
}

/// Erstellt einen floating [SnackBar] mit abgerundeten Ecken
/// [text] ist ein String, der im SnackBar zu sehen ist, von
/// diesem wird auch die [width] des SnackBars bestimmt.
///
/// Code von Dorian Zimmermann
SnackBar uniformSnackBar(String text) {
  return SnackBar(
      content: Text(text, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20))),
      width: (text.length * 10),
      clipBehavior: Clip.none,
  );
}