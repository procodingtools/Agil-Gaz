import 'package:agin_gaz/shared/dimens.dart';
import 'package:agin_gaz/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController _sizeController;
  Animation _sizeAnimation;
  double _width, _height;
  bool _repeat = true;
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Entered to splash screen');

    _sizeController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _sizeAnimation = Tween(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _sizeController, curve: Curves.elasticInOut));

    _sizeController.forward();
    _repeatAnim();

    Future.delayed(Duration(seconds: 5)).then((_) {
      _repeat = false;
      _sizeController.reset();
      _sizeController.dispose();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    hero: _logo(),
                  )),
          ModalRoute.withName('/home'));
    });
  }

  void _repeatAnim() async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (_repeat) {
        if (i == 0) {
          _sizeController.reverse();
          i = 1;
          _repeatAnim();
        } else {
          _sizeController.forward();
          i = 0;
          _repeatAnim();
        }
      }
    });
  }

  Widget _logo() {
    return Hero(
        tag: 'logo',
        child: Image.asset(
          'assets/agil_logo.png',
          width: _width * .5,
        ));
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    Dimens.HEIGHT = _height;
    Dimens.WIDTH = _width;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: AnimatedBuilder(
              animation: _sizeController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sizeAnimation.value,
                  child: _logo(),
                );
              })),
    );
  }
}
