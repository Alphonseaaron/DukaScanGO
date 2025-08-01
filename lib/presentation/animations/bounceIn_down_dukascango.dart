part of 'animations.dart';


class BounceInDownDukascango extends StatefulWidget {

  final Widget child;

  const BounceInDownDukascango({
    Key? key, 
    required this.child,
  }) : super(key: key);

  @override
  _BounceInDownDukascangoState createState() => _BounceInDownDukascangoState();
}

class _BounceInDownDukascangoState extends State<BounceInDownDukascango> with TickerProviderStateMixin{

  AnimationController? _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    _animation = Tween<double>(begin: 120 * -1, end: 0).animate(CurvedAnimation(parent: _controller!, curve: Curves.bounceOut));

    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context)
  {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) 
        => Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        ),
    );
  }
}