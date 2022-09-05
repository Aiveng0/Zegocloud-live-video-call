import 'package:zego_express_engine/zego_express_engine.dart';

class UserSettingsManager {
  /// Acoustic Echo Cancellation (AEC)
  ///
  /// https://doc-zh.zego.im/article/15213#:~:text=3%20%E4%BD%BF%E7%94%A8%E6%AD%A5%E9%AA%A4-,3.1%20%E8%AE%BE%E7%BD%AE%20AEC%EF%BC%88%E5%9B%9E%E5%A3%B0%E6%B6%88%E9%99%A4%EF%BC%89,-enableAEC%20%E3%80%81enableHeadphoneAEC
  void useAEC() {
    ZegoExpressEngine.instance.enableAEC(true);
    ZegoExpressEngine.instance.enableHeadphoneAEC(false);
    ZegoExpressEngine.instance.setAECMode(ZegoAECMode.Aggressive);
  }

  /// Automatic gain control (AGC)
  void useAGC() {
    ZegoExpressEngine.instance.enableAGC(true);
  }

  /// Active noise suppression (ANS, aka ANC)
  void useANS() {
    ZegoExpressEngine.instance.enableANS(true);
    ZegoExpressEngine.instance.enableTransientANS(true);
    ZegoExpressEngine.instance.setANSMode(ZegoANSMode.Medium);
  }
}
