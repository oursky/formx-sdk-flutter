import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SDKMethodsDemoScreen extends StatefulWidget {
  const SDKMethodsDemoScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SDKMethodsDemoScreenState();
  }
}

class _SDKMethodsDemoScreenState extends State {
  final _picker = ImagePicker();
  Exception? _selectImageError;

  bool _isDetecting = false;
  FormXDetectDocumentsResult? _detectResult;
  Exception? _detectError;

  bool _isExtracting = false;
  FormXExtractionResult? _extractionResult;
  Exception? _extractionError;

  bool _isCheckBlurrying = false;
  bool? _isBlurry;
  Exception? _checkBlurryError;

  XFile? _selectedImage;

  _onSelectImage(BuildContext context) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _detectError = null;
          _detectResult = null;
          _extractionResult = null;
          _extractionError = null;
          _isBlurry = null;
          _checkBlurryError = null;
        });
      }
    } on Exception catch (error) {
      _selectImageError = error;
    }
  }

  _onDetectImage(BuildContext context) async {
    try {
      final image = _selectedImage;

      setState(() {
        _isDetecting = true;
        _detectResult = null;
        _detectError = null;
      });
      if (image != null) {
        _detectResult = await FormXSDK.detect(image.path);
        setState(() {});
      }
    } on Exception catch (error) {
      _detectError = error;
    } finally {
      setState(() {
        _isDetecting = false;
      });
    }
  }

  _onExtractFromImage(BuildContext context) async {
    try {
      final image = _selectedImage;

      setState(() {
        _extractionResult = null;
        _extractionError = null;
        _isExtracting = true;
      });
      if (image != null) {
        _extractionResult = await FormXSDK.extract(image.path);
        setState(() {});
      }
    } on Exception catch (error) {
      _extractionError = error;
    } finally {
      setState(() {
        _isExtracting = false;
      });
    }
  }

  _onCheckIsBlurry(BuildContext context) async {
    try {
      final image = _selectedImage;

      setState(() {
        _isBlurry = null;
        _isCheckBlurrying = true;
        _checkBlurryError = null;
      });
      if (image != null) {
        _isBlurry = await FormxBlurDetector().isBlurry(image.path);
        setState(() {});
      }
    } on Exception catch (error) {
      _checkBlurryError = error;
    } finally {
      setState(() {
        _isCheckBlurrying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SDK Methods Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedImage != null)
                Image.file(File(_selectedImage!.path)),
              if (_selectImageError != null) Text(_selectImageError.toString()),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      _onSelectImage(context);
                    },
                    child: const Text('Select image'),
                  );
                },
              ),
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: _selectedImage == null
                            ? null
                            : () {
                                _onDetectImage(context);
                              },
                        child: const Text('Detect document'),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (_isDetecting) const CircularProgressIndicator(),
                ],
              ),
              if (_detectResult != null)
                Text(
                    "result ${_detectResult!.status}\ndetected document count: ${_detectResult!.documents.length}"),
              if (_detectError != null) Text(_detectError.toString()),
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: _selectedImage == null
                            ? null
                            : () {
                                _onExtractFromImage(context);
                              },
                        child: const Text('Extract from image'),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (_isExtracting) const CircularProgressIndicator(),
                ],
              ),
              if (_extractionResult != null)
                Text(
                    "result ${_extractionResult!.status}\nextracted document count: ${_extractionResult!.documents.length}"),
              if (_extractionError != null) Text(_extractionError.toString()),
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: _selectedImage == null || _isCheckBlurrying
                            ? null
                            : () {
                                _onCheckIsBlurry(context);
                              },
                        child: const Text('Check is blurry'),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (_isCheckBlurrying) const CircularProgressIndicator(),
                ],
              ),
              if (_isBlurry != null) Text("result is blurry: $_isBlurry"),
              if (_checkBlurryError != null) Text(_checkBlurryError.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
