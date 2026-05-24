// import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class ApiConstants {

  static String AESKey = "IEMSRajasthanJaipurIdeaInfinity2";
  static String strIV = "Man";

  static var authToken = "";
   static Future<void> saveToken(String token) async {
    authToken = token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }


  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

    static Future<Map<String, String>> getHeaders(String headersType) async {
    final tokens = await getToken() ?? "";

    switch(headersType){
      case "1":
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens}',
        };
        return headers;
      default:
        var defaultHeaders = {
          'Content-Type': 'application/json',
          'Authorization': '',
        };
        return defaultHeaders;
    }
  }
  static const String baseUrl = "http://216.48.181.186:3110/"; 
  static const String catandlanguage  = "series/get-all-languages-categories";
  static const String search = "series/search?q=";
  static const String rewardseries = "series/rewards/series";
  static const String rewardtotal = "series/rewards/total"; // not integrate
  static const String serieswatched = "series/watched";
  static const String mylist = "series/my-list";
  static const String favourate = "series/like-favorite";
  static const String rating = "series/rating";
  static const String getSeriesapi = "series/get-episodes-by-category-language-series";
  static const String accountdelete = "profile/account-deletion";
  static const String rewardstotal = "series/rewards/total";
  static const String explorer = "series/explore/episodes";
  static const String likefavourite = "series/like-favorite";
  static const String Feedback = "series/feedback";

  
  
 static String carousel(int languageId, int pageid, int limit, int seriecounting) {
    return "series/get-all-series-by-language?languageId=$languageId&page=${pageid}&limit=${limit}&seriesCount=${limit}";
  }    // static const String baseUrl = "http://192.168.128.156:8000/";
  static const String genreApi = "";

  





  static var receiveTimeout = const Duration(milliseconds: 250000);
  static var sendTimeout = const Duration(milliseconds: 250000);

  static var receiveTimeout2 = const Duration(milliseconds: 60000);
  static var sendTimeout2 = const Duration(milliseconds: 60000);
}
