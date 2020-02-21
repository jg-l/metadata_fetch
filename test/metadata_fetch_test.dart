import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/src/parsers/parsers.dart';
import 'package:test/test.dart';

void main() {
  // TODO: Use a Mock Server for testing
  group('Metadata parsers', () {
    test('HTML', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(HTMLMetaParser(document).title);
      print(HTMLMetaParser(document).description);
      print(HTMLMetaParser(document).image);
    });

    test('OpenGraph Parser', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);
    });
    test('Faulty', () async {
      var url = 'https://google.ca';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);

      print(HTMLMetaParser(document).title);
      print(HTMLMetaParser(document).description);
      print(HTMLMetaParser(document).image);
    });
  });

  group('extract()', () {
    test('First Test', () async {
      var data = await extract('https://flutter.dev/');
      print(data);
      print(data.description);
      expect(data.toMap().isEmpty, false);
    });

    test('FB Test', () async {
      var data = await extract('https://facebook.com/');
      expect(data.toMap().isEmpty, false);
    });

    test('Unicode Test', () async {
      var data = await extract('https://www.jpf.go.jp/');
      expect(data.toMap().isEmpty, false);
    });

    test('Gooogle Test', () async {
      var data = await extract('https://google.ca');
      expect(data.toMap().isEmpty, false);
    });

    test('Invalid Url Test', () async {
      var data = await extract('https://google');
      expect(data == null, true);
    });
  });
}
