// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zegocloud_live_video_call/ui/widgets/local_video_disabled.dart';
import 'package:zegocloud_live_video_call/ui/widgets/online_users_counter.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_disabled.dart';
import 'package:zegocloud_live_video_call/ui/widgets/row_view.dart';
import 'package:zegocloud_live_video_call/ui/widgets/toolbar.dart';

class ManyToManyCallPage extends StatefulWidget {
  const ManyToManyCallPage({
    Key? key,
    required this.userID,
    required this.roomID,
    required this.appSign,
    required this.appID,
    required this.token,
  }) : super(key: key);

  final String userID;
  final String roomID;
  final String? appSign;
  final String token;
  final int appID;

  @override
  State<ManyToManyCallPage> createState() => _VideoCallPageState();
}

class VideoModel {
  VideoModel({
    this.stream,
    this.viewID,
  });
  ZegoStream? stream;
  int? viewID;
}

class _VideoCallPageState extends State<ManyToManyCallPage> {
  bool _micEnabled = false;
  bool _cameraEnabled = false;
  bool _useFrontCamera = true;
  int _onlineUsersCount = 1;

  late int _previewViewID;
  late Widget _previewViewWidget;

  late String _myStreamID;

  List<int> _remoteViewIDs = [];
  List<Texture> _remoteViewWidgets = [];

  List<ZegoStream> _remoteStreams = [];
  List<VideoModel> _videoModelList = [];

  @override
  void initState() {
    createEngine();
    eventHandler();
    createUserAndLoginRoom();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    publishStream();
    createPreviewRenderer();
    super.didChangeDependencies();
  }

