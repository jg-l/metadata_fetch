import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/src/parsers/jsonld_parser.dart';
import 'package:metadata_fetch/src/parsers/parsers.dart';
import 'package:metadata_fetch/src/utils/util.dart';
import 'package:test/test.dart';

// TODO: Use a Mock Server for testing
// TODO: Improve testing
void main() {
  test('JSON Serialization', () async {
    var url = 'https://flutter.dev';
    var response = await http.get(url);
    var document = responseToDocument(response);
    var data = MetadataParser.parse(document);
    print(data.toJson());
    expect(data.toJson().isNotEmpty, true);
  });

  test('Metadata Parser', () async {
    var url = 'https://flutter.dev';
    var response = await http.get(url);
    var document = responseToDocument(response);

    var data = MetadataParser.parse(document);
    print(data);

    // Just Opengraph
    var og = MetadataParser.openGraph(document);
    print('OG $og');

    // Just Html
    var hm = MetadataParser.htmlMeta(document);
    print('Html $hm');

    // Just Json-ld schema
    var js = MetadataParser.jsonLdSchema(document);
    print('JSON $js');

    var twitter = MetadataParser.twitterCard(document);
    print('Twitter $twitter');
  });
  group('Metadata parsers', () {
    test('JSONLD', () async {
      var url = 'https://www.epicurious.com/';
      var response = await http.get(url);
      var document = responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD II', () async {
      var url =
          'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      var response = await http.get(url);
      var document = responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD III', () async {
      var url =
          'https://medium.com/@quicky316/install-flutter-sdk-on-windows-without-android-studio-102fdf567ce4';
      var response = await http.get(url);
      var document = responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD IV', () async {
      var url = 'https://www.distilled.net/';
      var response = await http.get(url);
      var document = responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });
    test('HTML', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(HtmlMetaParser(document).title);
      print(HtmlMetaParser(document).description);
      print(HtmlMetaParser(document).image);
    });

    test('OpenGraph Parser', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document));
      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);
    });

    test('OpenGraph Youtube Test', () async {
      String url = 'https://www.youtube.com/watch?v=0jz0GAFNNIo';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(OpenGraphParser(document));
      print(OpenGraphParser(document).title);
      Metadata data = OpenGraphParser(document).parse();
      expect(data.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(
          data.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');
    });

    test('TwitterCard Parser', () async {
      var url =
          'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(TwitterCardParser(document));
      print(TwitterCardParser(document).title);
      print(TwitterCardParser(document).description);
      print(TwitterCardParser(document).image);
      // Test the url
      print(TwitterCardParser(document).url);
    });

    test('Faulty', () async {
      var url = 'https://google.ca';
      var response = await http.get(url);
      var document = responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);

      print(HtmlMetaParser(document).title);
      print(HtmlMetaParser(document).description);
      print(HtmlMetaParser(document).image);
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

    test('Youtube Test', () async {
      Metadata data =
          await extract('https://www.youtube.com/watch?v=0jz0GAFNNIo');
      expect(data.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(
          data.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');
    });

    test('Unicode Test', () async {
      var data = await extract('https://www.jpf.go.jp/');
      expect(data.toMap().isEmpty, false);
    });

    test('Gooogle Test', () async {
      var data = await extract('https://google.ca');
      expect(data.toMap().isEmpty, false);
      expect(data.title, 'google');
    });

    test('Invalid Url Test', () async {
      var data = await extract('https://google');
      expect(data == null, true);
    });

    final htmlPage = '''
<html>
  <head>
    <title>Test</title>
  </head>
  <body>
    <img src="this/is/a/test.png" />
  </body>
<html>
        ''';

    test(
        "Image url without slash at beginning still results in valid url when falling back to html parser",
        () {
      final doc = html.parse(htmlPage);
      doc.requestUrl = 'https://example.com/some/page.html';
      var data = MetadataParser.parse(doc);
      expect(data.image, equals('https://example.com/some/this/is/a/test.png'));
    });

    test(
        "MetadataParser.parse(doc) works without a doc.requestUrl (relative URLs are just not resolved)",
        () {
      final doc = html.parse(htmlPage);
      // XXX: This is sadly needed because doc.requestUrl is a global shared for
      // all Document instances, so the value parsed in previous tests is
      // still present.
      doc.requestUrl = null;
      var data = MetadataParser.parse(doc);
      expect(data.image, equals('this/is/a/test.png'));
    });
  });
}
