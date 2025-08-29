// import 'package:get/get.dart';
// import 'package:test2/apiService.dart';

// class Controller extends GetxController {
//   int countA = 0;
//   int countB = 0;
//     bool isLoading = false;
//   void incrementA() {
//     countA++;
//     update();
//   }

//   void incrementB() {
//     countB++;
//     update();
//   }
//   Future<void> fetchData() async {
//     isLoading = true;
//     update();
//     await Apiservice().fetchUserData(); 
//     isLoading = false;
//     update();
//   }
//   Future<void> fetchDataDio() async {
//     isLoading = true;
//     update(); // Notify UI
//     await Apiservice().fetchUserDataDio(); // Your async call
//     isLoading = false;
//     update(); // Notify UI again
//   }
// }
