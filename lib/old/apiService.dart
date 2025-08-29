// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

// class Apiservice {
//   Future<void> fetchUserData() async {
//     var response = await http.get(
//       Uri.parse('https://api.tvmaze.com/search/shows?q=all'),
//     );
//     if (response.statusCode == 200) {
//       print(response.body);
//     } else {
//       throw Exception('network error');
//     }
//   }
//   final Dio dio = Dio();
//    Future<void> fetchUserDataDio() async {
//     final response = await dio.get(
//     'https://api.tvmaze.com/search/shows?q=all'
//     );
//     if (response.statusCode == 200) {
//       print(response.data[0]['show']['name']);
//     } else {
//       throw Exception('network error');
//     }
//   }
// }
