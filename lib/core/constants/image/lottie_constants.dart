class LottieImageConstants {
  static LottieImageConstants? _instace;

  static LottieImageConstants get instance =>
      _instace ??= LottieImageConstants._init();

  LottieImageConstants._init();
  String get animation => toLottie('animation');
  String toLottie(String name) => 'assets/images/$name.json';
}
