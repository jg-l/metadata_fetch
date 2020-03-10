/// The base class for implementing a parser
abstract class BaseMetadataParser {
  String title;
  String description;
  String image;
  String url;

  Metadata parse() {
    var m = Metadata();
    m.title = title;
    m.description = description;
    m.image = image;
    m.url = url;

    return m;
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'url': url,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

/// Container class for Metadata
class Metadata extends BaseMetadataParser {}
