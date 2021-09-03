import 'dart:convert';

import 'card_details.dart';

class User{
  late final avatar;
  late final   avatar_name;
  late final   username;
  late final   location;
  late final   phone_number;
  late final   email;
  late final   password;
  late final   is_notificaction;
  late final   token;
  late final   renewalToken;
  late final   tracking_codes;
  late final   cardDetails;
  late final   payasyougo;

  User({this.avatar, this.avatar_name, this.username, this.location, this.phone_number, this.email,
      this.password, this.is_notificaction, this.tracking_codes, this.token, this.renewalToken, this.cardDetails, this.payasyougo});

  factory User.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson['card']);
    var card = parsedJson['card'] != null
        ? new CardDetails(card_no:parsedJson['card']['card_no'],expiry_year:int.parse(parsedJson['card']['expiry_year']),expiry_month:int.parse(parsedJson['card']['expiry_month']), cvv: int.parse(parsedJson['card']['cvv']))
        : null;
    return User(
      avatar: parsedJson['avatar'],
      avatar_name: parsedJson['avatar_name'],
      username: parsedJson['username'],
      location: parsedJson['location'],
      phone_number: parsedJson['phone_number'],
      email: parsedJson['email'],
      password: parsedJson['password'],
      is_notificaction: parsedJson['is_notification'],
      token: parsedJson['token'],
      renewalToken: parsedJson['renewalToken'],
      tracking_codes: parsedJson['tracking_codes'],
      payasyougo: parsedJson['payasyougo'],
      cardDetails :  card
    );
  }

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'avatar_name': avatar_name,
    'username': username,
    'location': location,
    'phone_number': phone_number,
    'email': email,
    'tracking_codes': tracking_codes,
    'is_notificaction': is_notificaction,
    'token': token,
    'renewalToken': renewalToken,
    'payasyougo': payasyougo,
  };

  @override
  String toString() {
    return 'User{avatar: $avatar, avatar_name: $avatar_name, username: $username, location: $location, phone_number: $phone_number, email: $email, password: $password, is_notificaction: $is_notificaction, token: $token, renewalToken: $renewalToken, payasyougo: $payasyougo}';
  }
}