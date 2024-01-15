import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';
import 'package:formx_sdk_flutter/src/formx_sdk_flutter_platform_interface.dart';

// A SDK wrapper to communicate with the FormX API
class FormXSDK {
  /// Setup SDK with [extractorId] and [accessToken]. if [apiHost] is null, official formx api endpoint is used.
  static Future<void> init(
      {required String extractorId,
      required String accessToken,
      String? apiHost}) {
    return FormxSdkFlutterPlatform.instance
        .init(extractorId, accessToken, apiHost);
  }

  /// Detect documents by FormX API
  static Future<FormXDetectDocumentsResult?> detect(String imagePath) {
    return FormxSdkFlutterPlatform.instance.detect(imagePath);
  }

  /// Extract form data from documents by FormX API
  static Future<FormXExtractionResult?> extract(String imagePath) {
    return FormxSdkFlutterPlatform.instance.extract(imagePath);
  }
}
