import 'package:after_layout/after_layout.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/view/index.dart';

Widget _home;
Function _customFunction;
String _imagePath;
int _duration;
bool _isGIF;
AnimatedSplashType _runfor;

enum AnimatedSplashType { StaticDuration, BackgroundProcess }

Map<dynamic, Widget> _outputAndHome = {};

class AnimatedSplash extends StatefulWidget {
  AnimatedSplash(
      {@required String imagePath,
      @required Widget home,
      Function customFunction,
      @required int duration,
      AnimatedSplashType type,
      bool isGIF = false,
      Map<dynamic, Widget> outputAndHome}) {
    assert(duration != null);
    assert(home != null);
    assert(imagePath != null);

    _home = home;
    _duration = duration;
    _customFunction = customFunction;
    _imagePath = imagePath;
    _isGIF = isGIF;
    _runfor = type;
    _outputAndHome = outputAndHome;
  }

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash> with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController _animationController;
  Animation _animation;
  GifController controller;

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    if (!_isGIF) {
      _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
      _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInCirc));
      _animationController.forward();
    } else {
//      controller = GifController(vsync: this);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isGIF) {
        controller = GifController(vsync: this);
        controller.repeat(min: 0, max: 117, period: Duration(milliseconds: 500), reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController?.reset();
    _animationController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  navigator(home) {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => home));
  }

  @override
  Widget build(BuildContext context) {
    _runfor == AnimatedSplashType.BackgroundProcess
        ? Future.delayed(Duration.zero).then((value) {
            var res = _customFunction();
            //print("$res+${_outputAndHome[res]}");
            Future.delayed(Duration(milliseconds: _duration)).then((value) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => _outputAndHome[res]));
            });
          })
        : Future.delayed(Duration(milliseconds: _duration + 2000)).then((value) {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => _home));
          });

    return _isGIF
        ? Scaffold(
            body: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 10)),
                  builder: (context, data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: GifImage(
                        controller: controller,
                        repeat: ImageRepeat.noRepeat,
                        image: AssetImage(_imagePath),
                        fit: BoxFit.fill,
                      ),
                    );
                  }),
            ),
          ))
        : Scaffold(
            backgroundColor: AppColors.mainTextColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    textDirection: TextDirection.ltr,
                    children: [
                      Positioned(
                          child: ZoomIn(
                              preferences: AnimationPreferences(offset: Duration(seconds: 1)),
                              child: Image.asset('assets/images/diamond.png', height: 120))),
                      Positioned(
                          bottom: 0,
                          child: FadeInLeftBig(
                              preferences: AnimationPreferences(offset: Duration(seconds: 1, milliseconds: 500)),
                              child: Image.asset('assets/images/mouse.png', height: 45))),
                    ],
                  ),
                  SizedBox(height: 15),
                  BounceInUp(
                    preferences: AnimationPreferences(duration: Duration(seconds: 1, milliseconds: 500), offset: Duration(seconds: 2)),
                    child: Text(
                      SharedData.lang == 'ar' ? 'جوهره' : 'jawhara',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: FontFamily.cairo, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FadeIn(
                      preferences: AnimationPreferences(offset: Duration(seconds: 2, milliseconds: 500)),
                      child: Text(SharedData.lang == 'ar' ? 'كنز التسوق' : 'shopping treasure',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: FontFamily.cairo))),
                ],
              ),
            ));
  }
}
