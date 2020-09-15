import 'package:flutter/foundation.dart';

@immutable
abstract class RepliesState {}

/// The state when replies are currently being loaded.
class LoadingRepliesState extends RepliesState {}
