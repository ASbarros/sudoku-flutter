class Item {
  int column;
  int line;
  int? value;
  Item({
    required this.column,
    required this.line,
    this.value,
  });
  String get coord => '$column,$line';

  @override
  String toString() => 'Item(column: $column, line: $line, value: $value)';
}
