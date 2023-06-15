import '../index.dart';

class SearchBar extends StatelessWidget {
  final bool isSearching;

  SearchBar({@required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimateExpansion(
          animate: !isSearching,
          axisAlignment: 1.0,
          child: SizedBox(height: 30, child: SharedData.lang == 'en' ? Image.asset('assets/images/thumbnail_en.png') : Image.asset('assets/images/thumbnail.png')),
        ),
        AnimateExpansion(
          animate: isSearching,
          axisAlignment: -1.0,
          child: Search(),
        ),
      ],
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: AppColors.secondaryColor,
      ),
      child: TextField(
        // enabled: false,
        autofocus: false,
        readOnly: true,
        onTap: () {
          print('search');
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: SearchScreen(),
            ),
          );
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: IconButton(
              icon: Icon(Icons.search),
              onPressed: null),
          hintText: translate("searchForProduct"),
          hintStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;

  AnimateExpansion({
    this.animate = false,
    this.axisAlignment,
    this.child,
  });

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(axis: Axis.vertical, axisAlignment: -1.0, sizeFactor: _animation, child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
