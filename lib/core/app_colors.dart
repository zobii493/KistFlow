import 'package:flutter/material.dart';

class AppColors {
  // LIGHT COLORS (unchanged)
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color slateGray = Color(0xFF37474F);
  static const Color coolMint = Color(0xFFB2DFDB);
  static const Color warmAmber = Color(0xFFFCD57D);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color pink = Color(0xFFE71D36);
  static const Color lightPink = Color(0xFFFFB6B6);
  static const Color skyBlue = Color(0xFFB5E2FA);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color darkGrey = Color(0xFF757575);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightCoolMint = Color(0xFFEAF1FF);

  // DARK COLORS (deep purple-based professional palette)
  static const Color primaryTealDark = Color(0xFF7C4DFF); // main accent (deep purple)
  static const Color slateGrayDark = Color(0xFFB39DDB); // muted purple-grey
  static const Color coolMintDark = Color(0xFF512DA8); // deep purple accent
  static const Color warmAmberDark = Color(0xFFFFB74D); // orange accent
  static const Color offWhiteDark = Color(0xFF1E1E2C); // dark background
  static const Color pinkDark = Color(0xFFF48FB1); // subtle pink accent
  static const Color lightPinkDark = Color(0xFFF8BBD0); // lighter pink
  static const Color skyBlueDark = Color(0xFF8C9EFF); // soft blue accent
  static const Color lightGreyDark = Color(0xFF2C2C3A); // cards / containers
  static const Color darkGreyDark = Color(0xFFE0E0E0); // text & icons
  static const Color slateGrayLight = Color(0xFF605672);
  static const Color skyBlueLight = Color(0xFF8F9CD0);
  static const Color coolMintLight = Color(0xFF69559B);
  static const Color warmAmberLight = Color(0xFFB49359);
  static const Color pinkLight = Color(0xFF916374);
  static const Color lightGreyLight = Color(0xFF3D3D5D);

  // ================= GETTERS BASED ON THEME =================
  static Color primaryTealOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? primaryTealDark
      : primaryTeal;

  static Color slateGrayOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? slateGrayDark
      : slateGray;

  static Color slateGrayOffWhiteOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? offWhite : slateGray;

  static Color coolMintOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? coolMintLight
      : coolMint;

  static Color warmAmberOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? warmAmberLight
      : warmAmber;

  static Color offWhiteOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? offWhiteDark : offWhite;

  static Color offBlackOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? lightGreyDark : white;

  static Color pinkOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? pinkDark : pink;

  static Color lightPinkOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? pinkLight : lightPink;

  static Color skyBlueOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? skyBlueLight : skyBlue;

  static Color lightGreyOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? lightGreyDark
      : lightGrey;

  static Color darkGreyOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGreyDark : darkGrey;

  static Color darkOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? slateGrayLight
      : slateGray;

  static Color lightGreyCool(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? lightGreyLight
      : lightCoolMint;
}
