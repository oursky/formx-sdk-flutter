package ai.formx.mobile.sdk.formx_sdk_flutter

import ai.formx.mobile.sdk.FormXBlurDetector
import android.graphics.BitmapFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

/** FormxSdkFlutterPlugin */
class FormxSdkFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var flutterPluginBinding: FlutterPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "formx_sdk_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterPluginBinding?.let {
            val cameraViewFactory = FormXCameraNativeViewFactory(
                binding.activity,
                messenger = it.binaryMessenger
            )
            it.platformViewRegistry.registerViewFactory(
                "formx_sdk_flutter/camera_view_android",
                cameraViewFactory
            )
        }
    }

    override fun onDetachedFromActivity() {
        flutterPluginBinding = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val extractorId = call.argument<String>("extractorId")
                val accessToken = call.argument<String>("accessToken")
                val apiHost = call.argument<String>("apiHost")
                if (extractorId != null && accessToken != null) {
                    try {
                        FormXSDKInitializer.init(extractorId, accessToken, apiHost)
                    } catch (e: Exception) {
                        result.error(runtimeError(e), e)
                        return
                    }
                    result.success(null)
                } else {
                    result.error(validationError("missing required parameters"))
                }
            }

            "detect" -> {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath == null) {
                    result.error(validationError("missing required parameters"))
                    return
                }
                FormXSDKInitializer.apiClient?.let { apiClient ->
                    val imageBytes = ImageHelper.readBytes(imagePath)
                    CoroutineScope(Dispatchers.IO).launch {
                        apiClient.findDocuments(imageBytes).catch {
                            result.error(formXSDKError(it))
                        }.collect {
                            val r = it.toMap()
                            result.success(r)
                        }
                    }
                } ?: result.error(formXSDKNotInitialized())
            }

            "extract" -> {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath == null) {
                    result.error(validationError("missing required parameters"))
                    return
                }
                FormXSDKInitializer.formId?.let { formId ->
                    FormXSDKInitializer.apiClient?.let { apiClient ->
                        val imageBytes = ImageHelper.readBytes(imagePath)
                        CoroutineScope(Dispatchers.IO).launch {
                            apiClient.extract(formId, imageBytes).catch {
                                result.error(formXSDKError(it))
                            }.collect {
                                val r = it.toMap()
                                result.success(r)
                            }
                        }
                    } ?: result.error(formXSDKNotInitialized())
                } ?: result.error(formXSDKNotInitialized())
            }

            "isBlurry" -> {
                val imagePath = call.argument<String>("imagePath")
                val threshold = call.argument<Double>("threshold")
                if (imagePath == null || threshold == null) {
                    result.error(validationError("missing required parameters"))
                    return
                }
                CoroutineScope(Dispatchers.IO).launch {
                    val bitmap = BitmapFactory.decodeFile(imagePath)

                    val isBlurry = FormXBlurDetector(threshold.toFloat()).isBlurry(bitmap)
                    result.success(isBlurry)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
