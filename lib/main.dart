import 'package:flutter/material.dart';
import 'package:sudoku/item_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sudoku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<Item>> items = <List<Item>>[];

  @override
  void initState() {
    super.initState();

    int line = 0;

    for (var i = 0, q = 0; i < 9; i++, q += 3) {
      List<Item> list = <Item>[];

      for (var j = 0; j < 9; j++) {
        list.add(Item(
          line: line,
          column: (j % 3) + q % 9,
        ));
        if (j == 2) {
          line++;
        } else if (j == 5) {
          line++;
        }
      }
      if (i == 0 || i == 1) {
        line = 0;
      } else if (i == 2 || i == 3 || i == 4) {
        line = 3;
      } else if (i == 5 || i == 6 || i == 7 || i == 8) {
        line = 6;
      }

      items.add(list);
    }
  }

  int? numberSelected;
  bool delete = false;

  bool isValid(List<Item> item, Item subItem) {
    if (numberSelected == null || subItem.value != null) {
      return false;
    }
    if (!item.map((e) => e.value).contains(numberSelected) &&
        isValid2(item, subItem)) {
      return true;
    }

    return false;
  }

  bool isValid2(List<Item> item, Item subItem) {
    // ignore: no_leading_underscores_for_local_identifiers
    for (final _items in items) {
      // ignore: no_leading_underscores_for_local_identifiers
      for (final _subItem in _items) {
        if ((_subItem.column == subItem.column ||
                _subItem.line == subItem.line) &&
            _subItem.value == numberSelected) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            children: items
                .map<Widget>(
                  (item) => DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black87,
                      width: 3,
                    )),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: item.map<Widget>((subItem) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (delete) {
                                setState(() {
                                  subItem.value = null;
                                });
                              } else if (isValid(item, subItem)) {
                                setState(() {
                                  delete = false;
                                  subItem.value = numberSelected!;
                                });
                              }
                            },
                            child: Center(
                              child: Text('${subItem.value ?? ''}'),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
                .toList(),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      delete = !delete;
                      numberSelected = null;
                    });
                  },
                  child: const Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 9,
            children: [1, 2, 3, 4, 5, 6, 7, 8, 9].map<Widget>(
              (index) {
                return SizedBox(
                  width: 50.0,
                  child: Card(
                    color: numberSelected == index
                        ? Colors.grey[300]
                        : Colors.grey[100],
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (numberSelected != index) {
                            numberSelected = index;
                            delete = false;
                          } else {
                            numberSelected = null;
                          }
                        });
                      },
                      child: Center(child: Text('$index')),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
