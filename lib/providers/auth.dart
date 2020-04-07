import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/models/http_exceptions.dart';
class Authenticate with ChangeNotifier{
   String _token;
   DateTime _expiryDate;
   String _userId;
   Timer _authTimer;

  bool get isAuth{
    if(getToken!=null)return true;
    return false;
  }
  String get getToken{
    if(_expiryDate!=null&&_token!=null&&_expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }
  String get getUserId{
    if(_userId!=null) return _userId;
    return null;
  }

   Future<void> authenticate(String email,String password,String idSegment) async{
      final url='https://identitytoolkit.googleapis.com/v1/accounts:$idSegment?key=[API KEY]';
     try{
     var response= await http.post(url,body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true,
    }));
    if(json.decode(response.body)['error']!=null)
    throw HttpException(json.decode(response.body)['error']['message']);
    _token=(json.decode(response.body))['idToken'];
    _expiryDate=DateTime.now().add(Duration(seconds: int.parse((json.decode(response.body))['expiresIn'])));
    _userId=json.decode(response.body)['localId'];
    _autoLogout();
    notifyListeners();
    final pref=await SharedPreferences.getInstance();
    final String userData=json.encode({
      'token':_token,
      'userId':_userId,
      'expiryDate':_expiryDate.toIso8601String(),
    });
    pref.setString('userData', userData);
   }
   catch(err){
     throw err;
   }
   }

   Future<void> signUp(String email,String password) async{
    return authenticate(email,password,'signUp'); 
   }
      Future<void> signIn(String email,String password) async{
    return authenticate(email,password,'signInWithPassword'); 
   }

   Future<bool> tryAutoLogin() async{
     final pref= await SharedPreferences.getInstance();
     if(!pref.containsKey('userData')) return false;
     final userData=json.decode(pref.get('userData'));
     final expiryDate=DateTime.parse(userData['expiryDate']);
     if(expiryDate.isBefore(DateTime.now())) return false;
     _token=userData['token'];
     _userId=userData['userId'];
     _expiryDate=expiryDate;
     _autoLogout();
     notifyListeners();
     return true;
   }

  void logout() async{
    _token=null;
    _expiryDate=null;
    _userId=null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
      notifyListeners();
    }
    final pref=await SharedPreferences.getInstance();
    pref.clear();
  }
   void _autoLogout(){
     if(_authTimer!=null){
       _authTimer.cancel();
       _authTimer=null;
     }
     final secondsLeft=_expiryDate.difference(DateTime.now()).inSeconds;
     _authTimer=Timer(Duration(seconds:secondsLeft), logout);
   }
}
