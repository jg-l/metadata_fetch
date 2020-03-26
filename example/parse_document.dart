import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;

void main() async {
  var url = 'https://flutter.dev';
  var response = await http.get(url);
  var document = responseToDocument(response);

  var data = MetadataParser.parse(document);
  print(data);

  // Just Opengraph
  var og = MetadataParser.OpenGraph(document);
  print(og);

  var hm = MetadataParser.HtmlMeta(document);
  print(hm);

  var js = MetadataParser.JsonLdSchema(document);
  print(js);

  var twitter = MetadataParser.TwitterCard(document);
  print(twitter);
}
