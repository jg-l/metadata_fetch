import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:metadata_fetch/src/metadata.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('Metadata ', () {
    test('HTML', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(HTMLMeta(document).getTitle());
      print(HTMLMeta(document).getDescription());
      print(HTMLMeta(document).getImage());
    });

    test('OpenGraph', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document).getTitle());
    });
  });

  group('MetadataFetch.extract()', () {
    test('First Test', () async {
      var data = await MetadataFetch.extract("https://flutter.dev/");
      print(data);
      expect(data.isEmpty, false);
    });

    test('FB Test', () async {
      var data = await MetadataFetch.extract("https://facebook.com/");
      print(data);
      expect(data.isEmpty, false);
    });

    test('Unicode Test', () async {
      var data = await MetadataFetch.extract("https://www.jpf.go.jp/");
      print(data);
      expect(data.isEmpty, false);
    });

    test('Gooogle Test', () async {
      var data = await MetadataFetch.extract("https://google.ca");
      print(data);
      expect(data.isEmpty, false);
    });

    test('Invalid Url Test', () async {
      var data = await MetadataFetch.extract("https://google");
      print(data);
      expect(data == null, true);
    });
  });
}
