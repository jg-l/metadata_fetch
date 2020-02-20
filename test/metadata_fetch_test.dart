import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:test/test.dart';

void main() {
  test('First Test', () async {
    var data = await MetadataFetch.getMetadata("https://flutter.dev/");
    print(data);
    expect(data.isEmpty, false);
  });

  test('FB Test', () async {
    var data = await MetadataFetch.getMetadata("https://facebook.com/");
    print(data?["image"]);
    expect(data.isEmpty, false);
  });

  test('UTF8 Rune Test', () async {
    var data = await MetadataFetch.getMetadata("https://www.jpf.go.jp/");
    expect(data.isEmpty, false);
  });

  test('Gooogle Test', () async {
    var data = await MetadataFetch.getMetadata("https://google.ca");
    expect(data.isEmpty, false);
  });

  test('Invalid Url Test', () async {
    var data = await MetadataFetch.getMetadata("https://google");
    expect(data == null, true);
  });
}
