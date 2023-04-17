import 'package:flutter/cupertino.dart';

class Botoness extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height+size.height);
    path.lineTo(size.width*size.width, size.height/size.height);
    path.moveTo(size.width, size.height+5);
    path.lineTo(size.width-20, 0);
    path.lineTo(size.width*100, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}