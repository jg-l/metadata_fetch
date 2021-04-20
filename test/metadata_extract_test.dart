import 'package:metadata_extract/metadata_extract.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

import 'package:metadata_extract/src/utils/util.dart';
import 'package:test/test.dart';

// TODO: Use a Mock Server for testing
// TODO: Improve testing
void main() {
  test('JSON Serialization', () async {
    var url = 'https://flutter.dev';
    var response = await http.get(Uri.parse(url));
    var document = responseToDocument(response);
    var data = MetadataParser.parse(document);
    expect(data.toJson(), hasStringValue);
    expect(data.title, hasStringValue);
    expect(data.description, hasStringValue);
    expect(data.url, hasStringValue);
    expect(data.image, hasStringValue);
  });

  group('Metadata Parser', () {
    var url = 'https://flutter.dev';
    dynamic document;

    setUp(() async {
      var response = await http.get(Uri.parse(url));
      document = responseToDocument(response);
    });

    test('parse', () {
      var data = MetadataParser.parse(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, hasStringValue);
      expect(data.image, hasStringValue);
    });

    test('openGraph', () {
      // Just Opengraph
      var og = MetadataParser.openGraph(document);
      expect(og.title, hasStringValue);
      expect(og.description, hasStringValue);
      expect(og.url, hasStringValue);
      expect(og.image, hasStringValue);
    });

    test('htmlMeta', () {
      // Just Html
      var hm = MetadataParser.htmlMeta(document);
      expect(hm.title, hasStringValue);
      expect(hm.description, isNull);
      expect(hm.url, hasStringValue);
      expect(hm.image, hasStringValue);
    });

    test('jsonLdSchema', () {
      // Just Json-ld schema
      var js = MetadataParser.jsonLdSchema(document);
      expect(js.title, isNull);
      expect(js.description, isNull);
      expect(js.url, hasStringValue);
      expect(js.image, isNull);
    });

    test('twitterCard', () {
      var twitter = MetadataParser.twitterCard(document);
      expect(twitter.title, isNull);
      expect(twitter.description, isNull);
      expect(twitter.url, hasStringValue);
      expect(twitter.image, isNull);
    });
  });

  group('Metadata parsers', () {
    test('JSONLD', () async {
      var url = 'https://www.epicurious.com/';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);
      // print(response.statusCode);

      final data = JsonLdParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, hasStringValue);
      expect(data.image, isNull);
    });

    test('JSONLD II', () async {
      var url = 'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);
      // print(response.statusCode);

      final data = JsonLdParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });

    test('JSONLD III', () async {
      var url =
          'https://medium.com/@quicky316/install-flutter-sdk-on-windows-without-android-studio-102fdf567ce4';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);
      // print(response.statusCode);

      final data = JsonLdParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });

    test('JSONLD IV', () async {
      var url = 'https://www.distilled.net/';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);
      // print(response.statusCode);

      var data = JsonLdParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, isNull);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });
    test('HTML', () async {
      var url = 'https://flutter.dev';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);

      final data = HtmlMetaParser(document);

      expect(data.title, hasStringValue);
      expect(data.description, isNull);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });

    test('OpenGraph Parser', () async {
      var url = 'https://flutter.dev/';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);

      var data = OpenGraphParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });

    test('OpenGraph Youtube Test', () async {
      String url = 'https://www.youtube.com/watch?v=0jz0GAFNNIo';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);

      final data = OpenGraphParser(document);
      expect(data.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(data.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');
      expect(data.description, hasStringValue);
      expect(data.url, url);
    });

    test('TwitterCard Parser', () async {
      var url = 'https://www.epicurious.com/expert-advice/best-soy-sauce-chefs-pick-article';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);

      final data = TwitterCardParser(document);
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, url);
      expect(data.image, isNull);
    });

    test('Faulty', () async {
      var url = 'https://google.ca';
      var response = await http.get(Uri.parse(url));
      var document = responseToDocument(response);

      final og = OpenGraphParser(document);
      expect(og.title, isNull);
      expect(og.description, isNull);
      expect(og.url, isNull);
      expect(og.image, isNull);

      final hm = HtmlMetaParser(document);
      expect(hm.title, isNull);
      expect(hm.description, isNull);
      expect(hm.url, isNull);
      expect(hm.image, isNull);
    });
  });

  group('extract()', () {
    test('First Test', () async {
      final url = 'https://flutter.dev/';
      var data = await extract(url);
      expect(data!.toMap(), isNot(isEmpty));
      expect(data.title, hasStringValue);
      expect(data.description, hasStringValue);
      expect(data.url, url);
      expect(data.image, hasStringValue);
    });

    test('FB Test', () async {
      var data = await extract('https://facebook.com/');
      expect(data!.toMap(), isNot(isEmpty));
      expect(data.title, hasStringValue);
      expect(data.description, isNull);
      expect(data.url, hasStringValue);
      expect(data.image, hasStringValue);
    });

    test('Youtube Test', () async {
      Metadata? data = await extract('https://www.youtube.com/watch?v=0jz0GAFNNIo');
      expect(data!.title, 'Drake - When To Say When & Chicago Freestyle');
      expect(data.image, 'https://i.ytimg.com/vi/0jz0GAFNNIo/maxresdefault.jpg');

      expect(data.description, hasStringValue);
      expect(data.url, hasStringValue);
    });

    test('Unicode Test', () async {
      var data = await extract('https://www.jpf.go.jp/');
      expect(data!.toMap(), isNot(isEmpty));
      expect(data.title, hasStringValue);
      expect(data.description, isNull);
      expect(data.url, hasStringValue);
      expect(data.image, hasStringValue);
    });

    test('Gooogle Test', () async {
      var data = await extract('https://google.ca');
      expect(data!.toMap(), isNot(isEmpty));
      expect(data.title, 'google');
      expect(data.description, hasStringValue);
      expect(data.url, isNull);
      expect(data.image, isNull);
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
      expect(data.title, 'Test');
      expect(data.description, isNull);
      expect(data.url, hasStringValue);
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
      expect(data.title, 'Test');
      expect(data.description, isNull);
      expect(data.url, isNull);
    });
  });

  group('full urls', () {
    final parserTypes = {
      OpenGraphParser: (doc) => OpenGraphParser(doc),
      JsonLdParser: (doc) => JsonLdParser(doc),
      HtmlMetaParser: (doc) => HtmlMetaParser(doc),
      TwitterCardParser: (doc) => TwitterCardParser(doc),
    };

    const urls = <String>[
      'https://www.sonder.com/destinations/new_orleans/Sonder-Constance-Lofts-Desirable-1BR-Gym/c19723',
      'https://abnb.me/z16mAG6UAfb',
      // TODO(safarmer): support Airbnb link previews.
      // 'https://www.airbnb.com.au/rooms/15549396',
    ];

    for (var url in urls) {
      group(url, () {
        test('extract', () async {
          final data = await extract(url);
          expect(data, isNotNull);
          expect(data!.url, url);
        });

        for (var type in parserTypes.keys) {
          final parser = parserTypes[type]!;

          test(type.toString(), () async {
            final response = await http.get(Uri.parse(url));
            var document = responseToDocument(response);
            final data = parser(document);
            print(data);
          });
        }
      });
    }
  });
}

class HasStringValue extends CustomMatcher {
  HasStringValue()
      : super('String is not empty or the value \'null\'', 'string',
            allOf(isNotNull, isNotEmpty, isNot(contains('null'))));
}

final hasStringValue = HasStringValue();
