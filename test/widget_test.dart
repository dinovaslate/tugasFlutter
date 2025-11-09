import 'package:flutter_test/flutter_test.dart';

import 'package:tugas_7/main.dart';

void main() {
  testWidgets('Home page renders dashboard title', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Football Shop Dashboard'), findsOneWidget);
    expect(find.text('Tambah Produk'), findsOneWidget);
  });
}
