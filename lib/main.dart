import 'package:country_list/feature/ui/country_list_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink("https://countries.trevorblades.com/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
            link: httpLink, cache: GraphQLCache(store: InMemoryStore())));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Experiment FGQL",
      home: GraphQLProvider(
        child: CountryListPage(),
        client: client,
      ),
    );
  }
}
