import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_mate/util/StateManagement.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'models/ExpenseList.dart';
import 'models/dtos.dart';
import 'models/models.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late final HTTPRequestBuilder builder = HTTPRequestBuilder();

  //Prop<IList<Prop<Category>>> categoryList = Prop(<Prop<Category>>[].lockUnsafe);
  List<Category> categoryList = [];
  final ExpenseList expendList = ExpenseList(<Prop<Expense>>[].lockUnsafe);

  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }

  //clears the categoryList and fills it with fresh data from the backend
  Future<void> initListCategoryList() async {
    categoryList.clear();
    List<Category> exps = (await HTTPRequestBuilder()
        .get(path: "categories", returnType: List<Category>)) as List<Category>;
    for (Category element in exps) {
      categoryList.add(element);
    }
  }

  // Logs in the user and fills the [expendList] and [categoryList] with data from the backend
  Future<void> loginUser({
    required String name,
    required String password,
  }) async {
    try {
      await HTTPRequestBuilder().login(name: name, password: password);
      await expendList.initListExpenseList();
      await initListCategoryList();
    } catch (e) {
      print(e);
    }
  }

  // Registers a user with the backend
  Future<void> registerUser({
    required String name,
    required String password,
  }) async {
    await HTTPRequestBuilder().register(name: name, password: password);
  }

  //Logs out the user and clears the data
  Future<void> logoutUser() async {
    categoryList.clear();
    await builder.logout();
  }

  //Creates a Category and adds it to the [categoryList]
  Future<void> addCategory({
    required String name,
    required int budget,
    String? icon,
  }) async {
    Category cat = Category.create(name, budget, icon);
    await cat.create();
  }

  // Removes a category from the [categoryList] and backend
  Future<void> removeCategory(Category category) async {
    categoryList.remove(category);
    await HTTPRequestBuilder().delete(deleteType: Category, objId: category.id);
    await initListCategoryList();
    await expendList.initListExpenseList();
  }

  // Updates a category on the [categoryList] and backend
  Future<void> updateCategory(
      {required Category category, String? name, int? budget, String? icon}) async {
    // GET, SET name and budget methods on category not working rn, kinda hacky method to change the
    // attributes, but it works tho *Grinning Face With Sweat emoji*
    name ??= category.name;
    budget ??= category.budget;
    icon ??= category.icon;

    await HTTPRequestBuilder().put(
        path: "categories/${category.id}",
        obj: CategoryDTO(name, budget, category.id, icon),
        returnType: Category);
    initListCategoryList();
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return expendList != oldWidget.expendList;
  }
}