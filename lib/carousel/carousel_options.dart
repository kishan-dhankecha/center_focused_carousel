class CarouselOptions {
  /// Determines if carousel should loop infinitely or be limited to item length.
  ///
  /// Defaults to false, i.e. limited to item length.
  final bool loop;

  /// The [viewFraction] is fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 0.8, which means each page fills 80% of the carousel.
  final double viewFraction;

  /// The [sizeRatio] is fraction of the current widget size that each background widget should occupy.
  ///
  /// Defaults to 0.7, which means each background widget fills 70% of the current widget.
  final double sizeRatio;

  /// The [backgroundOffset] sets the distance from the screen end
  /// for each background widget.
  final double backgroundOffset;

  /// The initial page to show when first creating the [CenterFocusedCarousel].
  ///
  /// Defaults to 0.
  final int initialIndex;

  const CarouselOptions({
    this.loop = false,
    this.viewFraction = 0.8,
    this.sizeRatio = 0.7,
    this.backgroundOffset = 15,
    this.initialIndex = 0,
  });
}
