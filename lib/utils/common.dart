import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class commonFunctions {
  Future<dynamic> callAPI(params) async {
    print('Params:');
    print(params);
    var payload = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'paramsFor': params.toString()
    };

    final response = await http.get(Uri.parse(API_URL), headers: payload);

    // final int statusCode = response.statusCode;

    // if (statusCode < 200 || statusCode >= 400 || json == null) {
    //   throw new ApiException(jsonDecode(response.body)["message"]);
    // }
    final data = json.decode("[" + response.body + "]");

    return data[0]['body'];
  }
}