  Future<void> createEngine() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      widget.appID,
      ZegoScenario.General,
      appSign: widget.appSign, // it is null because I use token
      /// commented because I use TextureRenderer object for rendering the preview
      // enablePlatformView: true,
    );
    await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  Future<void> createUserAndLoginRoom() async {
    ZegoUser user = ZegoUser.id(widget.userID);

    /// Set the token
    ZegoRoomConfig config = ZegoRoomConfig.defaultConfig();
    config.token = widget.token;

    /// To receive the onRoomUserUpdate callback, you must set the isUserStatusNotify property of the room configuration parameter ZegoRoomConfig to true when you call the loginRoom method to log in to a room.
    config.isUserStatusNotify = true;

    await ZegoExpressEngine.instance.loginRoom(
      widget.roomID,
      user,
      config: config,
    );
  }

  Future<void> eventHandler() async {
    /// The callback triggered when the number of streams published by the other users increases or decreases.
    /// [streamList] it is ONLY updated stream!
    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) async {
      if (updateType == ZegoUpdateType.Add) {
        log('ZegoUpdateType.Add');

        await playRemoteStreams(streamList);
      }
      if (updateType == ZegoUpdateType.Delete) {
        log('ZegoUpdateType.Delete');

        log('_videoModelList = ${_videoModelList.length}');
        log('_remoteViewIDs = ${_remoteViewIDs.length}');
        log('_remoteViewWidgets = ${_remoteViewWidgets.length}');
        log('_remoteStreams = ${_remoteStreams.length}');

        List<int> deletedViewIDs = [];
        List<ZegoStream> deletedStreams = [];
        List<Texture> availableTextures = [];
        List<ZegoStream> availableStreams = [];
        List<VideoModel> availableVideoModel = [];

        for (var model in _videoModelList) {
          for (var stream in streamList) {
            if (model.stream?.streamID == stream.streamID) {
              deletedViewIDs.add(model.viewID!);
              deletedStreams.add(stream);
            } else {
              availableVideoModel.add(model);
            }
          }
        }

        _videoModelList.clear();
        _videoModelList.addAll(availableVideoModel);

        for (var stream in deletedStreams) {
          ZegoExpressEngine.instance.stopPlayingStream(stream.streamID);

          for (var el in _remoteStreams) {
            if (el.streamID != stream.streamID) {
              availableStreams.add(el);
            }
          }
        }

        _remoteStreams.clear();
        _remoteStreams.addAll(availableStreams);

        for (var viewID in deletedViewIDs) {
          ZegoExpressEngine.instance.destroyTextureRenderer(viewID);
          _remoteViewIDs.remove(viewID);

          for (var texture in _remoteViewWidgets) {
            if (texture.textureId != viewID) {
              availableTextures.add(texture);
            }
          }
        }

        _remoteViewWidgets.clear();
        _remoteViewWidgets.addAll(availableTextures);

        log('=======================================');

        log('_videoModelList = ${_videoModelList.length}');
        log('_remoteViewIDs = ${_remoteViewIDs.length}');
        log('_remoteViewWidgets = ${_remoteViewWidgets.length}');
        log('_remoteStreams = ${_remoteStreams.length}');

        setState(() {});
      }
    };

    /// The callback triggered when the state of the remote camera changes.
    ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) async {
      if (state == ZegoRemoteDeviceState.Open) {
        log('ZegoRemoteDeviceState.Open');
      }
      if (state == ZegoRemoteDeviceState.Disable) {
        log('ZegoRemoteDeviceState.Disable');
      }
    };

    /// The callback triggered when the number of other users in the room increases or decreases.
    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, userList) {
      if (updateType == ZegoUpdateType.Add) {
        _onlineUsersCount += userList.length;
      } else {
        _onlineUsersCount -= userList.length;
      }

      setState(() {});
    };

    /// The callback triggered every 30 seconds to report the current number of online users.
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = (roomID, count) {
      if (count != _onlineUsersCount) {
        log('onRoomOnlineUserCountUpdate => $count');
        setState(() => _onlineUsersCount = count);
      }
    };
  }

  /// Method 1: Using TextureRenderer (the default method)
  Future<void> createPreviewRenderer() async {
    final Size size = MediaQuery.of(context).size;
    final int width = (size.width - 40 - 20) ~/ 3;
    final int height = (size.height - 80 - 40) ~/ 4;

    await ZegoExpressEngine.instance.createTextureRenderer(width, height).then((textureID) {
      _previewViewID = textureID;

      setState(() {
        // Create a Texture Widget
        Widget previewViewWidget = Texture(textureId: textureID);
        // Add this Widget to the layertree for displaying the view of video preview.
        _previewViewWidget = previewViewWidget;
      });

      /// Start preview using texture renderer
      /// _startPreview(textureID);
    });
  }

  ///Method 1: Using TextureRenderer (the default method)
  Future<void> _startPreview(int viewID) async {
    ZegoCanvas previewCanvas = ZegoCanvas(viewID, backgroundColor: 0x444444);
    await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
  }

  Future<void> publishStream() async {
    /// streamID must be globally unique within the scope of the AppID. If different streams are published with the same streamID, the ones that are published after the first one will fail.
    setState(() {
      _myStreamID = DateTime.now().millisecondsSinceEpoch.toString();
    });

    /// Disable camera and mute microphone before [startPublishingStream]
    await ZegoExpressEngine.instance.enableCamera(_cameraEnabled);
    await ZegoExpressEngine.instance.muteMicrophone(!_micEnabled);
    log("muteMicrophone => ${!_micEnabled}");
    log("enableCamera => $_cameraEnabled");

    // await ZegoExpressEngine.instance.setVideoMirrorMode(ZegoVideoMirrorMode.OnlyPreviewMirror);
    await ZegoExpressEngine.instance.startPublishingStream(_myStreamID);
    log("startPublishingStream");
  }

  Future<void> playRemoteStreams(List<ZegoStream> streamList) async {
    final Size size = MediaQuery.of(context).size;
    final int width = (size.width - 40 - 20) ~/ 3;
    final int height = (size.height - 80 - 40) ~/ 4;

    for (var stream in streamList) {
      ZegoExpressEngine.instance.createTextureRenderer(width, height).then((viewID) {
        /// Add the Widget you get to the layertree for displaying the view of video preview.

        _remoteViewIDs.add(viewID);
        _remoteStreams.add(stream);
        _remoteViewWidgets.add(Texture(textureId: viewID));

        _videoModelList.add(
          VideoModel(
            stream: stream,
            viewID: viewID,
          ),
        );

        _startPlayingStream(viewID, stream.streamID);
      });
    }

    setState(() {});
  }

  Future<void> _startPlayingStream(int viewID, String streamID) async {
    ZegoCanvas canvas = ZegoCanvas(viewID, backgroundColor: 0x444444);
    await ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
  }

  List _rowViewList() {
    List<Widget> list = [_cameraEnabled ? _previewViewWidget : const LocalVideoDisabled()];

    list.addAll(_remoteViewWidgets);

    final listLength = list.length;

    if (listLength < _onlineUsersCount) {
      for (var i = 0; i < (_onlineUsersCount - listLength); i++) {
        list.add(const RemoteVideoDisabled());
      }
    }

    // log('Video card list size => ${list.length}');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RowView(
            list: _rowViewList(),
          ),
          OnlineUsersCounter(
            onlineUsersCount: _onlineUsersCount,
          ),
          Toolbar(
            micEnabled: _micEnabled,
            cameraEnabled: _cameraEnabled,
            micButtonPressed: () {
              ZegoExpressEngine.instance.muteMicrophone(_micEnabled);
              setState(() {
                _micEnabled = !_micEnabled;
              });
            },
            callEndButtonPressed: () {
              ZegoExpressEngine.instance.stopPublishingStream();
              ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
              ZegoExpressEngine.instance.logoutRoom(widget.roomID);
              ZegoExpressEngine.destroyEngine();
              Navigator.pop(context);
            },
            enableCameraButtonPressed: () async {
              setState(() => _cameraEnabled = !_cameraEnabled);
              ZegoExpressEngine.instance.enableCamera(_cameraEnabled);

              if (_cameraEnabled) {
                await _startPreview(_previewViewID);
              } else {
                await ZegoExpressEngine.instance.stopPreview();
              }
            },
            switchCameraButtonPressed: () async {
              setState(() => _useFrontCamera = !_useFrontCamera);
              ZegoExpressEngine.instance.useFrontCamera(_useFrontCamera);
            },
          ),
        ],
      ),
    );
  }
}
