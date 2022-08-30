import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zegocloud_live_video_call/ui/widgets/online_users_counter.dart';
import 'package:zegocloud_live_video_call/ui/widgets/toolbar.dart';

class FaceToFaceCallPage extends StatefulWidget {
  const FaceToFaceCallPage({
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
  State<FaceToFaceCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<FaceToFaceCallPage> {
  bool _micEnabled = false;
  bool _cameraEnabled = false;
  bool _useFrontCamera = true;
  int _onlineUserCount = 1;

  /// My local video
  late int _previewViewID;
  late Widget _previewViewWidget;

  /// Remote video
  Widget? _playViewWidget;
  late int _playViewID;

  /// My stream ID
  late String _myStreamID;

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
    /// The callback triggered when the number of streams published by the other users in the same room increases or decreases.
    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) async {
      if (updateType == ZegoUpdateType.Add) {
        log('ZegoUpdateType.Add');
        await playRemoteStreams();
        await _startPlayingStream(_playViewID, streamList.first.streamID);
      }
      if (updateType == ZegoUpdateType.Delete) {
        log('ZegoUpdateType.Delete');
        await ZegoExpressEngine.instance.stopPlayingStream(streamList.first.streamID);
        await ZegoExpressEngine.instance.destroyTextureRenderer(_playViewID);
        setState(() => _playViewWidget = null);
      }
    };

    /// The callback triggered when the state of the remote camera changes.
    ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) async {
      if (state == ZegoRemoteDeviceState.Open) {
        log('ZegoRemoteDeviceState.Open');
        await playRemoteStreams();
        await _startPlayingStream(_playViewID, streamID);
      }
      if (state == ZegoRemoteDeviceState.Disable) {
        log('ZegoRemoteDeviceState.Disable');
        setState(() => _playViewWidget = null);
      }
    };

    /// The callback triggered every 30 seconds to report the current number of online users.
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = (roomID, count) {
      log('onRoomOnlineUserCountUpdate => $count');
      setState(() => _onlineUserCount = count);
    };
  }

  /// Method 1: Using TextureRenderer (the default method)
  Future<void> createPreviewRenderer() async {
    const int width = 114, height = 170;

    await ZegoExpressEngine.instance.createTextureRenderer(width, height).then((textureID) {
      _previewViewID = textureID;

      setState(() {
        // Create a Texture Widget
        Widget previewViewWidget = Texture(textureId: textureID);
        // Add this Widget to the layertree for displaying the view of video preview.
        _previewViewWidget = previewViewWidget;
      });
    });
  }

  /// Method 1: Using TextureRenderer (the default method)
  Future<void> _startPreview(int viewID) async {
    ZegoCanvas previewCanvas = ZegoCanvas(viewID, backgroundColor: 0x222222);
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

  Future<void> playRemoteStreams() async {
    final Size size = MediaQuery.of(context).size;

    await ZegoExpressEngine.instance.createTextureRenderer(size.width.toInt(), size.height.toInt()).then((viewID) {
      _playViewID = viewID;

      /// Add the Widget you get to the layertree for displaying the view of video preview.
      setState(() {
        _playViewWidget = Texture(textureId: viewID);
      });
    });
  }

  Future<void> _startPlayingStream(int viewID, String streamID) async {
    ZegoCanvas canvas = ZegoCanvas.view(viewID);
    await ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            /// Remote video
            SizedBox.expand(
              child: _playViewWidget ?? const _RemoteVideoDisabled(),
            ),

            /// My local video
            Positioned(
              top: 40,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 114, // Width from [createPreviewRenderer] function
                  height: 170, // Height from [createPreviewRenderer] function
                  child: _cameraEnabled ? _previewViewWidget : const _VideoDisabled(),
                ),
              ),
            ),

            /// User counter
            OnlineUsersCounter(
              onlineUsersCount: _onlineUserCount,
            ),

            /// Toolbar
            Toolbar(
              micEnabled: _micEnabled,
              cameraEnabled: _cameraEnabled,
              micButtonPressed: () {
                ZegoExpressEngine.instance.muteMicrophone(_micEnabled);
                setState(() => _micEnabled = !_micEnabled);
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
      ),
    );
  }
}

class _VideoDisabled extends StatelessWidget {
  const _VideoDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222222),
      child: const Icon(
        Icons.videocam_off,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class _RemoteVideoDisabled extends StatelessWidget {
  const _RemoteVideoDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF444444),
      child: const Icon(
        Icons.account_circle,
        size: 120,
        color: Colors.white,
      ),
    );
  }
}
