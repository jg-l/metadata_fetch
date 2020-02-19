import '../lib/metadata_fetch.dart';

void main() async {
  var data = await MetadataFetch.getMetadata('https://flutter.dev');
  print(data['title']);
  print(data['description']);
  if (data.containsKey('image')) {
    print(data['image']);
  }
}
