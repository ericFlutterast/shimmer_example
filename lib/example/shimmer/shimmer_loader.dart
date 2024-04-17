import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({
    super.key,
    required this.child,
    required this.isLoading,
  });

  final Widget child;
  final bool isLoading;

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> {
  RenderBox? _renderObj;
  Listenable? _shimmerChanges;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_shimmerChanges != null) {
      _shimmerChanges?.removeListener(_onShimmerChanges);
    }

    _shimmerChanges = Shimmer.of(context)?.controller;
    if (_shimmerChanges != null) {
      _shimmerChanges?.addListener(_onShimmerChanges);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChanges);
    super.dispose();
  }

  void _onShimmerChanges() {
    if (widget.isLoading) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final shimmerState = Shimmer.of(context);
    if (shimmerState == null || !shimmerState.isSize) {
      return widget.child;
    }
    final shimmerSize = shimmerState.size;
    final shimmerGradient = shimmerState.gradient;
    final offsetWithimShimmer = shimmerState.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox?,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return shimmerGradient.createShader(
          Rect.fromLTRB(
            -offsetWithimShimmer.dy,
            -offsetWithimShimmer.dx,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
  });

  final Widget? child;
  final LinearGradient gradient;

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  @override
  State<Shimmer> createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 1000),
      );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  ///Доступ к контроллеру для прослушивания изменений
  Listenable get controller => _animationController;

  ///Доступ к градиенту
  Gradient get gradient => LinearGradient(
        colors: widget.gradient.colors,
        stops: widget.gradient.stops,
        begin: widget.gradient.begin,
        end: widget.gradient.end,
        transform: _SlidingGradientTransform(
          slidePercent: _animationController.value,
        ),
      );

  ///Проверка отрисован ли оюъект через размер рендер обжект
  bool get isSize => (context.findRenderObject() as RenderBox).hasSize;

  ///Доступ к текущим размерам объекта
  Size get size => (context.findRenderObject() as RenderBox).size;

  ///Расчитать смещение для потомков
  Offset getDescendantOffset({
    required RenderBox? descendant,
    Offset offset = Offset.zero,
  }) {
    if (descendant == null) return offset;

    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}

final class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
