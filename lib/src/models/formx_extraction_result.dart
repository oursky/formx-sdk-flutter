import 'package:flutter/foundation.dart';
import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';

class ExtractMetaData {
  final String extractorId;
  final String requestId;
  final int usage;
  final String? jobId;
  ExtractMetaData(Map<Object?, Object?> json)
      : extractorId = json["extractorId"] as String,
        requestId = json["requestId"] as String,
        usage = json["usage"] as int,
        jobId = json["jobId"] as String?;
}

class ExtractDocumentMetaData {
  final int pageNo;
  final int sliceNo;
  final String extractorType;
  final int? orientation;

  ExtractDocumentMetaData(Map<Object?, Object?> json)
      : pageNo = json["pageNo"] as int,
        sliceNo = json["sliceNo"] as int,
        extractorType = json["extractorType"] as String,
        orientation = json["orientation"] as int?;
}

class ExtractDocumentDataField {
  final String name;
  final FormXAutoExtractionItem? value;

  ExtractDocumentDataField({required this.name, required this.value});

  factory ExtractDocumentDataField.from(Map<Object?, Object?> json) {
    return ExtractDocumentDataField(
        name: json["name"] as String,
        value: json["value"] == null
            ? null
            : parseFormXAutoExtractionItem(
                json["value"] as Map<Object?, Object?>));
  }
}

class ExtractDocumentData {
  final List<ExtractDocumentDataField> fields;
  ExtractDocumentData(Map<Object?, Object?> json)
      : fields = (json["fields"] as List<Object?>).map((obj) {
          debugPrint(obj.toString());
          return ExtractDocumentDataField.from(obj as Map<Object?, Object?>);
        }).toList();
}

class ExtractDetailedData {
  ExtractDetailedData(Map<Object?, Object?> json);
}

class ExtractDocument {
  final String? type;
  final double? typeConfidence;
  final List<double>? boundingBox;
  final String extractorId;
  final ExtractDocumentMetaData metaData;
  final ExtractDocumentData data;
  final ExtractDetailedData detailedData;
  ExtractDocument(Map<Object?, Object?> json)
      : extractorId = json["extractorId"] as String,
        type = json["type"] as String?,
        typeConfidence = json["typeConfidence"] as double?,
        boundingBox = (json["boundingBox"] as List<Object?>?)?.cast(),
        metaData = ExtractDocumentMetaData(
          json["metaData"] as Map<Object?, Object?>,
        ),
        data = ExtractDocumentData(
          json["data"] as Map<Object?, Object?>,
        ),
        detailedData = ExtractDetailedData(
          json["detailedData"] as Map<Object?, Object?>,
        );
}

/// The response returned by [FormXSDK.extract]
class FormXExtractionResult {
  final ExtractMetaData extractMetaData;
  final String status;
  final List<ExtractDocument> documents;

  FormXExtractionResult(Map<Object?, Object?> json)
      : extractMetaData =
            ExtractMetaData(json["metaData"] as Map<Object?, Object?>),
        status = json["status"] as String,
        documents = (json["documents"] as List<Object?>).map((it) {
          return ExtractDocument(it as Map<Object?, Object?>);
        }).toList();
}
