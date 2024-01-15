//
//  Serialization.swift
//  formx_sdk_flutter
//
//  Created by wu mark on 2023/12/19.
//

import Foundation
import FormX

extension FormXAutoExtractionItem {
    func toMap() -> [String: Any] {
        switch self {
        case .intValue(let value):
            return [
                "type": "FormXAutoExtractionIntItem",
                "value": value,
            ]
        case .doubleValue(let value):
            return [
                "type": "FormXAutoExtractionDoubleItem",
                "value": value,
            ]
        case .purchaseInfoValue(let productItem):
            return [
                "type": "FormXAutoExtractionPurchaseInfoValueItem",
                "value": [
                        "name": productItem.name ?? "",
                        "sku": productItem.sku ?? "",
                        "quantity": productItem.quantity ?? 0,
                        "amount": productItem.amount ?? 0.0,
                        "unitPrice": productItem.unitPrice ?? 0.0,
                        "discount": productItem.discount ?? "0",
                        ]
            ]
        case .stringValue(let value):
            return [
                "type": "FormXAutoExtractionStringItem",
                "value": value,
            ]
        case .list(let list):
            return [
                "type": "FormXAutoExtractionItemArray",
                "value": list.map({ item in
                    return item.toMap()
                })
            ]
        case .nestedValue(let value):
            return [
                "type": "NestedFormXAutoExtractionItem",
                "value": value.map({ (key: String, value: FormXAutoExtractionItem) in
                    return [
                        "name": key,
                        "value": value.toMap()
                    ]
                })
            ]
        case .unsupported:
            return [
                "type": "FormXAutoExtractionUnsupportedValue",
                "value": "",
            ]
        }
    }
}

extension ExtractMetaData {
    func toMap() -> [String: Any?] {
        return [
            "extractorId": extractorId,
            "jobId": jobId,
            "usage": usage,
            "requestId": requestId,
        ]
    }
}


extension ExtractDocumentData {
    func toMap() -> [String: Any?] {
      return [
        "fields": fields.map({ field in
            return [
                "name": field.name,
                "value": field.value?.toMap()
            ]
        })
      ]
    }
}

extension ExtractDetailedDataFieldValue {
    func toMap() -> [String: Any?] {
      return [
        "value": value?.toMap(),
        "valueType": valueType,
        "confidence": confidence,
        "extractedBy": extractedBy
      ]
    }
}


extension ExtractDetailedData {
    func toMap() -> [String: Any?] {
      return [
        "fields": fields.map({ field in
            return [
                "name": field.name,
                "value": field.value.map { $0.value?.toMap() }
            ]
        })
      ]
    }
}


extension ExtractDocumentMetaData {
    
    func toMap() -> [String: Any?] {
        return [
            "extractorType": extractorType,
            "pageNo": pageNo,
            "sliceNo": sliceNo,
            "orientation": orientation
        ]
    }
}

extension ExtractDocument {
    func toMap() -> [String: Any?] {
      return [
        "extractorId": extractorId,
        "type": type,
        "typeConfidence": typeConfidence,
        "metaData": metadata.toMap(),
        "data": data.toMap(),
        "detailedData": detailedData.toMap(),
        "boundingBox": boundingBox
      ]
    }
}

extension FormXAPIExtractResult {
    func toMap() -> [String: Any] {
        return [
            "status": self.response.status,
            "metaData": self.response.metadata.toMap(),
            "documents": self.response.documents.map({ doc in
                return doc.toMap()
            })
        ]
    }
}

extension FormXAPIDetectDocumentsResult {
    func toMap() -> [String: Any] {
        return [
            "status": response.status,
            "documents": response.documents.map({ region in
                return [
                    "bbox": [
                        "left": region.bbox[0],
                        "top": region.bbox[1],
                        "right": region.bbox[2],
                        "bottom": region.bbox[3],
                    ],
                    "type": region.type,
                ]
            }),
        ]
    }
}

extension FormXError {
    
    func toMap() -> [String: Any] {
      return [
        "code": self.code,
        "message": self.message,
      ]
    }
}
