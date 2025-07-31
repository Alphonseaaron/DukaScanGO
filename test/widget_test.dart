import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/bottom_navigation_dukascango.dart';
import 'package:dukascango/presentation/screens/client/self_scan/product_scan_screen.dart';
import 'package:dukascango/presentation/screens/admin/products/add_new_product_screen.dart';
import 'package:dukascango/presentation/components/form_field_dukascango.dart';

void main() {
  group('BottomNavigationDukascango', () {
    testWidgets('renders Scan & Go button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationDukascango(2),
          ),
        ),
      );

      expect(find.text('Scan & Go'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });
  });

  group('ProductScanScreen', () {
    testWidgets('renders manual entry button and footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => SelfScanBloc()),
          ],
          child: MaterialApp(
            home: ProductScanScreen(),
          ),
        ),
      );

      expect(find.text('Enter Manually'), findsOneWidget);
      expect(find.text('View Cart & Checkout'), findsOneWidget);
    });
  });

  group('AddNewProductScreen', () {
    testWidgets('renders scan barcode button and barcode field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductsBloc()),
          ],
          child: MaterialApp(
            home: AddNewProductScreen(),
          ),
        ),
      );

      expect(find.text('Scan Barcode'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        if (widget is FormFieldDukascango) {
          return widget.hintText == 'Barcode';
        }
        return false;
      }), findsOneWidget);
    });
  });
}
