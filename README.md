# formx_sdk_flutter

Using [FormX SDK](https://help.formx.ai/docs/getting-started) within Flutter application.


## Platform Support

|  Android   |      iOS      | MacOS |  Web  | Linux | Windows |
| :--------: | :-----------: | :---: | :---: | :---: | :-----: |
| ✅(SDK 26+) | ✅ (iOS 14.0+) |   ❌   |   ❌   |   ❌   |    ❌    |

## Installation

In the dependencies: section of your pubspec.yaml, add the following line:

```yaml
dependencies:
  formx_sdk_flutter: ^1.0.2
```

## Setup

<details>
<summary>Android</summary>

1. Set the `minSdkVersion` in `android/app/build.gradle`:

```
android {
    defaultConfig {
        minSdkVersion 26
    }
}
```

2. Replace base activity with `FlutterFragmentActivity`

```
class MainActivity: FlutterFragmentActivity() {
}
```
</details>

<details>
<summary>iOS</summary>

1. Update `Podfile` with:
```
target 'Runner' do

  ....skiped...

  pod 'FormX', :git => 'https://github.com/oursky/formx-sdk.git', tag: '0.3.0'

  ....skiped...
```

2. Set minimum deployments to `14.0`

</details>


## Sample Usage

### FormXCameraView

A native camera view to detect documents

1. Obtain camera permission:

To use `FormXCameraView`, `Camera` permission must be granted. Recommend to use flutter plugin like [permission_handler](https://pub.dev/packages/permission_handler) to handle it.


2. Using `FormXCameraView` widget in flutter app:

```
Scaffold(
      body: _cameraPermissionStatus == PermissionStatus.granted
          ? FormXCameraView(
              controller: _controller,
              onClose: _onCloseCamera,
              onCaptured: _onCaptured,
              onCaptureError: _onCaptureError,
            )
      ...
)
```
_For complete tutorial please refer to [example app doc](https://github.com/oursky/formx-sdk-flutter/tree/main/example)_

## Publish library

https://docs.flutter.dev/packages-and-plugins/developing-packages#publish
