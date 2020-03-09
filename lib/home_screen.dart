import 'package:agin_gaz/shared/dimens.dart';
import 'package:agin_gaz/location_screen.dart';
import 'package:agin_gaz/shared/list_behavior.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Widget hero;

  const HomeScreen({Key key, this.hero}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with TickerProviderStateMixin {
  double _width, _height;
  List<Map<String, dynamic>> _list = List();
  AnimationController _translateController,
      _fItemController,
      _sItemController,
      _tItemController,
      _itemsController,
      _logoFadeController;
  Animation _translateAnim,
      _scaleAnim,
      _logoFadeAnim,
      _fFadeAnim,
      _sFadeAnim,
      _tFadeAnim,
      _fItemAnim,
      _sItemAnim,
      _tItemAnim;
  int _horseState, _logoState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> map = Map();
      map['title'] = i == 0 ? "essence" : i == 1 ? "Durabilitée" : 'Kiosques';
      map['icon'] = i == 0
          ? FontAwesomeIcons.gasPump
          : i == 1
              ? FontAwesomeIcons.tachometerAlt
              : FontAwesomeIcons.mapMarkedAlt;
      map['txt'] = i == 0
          ? 'Le plus puissant'
          : i == 1 ? 'La durabilité ultime' : 'Consulter notre kiosques';
      _list.add(map);
    }

    _width = Dimens.WIDTH;
    _height = Dimens.HEIGHT;

    _translateController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _scaleAnim = Tween(begin: 1.3, end: 0.7).animate(
        CurvedAnimation(parent: _translateController, curve: Curves.easeInOut));
    _translateAnim = Tween(begin: _height * .02, end: -_height * .02).animate(
        CurvedAnimation(parent: _translateController, curve: Curves.easeInOut));
    _translateController.forward();
    _horseState = 0;
    _logoState = 0;
    _repeatAnim();

    _fItemController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _sItemController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _tItemController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _fFadeAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fItemController, curve: Curves.easeOut));
    _sFadeAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _sItemController, curve: Curves.easeOut));
    _tFadeAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _tItemController, curve: Curves.easeOut));
    _fItemAnim = Tween(begin: -150.0, end: 0.0).animate(
        CurvedAnimation(parent: _fItemController, curve: Curves.easeOut));
    _sItemAnim = Tween(begin: -150.0, end: 0.0).animate(
        CurvedAnimation(parent: _sItemController, curve: Curves.easeOut));
    _tItemAnim = Tween(begin: -150.0, end: 0.0).animate(
        CurvedAnimation(parent: _tItemController, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 300))
        .then((_) => _fItemController.forward());
    Future.delayed(Duration(milliseconds: 600)).then((_) {
      _tItemController.forward();
      Future.delayed(Duration(milliseconds: 300)).then((_) {
        _sItemController.forward();
      });
    });

    _logoFadeController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _logoFadeAnim = Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _logoFadeController, curve: Curves.easeOut));
    _logoFadeController.forward();
    _repeatLogoAnim();
  }

  void _repeatLogoAnim() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (_logoState == 0) {
        _logoFadeController.reverse();
        _logoState = 1;
        _repeatLogoAnim();
      } else {
        _logoFadeController.forward();
        _logoState = 0;
        _repeatLogoAnim();
      }
    });
  }

  void _repeatAnim() {
    Future.delayed(Duration(seconds: 10)).then((_) {
      if (_horseState == 0) {
        _translateController.reverse();
        _horseState = 1;
        _repeatAnim();
      } else {
        _translateController.forward();
        _horseState = 0;
        _repeatAnim();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black,
            Colors.grey.withOpacity(.0),
            Colors.black
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            children: <Widget>[
              _actionBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _fFadeAnim,
                      builder: (context, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .02, vertical: 4.0),
                          child: Opacity(
                            opacity: _fFadeAnim.value,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  _fItemAnim.value, 0.0, 0.0),
                              child:
                                  _listBtn(child: _btnContent(data: _list[0])),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _sFadeAnim,
                      builder: (context, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .02, vertical: 4.0),
                          child: Opacity(
                            opacity: _sFadeAnim.value,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  _sItemAnim.value, 0.0, 0.0),
                              child:
                                  _listBtn(child: _btnContent(data: _list[1])),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _tFadeAnim,
                      builder: (context, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * .02, vertical: 4.0),
                          child: Opacity(
                            opacity: _tFadeAnim.value,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  _tItemAnim.value, 0.0, 0.0),
                              child:
                                  _listBtn(child: _btnContent(data: _list[2])),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBtn({@required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _height * .01),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnContent({@required Map data}) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LocationScreen())),
        splashColor: Colors.white54,
        child: Container(
          height: _height * .15,
          padding: EdgeInsets.symmetric(vertical: _height * .03),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _width * .05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  data['icon'],
                  color: Colors.yellow,
                ),
                Padding(
                  padding: EdgeInsets.only(left: _width * .05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data['title'],
                        style: TextStyle(
                            color: Colors.yellow,
                            //fontWeight: FontWeight.bold,
                            fontSize: _width * .06,
                            fontFamily: 'Ainslie'),
                      ),
                      Expanded(child: Container()),
                      Text(
                        data['txt'],
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBar() {
    return Container(
      height: _height * .3,
      child: ClipRRect(
        borderRadius:
            BorderRadius.only(bottomLeft: Radius.circular(_width * .4)),
        child: Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedBuilder(
                  animation: _translateController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnim.value,
                      child: Transform(
                          transform: Matrix4.translationValues(
                              -_translateAnim.value, _translateAnim.value, 0.0),
                          child: widget.hero),
                    );
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: _width * .05),
                  child: Image.asset(
                    "assets/agil.png",
                    width: _width * .35,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(right: _width * .05),
                    child: AnimatedBuilder(
                        animation: _logoFadeController,
                        builder: (contect, child) {
                          return Opacity(
                            opacity: _logoFadeAnim.value,
                            child: Image.asset(
                              "assets/agil_light.png",
                              width: _width * .35,
                            ),
                          );
                        })
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/agil_header.jpg'), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
