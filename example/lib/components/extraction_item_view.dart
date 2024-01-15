import 'package:flutter/material.dart';
import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';
import 'package:formx_sdk_flutter_example/components/extraction_key_value_view.dart';

class ExtractionItemView extends StatelessWidget {
  final FormXAutoExtractionItem? item;
  const ExtractionItemView({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    switch (item) {
      case FormXAutoExtractionIntItem(value: var value):
        return Text(value.toString());
      case FormXAutoExtractionDoubleValue(value: var value):
        return Text(value.toString());
      case FormXAutoExtractionStringItem(value: var value):
        return Text(value.toString());
      case FormXAutoExtractionItemArray(value: var value):
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: value.map((v) => ExtractionItemView(item: v)).toList(),
          ),
        );
      case NestedFormXAutoExtractionItem(value: var value):
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: value.entries
                .map((entry) => ExtractionKeyValueView(
                    title: entry.key,
                    child: ExtractionItemView(
                      item: entry.value,
                    )))
                .toList(),
          ),
        );
      case FormXAutoExtractionPurchaseInfoValueItem(
          name: var name,
          sku: var sku,
          amount: var amount,
          discount: var discount,
          quantity: var quantity,
          unitPrice: var unitPrice,
        ):
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExtractionKeyValueView(title: "Name", child: Text(name)),
              ExtractionKeyValueView(title: "Sku", child: Text(sku)),
              ExtractionKeyValueView(
                  title: "Amount", child: Text(amount.toString())),
              ExtractionKeyValueView(
                  title: "Discount", child: Text(discount.toString())),
              ExtractionKeyValueView(
                  title: "Quantity", child: Text(quantity.toString())),
              ExtractionKeyValueView(
                  title: "Unit Price", child: Text(unitPrice.toString())),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
