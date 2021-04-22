import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback ondismissed;
  const DismissibleWidget(
      {@required this.item,
      @required this.child,
      @required this.ondismissed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(item),
        background: buildSwipeActionLeft(),
        child: child,
        onDismissed: ondismissed);
  }

  Widget buildSwipeActionLeft() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
