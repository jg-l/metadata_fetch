import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/src/parsers/jsonld_parser.dart';
import 'package:metadata_fetch/src/parsers/parsers.dart';
import 'package:test/test.dart';

// TODO: Use a Mock Server for testing
// TODO: Improve testing
void main() {
  test('JSON Serialization', () async {
    final url = 'https://flutter.dev';
    final response = await http.get(Uri.parse(url));
    final document = MetadataFetch.responseToDocument(response);
    final data = MetadataParser.parse(document);
    print(data.toJson());
    expect(data.toJson().isNotEmpty, true);
  });

  test('Metadata Parser', () async {
    final url = 'https://flutter.dev';
    final response = await http.get(Uri.parse(url));
    final document = MetadataFetch.responseToDocument(response);

    final data = MetadataParser.parse(document);
    print(data);

    // Just Opengraph
    final og = MetadataParser.openGraph(document);
    print('OG $og');

    // Just Html
    final hm = MetadataParser.htmlMeta(document);
    print('Html $hm');

    // Just Json-ld schema
    final js = MetadataParser.jsonLdSchema(document);
    print('JSON $js');

    final twitter = MetadataParser.twitterCard(document);
    print('Twitter $twitter');
  });
  group('Metadata parsers', () {
    test('JSONLD', () async {
      final url = 'https://www.epicurious.com/';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD II', () async {
      final url =
          'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD III', () async {
      final url =
          'https://medium.com/@quicky316/install-flutter-sdk-on-windows-without-android-studio-102fdf567ce4';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });

    test('JSONLD IV', () async {
      final url = 'https://www.distilled.net/';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      // print(response.statusCode);

      print(JsonLdParser(document));
    });
    test('HTML', () async {
      final url = 'https://flutter.dev';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(HtmlMetaParser(document).title);
      print(HtmlMetaParser(document).description);
      print(HtmlMetaParser(document).image);
    });

    test('OpenGraph Parser', () async {
      final url = 'https://flutter.dev';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document));
      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);
    });

    test('OpenGraph Youtube Test', () async {
      String url = 'https://www.youtube.com/watch?v=0jz0GAFNNIo';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      print(OpenGraphParser(document));
      print(OpenGraphParser(document).title);
      Metadata data = OpenGraphParser(document).parse();
      expect(data.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(
          data.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');
    });

    test('TwitterCard Parser', () async {
      final url =
          'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(TwitterCardParser(document));
      print(TwitterCardParser(document).title);
      print(TwitterCardParser(document).description);
      print(TwitterCardParser(document).image);
      // Test the url
      print(TwitterCardParser(document).url);
    });

    test('Faulty', () async {
      final url = 'https://google.ca';
      final response = await http.get(Uri.parse(url));
      final document = MetadataFetch.responseToDocument(response);
      print(response.statusCode);

      print(OpenGraphParser(document).title);
      print(OpenGraphParser(document).description);
      print(OpenGraphParser(document).image);

      print(HtmlMetaParser(document).title);
      print(HtmlMetaParser(document).description);
      print(HtmlMetaParser(document).image);
    });
  });

  group('MetadataFetch.extract()', () {
    test('First Test', () async {
      final url = 'https://flutter.dev';
      final data = await MetadataFetch.extract(url);
      print(data);
      print(data?.description);
      print(data?.url);
      expect(data?.toMap().isEmpty, false);
      expect(data?.url, url + "/");
    });

    test('FB Test', () async {
      final data = await MetadataFetch.extract('https://facebook.com/');
      expect(data?.toMap().isEmpty, false);
    });

    test('Youtube Test', () async {
      Metadata? data = await MetadataFetch.extract(
          'https://www.youtube.com/watch?v=0jz0GAFNNIo');
      expect(data?.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(
          data?.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');
    });

    test('Unicode Test', () async {
      final data = await MetadataFetch.extract('https://www.jpf.go.jp/');
      expect(data?.toMap().isEmpty, false);
    });

    test('Gooogle Test', () async {
      final data = await MetadataFetch.extract('https://google.ca');
      expect(data?.toMap().isEmpty, false);
      expect(data?.title, 'google');
    });

    test('Invalid Url Test', () async {
      final data = await MetadataFetch.extract('https://google');
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
      // Provide a url to be used as a fallback, when no url metadata is extracted from the Document.
      // Useful for relative images
      var data = MetadataParser.parse(doc, url: 'https://example.com/some/');
      expect(data.image, equals('https://example.com/some/this/is/a/test.png'));
    });

    test(
        "MetadataParser.parse(doc) works without a doc.requestUrl (relative URLs are just not resolved)",
        () {
      final doc = html.parse(htmlPage);
      final data = MetadataParser.parse(doc);
      expect(data.image, equals('this/is/a/test.png'));
    });
  });
}
