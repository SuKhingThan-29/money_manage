import 'package:flutter/material.dart';

const Color primary = Colors.deepOrange;
const red = Colors.red;
const yellow = Colors.yellow;
const Color white = Colors.white;
const Color black = Colors.black;
const Color lightBlack = Color(0xFF212121);
const Color grey = Colors.grey;
const Color green = Colors.green;
const double kSpace = 10;
const Color blue = Colors.blue;
const Color lightBlue = Colors.blueAccent;
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Colors.grey;
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const String dbName='AthaPyar.db';
const String IncomeType='IncomeType';
const String ExpenseType='ExpenseType';
const String TransferType='TransferType';
const int sec=3;
const String IncomeTypeSave_UserGuide='IncomeTypeSave_UserGuide';
const String ExpenseTypeSave_UserGuide='ExpenseTypeSave_UserGuide';


const String internetConnectionStatus='Please check your internet connection';
const String loginMessage='You have account,please login your with phone number and password';
const String loginResponseMessage='Your password is incorrect,please login again!';
const String successLogin='Success Login';
const String successResetPassword='Success Reset Password';
const String forgetPasswordMessage="Please request OTP code with your account's phone number";
const String notRegisterMessage='There is no account in this phone number';
const String wrongOTP='OTP code is not correct!';

//SharePref for save,and clear at logout
const String Lang='lang';
const String is_Switch='Switch';
const String LoginSuccess='LoginSuccess';
const String mProfileId='mProfileId';
const String mPhoneNumber='PhoneNumber';
const String termsAndCondition_eng='termsAndCondition_eng';
const String termsAndCondition_mm='termsAndCondition_mm';
const String about_us_eng='about_us_eng';
const String about_us_mm='about_us_mm';
const String CurrentDate50='CurrentDate';
const String CurrentDate250='CurrentDate250';
const String CurrentDate480='CurrentDate480';
const String selected_date='selected_date';
const String selected_type='type';
const String selected_img='img';
const String isUserGuideWork='isUserGuideWork';
const String selected_country='selected_country';
const String mDeviceId='mDeviceId';
const String mCountryCode='mCountryCode';



//DarkMode
Color dark_background_color=HexColor("#303539");
Color dark_nav_color=HexColor("#1D2025");
Color dark_tab_bar_color=HexColor("#384048");
Color dark_border_color=HexColor("#866325");
Color dark_box_background_color=HexColor("#F0A527");
Color dark_font_red_color=HexColor("#E43700");
Color dark_font_blue_color=HexColor("#3D86EA");
Color dark_font_grey_color=HexColor("#BBBCBE");
Color dark_add_color=HexColor("#FB3B2F");
Color dark_label_selected_color=HexColor("#F0A527");
Color dark_label_unselected_color=HexColor("#BBBCBE");



//LightMode
Color light_background_color=HexColor("#F2F2F2");
Color light_nav_color=HexColor("#FFFFFF");
Color light_tab_bar_color=HexColor("#FFFFFF");
Color light_border_color=HexColor("#F0A500");
Color light_box_background_color=HexColor("#F0A500");
Color light_font_red_color=HexColor("#E43700");
Color light_font_blue_color=HexColor("#3D86EA");
Color light_font_grey_color=HexColor("#9B9B9B");
Color light_add_color=HexColor("#FB3B2F");
Color light_label_selected_color=HexColor("#000000");
Color light_label_unselected_color=HexColor("#FFFFFF");


Color themeColor = HexColor("#F0A500");
Color redColor=HexColor("#E43700");
Color fontGreyColor=HexColor("#9B9B9B");
Color themeLightColor = HexColor("#FFCC80");
Color themeBackgroundColor = HexColor("#FCEDD3");
Color underLineColor=HexColor("#FBE8C8");
Color underLineGreyColor=HexColor("#D4D4D4");

const Color lightGrey = Color(0xE6E0E0E0);
Color lightGreyBackgroundColor=HexColor("#F2F2F2");
const Color lightWhiteBackgroundColor = Color(0xE6FFFFFF);
Color unSelectedColor=HexColor("#E2E2E2");

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}



//FontSize

const double label_text_size = 12;

const double setting_label_width = 80;

const double setting_icon_size = 20;

const double border_radius=20;


const double app_bar_icon_size = 30;

const double app_bar_title = 14;

const double app_bar_height = 50;

//Color
const Color appBarColor = Colors.white;

//Spacing
const double spaceMedium=4;

//Divider
const double dividerSize=80;

const double spaceIcon=10;

const String myanmarCode='+95';
const String cambodiaCode='+855';
const String mDollar=" \$ ";

const String bannerAndroid='ca-app-pub-2316532966920798/2514128878';
const String bannerIOS='ca-app-pub-2316532966920798/7045267450';
const String interstitialAndroid='ca-app-pub-2316532966920798/8797139300';
const String interstitialIOS='ca-app-pub-2316532966920798/4419104118';
const String nativeAdvancedAndroid='ca-app-pub-2316532966920798/9535505902';
const String nativeAdvanceIOS='ca-app-pub-2316532966920798/8330235446';



//Testing

// const String bannerAndroid='ca-app-pub-3940256099942544/6300978111';
// const String bannerIOS='ca-app-pub-3940256099942544/2934735716';
// const String interstitialAndroid='ca-app-pub-3940256099942544/1033173712';
// const String interstitialIOS='ca-app-pub-3940256099942544/4411468910';
// const String nativeAdvancedAndroid='ca-app-pub-3940256099942544/2247696110';
// const String nativeAdvanceIOS='ca-app-pub-3940256099942544/3986624511';

//Event Tracker
const String home_screen='HomeScreen';
const String calendar_screen='CalendarScreen';
const String status_screen='StatusScreen';
const String account_screen='AccountsScreen';
const String exchange_screen='ExchangeScreen';
const String summary_screen='SummaryScreen';
const String monthly_screen='MonthlyScreen';
const String weekly_screen='WeeklyScreen';
const String account_group_screen='AccountGroupScreen';
const String account_detail_screen='AccountDetailScreen';
const String account_group_detail_screen='AccountGroupDetailScreen';
const String account_create_screen='AccountCreateScreen';
const String choose_form_screen='SignInAndSignUPSelect Screen';
const String setting_screen='SettingScreen';
const String category_screen='CategoryScreen';
const String category_detail_screen='CategoryDetailScreen';
const String search_screen='SearchScreen';
const String otp_screen='OtpScreen';
const String forgot_password_otp='ForgotPasswordOtpScreen';
const String forgot_password_account='ForgotPasswordAccountScreen';
const String password_reset='PasswordResetScreen';
const String register_screen='RegisterScreen';
const String signup_password_create='SignUpPasswordCreateScreen';


//Button click event
const String account_group_btn='AccountGroupSaveEvent';
const String account_btn='AccountSaveEvent';
const String category_btn='CategorySaveEvent';
const String profile_btn='ProfileSaveEvent';
const String otp_btn='OTPRequestEvent';
const String transaction_screen_click='TransactionEvent';
const String login_btn='LoginEvent';
const String signup_btn='SignUpEvent';
const String language_change_event='LanguageChangeEnglishEvent';
const String language_myanmar_event='LanguageChangeMyanmarEvent';

//Route
const String accountScreenRoute='accountScreenRoute';
const String accountGroupDetailRoute='accountGroupDetailScreenRoute';








