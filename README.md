# Country List with GraphQl

A project mainly used for testing the integration between flutter and graphQl

## Relevant versions

flutter 2.0.1 (stable channel)  
graphql_flutter 5.0.0  

### Commands:
flutter pub get  
flutter packages pub run build_runner build (actually not needed, because i don't included the .g.dart files on gitignore)  
flutter run (or run with your IDE)  

### Tests
There are two tests in the test file, but only one is working, the widgetTest seems not to be working well with the widgets i used (Scaffold/GraphQLprovider) (but the unit test is fine)
