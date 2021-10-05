import 'package:country_list/feature/ui/country_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

class MockGraphQLClient extends Mock implements GraphQLClient {}

final jsonCountry = """{"countries": [
            {
                "code": "BR",
                "name": "Brazil",
                "emoji": "🇧🇷",
                "continent": {
                    "name": "South America",
                    "code": "SA"
                },
                "languages": [
                    {
                        "name": "Portuguese"
                    }
                ]
            }
        ]}""";

final countryQuery = (filters) => """
  query {
    countries ${filters != null ? (filters['currency'] != null ? '(filter: { currency: {eq: "${filters['currency']}"}})' : filters['code'] != null ? ('(filter: { code: {eq: "${filters['code']}"}})') : filters['continent'] != null ? ('(filter: { continent: {eq: "${filters['continent']}"}})') : '') : ''}{
      code
      name
      currency
      continent {
        code
        name
      }
      languages {
        name
      }
    }
  }
  """;

void main() {
  MockGraphQLClient mockClient;
  final defaultOptions = QueryOptions(document: gql(countryQuery(null)));
  setUp(() {
    mockClient = MockGraphQLClient();
  });
  group('GraphQl Integration tests', () {
    testWidgets('List countries and detail one', (WidgetTester tester) async {
      // NOT WORKING
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Experiment FGQL",
        home: GraphQLProvider(
          child: CountryListPage(),
          client: ValueNotifier(mockClient),
        ),
      ));

      // await tester.tap(find.byElementType(ListTile));
      // await tester.pump();

      expect(find.text('NOT_A_COUNTRY'), findsNothing);
      expect(find.text('BR'), findsOneWidget);
    });
    test('should preform a query', () async {
      when(
        mockClient.query(defaultOptions),
      ).thenAnswer((_) async => QueryResult(data: json.decode(jsonCountry)));

      await mockClient.query(defaultOptions);

      verify(mockClient.query(
        defaultOptions,
      ));
    });
  });
}
