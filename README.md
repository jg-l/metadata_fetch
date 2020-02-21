# Metadata Fetch
A dart library for extracting metadata on web pages such as OpenGraph, Meta, and soon, Twitter-Cards and json-LD Schemas.


## Usage


### Extract Metadata for a given URL

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  var data = extract("https://flutter.dev/"); // Use the extract() function to fetch data from the url

  print(data.title) // Flutter - Beautiful native apps in record time

  print(data.description) // Flutter is Google's UI toolkit for crafting beautiful...

  print(data.image) // https://flutter.dev/images/flutter-logo-sharing.png

  var dataAsMap = data.toMap();

}
```

### Parsing Manually

#### OpenGraphParser and HTMLMetaParser

```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // Get OpenGraph Metadata
  var og_data = OpenGraphParser(document);

  // Get HTML metadata
  var html_data = HTMLMetaParser(document);

  // Do work with the data
  print(og_data.title)
  print(html_data.title)

}

```

### No Errors, Only Nulls

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  var data = await extract("https://invalid*broken_url/");
  print(data) // null
}
```



## Credit
This library is inspired by [open_graph_parser](https://github.com/Patte1808/open_graph_parser). 
However this one tries to be more general.


## Roadmap
- Improve Documentation
- Implement json-ld parser for schema metadata.


## Questions, Bugs, and Feature Requests
Please forward all queries about this project to the [issue tracker](https://github.com/jg-l/metadata_fetch/issues).

