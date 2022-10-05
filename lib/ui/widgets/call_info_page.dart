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


// class CallInfoPage extends StatefulWidget {
//   const CallInfoPage({
//     Key? key,
//     required this.videoModels,
//     required this.onTap,
//   }) : super(key: key);

//   final List<VideoModel> videoModels;
//   final VoidCallback onTap;

//   @override
//   State<CallInfoPage> createState() => _BottomSheetPageState();
// }

// class _BottomSheetPageState extends State<CallInfoPage> {
//   List<VideoModel> _videoModels = [];

//   @override
//   void initState() {
//     _videoModels.addAll(widget.videoModels);
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant CallInfoPage oldWidget) {
//     log(name: 'CallInfoPage', 'didUpdateWidget');
//     if (!(oldWidget.videoModels == widget.videoModels)) {
//       log(name: 'CallInfoPage > didUpdateWidget', 'Updated');
//       _videoModels.clear();
//       _videoModels.addAll(widget.videoModels);
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void didChangeDependencies() {
//     log(name: 'CallInfoPage', 'didChangeDependencies');

//     setState(() {
//       _videoModels.clear();
//       _videoModels.addAll(widget.videoModels);
//     });

//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: Container(
//           padding: const EdgeInsets.only(top: 30),
//           color: Colors.white,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                   left: 15,
//                   right: 15,
//                   top: 15,
//                 ),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: widget.onTap,
//                       child: const Icon(
//                         Icons.arrow_back_rounded,
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     const Text(
//                       'Call details',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Theme(
//                 data: ThemeData(
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                 ),
//                 child: const TabBar(
//                   labelColor: Colors.black87,
//                   indicatorColor: Colors.black87,
//                   unselectedLabelColor: Colors.black45,
//                   labelStyle: TextStyle(
//                     letterSpacing: 1.2,
//                   ),
//                   tabs: [
//                     Tab(text: 'People'),
//                     Tab(text: 'Information'),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     PeopleTab(
//                       videoModels: _videoModels,
//                       // videoModels: widget.videoModels,
//                     ),
//                     const InformationTab(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }