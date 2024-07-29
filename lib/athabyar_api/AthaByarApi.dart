//Login
const token='XWU5zAaPeCGFsnJJrcWn_PuX9GZuOTH7wCAWDUzSNns3sankRPHUiTd8N5hs7-cW';
const mHttp='https://athabyar.dkmads.com';
//Myanmar
const requestSMSApi=mHttp+'/sms_otp/index.php';
const requestVerifyOtpApi=mHttp+'/sms_otp/verify.php';
const requestLoginApi=mHttp+'/login_api/login_device.php';
const requestSignupResetPassword=mHttp+'/sms_otp/login.php';

const requestForgetPasswordSMSApi=mHttp+'/ForgetPassword/index.php';
const requestForgetPasswordVerifyOtpApi=mHttp+'/ForgetPassword/verify.php';
const requestForgetPasswordResetApi=mHttp+'/ForgetPassword/login.php';

//Cambodia
const requestSMS_Cambodia_Api=mHttp+'/sms_otp_cambodia/index.php';
const requestVerifyOtp_Cambodia_Api=mHttp+'/sms_otp_cambodia/verify.php';
const requestLogin_Cambodia_Api=mHttp+'/login_api_cambodia/index.php';
const requestSignupResetPassword_Cambodia=mHttp+'/sms_otp_cambodia/login.php';

const requestForgetPasswordSMS_Cambodia_Api=mHttp+'/ForgetPassword_cambodia/index.php';
const requestForgetPasswordVerifyOtp_Cambodia_Api=mHttp+'/ForgetPassword_cambodia/verify.php';
const requestForgetPasswordReset_Cambodia_Api=mHttp+'/ForgetPassword_cambodia/login.php';

//TermAndCodition
const responseTermAndConditionApi=mHttp+'/admin_login/terms_api.php';

//About Us
const responseAboutUsApi=mHttp+'/admin_login/about_us_api.php';

//Gold
const responseGoldApi=mHttp+'/gold/generate_api.php';

//sendProfile
const requestProfileApi=mHttp+'/Profile/index.php';
const responseProfileApi=mHttp+'/Profile/generate_api.php?id=';

//exchange Myanmar
const responseExchangeRateApi='https://forex.cbm.gov.mm/api/history/';

//exchange Cambodia
const responseExchangeRateCambodiaApi='https://api.exchangerate.host/latest?base=KHR';

//Daily and DailyDetail
const requestDailyApi=mHttp+'/Daily/index.php';
const responseDailyApi=mHttp+'/Daily/generate_api.php?updated_by=';

//AccountGroup Myanmar
const requestAccountGroupApi=mHttp+'/AccountGroup/index.php';
const responseAccountGroupApi=mHttp+'/AccountGroup/generate_api.php?updated_by=';

//AccountGroup Cambodia
const requestAccountGroup_cambodia_Api=mHttp+'/AccountGroup_cambodia/index.php';
const responseAccountGroup_cambodia_Api=mHttp+'/AccountGroup_cambodia/generate_api.php?updated_by=';

//Account Myanmar
const requestAccountApi=mHttp+'/Account/index.php';
const responseAccountApi=mHttp+'/Account/generate_api.php?updated_by=';

//Account Cambodia
const requestAccount_cambodia_Api=mHttp+'/Account_cambodia/index.php';
const responseAccount_cambodia_Api=mHttp+'/Account_cambodia/generate_api.php?updated_by=';

//Category
const requestCategoryApi=mHttp+'/Category/index.php';
const responseCategoryApi=mHttp+'/Category/generate_api.php?updated_by=';

//AccountSummary
const requestAccountSummaryApi=mHttp+'/AccountSummary/index.php';
const responseAccountSummaryApi=mHttp+'/AccountSummary/generate_api.php?updated_by=';

//MonthlySummary
const requestMonthlySummaryApi=mHttp+'/MonthlySummary/index.php';
const responseMonthlySummaryApi=mHttp+'/MonthlySummary/generate_api.php?updated_by=';

//Ads
const requestAds250Api=mHttp+'/admin_login/add_one_api.php';
const requestAds50Api=mHttp+'/admin_login/add_two_api.php';
const requestAds480Api=mHttp+'/admin_login/add_three_api.php';

//User Guide
const requestUserGuideApi=mHttp+'/UserGuide/generate_api.php';

//Zipfile

const requestZipApi='https://athabyar.dkmads.com/admin_login/uploads/img.zip';