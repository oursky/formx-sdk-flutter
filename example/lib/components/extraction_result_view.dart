import 'package:flutter/material.dart';
import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';
import 'package:formx_sdk_flutter_example/components/extraction_item_view.dart';
import 'package:formx_sdk_flutter_example/components/extraction_key_value_view.dart';

class ExtractionResultView extends StatelessWidget {
  final FormXExtractionResult result;
  final List<ExtractDocument> _documents;

  ExtractionResultView(this.result, {super.key})
      : _documents = result.documents
            .where((item) => item is! FormXAutoExtractionUnsupportedValue)
            .toList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: _documents.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _documents[index]
                          .data
                          .fields
                          .map(
                            (field) => Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              )),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ExtractionKeyValueView(
                                  title: field.name,
                                  child: ExtractionItemView(item: field.value),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
