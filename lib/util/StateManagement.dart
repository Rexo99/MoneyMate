import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class ReactiveListener {
  /// The stack of [ReactiveListener] contexts in which execution
  /// is currently happening. Makes it possible to access the current
  /// context when accessing a [ReactiveValue].
  static final _contextStack = <ReactiveListener>[];

  static ReactiveListener? get _currentContextListener =>
      _contextStack.isEmpty ? null : _contextStack.last;

  Set<ReactiveValue> dependencies = {};

  void onDependencyChange();

  void listenTo(ReactiveValue dependency) {
    if (dependencies.add(dependency)) {
      dependency.addListener(onDependencyChange);
    }
  }

  void removeAllListeners() {
    for (var dependency in dependencies) {
      dependency.removeListener(onDependencyChange);
    }
    dependencies.clear();
  }

  void executeInContext(VoidCallback exec) {
    _contextStack.add(this);
    exec();
    assert(_contextStack.last == this);
    _contextStack.removeLast();
  }
}

abstract class ReactiveWidget extends StatefulWidget {
  const ReactiveWidget({super.key});

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => _ReactiveWidgetState();
}

class _ReactiveWidgetState extends State<ReactiveWidget> with ReactiveListener {
  @override
  void onDependencyChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    removeAllListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    removeAllListeners();
    Widget? result;
    executeInContext(() {
      result = widget.build(context);
    });
    return result!;
  }
}

class ReactiveBuilder extends StatefulWidget {
  final Widget Function() builder;
  const ReactiveBuilder(this.builder, {super.key});

  @override
  State<StatefulWidget> createState() => _ReactiveBuilderState();
}

class _ReactiveBuilderState extends State<ReactiveBuilder>
    with ReactiveListener {
  Widget? cache;

  @override
  void onDependencyChange() {
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) setState(() => cache = null);
    //});
  }

  @override
  void dispose() {
    removeAllListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cache == null) {
      removeAllListeners();
      executeInContext(() {
        cache = widget.builder();
      });
    }
    return cache!;
  }
}

abstract class ReactiveValue<T> extends ChangeNotifier
    implements ValueListenable<T> {}

class Prop<T> extends ReactiveValue<T> {
  T _value;
  Prop(this._value);

  @override
  T get value {
    ReactiveListener._currentContextListener?.listenTo(this);
    return _value;
  }

  set value(T val) {
    print("setter: $val" );
    _value = val;
    notifyListeners();
  }
}

class PropList<T> extends Prop<List<ReactiveValue<T>>> {
  PropList(List<ReactiveValue<T>> items) : super(items);

  void add(ReactiveValue<T> item) {
    super.value.add(item);
    super.notifyListeners();
  }

  Iterable<T> get values => value.map((item) => item.value);

  ReactiveValue<T> operator [](int index) => super.value[index];
}

/// A [List] of [Prop]s of type T.
/// To use other [ReactiveValue]s than [Prop]s use [PropList].
///
/// Accessing an item using the index operator bypasses the lists
/// value getter, so only changes of that item trigger a context rebuild,
/// not changes of the list itself.
class Props<T> extends Prop<List<Prop<T>>> {
  Props(Iterable<T> items) : super(items.map((item) => Prop(item)).toList());

  void add(T item) {
    value.add(Prop(item));
    notifyListeners();
  }

  void removeAt(int index) {
    value.removeAt(index);
    notifyListeners();
  }

  Iterable<T> get values => value.map((item) => item.value);

  int get length => value.length;

  T operator [](int index) => _value[index].value;
}

