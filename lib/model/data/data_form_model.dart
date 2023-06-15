class DataForm {
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String rePassword;
  String countryId;
  String cityId;
  String address;
  String code;
  String job;
  String gender;
  String verifyCode;
  DateTime dob;
  bool isSubscribed;

  DataForm(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.password,
      this.rePassword,
      this.countryId,
      this.cityId,
      this.code,
      this.job,
      this.dob,
      this.gender,
      this.verifyCode,
      this.address,
      this.isSubscribed = true});

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "password": password,
        "rePassword": rePassword,
        "countryId": countryId,
        "cityId": cityId,
        "address": address,
        "code": code,
        "job": job,
        "dob": dob,
        "verifyCode": verifyCode,
        "gender": gender,
      };
}
