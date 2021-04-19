import 'package:metadata_extract/metadata_extract.dart';

void main() async {
  var data = await extract('https://flutter.dev'); // returns a Metadata object
  print(data); // Metadata.toString()
  print(data!.title); // Metadata.title
  print(data.toMap()); // converts Metadata to map
  print(data.toJson()); // converts Metadata to JSON
}
