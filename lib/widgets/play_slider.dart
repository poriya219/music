// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:music/const.dart';
// import 'package:music/screens/track_screen/controller/trackscreen_controller.dart';
// import 'package:music/widgets/streambuilder.dart';
//
// class Play_Slider extends StatefulWidget {
//
//   Size size;
//   double time;
//
//   Play_Slider({required this.size,required this.time});
//
//   @override
//   State<Play_Slider> createState() => _Play_SliderState();
// }
//
// class _Play_SliderState extends State<Play_Slider> {
//
//
//   final trackController = Get.find<TrackScreenController>();
//   @override
//   Widget build(BuildContext context){
//     return Container(
//       child: Column(
//         children: [
//           Slider(
//             inactiveColor: Colors.grey,
//             activeColor: kLighterPurple,
//             min: 0,
//             max: playerService.player.duration?.inSeconds.toDouble() ?? 0.0,
//             value: widget.time,
//             onChanged: (value) {
//               setState((){
//                 widget.time = value;
//               });
//
//             },
//           ),
//           SizedBox(
//             width: widget.size.width * 0.88,
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Obx(() => Text(trackController.currentTrackPosition.toString().split('.').first),),
//                 DurationStream(stream: trackController.currentTrackPosition.stream),
//                 Obx(() => Text(trackController.trackDuration.toString()),),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
