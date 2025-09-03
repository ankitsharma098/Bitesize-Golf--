import 'package:flutter/material.dart';

AppBar appBar(
  context,
  String text, {
  Color backgroundColor = Colors.white,
  double textSize = 16,
  Color textColor = Colors.black,
  showBack = true,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(
      text,
      style: TextStyle(color: textColor, fontSize: textSize),
    ),
    backgroundColor: backgroundColor,
    leading: showBack
        ? IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () {},
          )
        : null,
    actions: actions,
    automaticallyImplyLeading: true,
  );
}

Widget cachedImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
}) {
  if (url!.isEmpty) {
    return placeHolderWidget(
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      radius: radius,
    );
  } else if (url.startsWith('http')) {
    return Image.network(
      url!,
      height: height,
      width: width,
      fit: fit,
      errorBuilder:
          (BuildContext? context, Object? exception, StackTrace? stackTrace) {
            return Image.asset(
              'assets/placeholder.jpg',
              height: height,
              width: width,
              fit: fit,
              alignment: alignment ?? Alignment.center,
            );
          },
      alignment: alignment as Alignment? ?? Alignment.center,
    );
  } else {
    return Image.asset(
      'assets/placeholder.jpg',
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    );
  }
}

Widget placeHolderWidget({
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  double? radius,
}) {
  return Image.asset(
    'assets/placeholder.jpg',
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
  );
}
