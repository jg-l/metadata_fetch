import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main() async {
  var url = 'https://flutter.dev';
  var response = await http.get(Uri.parse(url));
  var document = responseToDocument(response);

  var data = MetadataParser.parse(document);
  print(data);

  // Just Opengraph
  var og = MetadataParser.openGraph(document);
  print(og);

  var hm = MetadataParser.htmlMeta(document);
  print(hm);

  var js = MetadataParser.jsonLdSchema(document);
  print(js);

  var twitter = MetadataParser.twitterCard(document);
  print(twitter);
}
