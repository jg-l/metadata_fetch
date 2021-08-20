# Metadata Extract
A dart library for extracting metadata in web pages. Supports OpenGraph, Meta, Twitter Cards, and Structured Data (Json-LD)

This version was forked from the original [metadata_fetch](https://github.com/jg-l/metadata_fetch).


## Usage


### Extract Metadata for a given URL

```dart
import 'package:metadata_extract/metadata_extract.dart';

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

This method prioritizes Open Graph data, followed by Twitter Card, JSON-LD and finally falls back too HTML metadata.


```dart
import 'package:metadata_extract/metadata_extract.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Convert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.parse(document);
  print(data);


}

```

#### Get Open Graph Metadata

```dart
import 'package:metadata_extract/metadata_extract.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Convert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.OpenGraph(document);
  print(data);


}

```

#### Get Html Metadata
```dart
import 'package:metadata_extract/metadata_extract.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Convert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // get metadata
  var data = MetadataParser.HtmlMeta(document);
  print(data);
}
```

#### Get Structured Data (Json+LD)
```dart
import 'package:metadata_extract/metadata_extract.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://flutter.dev');

  // Convert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // Just Json-ld schema
  var data = MetadataParser.JsonLdSchema(document);
  print(data);
}
```

#### Get Twitter Cards Metadata 
```dart
import 'package:metadata_extract/metadata_extract.dart';
import 'package:http/http.dart' as http;

void main () async {

  // Makes a call
  var response = await http.get('https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article');

  // Convert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // Get Twitter Card metadata
  var data = MetadataParser.TwitterCard(document);
  print(data);
}
```






## Credit
This library is a fork of [https://github.com/jg-l/metadata_fetch](https://github.com/jg-l/metadata_fetch) which was inspired by 
[open_graph_parser](https://github.com/Patte1808/open_graph_parser). This fork has some minor bug fixes and has been
migrated to sound null-safety.

The name of the package has been changed to allow re-publishing on pub.dev.
