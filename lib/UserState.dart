import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_mate/state.dart';
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
    List<Category> exps = (await HTTPRequestBuilder().get(
        path: "categories",
        returnType: List<Category>)) as List<Category>;
    for (Category element in exps) {
      categoryList.add(element);
    }
  }

  // Logs in the user and fills the [expendList] and [categoryList] with data from the backend
  Future<void> loginUser({
    required String name,
    required String password,
  }) async {
    await HTTPRequestBuilder().login(name: name, password: password);
    await expendList.initListExpenseList();
    initListCategoryList();
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
  void addCategory({
    required String name,
    required int budget,
  }) {
    categoryList.add(new Category.create(name, budget));
  }

  // Removes a category from the [categoryList] and backend
  void removeCategory(Category category) {
    categoryList.remove(category);
    HTTPRequestBuilder().delete(deleteType: Category, objId: category.id);
  }

  // Updates a category on the [categoryList] and backend
  void updateCategory({required Category category, String? name, int? budget}) {
    // GET, SET name and budget methods on category not working rn, kinda hacky method to change the
    // attributes, but it works tho *Grinning Face With Sweat emoji*
    if (name == null) {
      name = category.name;
    }
    if (budget == null) {
      budget = category.budget;
    }
    HTTPRequestBuilder().put(
        path: "categories/${category.id}",
        obj: CategoryDTO(name, budget, category.id),
        returnType: Category);
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return expendList != oldWidget.expendList;
  }
}
