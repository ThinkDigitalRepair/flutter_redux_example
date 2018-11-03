import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_example/model/model.dart';
import 'package:flutter_redux_example/redux/actions.dart';
import 'package:flutter_redux_example/redux/reducers.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store =
        Store<AppState>(appStateReducer, initialState: AppState.initialState());
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Redux Example'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => Column(
                children: <Widget>[
                  AddItemWidget(model: viewModel),
                  Expanded(
                    child: ItemListWidget(model: viewModel),
                  ),
                  RemoveItemsButton(model: viewModel),
                ],
              ),
        ));
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function onRemoveItems;

  _ViewModel(
      {@required this.items,
      @required this.onAddItem,
      @required this.onRemoveItem,
      @required this.onRemoveItems});

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems(),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  const AddItemWidget({Key key, this.model}) : super(key: key);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: "Add an Item"),
      onSubmitted: (String string) {
        widget.model.onAddItem(string);
        controller.clear();
      },
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  const ItemListWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items
          .map((item) => ListTile(
                title: Text(item.body),
                leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: model.onRemoveItem(item)),
              ))
          .toList(),
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  const RemoveItemsButton({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Delete All Items"), onPressed: model.onRemoveItems);
  }
}
