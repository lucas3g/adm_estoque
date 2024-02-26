// ignore_for_file: public_member_api_docs, sort_constructors_first
class DatabaseParams {
  final String table;
  final String? key;
  final dynamic value;

  DatabaseParams({
    required this.table,
    this.key,
    this.value,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DatabaseParams && other.table == table;
  }

  @override
  int get hashCode => table.hashCode;
}
