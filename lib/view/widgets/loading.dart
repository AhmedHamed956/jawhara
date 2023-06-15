import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/constants/colors.dart';
import '../index.dart';

class Loading {
  init() {
    int backgroundColor = 0x42000000;
    int seconds = 20;
    bool clickClose = false;
    bool allowClick = false;
    bool ignoreContentClick = false;
    int animationMilliseconds = 200;
    int animationReverseMilliseconds = 200;
    BotToast.showCustomLoading(
        clickClose: clickClose,
        allowClick: allowClick,
        ignoreContentClick: ignoreContentClick,
        animationDuration: Duration(milliseconds: animationMilliseconds),
        animationReverseDuration: Duration(milliseconds: animationReverseMilliseconds),
        duration: Duration(
          seconds: seconds,
        ),
        backgroundColor: Color(backgroundColor),
        align: Alignment.center,
        toastBuilder: (cancelFunc) {
          return _CustomLoadWidget(cancelFunc: cancelFunc);
        });
  }
}

class _CustomLoadWidget extends StatefulWidget {
  final CancelFunc cancelFunc;

  const _CustomLoadWidget({Key key, this.cancelFunc}) : super(key: key);

  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState();
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: ShapeLoading(),
              width: 50,
              height: 50,
            ),
            Text(translate('loading'))
          ],
        ),
      ),
    );
  }
}

class ShapeLoading extends StatefulWidget {
  double size;
  Color color;

  @override
  ShapeLoadingState createState() =>ShapeLoadingState();

  ShapeLoading({this.size, this.color});
}

class ShapeLoadingState extends State<ShapeLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitRipple(
      color:  widget.color ?? AppColors.secondaryColor,
      size: widget.size ?? 40.0,
      controller: AnimationController(vsync: __CustomLoadWidgetState(), duration: const Duration(milliseconds: 1200)),
    ));
  }
}

class ShapeLoadingR extends StatefulWidget {
  @override
  ShapeLoadingRState createState() =>ShapeLoadingRState();
}

class ShapeLoadingRState extends State<ShapeLoadingR> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitRipple(
          color: AppColors.primaryColor,
          size: 40.0,
          controller: AnimationController(vsync: __CustomLoadWidgetState(), duration: const Duration(milliseconds: 1200)),
        ));
  }
}
