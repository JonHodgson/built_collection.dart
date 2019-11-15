// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_collection.sorted_list;

import 'dart:math' show Random;

import 'package:built_collection/src/list.dart' show BuiltList;
import 'package:built_collection/src/iterable.dart' show BuiltIterable;
import 'package:built_collection/src/set.dart' show BuiltSet;
import 'package:quiver/core.dart' show hashObjects;

import 'internal/copy_on_write_list.dart';
import 'internal/iterables.dart';

part 'sorted_list/built_sorted_list.dart';
part 'sorted_list/sorted_list_builder.dart';

// Internal only, for testing.
class OverriddenHashcodeBuiltSortedList<T> extends _BuiltSortedList<T> {
  final int _overridenHashCode;

  OverriddenHashcodeBuiltSortedList(Iterable iterable, this._overridenHashCode)
      : super.copyAndCheckTypes(null, iterable);

  @override
  // ignore: hash_and_equals
  int get hashCode => _overridenHashCode;
}
