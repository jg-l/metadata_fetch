# Metadata Fetch
A dart library for extracting metadata on web pages such as OpenGraph, Meta, and soon, Twitter-Cards and json+LD Schemas.


## Usage

### Fetch Metadata for a given URL

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  var data = await MetadataFetch.getMetadata("https://flutter.dev/");

  print(data['title']) // Flutter - Beautiful native apps in record time
  print(data['description'])
  print(data['image']) // https://flutter.dev/images/flutter-logo-sharing.png
}
```

### Bad URL

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  var data = await MetadataFetch.getMetadata("https://broken/");

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

