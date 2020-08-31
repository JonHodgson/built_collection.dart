// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.sorted_list;

typedef _Compare<E> = int Function(E a, E b);

/// The Built Collection Sorted[List].
///
/// It implements [Iterable] and the non-mutating part of the [List] interface.
/// Modifications are made via [SortedListBuilder].
///
/// See the
/// [Built Collection library documentation]
/// (#built_collection/built_collection)
/// for the general properties of Built Collections.
///
abstract class BuiltSortedList<E> implements Iterable<E>, BuiltIterable<E> {
  final List<E> _list;
  final _Compare<E> compare;
  int _hashCode;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltSortedList([1, 2, 3])`.
  ///
  /// Right: `new BuiltSortedList<int>([1, 2, 3])`.
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory BuiltSortedList(_Compare<E> compare, [Iterable iterable = const []]) =>
      BuiltSortedList<E>.from(compare, iterable);

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new BuiltSortedList.from([1, 2, 3])`.
  ///
  /// Right: `new BuiltSortedList<int>.from([1, 2, 3])`.
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory BuiltSortedList.from(_Compare<E> compare, Iterable iterable) {
    if (iterable is _BuiltSortedList && iterable.hasExactElementType(E)) {
      return iterable as BuiltSortedList<E>;
    } else {
      return _BuiltSortedList<E>.copyAndCheckTypes(compare, iterable);
    }
  }

  /// Instantiates with elements from an [Iterable<E>].
  ///
  /// `E` must not be `dynamic`.
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory BuiltSortedList.of(_Compare<E> compare, Iterable<E> iterable) {
    if (iterable is _BuiltSortedList<E> && iterable.hasExactElementType(E)) {
      return iterable;
    } else {
      return _BuiltSortedList<E>.copyAndCheckForNull(compare, iterable);
    }
  }

  /// Creates a [SortedListBuilder], applies updates to it, and builds.
  factory BuiltSortedList.build(_Compare<E> compare, Function(SortedListBuilder<E> builder) updates) =>
      (SortedListBuilder<E>(compare)..update(updates)).build();

  /// Converts to a [SortedListBuilder] for modification.
  ///
  /// The `BuiltSortedList` remains immutable and can continue to be used.
  SortedListBuilder<E> toBuilder() => SortedListBuilder<E>(compare, this);

  /// Converts to a [SortedListBuilder], applies updates to it, and builds.
  BuiltSortedList<E> rebuild(Function(SortedListBuilder<E> builder) updates) =>
      (toBuilder()..update(updates)).build();

  BuiltSortedList<E> toBuiltSortedList() => this;

  @override
  BuiltList<E> toBuiltList() => BuiltList.from(this);

  @override
  BuiltSet<E> toBuiltSet() => BuiltSet<E>(this);

  /// Deep hashCode.
  ///
  /// A `BuiltSortedList` is only equal to another `BuiltSortedList` with equal elements in
  /// the same order. Then, the `hashCode` is guaranteed to be the same.
  @override
  int get hashCode {
    _hashCode ??= hashObjects(_list);
    return _hashCode;
  }

  /// Deep equality.
  ///
  /// A `BuiltSortedList` is only equal to another `BuiltSortedList` with equal elements in
  /// the same order.
  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! BuiltSortedList) return false;
    if (other.length != length) return false;
    if (other.hashCode != hashCode) return false;
    for (var i = 0; i != length; ++i) {
      if (other[i] != this[i]) return false;
    }
    return true;
  }

  @override
  String toString() => _list.toString();

  /// Returns as an immutable list.
  ///
  /// Useful when producing or using APIs that need the [List] interface. This
  /// differs from [toList] where mutations are explicitly disallowed.
  List<E> asList() => List<E>.unmodifiable(_list);

  // List.

  /// As [List.elementAt].
  E operator [](int index) => _list[index];

  /// As [List.+].
  BuiltSortedList<E> operator +(BuiltSortedList<E> other) =>
      _BuiltSortedList<E>.withSafeList(compare, _list + other._list);

  /// As [List.length].
  @override
  int get length => _list.length;

  /// As [List.reversed].
  Iterable<E> get reversed => _list.reversed;

  /// As [List.indexOf].
  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  /// As [List.lastIndexOf].
  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);

  /// As [List.indexWhere].
  int indexWhere(bool Function(E element) test, [int start = 0]) =>
      _list.indexWhere(test, start);

  /// As [List.lastIndexWhere].
  int lastIndexWhere(bool Function(E element) test, [int start]) =>
      _list.lastIndexWhere(test, start);

  /// As [List.sublist] but returns a `BuiltSortedList<E>`.
  BuiltSortedList<E> sublist(int start, [int end]) =>
      _BuiltSortedList<E>.withSafeList(compare, _list.sublist(start, end));

  /// As [List.getRange].
  Iterable<E> getRange(int start, int end) => _list.getRange(start, end);

  /// As [List.asMap].
  Map<int, E> asMap() => _list.asMap();

  // Iterable.

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  Iterable<T> map<T>(T Function(E e) f) => _list.map(f);

  @override
  Iterable<E> where(bool Function(E element) test) => _list.where(test);

  @override
  Iterable<T> whereType<T>() => _list.whereType<T>();

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E e) f) => _list.expand(f);

  @override
  bool contains(Object element) => _list.contains(element);

  @override
  void forEach(void Function(E element) f) => _list.forEach(f);

  @override
  E reduce(E Function(E value, E element) combine) => _list.reduce(combine);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _list.followedBy(other);

  @override
  bool every(bool Function(E element) test) => _list.every(test);

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  bool any(bool Function(E element) test) => _list.any(test);

  /// As [Iterable.toList].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `BuiltSortedList`. So, if no mutations are
  /// made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  @override
  List<E> toList({bool growable = true}) =>
      CopyOnWriteList<E>(_list, growable);

  @override
  Set<E> toSet() => _list.toSet();

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterable<E> take(int n) => _list.take(n);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _list.takeWhile(test);

  @override
  Iterable<E> skip(int n) => _list.skip(n);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _list.skipWhile(test);

  @override
  E get first => _list.first;

  @override
  E get last => _list.last;

  @override
  E get single => _list.single;

  @override
  E firstWhere(bool Function(E element) test, {E Function() orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  E lastWhere(bool Function(E element) test, {E Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  E singleWhere(bool Function(E element) test, {E Function() orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  Iterable<T> cast<T>() => Iterable.castFrom<E, T>(_list);

  // Internal.

  BuiltSortedList._(this.compare, this._list) {
    if (E == dynamic) {
      throw UnsupportedError(
          'explicit element type required, for example "new BuiltSortedList<int>"');
    }
  }

}

/// Default implementation of the public [BuiltSortedList] interface.
class _BuiltSortedList<E> extends BuiltSortedList<E> {
  _BuiltSortedList.withSafeList(_Compare<E> compare, List<E> list) : super._(compare, list);

  _BuiltSortedList.copyAndCheckTypes(_Compare<E> compare,[Iterable iterable = const []])
      : super._(compare, List<E>.from(iterable, growable: false)) {
    for (var element in _list) {
      if (element is! E) {
        throw ArgumentError('iterable contained invalid element: $element');
      }
    }
  }

  _BuiltSortedList.copyAndCheckForNull(_Compare<E> compare, Iterable<E> iterable)
      : super._(compare, List<E>.from(iterable, growable: false)) {
    for (var element in _list) {
      if (identical(element, null)) {
        throw ArgumentError('iterable contained invalid element: null');
      }
    }
  }

  bool hasExactElementType(Type type) => E == type;
}
