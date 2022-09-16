// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/widgets/online_users_counter.dart';
import 'package:zegocloud_live_video_call/ui/widgets/row_view.dart';
import 'package:zegocloud_live_video_call/ui/widgets/toolbar.dart';
import 'package:zegocloud_live_video_call/utils/call_helper.dart';
import 'package:zegocloud_live_video_call/utils/texture_size_helper.dart';

class ManyToManyCallPage extends StatefulWidget {
  const ManyToManyCallPage({
    Key? key,
    required this.userID,
    required this.roomID,
    required this.appSign,
    required this.appID,
    required this.token,
    required this.screenSize,
    required this.username,
    required this.micEnabled,
    required this.cameraEnabled,
    required this.useFrontCamera,
  }) : super(key: key);

  final String userID;
  final String roomID;
  final String? appSign;
  final String token;
  final int appID;
  final String username;
  final Size screenSize;
  final bool micEnabled;
  final bool cameraEnabled;
  final bool useFrontCamera;

  @override
  State<ManyToManyCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<ManyToManyCallPage> {
  final CallHelper callHelper = CallHelper();
  late bool _micEnabled = widget.micEnabled;
  late bool _cameraEnabled = widget.cameraEnabled;
  late bool _useFrontCamera = widget.useFrontCamera;
  bool _initialTextureUpdating = true;
  int _onlineUsersCount = 1;
  String _loudestStreamID = '';

  late int _localViewID; // local textureID
  Texture? _localViewWidget; // local texture
  late String _localStreamID; // local streamID
  late ZegoStream _localStream = ZegoStream(
    ZegoUser(
      widget.userID,
      widget.username.isNotEmpty ? widget.username : 'Anonym',
    ),
    _localStreamID,
    '',
  );

  List<int> _remoteViewIDs = []; // textureIDs
  List<Texture> _remoteTextureList = []; // video textures
  List<ZegoStream> _remoteStreams = []; // streams with video
  List<VideoModel> _videoModelList = []; // video models with video
  List<VideoModel> _disabledVideoModelList = []; // video models without video

  VideoModel? _loudestEnabledVideoModel;
  VideoModel? _loudestDisabledVideoModel;

  @override
  void initState() {
    _eventHandler();
    _createUserAndLoginRoom();
    _startSoundLevelMonitor();
    _publishStream();
    _createPreviewRenderer();
    super.initState();
  }

  Future<void> _createUserAndLoginRoom() async {
    ZegoUser user = ZegoUser(
      widget.userID,
      widget.username.isNotEmpty ? widget.username : 'Anonym',
    );

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

  Future<void> _eventHandler() async {
    /// The callback triggered when the number of streams published by the other users increases or decreases.
    /// [streamList] it is ONLY updated stream!
    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) async {
      if (updateType == ZegoUpdateType.Add) {
        log('ZegoUpdateType.Add');

        await _playRemoteStreams(streamList);
      }
      if (updateType == ZegoUpdateType.Delete) {
        log('ZegoUpdateType.Delete');

        log('_videoModelList = ${_videoModelList.length}');
        log('_remoteViewIDs = ${_remoteViewIDs.length}');
        log('_remoteTextureList = ${_remoteTextureList.length}');
        log('_remoteStreams = ${_remoteStreams.length}');
        log('_disabledVideoModelList = ${_disabledVideoModelList.length}');

        List<int> deletedViewIDs = [];
        List<ZegoStream> deletedStreams = [];
        List<Texture> availableTextures = [];
        List<ZegoStream> availableStreams = [];
        List<VideoModel> availableVideoModel = [];
        List<VideoModel> availableDisabledVideoModel = [];

        for (VideoModel model in _videoModelList) {
          for (ZegoStream stream in streamList) {
            if (model.stream.streamID == stream.streamID) {
              deletedViewIDs.add(model.viewID!);
              deletedStreams.add(stream);
            } else {
              availableVideoModel.add(model);
            }
          }
        }

        for (VideoModel model in _disabledVideoModelList) {
          for (ZegoStream stream in streamList) {
            if (model.stream.streamID == stream.streamID) {
              if (model.viewID != null) {
                deletedViewIDs.add(model.viewID!);
              }
              deletedStreams.add(stream);
            } else {
              availableDisabledVideoModel.add(model);
            }
          }
        }

        _videoModelList.clear();
        _videoModelList.addAll(availableVideoModel);

        _disabledVideoModelList.clear();
        _disabledVideoModelList.addAll(availableDisabledVideoModel);

        for (ZegoStream stream in deletedStreams) {
          ZegoExpressEngine.instance.stopPlayingStream(stream.streamID);

          for (ZegoStream element in _remoteStreams) {
            if (element.streamID != stream.streamID) {
              availableStreams.add(element);
            }
          }
        }

        _remoteStreams.clear();
        _remoteStreams.addAll(availableStreams);

        for (int viewID in deletedViewIDs) {
          ZegoExpressEngine.instance.destroyTextureRenderer(viewID);
          _remoteViewIDs.remove(viewID);

          for (Texture texture in _remoteTextureList) {
            if (texture.textureId != viewID) {
              availableTextures.add(texture);
            }
          }
        }

        _remoteTextureList.clear();
        _remoteTextureList.addAll(availableTextures);

        _loudestEnabledVideoModel = null;
        _loudestDisabledVideoModel = null;

        log('=======================================');
        log('_videoModelList = ${_videoModelList.length}');
        log('_remoteViewIDs = ${_remoteViewIDs.length}');
        log('_remoteTextureList = ${_remoteTextureList.length}');
        log('_remoteStreams = ${_remoteStreams.length}');
        log('_disabledVideoModelList = ${_disabledVideoModelList.length}');

        setState(() {});
      }
    };

    /// The callback triggered when the state of the remote camera changes.
    ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) async {
      if (state == ZegoRemoteDeviceState.Open) {
        log(name: 'onRemoteCameraStateUpdate', 'ZegoRemoteDeviceState.Open');

        late VideoModel newVideoModel;

        List<VideoModel> disabledVideoModels = [];

        for (VideoModel model in _disabledVideoModelList) {
          if (model.stream.streamID == streamID) {
            newVideoModel = model;
          } else {
            disabledVideoModels.add(model);
          }
        }

        _disabledVideoModelList.clear();
        _disabledVideoModelList.addAll(disabledVideoModels);

        _loudestEnabledVideoModel = null;
        _loudestDisabledVideoModel = null;

        _playRemoteStreamsFromVideoModel(<VideoModel>[newVideoModel]);
      }
      if (state == ZegoRemoteDeviceState.Disable) {
        log(name: 'onRemoteCameraStateUpdate', 'ZegoRemoteDeviceState.Disable');

        late int disabledViewID;
        late VideoModel disabledVideoModel;

        List<Texture> enabledTextureList = [];
        List<VideoModel> enabledVideoModels = [];
        List<ZegoStream> enabledStreams = [];

        for (VideoModel model in _videoModelList) {
          if (model.stream.streamID == streamID) {
            disabledViewID = model.viewID!;
            disabledVideoModel = model;
          } else {
            enabledStreams.add(model.stream);
            enabledVideoModels.add(model);
          }
        }

        _remoteStreams.clear();
        _remoteStreams.addAll(enabledStreams);
        _disabledVideoModelList.add(VideoModel(
          stream: disabledVideoModel.stream,
          micEnabled: disabledVideoModel.micEnabled,
        ));

        _videoModelList.clear();
        _videoModelList.addAll(enabledVideoModels);

        for (Texture texture in _remoteTextureList) {
          if (texture.textureId != disabledViewID) {
            enabledTextureList.add(texture);
          }
        }

        _remoteTextureList.clear();
        _remoteTextureList.addAll(enabledTextureList);

        ZegoExpressEngine.instance.destroyTextureRenderer(disabledViewID);
        _remoteViewIDs.remove(disabledViewID);

        _loudestEnabledVideoModel = null;
        _loudestDisabledVideoModel = null;

        setState(() {});
      }
    };

    /// The callback triggered when the state of the remote microphone changes.
    ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) async {
      if (state == ZegoRemoteDeviceState.Open) {
        log(name: 'onRemoteMicStateUpdate', 'ZegoRemoteDeviceState.Open');

        _onRemoteMicStateUpdateCallback(
          streamID: streamID,
        );
      }
      if (state == ZegoRemoteDeviceState.Mute) {
        log(name: 'onRemoteMicStateUpdate', 'ZegoRemoteDeviceState.Mute');

        _onRemoteMicStateUpdateCallback(
          streamID: streamID,
        );
      }
    };

