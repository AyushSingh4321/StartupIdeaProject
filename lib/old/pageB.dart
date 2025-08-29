// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:test2/controller.dart';
// import 'package:test2/old/pageA.dart';

// class PageB extends StatelessWidget {
//   final controller = Get.find<Controller>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           Get.off(PageA());
//         },
//         child: Text("Go to Page B"),
//       ),
//       appBar: AppBar(title: Text("This is page B")),
//       body: GetBuilder<Controller>(
//         builder: (context) {
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
//                   controller.incrementA();
//                 },
//                 child: Text("Increase value of page A"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
