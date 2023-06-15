import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/view/index.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback retryFunc;

  const NoInternetWidget({Key key, this.retryFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              // width: double.infinity,
              // height: MediaQuery.of(context).size.height / 5,
            margin: EdgeInsets.all(20),
              child: CircleAvatar(
                  backgroundColor: AppColors.secondaryColor,
                  maxRadius: 40,
                  child: Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 40,
                  ))),
          Text(
            translate("no_internet.title"),
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            // style: GoogleFonts.lato(fontSize: 20, color: ThemeCustom.darkGreyColor, fontWeight: FontWeight.w600),
          ),
          Text(
            translate("no_internet.subtitle"),
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            // style: GoogleFonts.lato(fontSize: 15, color: ThemeCustom.darkGreyColor, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 16),
          if (retryFunc != null) ...[
            Center(
              child: GestureDetector(
                onTap: retryFunc,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: AppColors.secondaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    translate("no_internet.tryAgain"),
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
