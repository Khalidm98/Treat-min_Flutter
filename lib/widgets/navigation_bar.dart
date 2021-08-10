import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  final ValueChanged<int> onTap;
  final int index;
  final List<Widget> items;
  final List<Widget> activeItems;

  NavigationBar({
    Key key,
    @required this.onTap,
    @required this.index,
    @required this.items,
    this.activeItems,
  })  : assert(items.length >= 2 && items.length <= 5),
        assert(activeItems == null ? true : items.length == activeItems.length),
        super(key: key);

  @override
  State createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  double width = 0;
  Color indicatorColor;
  int currentIndex;

  List<Widget> get items => widget.items;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    Future.delayed(Duration.zero, () {
      setState(() {
        width = MediaQuery.of(context).size.width;
        indicatorColor = Theme.of(context).accentColor;
      });
    });
  }

  @override
  void didUpdateWidget(NavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentIndex = widget.index;
  }

  void _select(int index) {
    widget.onTap(index);
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 2,
            child: Row(
              children: items.map((item) {
                final index = items.indexOf(item);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _select(index),
                  child: Container(
                    height: 30,
                    width: width / items.length,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: widget.activeItems == null
                        ? item
                        : AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: index == currentIndex
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: widget.activeItems[index],
                            secondChild: item,
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
          AnimatedPositioned(
            // (width / count) / 4 + (width / count) * index
            left: (width / items.length) * (currentIndex + 0.25),
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            child: Container(
              color: indicatorColor,
              width: width / items.length / 2,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
