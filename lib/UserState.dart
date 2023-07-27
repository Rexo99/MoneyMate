import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/util/StateManagement.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'models/ExpenseList.dart';
import 'models/dtos.dart';
import 'models/models.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late final HTTPRequestBuilder builder = HTTPRequestBuilder();
  List<Category> categoryList = [];
  final ExpenseList expendList = ExpenseList(<Prop<Expense>>[].lockUnsafe);

  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }

  /// Method to initialize the [categoryList] with data from the backend
  /// Code by Dannie Krösche
  Future<void> initListCategoryList() async {
    categoryList.clear();
    List<Category> exps = (await HTTPRequestBuilder()
        .get(path: "categories", returnType: List<Category>)) as List<Category>;
    for (Category element in exps) {
      categoryList.add(element);
    }
  }

  /// Method to login a user and initialize the [expendList] and [categoryList]
  /// Code by Dannie Krösche, Erik Hinkelmanns, Daniel Ottolien
  Future<void> loginUser({
    required String name,
    required String password,
  }) async {
    try {
      await HTTPRequestBuilder().login(name: name, password: password);

      if(HTTPRequestBuilder().loggedIn)
      {
        await expendList.initListExpenseList();
        await initListCategoryList();
      }
    } catch (e) {
      print(e);
    }
  }

  /// Method to register a user
  /// Code by Dorian Zimmermann
  Future<bool> registerUser({
    required String name, required String password })
  async {
     return await HTTPRequestBuilder().register(name: name, password: password);
  }

  /// Method to log out the user and clear the data
  /// Code by Dannie Krösche
  Future<void> logoutUser() async {
    categoryList.clear();
    await builder.logout();
  }

  /// Method to add a category to the [categoryList] and backend
  /// Code by Dannie Krösche
  Future<void> addCategory({
    required String name,
    required int budget,
    String? icon,
  }) async {
    Category cat = Category.create(name, budget, icon);
    await cat.create();
  }

  /// Method to remove a category from the [categoryList] and backend
  /// Code by Dannie Krösche
  Future<void> removeCategory(Category category) async {
    categoryList.remove(category);
    await HTTPRequestBuilder().delete(deleteType: Category, objId: category.id);
    await initListCategoryList();
    await expendList.initListExpenseList();
  }

  /// Method to update a category in the [categoryList] and backend
  /// Code by Dannie Krösche, Daniel Ottolien
  Future<void> updateCategory(
      {required Category category, String? name, int? budget, String? icon}) async {
    name ??= category.name;
    budget ??= category.budget;
    icon ??= category.icon;

    await HTTPRequestBuilder().put(
        path: "categories/${category.id}",
        obj: CategoryDTO(name, budget, category.id, icon),
        returnType: Category);
    initListCategoryList();
  }

  /// Method to get a category by its id
  /// Code by Erik Hinkelmanns
  Category? getCategoryById({required categoryId}){
    for(Category c in categoryList) {
      if(c.id == categoryId) {
        return c;
      }
    }
    return null;
  }

  /// Method to get the icon of a category by its id
  /// Code by Erik Hinkelmanns
  IconData getIconFromCategoryId({required categoryId}){
    Category? category = getCategoryById(categoryId: categoryId);
    if (category == null){
      return Icons.square;
    }
    return category.getIconData();
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return expendList != oldWidget.expendList;
  }
}