import 'dart:async';

sealed class ShimmerExamleState {
  factory ShimmerExamleState.loading() = LoadingState;

  factory ShimmerExamleState.success() = SuccessState;

  T map<T extends Object?>({
    required T Function(LoadingState) loading,
    required T Function(SuccessState) success,
  });
}

final class LoadingState implements ShimmerExamleState {
  @override
  T map<T extends Object?>({
    required T Function(LoadingState loading) loading,
    required T Function(SuccessState success) success,
  }) {
    return loading(this);
  }
}

final class SuccessState implements ShimmerExamleState {
  @override
  T map<T extends Object?>({
    required T Function(LoadingState loading) loading,
    required T Function(SuccessState success) success,
  }) {
    return success(this);
  }
}

final class StateController {
  StateController() : _streamController = StreamController<ShimmerExamleState>();

  final StreamController<ShimmerExamleState> _streamController;

  Stream<ShimmerExamleState> get currentState => _streamController.stream;

  Future<void> initFakeRequest() async {
    _streamController.add(ShimmerExamleState.loading());

    await Future.delayed(const Duration(seconds: 5));

    _streamController.add(ShimmerExamleState.success());
  }
}
