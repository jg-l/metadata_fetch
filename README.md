# Metadata Fetch
A dart library for extracting metadata in web pages. Supports OpenGraph, Meta, and Structured Data (Json-LD)


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

#### Get aggregated Metadata from a document


```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.parse(document);
  print(data);


}

```

#### Get Open Graph Metadata

```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.OpenGraph(document);
  print(data);


}

```

#### Get Html Metadata
```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.HtmlMeta(document);
  print(data);
}
```

#### Get Structured Data (Json+LD)
```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // Just Json-ld schema
  var data = MetadataParser.JsonLdSchema(document);
  print(data);
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

