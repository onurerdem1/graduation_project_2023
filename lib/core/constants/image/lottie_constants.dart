class LottieImageConstants {
  static LottieImageConstants? _instace;

  static LottieImageConstants get instance =>
      _instace ??= LottieImageConstants._init();

  LottieImageConstants._init();

  String toLottie(String name) => 'assets/lottie/$name.json';
}
