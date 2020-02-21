import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:test/test.dart';

void main() {
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
}
