class SVGImageConstants {
  static SVGImageConstants? _instace;

  static SVGImageConstants get instance =>
      _instace ??= SVGImageConstants._init();

  SVGImageConstants._init();
  String get splashLogo => toSvg('splash_logo');
  String get appName => toSvg('app_name');
  String toSvg(String name) => 'assets/svg/$name.svg';
}
