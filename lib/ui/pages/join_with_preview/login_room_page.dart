// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/pages/join_with_preview/many_to_many_call_page.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_card.dart';
import 'package:zegocloud_live_video_call/ui/widgets/test_text_field.dart';
import 'package:zegocloud_live_video_call/ui/widgets/toolbar.dart';
import 'package:zegocloud_live_video_call/utils/color_helper.dart';
import 'package:zegocloud_live_video_call/utils/permission_helper.dart';
import 'package:zegocloud_live_video_call/utils/settings.dart' as settings;

class LoginRoomPage extends StatefulWidget {
  const LoginRoomPage({
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
  State<LoginRoomPage> createState() => _LoginRoomPageState();
}

class _LoginRoomPageState extends State<LoginRoomPage> {
  final String _localStreamID = DateTime.now().millisecondsSinceEpoch.toString();
  final PermissionHelper permissionHelper = PermissionHelper();
  final MaterialColor _avatarColor = ColorHelper.getRandomColor();
  late TextEditingController _usernameController;
  late int _localViewID;
  late Texture _localViewWidget;
  bool _micEnabled = false;
  bool _cameraEnabled = false;
  bool _useFrontCamera = true;
  bool _callPageClosed = false;
  bool _initialRender = true;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _createEngine();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _destroyEngine();
    super.dispose();
  }

  Future<void> _createEngine() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      widget.appID,
      ZegoScenario.General,
      appSign: widget.appSign, // it is null because I use token
      /// [enablePlatformView] commented because I use TextureRenderer object for rendering the preview
      // enablePlatformView: true,
    );

    await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  /// Using TextureRenderer (the default method).
  Future<void> _createPreviewRenderer() async {
    final Size size = MediaQuery.of(context).size;

    await ZegoExpressEngine.instance.createTextureRenderer(size.width ~/ 2, size.height ~/ 2.2).then((textureID) {
      _localViewID = textureID;

      setState(() {
        /// Create a Texture Widget.
        Texture previewViewWidget = Texture(textureId: textureID);

        /// Add this Widget to the layertree for displaying the view of video preview.
        _localViewWidget = previewViewWidget;
      });
    });
  }

  /// Using TextureRenderer (the default method). The user can see his own local image by calling this function.
  Future<void> _startPreview(int viewID) async {
    /// The view used to display the play audio and video stream's image.
    ZegoCanvas previewCanvas = ZegoCanvas(viewID, backgroundColor: 0x444444, viewMode: ZegoViewMode.AspectFill);
    await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
  }

  VideoModel _getVideoModel() {
    if (_cameraEnabled) {
      return VideoModel(
        stream: ZegoStream(
          ZegoUser(
            widget.userID,
            _usernameController.text.isNotEmpty ? _usernameController.text : 'Anonym',
          ),
          _localStreamID,
          '',
        ),
        micEnabled: _micEnabled,
        texture: _localViewWidget,
        viewID: _localViewID,
        avatarColor: _avatarColor,
      );
    }

    return VideoModel(
      stream: ZegoStream(
        ZegoUser(
          widget.userID,
          _usernameController.text.isNotEmpty ? _usernameController.text : 'Anonym',
        ),
        _localStreamID,
        '',
      ),
      micEnabled: _micEnabled,
      avatarColor: _avatarColor,
    );
  }

  void _destroyEngine() {
    if (!_initialRender) {
      ZegoExpressEngine.instance.destroyTextureRenderer(_localViewID);
    }
    ZegoExpressEngine.destroyEngine();
  }

  void _unfocus(BuildContext context) {
    final FocusScopeNode focus = FocusScope.of(context);
    if (focus.hasFocus) {
      focus.unfocus();
    }
  }

  Future<void> _micButtonPressed() async {
    await permissionHelper.requestMicPermission();
    ZegoExpressEngine.instance.muteMicrophone(!_micEnabled);
    setState(() {
      _micEnabled = !_micEnabled;
    });
  }

  Future<void> _cameraButtonPressed() async {
    if (_initialRender) {
      await permissionHelper.requestCameraPermission();
      await _createPreviewRenderer();
      _initialRender = false;
    }

    setState(() => _cameraEnabled = !_cameraEnabled);
    await ZegoExpressEngine.instance.enableCamera(_cameraEnabled);

    if (_cameraEnabled) {
      await _startPreview(_localViewID);
    } else {
      await ZegoExpressEngine.instance.stopPreview();
    }
  }

  void _switchCameraButtonPressed() {
    setState(() => _useFrontCamera = !_useFrontCamera);
    ZegoExpressEngine.instance.useFrontCamera(_useFrontCamera);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _destroyEngine();
        Wakelock.disable();
        log(name: 'Keep screen awake', 'Wakelock disabled');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFfafafa),
          elevation: 0,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              _destroyEngine();
              Wakelock.disable();
              log(name: 'Keep screen awake', 'Wakelock disabled');
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => _unfocus(context),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Text(
                          'Event name some event name yeah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF3c4043),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RemoteVideoCard(
                        textureSize: Size(
                          MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 2.2,
                        ),
                        videoModel: _getVideoModel(),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 38,
                            child: ToolbarButton(
                              onPressed: _micButtonPressed,
                              icon: _micEnabled ? Icons.mic : Icons.mic_off,
                              color: _micEnabled ? Colors.white : const Color(0xFF3c4043),
                              iconColor: _micEnabled ? const Color(0xFF3c4043) : Colors.white,
                              padding: 0,
                              iconSize: 20,
                            ),
                          ),
                          Container(
                            width: 38,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ToolbarButton(
                              onPressed: _cameraButtonPressed,
                              icon: _cameraEnabled ? Icons.videocam : Icons.videocam_off,
                              color: _cameraEnabled ? Colors.white : const Color(0xFF3c4043),
                              iconColor: _cameraEnabled ? const Color(0xFF3c4043) : Colors.white,
                              padding: 0,
                              iconSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 38,
                            child: ToolbarButton(
                              onPressed: _switchCameraButtonPressed,
                              icon: Icons.switch_camera,
                              iconColor: const Color(0xFF3c4043),
                              color: Colors.white,
                              padding: 0,
                              iconSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TestTextField(
                          controller: _usernameController,
                          hintText: 'Username',
                          labelText: 'Username',
                          maxLength: 30,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final Size size = MediaQuery.of(context).size;

                          await permissionHelper.requestPermission();

                          if (!_initialRender) {
                            ZegoExpressEngine.instance.stopPreview();
                            ZegoExpressEngine.instance.destroyTextureRenderer(_localViewID);
                          }

                          Wakelock.enable();
                          log(name: 'Keep screen awake', 'Wakelock enabled');

                          _callPageClosed = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManyToManyCallPage(
                                userID: widget.userID,
                                roomID: widget.roomID,
                                appSign: null,
                                appID: settings.appID,
                                token: widget.token,

                                /// Settings
                                username: _usernameController.text.isNotEmpty ? _usernameController.text : 'Anonym',
                                screenSize: size,
                                cameraEnabled: _cameraEnabled,
                                micEnabled: _micEnabled,
                                useFrontCamera: _useFrontCamera,
                                avatarColor: _avatarColor,
                                callName: 'Event name some event',
                              ),
                            ),
                          );

                          if (_callPageClosed) {
                            ZegoExpressEngine.instance.enableCamera(_cameraEnabled);
                            ZegoExpressEngine.instance.muteMicrophone(!_micEnabled);

                            await _createPreviewRenderer();
                            _startPreview(_localViewID);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueAccent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.video_collection_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _callPageClosed ? 'Join a call again' : 'Join a call',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
