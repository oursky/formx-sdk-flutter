sealed class FormXAutoExtractionItem {}

class FormXAutoExtractionPurchaseInfoValueItem extends FormXAutoExtractionItem {
  final String name;
  final double amount;
  final String discount;
  final String sku;
  final int quantity;
  final double unitPrice;
  FormXAutoExtractionPurchaseInfoValueItem(Map<Object?, Object?> json)
      : name = json["name"] as String? ?? "",
        amount = json["amount"] as double? ?? 0.0,
        discount = json["discount"] as String? ?? "",
        sku = json["sku"] as String? ?? "",
        quantity = json["quantity"] as int? ?? 0,
        unitPrice = json["unitPrice"] as double? ?? 0.0;
}

/// Extraction structure of a single integer value
class FormXAutoExtractionIntItem extends FormXAutoExtractionItem {
  final int value;
  FormXAutoExtractionIntItem(Map<Object?, Object?> json)
      : value = json["value"] as int;
}

class FormXAutoExtractionDoubleValue extends FormXAutoExtractionItem {
  final double value;
  FormXAutoExtractionDoubleValue(Map<Object?, Object?> json)
      : value = json["value"] as double;
}

class FormXAutoExtractionItemArray extends FormXAutoExtractionItem {
  final List<FormXAutoExtractionItem> value;
  FormXAutoExtractionItemArray(Map<Object?, Object?> json)
      : value = (json["value"] as List<Object?>)
            .map((obj) =>
                parseFormXAutoExtractionItem(obj as Map<Object?, Object?>))
            .toList();
}

class NestedFormXAutoExtractionItem extends FormXAutoExtractionItem {
  final Map<String, FormXAutoExtractionItem?> value;
  NestedFormXAutoExtractionItem(Map<Object?, Object?> json)
      : value = json.map((key, value) => MapEntry(
            key as String,
            value == null
                ? null
                : parseFormXAutoExtractionItem(
                    value as Map<Object?, Object?>)));
}

/// An auto extracted string value
class FormXAutoExtractionStringItem extends FormXAutoExtractionItem {
  final String value;
  FormXAutoExtractionStringItem(Map<Object?, Object?> json)
      : value = json["value"] as String;
}

/// An unknown extracted value
class FormXAutoExtractionUnsupportedValue extends FormXAutoExtractionItem {
  final String? value;
  FormXAutoExtractionUnsupportedValue(Map<Object?, Object?> json)
      : value = json["value"] as String?;
}

FormXAutoExtractionItem parseFormXAutoExtractionItem(
    Map<Object?, Object?> json) {
  switch (json["type"] as String) {
    case "FormXAutoExtractionIntItem":
      return FormXAutoExtractionIntItem(json);
    case "FormXAutoExtractionDoubleItem":
      return FormXAutoExtractionDoubleValue(json);
    case "FormXAutoExtractionStringItem":
      return FormXAutoExtractionStringItem(json);
    case "FormXAutoExtractionItemArray":
      return FormXAutoExtractionItemArray(json);
    case "NestedFormXAutoExtractionItem":
      return NestedFormXAutoExtractionItem(
          json["value"] as Map<Object?, Object?>);
    case "FormXAutoExtractionPurchaseInfoValueItem":
      return FormXAutoExtractionPurchaseInfoValueItem(
          json["value"] as Map<Object?, Object?>);
    default:
      return FormXAutoExtractionUnsupportedValue(json);
  }
}
