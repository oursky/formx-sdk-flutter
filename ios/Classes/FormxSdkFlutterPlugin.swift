import Flutter
import FormX
import UIKit

public class FormxSdkFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "formx_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = FormxSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let factory = FormXCameraNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "formx_sdk_flutter/camera_view_ios")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            if let arguments = call.arguments as? Dictionary<String, Any>,
               let extractorId = arguments["extractorId"] as? String,
               let accessToken = arguments["accessToken"] as? String{
                let apiEndpoint = arguments["apiHost"] as? String
                FormXSDKInitializer.shared.`init`(extractorId: extractorId, accessToken: accessToken, apiHost: apiEndpoint)
                result(nil)
            } else {
                result(FormXError.validationError(message: "missing required parameters").asFlutterError())
            }
        case "detect":
            guard let arguments = call.arguments as? Dictionary<String, Any>,
                  let imagePath = arguments["imagePath"] as? String else {
                result(FormXError.validationError(message: "missing required parameters").asFlutterError())
                return
            }
            guard let formXApiClient = FormXSDKInitializer.shared.apiClient else {
                result(FormXError.formXSDKNotInitialized().asFlutterError())
                return
            }
            DispatchQueue.global().async {
                guard
                    let imageData = UIImage(contentsOfFile: URL(fileURLWithPath: imagePath).path)?.jpegData(
                        compressionQuality: 1) else {
                    DispatchQueue.main.async {
                        result(FormXError.invalidImagePath(imagePath: imagePath).asFlutterError())
                    }
                    return
                }
                formXApiClient.findDocuments(data: imageData) {response, error in
                    
                    DispatchQueue.main.async {
                        if let err = error {
                            result(FormXError.formXSDKError(err: err).asFlutterError())
                            return
                        }
                        guard let response = response else {
                            result(FormXError.emptyAPIResponse().asFlutterError())
                            return
                        }
                        result(response.toMap())
                    }
                }
            }
        case "extract":
            guard let arguments = call.arguments as? Dictionary<String, Any>,
                  let imagePath = arguments["imagePath"] as? String else {
                result(FormXError.validationError(message: "missing required parameters").asFlutterError())
                return
            }
            guard let formXApiClient = FormXSDKInitializer.shared.apiClient,
                  let extractorId = FormXSDKInitializer.shared.extractorId else {
                result(FormXError.formXSDKNotInitialized().asFlutterError())
                return
            }
            DispatchQueue.global().async {
                guard
                    let imageData = UIImage(contentsOfFile: URL(fileURLWithPath: imagePath).path)?.jpegData(
                        compressionQuality: 1) else {
                    DispatchQueue.main.async {
                        result(FormXError.invalidImagePath(imagePath: imagePath).asFlutterError())
                    }
                    return
                }
                formXApiClient.extract(extractorId: extractorId, data: imageData) {response, error in
                    
                    DispatchQueue.main.async {
                        if let err = error {
                            result(FormXError.formXSDKError(err: err).asFlutterError())
                            return
                        }
                        guard let response = response else {
                            result(FormXError.emptyAPIResponse().asFlutterError())
                            return
                        }
                        result(response.toMap())
                    }
                }
            }
        case "isBlurry":
            guard let arguments = call.arguments as? Dictionary<String, Any>,
                  let imagePath = arguments["imagePath"] as? String,
                  let threshold = arguments["threshold"] as? Double else {
                result(FormXError.validationError(message: "missing required parameters").asFlutterError())
                return
            }
            DispatchQueue.global().async {
                guard
                    let image = UIImage(contentsOfFile: URL(fileURLWithPath: imagePath).path)?.cgImage else {
                    DispatchQueue.main.async {
                        result(FormXError.invalidImagePath(imagePath: imagePath).asFlutterError())
                    }
                    return
                }
                let isBlurry = FormXBlurDetectorOpenCV(threshold: threshold).isBlurry(image: image)
                DispatchQueue.main.async {
                    result(isBlurry)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
