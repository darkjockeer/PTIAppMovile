import 'package:flutter/cupertino.dart';

class MycustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(size.width, (size.height),   (size.width/5), size.height/10, size.width*1.5, size.height*0.4);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}