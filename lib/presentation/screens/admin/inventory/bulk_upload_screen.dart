import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/inventory/inventory_bloc.dart';
import 'package:dukascango/presentation/components/components.dart';

class BulkUploadScreen extends StatefulWidget {
  @override
  _BulkUploadScreenState createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  void _showTemplate() {
    final headers = [
      'name',
      'description',
      'price',
      'barcode',
      'costPrice',
      'stockQuantity',
      'supplier',
      'taxRate',
      'lowStockThreshold'
    ];
    final csv = headers.join(',');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CSV Template'),
        content: Text(csv),
        actions: [
          TextButton(
            child: const Text('Copy'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csv));
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null) {
      final bytes = result.files.single.bytes!;
      final csvString = utf8.decode(bytes);
      BlocProvider.of<InventoryBloc>(context)
          .add(OnBulkUploadFileEvent(csvString));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Bulk Inventory Upload'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BtnDukascango(
              text: 'Show Template',
              onPressed: _showTemplate,
            ),
            const SizedBox(height: 20),
            BtnDukascango(
              text: 'Upload File',
              onPressed: _uploadFile,
            ),
            const SizedBox(height: 20),
            const TextCustom(
                text: 'Import Results',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is InventoryFailure) {
                    return Text(state.error,
                        style: const TextStyle(color: Colors.red));
                  }
                  if (state is InventorySuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Success: ${state.successCount} rows'),
                        Text('Failed: ${state.failureCount} rows'),
                        const SizedBox(height: 10),
                        if (state.errors.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.errors.length,
                              itemBuilder: (context, index) => Text(
                                  state.errors[index],
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          ),
                      ],
                    );
                  }
                  return const Text('No file uploaded yet.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
