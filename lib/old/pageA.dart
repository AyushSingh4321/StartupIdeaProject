// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test2/apiService.dart';
// import 'package:test2/controller.dart';
// import 'package:test2/old/pageB.dart';

// class PageA extends StatelessWidget {
//   final controller = Get.find<Controller>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           Get.off(PageB());
//         },
//         child: Text("Go to Page A"),
//       ),
//       appBar: AppBar(title: Text("This is page A")),
//       body: GetBuilder<Controller>(
//         builder: (context) {
//           if (controller.isLoading) {
//             return Center(child: CircularProgressIndicator()); //  Show loader
//           }
//           return Column(
//             children: [
//               Center(
//                 child: Text("This is the value on page A ${controller.countA}"),
//               ),
//               Center(
//                 child: Text("This is the value on page B ${controller.countB}"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   controller.incrementB();
//                 },
//                 child: Text("Increase value of page B"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   controller.fetchDataDio();
//                   controller.fetchData();
//                 },
//                 child: Text('Fetch user data'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