    /// The callback triggered when the number of other users in the room increases or decreases.
    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, userList) async {
      if (updateType == ZegoUpdateType.Add) {
        _onlineUsersCount += userList.length;
        log(name: 'Number of other users in the room', 'onRoomUserUpdate => $_onlineUsersCount');
      } else {
        _onlineUsersCount -= userList.length;
        log(name: 'Number of other users in the room', 'onRoomUserUpdate => $_onlineUsersCount');
      }

      /// Update textures size.
      if (_initialTextureUpdating || (_onlineUsersCount >= 1 && _onlineUsersCount <= 5)) {
        callHelper.updateTexturesSize(
          context: context,
          onlineUsersCount: _onlineUsersCount,
          remoteViewIDs: _remoteViewIDs,
          localViewID: _localViewID,
        );

        _initialTextureUpdating = false;
      }

      setState(() {});
    };

    /// The remote playing streams audio sound level callback.
    ZegoExpressEngine.onRemoteSoundLevelUpdate = (soundLevelInfos) {
      double soundLevel = 10.0;
      String loudestStreamID = '';

      soundLevelInfos.forEach((k, v) {
        if (v > soundLevel) {
          soundLevel = v;
          loudestStreamID = k;
        }
      });

      if (loudestStreamID.isNotEmpty && _loudestStreamID != loudestStreamID) {
        bool loudestStreamFonded = false;

        for (VideoModel model in _videoModelList) {
          _loudestEnabledVideoModel = null;
          _loudestDisabledVideoModel = null;

          if (model.stream.streamID == loudestStreamID) {
            loudestStreamFonded = true;
            _loudestEnabledVideoModel = model;
          }
        }

        if (!loudestStreamFonded) {
          for (VideoModel model in _disabledVideoModelList) {
            if (model.stream.streamID == loudestStreamID) {
              loudestStreamFonded = true;
              _loudestDisabledVideoModel = model;
            }
          }
        }

        if (loudestStreamFonded) {
          setState(() {
            _loudestStreamID = loudestStreamID;
          });

          log(name: 'loudest stream ID', 'onRemoteSoundLevelUpdate: loudest stream ID = $loudestStreamID');
        }
      }
    };
  }

  /// Using TextureRenderer (the default method).
  Future<void> _createPreviewRenderer() async {
    final Size size = getVideoCardSize(
      screenSize: widget.screenSize,
      userCount: _onlineUsersCount,
    );

    await ZegoExpressEngine.instance.createTextureRenderer(size.width.toInt(), size.height.toInt()).then((textureID) {
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

  /// Starts publishing a stream.
  ///
  /// Users push their local audio and video streams to the ZEGO RTC server or CDN, and other users in the same room can pull the audio and video streams to watch through the streamID or CDN pull stream address.
  Future<void> _publishStream() async {
    setState(() {
      /// streamID must be globally unique within the scope of the AppID. If different streams are published with the same streamID, the ones that are published after the first one will fail.
      _localStreamID = DateTime.now().millisecondsSinceEpoch.toString();
    });

    /// Disable camera and mute microphone before [startPublishingStream]
    await ZegoExpressEngine.instance.enableCamera(_cameraEnabled);
    await ZegoExpressEngine.instance.muteMicrophone(!_micEnabled);
    log('muteMicrophone => ${!_micEnabled}');
    log('enableCamera => $_cameraEnabled');

    /// Sets up the video configurations.
    ZegoVideoConfig videoConfig = ZegoVideoConfig(720, 1280, 720, 1280, 30, 1500, ZegoVideoCodecID.Default);
    await ZegoExpressEngine.instance.setVideoConfig(videoConfig);

    // await ZegoExpressEngine.instance.setVideoMirrorMode(ZegoVideoMirrorMode.OnlyPreviewMirror);
    await ZegoExpressEngine.instance.startPublishingStream(_localStreamID);
    log('startPublishingStream');

    if (_cameraEnabled) {
      _startPreview(_localViewID);
      log(name: '_startPreview', '_startPreview');
    }
  }

  /// Creates a Texture render and then calls [_startPlayingStream].
  Future<void> _playRemoteStreams(List<ZegoStream> streamList) async {
    final Size size = getVideoCardSize(
      screenSize: widget.screenSize,
      userCount: _onlineUsersCount,
    );

    for (ZegoStream stream in streamList) {
      ZegoExpressEngine.instance.createTextureRenderer(size.width.toInt(), size.height.toInt()).then((viewID) {
        /// Add the Widget you get to the layertree for displaying the view of video preview.

        _remoteViewIDs.add(viewID);
        _remoteStreams.add(stream);
        _remoteTextureList.add(Texture(textureId: viewID));

        _videoModelList.add(
          VideoModel(
            stream: stream,
            viewID: viewID,
            texture: Texture(textureId: viewID),
          ),
        );

        _startPlayingStream(viewID, stream.streamID);
      });
    }

    setState(() {});
  }

  /// Creates a Texture render and then calls [_startPlayingStream].
  Future<void> _playRemoteStreamsFromVideoModel(List<VideoModel> videoModelList) async {
    final Size size = getVideoCardSize(
      screenSize: widget.screenSize,
      userCount: _onlineUsersCount,
    );

    for (VideoModel model in videoModelList) {
      ZegoExpressEngine.instance.createTextureRenderer(size.width.toInt(), size.height.toInt()).then((viewID) {
        /// Add the Widget you get to the layertree for displaying the view of video preview.

        _remoteViewIDs.add(viewID);
        _remoteStreams.add(model.stream);
        _remoteTextureList.add(Texture(textureId: viewID));

        _videoModelList.add(
          VideoModel(
            stream: model.stream,
            viewID: viewID,
            texture: Texture(textureId: viewID),
            micEnabled: model.micEnabled,
          ),
        );

        _startPlayingStream(viewID, model.stream.streamID);
      });
    }

    setState(() {});
  }

  /// Toggles the value of [VideoModel.micEnabled] for a model with the same [streamID] in [_videoModelList] or [_disabledVideoModelList] and then calls [setState].
  void _onRemoteMicStateUpdateCallback({
    required String streamID,
  }) {
    for (var i = 0; i < _videoModelList.length; i++) {
      if (_videoModelList[i].stream.streamID == streamID) {
        final VideoModel temp = _videoModelList[i];
        _videoModelList[i] = VideoModel(
          stream: temp.stream,
          texture: temp.texture,
          viewID: temp.viewID,
          micEnabled: !temp.micEnabled,
        );
      }
    }

    for (var i = 0; i < _disabledVideoModelList.length; i++) {
      if (_disabledVideoModelList[i].stream.streamID == streamID) {
        final VideoModel temp = _disabledVideoModelList[i];
        _disabledVideoModelList[i] = VideoModel(
          stream: temp.stream,
          texture: temp.texture,
          viewID: temp.viewID,
          micEnabled: !temp.micEnabled,
        );
      }
    }

    setState(() {});
  }

  /// Starts sound level monitoring. Support enable some advanced feature.
  void _startSoundLevelMonitor() {
    ZegoExpressEngine.instance.startSoundLevelMonitor(
      config: ZegoSoundLevelConfig(1000, false),
    );
  }

  /// Starts playing a stream (audio and video streams) from ZEGO RTC server or from third-party CDN.
  Future<void> _startPlayingStream(int viewID, String streamID) async {
    /// The view used to display the play audio and video stream's image.
    ZegoCanvas canvas = ZegoCanvas(viewID, backgroundColor: 0x444444, viewMode: ZegoViewMode.AspectFill);
    await ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
  }

  List<VideoModel> _rowViewList() {
    late VideoModel localVideoModel;

    if (_cameraEnabled && _localViewWidget != null) {
      localVideoModel = VideoModel(
        stream: _localStream,
        texture: _localViewWidget,
        viewID: _localViewID,
        micEnabled: _micEnabled,
      );
    } else {
      localVideoModel = VideoModel(
        stream: _localStream,
        texture: null,
        viewID: null,
        micEnabled: _micEnabled,
      );
    }

    List<VideoModel> list = [localVideoModel];

    if (_loudestEnabledVideoModel != null) {
      List<VideoModel> temp = [];
      list.add(_loudestEnabledVideoModel!);

      for (VideoModel model in _videoModelList) {
        if (model.stream.streamID != _loudestEnabledVideoModel!.stream.streamID) {
          temp.add(model);
        }
      }

      list.addAll(temp);
      list.addAll(_disabledVideoModelList);
    } else if (_loudestDisabledVideoModel != null) {
      List<VideoModel> temp = [];
      list.add(_loudestDisabledVideoModel!);

      for (VideoModel model in _disabledVideoModelList) {
        if (model.stream.streamID != _loudestDisabledVideoModel!.stream.streamID) {
          temp.add(model);
        }
      }

      list.addAll(_videoModelList);
      list.addAll(temp);
    } else {
      for (VideoModel model in _videoModelList) {
        list.add(model);
      }
      for (VideoModel model in _disabledVideoModelList) {
        list.add(model);
      }
    }

    return list;
  }

  void _callEndButtonPressed() {
    ZegoExpressEngine.instance.stopPublishingStream();
    for (int textureID in _remoteViewIDs) {
      ZegoExpressEngine.instance.destroyTextureRenderer(textureID);
    }
    ZegoExpressEngine.instance.logoutRoom(widget.roomID);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _callEndButtonPressed();
        Navigator.pop(context, true);
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Stack(
            children: [
              RowView(
                videoModels: _rowViewList(),
                textureSize: getVideoCardSize(
                  screenSize: widget.screenSize,
                  userCount: _onlineUsersCount,
                ),
              ),
              OnlineUsersCounter(
                onlineUsersCount: _onlineUsersCount,
              ),
              Toolbar(
                micEnabled: _micEnabled,
                cameraEnabled: _cameraEnabled,
                micButtonPressed: () {
                  ZegoExpressEngine.instance.muteMicrophone(_micEnabled);
                  setState(() => _micEnabled = !_micEnabled);
                },
                callEndButtonPressed: () {
                  _callEndButtonPressed();
                  Navigator.pop(context, true);
                },
                cameraButtonPressed: () async {
                  setState(() => _cameraEnabled = !_cameraEnabled);
                  ZegoExpressEngine.instance.enableCamera(_cameraEnabled);

                  if (_cameraEnabled) {
                    await _startPreview(_localViewID);
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
      ),
    );
  }
}



// 202124 background
// 28292c
// 3c4043 button 
// ea4335 red