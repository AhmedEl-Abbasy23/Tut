class LoginRequest {
  String email;
  String password;
  String imei;
  String deviceType;

  LoginRequest(this.email, this.password, this.imei, this.deviceType);
}

class ForgotPasswordRequest {
  String email;

  ForgotPasswordRequest(this.email);
}

class RegisterRequest {
  String countryMobileCode;
  String userName;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterRequest(
    this.countryMobileCode,
    this.userName,
    this.mobileNumber,
    this.email,
    this.password,
    this.profilePicture,
  );
}
