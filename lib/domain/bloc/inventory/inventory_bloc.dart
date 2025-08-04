import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/models/restocking_request.dart';
import 'package:dukascango/domain/services/inventory_services.dart';
import 'package:dukascango/domain/services/products_services.dart';
import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ProductsServices _productsServices = ProductsServices();
  final InventoryServices _inventoryServices = InventoryServices();

  InventoryBloc() : super(const InventoryInitial()) {
    on<OnBulkUploadFileEvent>(_onBulkUploadFile);
    on<OnGetRestockingRequestsEvent>(_onGetRestockingRequests);
  }

  Future<void> _onGetRestockingRequests(
      OnGetRestockingRequestsEvent event, Emitter<InventoryState> emit) async {
    try {
      emit(InventoryLoading());
      final requests = await _inventoryServices.getRestockingRequests();
      emit(state.copyWith(restockingRequests: requests));
    } catch (e) {
      emit(InventoryFailure(e.toString()));
    }
  }

  Future<void> _onBulkUploadFile(
      OnBulkUploadFileEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      final List<List<dynamic>> rows =
          const CsvToListConverter().convert(event.csvString);

      if (rows.isEmpty) {
        emit(InventoryFailure('CSV file is empty.'));
        return;
      }

      final header = rows[0];
      final products = <Product>[];
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length != header.length) {
          errors.add('Row ${i + 1}: Invalid number of columns.');
          continue;
        }
        try {
          final product = Product(
            name: row[header.indexOf('name')],
            description: row[header.indexOf('description')],
            price: double.parse(row[header.indexOf('price')].toString()),
            barcode: row[header.indexOf('barcode')].toString(),
            costPrice: row[header.indexOf('costPrice')] != null ? double.parse(row[header.indexOf('costPrice')].toString()) : null,
            stockQuantity: row[header.indexOf('stockQuantity')] != null ? int.parse(row[header.indexOf('stockQuantity')].toString()) : null,
            supplier: row[header.indexOf('supplier')]?.toString(),
            taxRate: row[header.indexOf('taxRate')] != null ? double.parse(row[header.indexOf('taxRate')].toString()) : null,
            lowStockThreshold: row[header.indexOf('lowStockThreshold')] != null ? int.parse(row[header.indexOf('lowStockThreshold')].toString()) : null,
            images: [],
            category: 'default',
          );
          products.add(product);
        } catch (e) {
          errors.add('Row ${i + 1}: ${e.toString()}');
        }
      }

      if (products.isNotEmpty) {
        final result = await _productsServices.bulkUpdateProducts(products);
        emit(InventorySuccess(
          successCount: result['successCount'],
          failureCount: result['failureCount'] + errors.length,
          errors: [...result['errors'], ...errors],
        ));
      } else {
        emit(InventoryFailure('No valid products found in the file.'));
      }
    } catch (e) {
      emit(InventoryFailure(e.toString()));
    }
  }
}
