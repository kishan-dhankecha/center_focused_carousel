import 'package:center_focused_carousel/carousel/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

class CenterFocusedCarousel extends StatefulWidget {
  /// List of widgets to show in carousel view.
  final List<Widget> children;

  /// Carousel options like size, spacing, loop, etc.
  late final CarouselOptions options;

  CenterFocusedCarousel({
    super.key,
    required this.children,
    CarouselOptions? carouselOptions,
  }) {
    options = carouselOptions ??= const CarouselOptions();
    assert(
      children.isNotEmpty,
      "At least one child required for carousel to render on display.",
    );
  }

  @override
  State<CenterFocusedCarousel> createState() => _CenterFocusedCarouselState();
}

class _CenterFocusedCarouselState extends State<CenterFocusedCarousel>
    with SingleTickerProviderStateMixin {
  //
  var _direction = ScrollDirection.idle;

  //
  late final ValueNotifier<int> _currentIndex;

  late final AnimationController _controller;
  Animation<double>? _scaleTween;
  Animation<double>? _xOffsetTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));

    _currentIndex = ValueNotifier<int>(
      widget.options.initialIndex,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valueAdder = MediaQuery.of(context).size.width * 0.22;
    final endOffset = valueAdder - widget.options.backgroundOffset;

    _xOffsetTween = Tween<double>(
      begin: 0,
      end: endOffset,
    ).animate(_controller);

    _scaleTween = Tween<double>(
      begin: widget.options.viewFraction,
      end: widget.options.viewFraction * widget.options.sizeRatio,
    ).animate(_controller);

    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onHorizontalDragUpdate: (details) {
        // Sets the scroll direction
        if (details.delta.dx < 0) {
          // Next => Swiping right to left
          if (_direction != ScrollDirection.forward) {
            _direction = ScrollDirection.forward;
          }
        } else {
          // Previous => Swiping left to right
          if (_direction != ScrollDirection.reverse) {
            _direction = ScrollDirection.reverse;
          }
        }
      },
      child: Stack(
        children: _getStackWidgets(endOffset),
      ),
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Check if the [_currentIndex] is first
    final first = _currentIndex.value == 0;
    // Check if the [_currentIndex] is last
    final last = _currentIndex.value == widget.children.length - 1;
    // Check if the [_currentIndex] is first and swiping for previous element
    final isFirstBoundary = first && _direction == ScrollDirection.reverse;
    // Check if the [_currentIndex] is last and swiping for next element
    final isLastBoundary = last && _direction == ScrollDirection.forward;
    // return here if the loop flag is false
    if (!widget.options.loop && (isFirstBoundary || isLastBoundary)) {
      return;
    }

    // First do the animation
    _controller.forward().whenComplete(() {
      // reset the animation to restore the size and position for center widget
      _controller.reset();
      // After animation completes, Change the current index
      _changeIndex();
    });
  }

  void _changeIndex() {
    switch (_direction) {
      case ScrollDirection.forward:
        // Go to next index
        if (_currentIndex.value != (widget.children.length - 1)) {
          _currentIndex.value++;
        } else {
          _currentIndex.value = 0;
        }
        break;
      case ScrollDirection.reverse:
        // Go to previous index
        if (_currentIndex.value > 0) {
          _currentIndex.value--;
        } else {
          _currentIndex.value = widget.children.length - 1;
        }
        break;
      default:
        break;
    }
  }

  List<Widget> _getStackWidgets(double x) {
    return [
      // Widget before Previous Widget below Previous Widget
      if (_currentIndex.value > 1)
        Transform.translate(
          // To the left side of current widget
          offset: Offset(-x, 0),
          child: Transform.scale(
            scale: widget.options.viewFraction * widget.options.sizeRatio,
            child: widget.children[_currentIndex.value - 2],
          ),
        ),

      // Widget after Upcoming Widget below Upcoming Widget
      if (_currentIndex.value < (widget.children.length - 2))
        Transform.translate(
          // To the right side of current widget
          offset: Offset(x, 0),
          child: Transform.scale(
            scale: widget.options.viewFraction * widget.options.sizeRatio,
            child: widget.children[_currentIndex.value + 2],
          ),
        ),

      // Previous Widget to the left side
      if (_currentIndex.value > 0)
        Transform.translate(
          // To the left side of current widget
          offset: Offset(-x, 0),
          child: Transform.scale(
            scale: widget.options.viewFraction * widget.options.sizeRatio,
            child: widget.children[_currentIndex.value - 1],
          ),
        ),

      // Upcoming Widget to the right side
      if (_currentIndex.value < (widget.children.length - 1))
        Transform.translate(
          // To the right side of current widget
          offset: Offset(x, 0),
          child: Transform.scale(
            scale: widget.options.viewFraction * widget.options.sizeRatio,
            child: widget.children[_currentIndex.value + 1],
          ),
        ),

      // Current Widget
      AnimatedBuilder(
        animation: _xOffsetTween!,
        builder: (context, child) {
          late double xOffset;
          if (_direction == ScrollDirection.forward) {
            xOffset = -_xOffsetTween!.value;
          } else {
            xOffset = _xOffsetTween!.value;
          }
          return AnimatedBuilder(
            animation: _scaleTween!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(xOffset, 0),
                child: Transform.scale(
                  scale: _scaleTween!.value,
                  child: child!,
                ),
              );
            },
            child: child!,
          );
        },
        child: widget.children[_currentIndex.value],
      ),
    ];
  }

  // List<Widget> _getIndexedStackWidgets() {
  //   var widgets = _getStackWidgets();
  //   if (widgets.length < 3) return widgets.reversed.toList();
  //   if (!_controller.isAnimating) return widgets;
  //   switch (_scrollDirection) {
  //     case ScrollDirection.forward:
  //       if (_xOffsetTween.value < 20) {
  //         final el = widgets[widgets.length - 2];
  //         return widgets
  //           ..removeAt(widgets.length)
  //           ..add(el);
  //       }
  //       break;
  //     case ScrollDirection.reverse:
  //       if (_xOffsetTween.value > 20) {
  //         final el = widgets[widgets.length - 3];
  //         return widgets
  //           ..removeAt(widgets.length)
  //           ..add(el);
  //       }
  //       break;
  //     default:
  //       break;
  //   }
  //   return widgets;
  // }
}
