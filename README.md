A library for extracing metadata on web pages.

- First, it checks if there are OpenGraph tags present
- If there are missing metadata, it will parse for html `<meta>` and `<title>` tags
- If none are found, a `Map` will return the url as a `title` and a `null` as `description`.


## Usage


Using this library is very simple.

```dart
import 'package:metadata_fetch/metadata_fetch.dart';

main() async {
  var data = await MetadataFetch.getMetadata(
        "https://flutter.dev/");
  // data will always have a title and description, sometimes an image
  print(data['title'])
  print(data['description'])
  print(data['image'])
}
```

## Credit
This library is inspired by[open_graph_parser](https://github.com/Patte1808/open_graph_parser). 
However this one tries to be more general.


## Roadmap
- Implement json-ld parser for schema metadata.


## Bugs
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
