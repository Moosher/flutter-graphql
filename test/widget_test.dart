import 'package:country_list/feature/ui/country_list_page.dart';
import 'package:country_list/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'http_mock.mocks.dart';

void main() {
  group('Test GQL', () {
    MockClient mockHttpClient;
    HttpLink httpLink;
    ValueNotifier<GraphQLClient> client;

    setUp(() async {
      mockHttpClient = MockClient();
      httpLink = HttpLink('https://countries.trevorblades.com/graphql',
          httpClient: mockHttpClient);
      client = ValueNotifier(
        GraphQLClient(
          cache: GraphQLCache(store: InMemoryStore()),
          link: httpLink,
        ),
      );
    });
    testWidgets('List countries and detail one', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Experiment FGQL",
        home: GraphQLProvider(
          child: CountryListPage(),
          client: client,
        ),
      ));

      await tester.tap(find.byElementType(ListTile));
      await tester.pump();

      expect(find.text('NOT_A_COUNTRY'), findsNothing);
      expect(find.text('BR'), findsOneWidget);
    });
  });
}
