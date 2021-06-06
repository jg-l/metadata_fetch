# Metadata Fetch
A dart library for extracting metadata in web pages. Supports OpenGraph, Meta, Twitter Cards, and Structured Data (Json-LD)

Available on Pub Dev:
[Pub](https://pub.dev/packages/metadata_fetch)

## Metadata Structure

```yaml
Metadata:
  - title
  - description
  - image
  - url
```

## Usage


### Extract Metadata for a given URL

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  final myURL = 'https://flutter.dev';

  // Use the `MetadataFetch.extract()` function to fetch data from the url
  var data = await MetadataFetch.extract(myURL); 

  print(data.title) // Flutter - Beautiful native apps in record time

  print(data.description) // Flutter is Google's UI toolkit for crafting beautiful...

  print(data.image) // https://flutter.dev/images/flutter-logo-sharing.png

  print(data.url) // https://flutter.dev/

  var dataAsMap = data.toMap();


}
```

### Parsing Manually

#### Get aggregated Metadata from a document

This method prioritizes Open Graph data, followed by Twitter Card, JSON-LD and finally falls back to HTML metadata.


```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  final myURL = 'https://flutter.dev';

  // makes a call
  var response = await http.get(myURL);

  // Covert Response to a Document. The utility function `MetadataFetch.responseToDocument` is provided or you can use own decoder/parser.
  var document = MetadataFetch.responseToDocument(response);


  // get aggregated metadata
  var data = MetadataParser.parse(document);
  print(data);


}

```

#### Manually specify which Metadata parser to use

```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  final myURL = 'https://flutter.dev';

  // Makes a call
  var response = await http.get(myURL);

  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  var document = responseToDocument(response);


  // Get OpenGraph Metadata
  var ogData = MetadataParser.OpenGraph(document);
  print(ogData);

  // Get Html metadata
  var htmlData = MetadataParser.HtmlMeta(document);
  print(htmlData);

  // Get Structured Data
  var structuredData = MetadataParser.JsonLdSchema(document);
  print(structuredData);

  // Get Twitter Cards Data
  var  twitterCardData = MetadataParser.TwitterCard(document);
  print(twitterCardData);

}
```

#### Provide a fallback url when manually parsing

If the parsers cannot extract a URL from the document, you may optionally provide a URL in `MetadataFetch.parse()`. 

This URL will be added in the final `Metadata` structure, and is used to resolve images with relative URLs (non-absolute URLs).

```dart
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main () async {

  final myURL = 'https://flutter.dev';

  // makes a call
  var response = await http.get(myURL);

  // Covert Response to a Document. The utility function `MetadataFetch.responseToDocument` is provided or you can use own decoder/parser.
  var document = MetadataFetch.responseToDocument(response);


  // get aggregated metadata, supplying a fallback URL
  // Used for images with relative URLs
  var data = MetadataParser.parse(document, url:myURL);
  print(data);

}

```







## Credit
This library is inspired by [open_graph_parser](https://github.com/Patte1808/open_graph_parser). 
However this one tries to be more general.


## Roadmap
- Weighted or Preferred Metadata. Can assign custom weights for each parser to provide a fallback priority sytem
- Improve Documentation


## Questions, Bugs, and Feature Requests
Please forward all queries about this project to the [issue tracker](https://github.com/jg-l/metadata_fetch/issues).

