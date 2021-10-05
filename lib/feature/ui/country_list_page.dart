import 'package:country_list/feature/entity/country_data.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountryListPage extends StatefulWidget {
  const CountryListPage({Key key}) : super(key: key);

  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  Map<String, String> filters = Map();

  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Country List GQL"),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  this._showFilterDialog();
                })
          ],
        ),
        body: Query(
          options: QueryOptions(
            document: gql(countryQuery(this.filters)),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (result.data == null ||
                (result.data['countries'] as List).isEmpty) {
              return Center(child: Text("No data found"));
            }

            List countries = result.data['countries'];
            return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  CountryData country = CountryData.fromJson(countries[index]);
                  return ListTile(
                    title: Row(
                      children: [
                        Text('(${country.code}) '),
                        Expanded(child: Text(country.name)),
                      ],
                    ),
                    subtitle: Row(children: [
                      Text('(${country.continent['code']}) '),
                      Text(country.continent['name']),
                    ]),
                    onTap: () {
                      this._showDetailDialog(country);
                    },
                  );
                });
          },
        ));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String filterType = "code";
        TextEditingController filterInput = TextEditingController();
        return AlertDialog(
          title: new Text("Search country by:"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio(
                        value: "code",
                        groupValue: filterType,
                        onChanged: (value) {
                          setState(() {
                            filterType = value;
                          });
                        }),
                    Text(" country code")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "currency",
                        groupValue: filterType,
                        onChanged: (value) {
                          setState(() {
                            filterType = value;
                          });
                        }),
                    Text(" currency code")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: "continent",
                        groupValue: filterType,
                        onChanged: (value) {
                          setState(() {
                            filterType = value;
                          });
                        }),
                    Text(" continent code")
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: filterInput,
                        decoration: InputDecoration(
                            labelText: 'Inform the country $filterType'),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
          actions: <Widget>[
            new OutlinedButton(
              child: new Text("Search"),
              onPressed: () {
                this.setState(() {
                  filters = <String, String>{
                    filterType:
                        filterInput.text.isNotEmpty ? filterInput.text : null
                  };
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(CountryData country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Country Details:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${country.name}", style: TextStyle(fontSize: 16)),
              Text("Code: ${country.code}", style: TextStyle(fontSize: 16)),
              Text("Currency: ${country.currency}",
                  style: TextStyle(fontSize: 16)),
              Text(
                  "Part of: ${country.continent['name']}(${country.continent['code']})",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16)),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Languages:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ..._drawnLanguages(country.languages)
            ],
          ),
          actions: <Widget>[
            new OutlinedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _drawnLanguages(List<Map<String, String>> languages) {
    if (languages != null && languages.isNotEmpty) {
      return languages
          .map((e) => Text(e['name'], style: TextStyle(fontSize: 16)))
          .toList();
    }
    return [Text("No info", style: TextStyle(fontSize: 16))];
  }
}
