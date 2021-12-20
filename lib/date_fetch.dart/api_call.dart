import 'dart:convert';

import 'package:http/http.dart' as http;

class OwlApi {
  final String token;
  final _baseURL = 'https://owlbot.info';

  OwlApi({required this.token})
      : assert(token.isNotEmpty, "token cannot be empty");

  Future<ApiResponse?> define({required String word}) async {
    final client = http.Client();
    final res = await client.get(Uri.parse("$_baseURL/api/v4/dictionary/$word"),
        headers: {'Authorization': 'Token $token'});
    if (res.statusCode == 200) {
      ///print(res.body);
      return ApiResponse.fromJson(json.decode(res.body));
    } else {
      return null;
    }
  }
}

class ApiResponse {
  List? definition;

  String? word;

  String? pronunciation;

  ApiResponse._({this.word, this.pronunciation, this.definition});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse._(
      definition: json['definitions'],
      word: json['word'],
      pronunciation: json['pronunciation'],
    );
  }
}
