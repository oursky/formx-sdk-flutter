package ai.formx.mobile.sdk.formx_sdk_flutter

import ai.formx.mobile.sdk.ExtractDetailedData
import ai.formx.mobile.sdk.ExtractDetailedDataFieldValue
import ai.formx.mobile.sdk.ExtractDocument
import ai.formx.mobile.sdk.ExtractDocumentData
import ai.formx.mobile.sdk.ExtractDocumentMetaData
import ai.formx.mobile.sdk.ExtractMetaData
import ai.formx.mobile.sdk.FormXAPIDetectDocumentsResponse
import ai.formx.mobile.sdk.FormXAPIExtractResponse
import ai.formx.mobile.sdk.FormXAutoExtractionDoubleItem
import ai.formx.mobile.sdk.FormXAutoExtractionIntItem
import ai.formx.mobile.sdk.FormXAutoExtractionItem
import ai.formx.mobile.sdk.FormXAutoExtractionItemArray
import ai.formx.mobile.sdk.FormXAutoExtractionPurchaseInfoValueItem
import ai.formx.mobile.sdk.FormXAutoExtractionStringItem
import ai.formx.mobile.sdk.FormXAutoExtractionUnsupportedItem
import ai.formx.mobile.sdk.NestedFormXAutoExtractionItem

fun FormXAPIDetectDocumentsResponse.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("status", status)
        put("documents",
            documents.map {
                HashMap<String, Any>().apply {
                    put("type", it.type)
                    put("bbox", HashMap<String, Int>().apply {
                        put("left", it.bbox[0])
                        put("top", it.bbox[1])
                        put("right", it.bbox[2])
                        put("bottom", it.bbox[3])
                    })
                }
            }
        )
    }

fun FormXAPIExtractResponse.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("status", status)
        put("metaData", metaData.toMap())
        put("documents", documents.map {
            it.toMap()
        })
    }

fun ExtractMetaData.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("extractorId", extractorId)
        put("requestId", requestId)
        put("usage", usage)
        jobId?.let {
            put("jobId", it)
        }
    }

fun ExtractDocument.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("extractorId", extractorId)
        put("metaData", metaData.toMap())
        type?.let {

            put("type", it)
        }
        typeConfidence?.let {
            put("typeConfidence", it)
        }
        put("data", data.toMap())
        put("detailedData", detailedData.toMap())
        boundingBox?.let {
            put("boundingBox", it)
        }
    }

fun ExtractDocumentMetaData.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("extractorType", extractorType)
        put("pageNo", pageNo)
        put("sliceNo", sliceNo)
        put("orientation", orientation)
    }

fun FormXAutoExtractionItem.toMap(): HashMap<String, Any?> =
    HashMap<String, Any?>().also {
        it["type"] = this::class.java.simpleName
        when (this) {
            is FormXAutoExtractionDoubleItem -> it["value"] = this.value
            is FormXAutoExtractionIntItem -> it["value"] = this.value
            is FormXAutoExtractionItemArray -> it["value"] = value.map { v -> v.toMap() }

            is FormXAutoExtractionPurchaseInfoValueItem -> it["value"] =
                HashMap<String, Any?>().apply {
                    put("name", name)
                    put("amount", amount ?: 0.0)
                    put("discount", discount)
                    put("sku", sku)
                    put("quantity", quantity ?: 0)
                    put("unitPrice", unitPrice ?: 0.0)
                }

            is FormXAutoExtractionStringItem -> it["value"] = this.value
            is FormXAutoExtractionUnsupportedItem -> it["value"] = this.value
            is NestedFormXAutoExtractionItem -> {
                it["value"] = HashMap<String, Any?>().also { nestedMap ->
                    for (entry in value.entries) {
                        nestedMap[entry.key] = entry.value?.toMap()
                    }
                }
            }
        }
    }

fun ExtractDocumentData.toMap(): HashMap<String, Any?> =
    HashMap<String, Any?>().apply {
        put("fields", fields.map { field ->
            HashMap<String, Any?>().also { fieldMap ->
                fieldMap["name"] = field.name
                fieldMap["value"] = field.value?.toMap()
            }
        })
    }

fun ExtractDetailedDataFieldValue.toMap(): HashMap<String, Any?> =
    HashMap<String, Any?>().apply {
        put("extractedBy", extractedBy)
        put("confidence", confidence)
        put("valueType", valueType)
        put("value", value?.toMap())
    }

fun ExtractDetailedData.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("fields", fields.map {
            HashMap<String, Any>().apply {
                put("name", it.name)
                put("value", it.value.map { v ->
                    v?.toMap()
                })
            }
        })
    }


fun Error.toMap(): HashMap<String, Any> =
    HashMap<String, Any>().apply {
        put("code", code.name)
        put("message", message ?: "")
    }