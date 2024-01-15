import 'package:formx_sdk_flutter/src/models/formx_detect_documents_result.dart';
import 'package:formx_sdk_flutter/src/models/formx_extraction_result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'formx_sdk_flutter_method_channel.dart';

abstract class FormxSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a FormxSdkFlutterPlatform.
  FormxSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FormxSdkFlutterPlatform _instance = MethodChannelFormxSdkFlutter();

  /// The default instance of [FormxSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelFormxSdkFlutter].
  static FormxSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FormxSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(FormxSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(String extractorId, String accessToken, String? apiHost) {
    throw UnimplementedError(
        'init(extractorId, accessToken, apiHost) has not been implemented.');
  }

  Future<FormXDetectDocumentsResult?> detect(String imagePath) {
    throw UnimplementedError('detect(imagePath) has not been implemented.');
  }

  Future<FormXExtractionResult?> extract(String imagePath) {
    throw UnimplementedError('extract(imagePath) has not been implemented.');
  }

  Future<bool?> isBlurry(String imagePath, double threshold) async {
    throw UnimplementedError(
        'isBlurry(imagePath, threshold) has not been implemented.');
  }
}
