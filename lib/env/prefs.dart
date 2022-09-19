import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs()async{
     this._prefs = await SharedPreferences.getInstance();
  }
 // logout to app
  logoutNumber(){
    _prefs!.remove('number');
  }
 // set to token app and save
 set number(String value){
   _prefs!.setString('number', value);
 }
 // get token
 String get number {
   return _prefs!.getString('number')?? '';
 }
}