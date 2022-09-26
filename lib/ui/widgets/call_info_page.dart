import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/widgets/information_tab.dart';
import 'package:zegocloud_live_video_call/ui/widgets/people_tab.dart';

class CallInfoPage extends StatefulWidget {
  const CallInfoPage({
    super.key,
    required this.videoModels,
    required this.onTap,
  });

  final List<VideoModel> videoModels;
  final VoidCallback onTap;

  @override
  State<CallInfoPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<CallInfoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onTap,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Call details',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: const TabBar(
                labelColor: Colors.black87,
                indicatorColor: Colors.black87,
                unselectedLabelColor: Colors.black45,
                labelStyle: TextStyle(
                  letterSpacing: 1.2,
                ),
                tabs: [
                  Tab(text: 'People'),
                  Tab(text: 'Information'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PeopleTab(
                    videoModels: widget.videoModels,
                  ),
                  const InformationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:zegocloud_live_video_call/models/video_model.dart';
// import 'package:zegocloud_live_video_call/ui/widgets/information_tab.dart';
// import 'package:zegocloud_live_video_call/ui/widgets/people_tab.dart';

// class CallInfoPage extends StatelessWidget {
//   const CallInfoPage({
//     super.key,
//     required this.videoModels,
//   });

//   final List<VideoModel> videoModels;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => Navigator.pop(context),
//       child: GestureDetector(
//         onTap: () {},
//         child: DraggableScrollableSheet(
//           initialChildSize: 0.8,
//           maxChildSize: 0.9,
//           minChildSize: 0.4,
//           builder: (context, scrollController) {
//             return DefaultTabController(
//               length: 2,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     Theme(
//                       data: ThemeData(
//                         highlightColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                       ),
//                       child: const TabBar(
//                         labelColor: Colors.black87,
//                         indicatorColor: Colors.black87,
//                         unselectedLabelColor: Colors.black45,
//                         labelStyle: TextStyle(
//                           letterSpacing: 1.2,
//                         ),
//                         tabs: [
//                           Tab(text: 'People'),
//                           Tab(text: 'Information'),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           PeopleTab(
//                             videoModels: videoModels,
//                             scrollController: scrollController,
//                           ),
//                           InformationTab(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
