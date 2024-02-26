class SharedParams<T> {
  final String key;
  final T value;

  SharedParams({
    required this.key,
    required this.value,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SharedParams<T> && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
