import 'package:flutter/foundation.dart';

/// an object being managed by this application
class Item {
  final int id;
  final String body;

  Item({@required this.id, @required this.body});

  /// since state is immutable, we don't change objects,
  /// we return new ones.
  Item copyWith({int id, String body}) =>
      // if the provided value is not passed (i.e. null) you don't want to return
      //a modified version of it, so return the original one.
      Item(id: id ?? this.id, body: body ?? this.body);
}

class AppState {
  final List<Item> items;

  AppState({@required this.items});
  // return an initial, blank state.
  AppState.initialState() : items = List.unmodifiable(<Item>[]);
}
