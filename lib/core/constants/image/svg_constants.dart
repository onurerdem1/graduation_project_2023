class SVGImageConstants {
  static SVGImageConstants? _instace;

  static SVGImageConstants get instance =>
      _instace ??= SVGImageConstants._init();

  SVGImageConstants._init();

  String toSvg(String name) => 'assets/svg/$name.svg';
}
