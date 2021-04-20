/// The base class for implementing a parser

class MetadataKeys {
  static const title = 'title';
  static const description = 'description';
  static const image = 'image';
  static const url = 'url';
}

mixin BaseMetadataParser {
  String? title;
  String? description;
  String? image;
  String? url;

  Metadata parse() {
    return Metadata(
      title: title,
      description: description,
      image: image,
      url: url,
    );
  }
}

/// Container class for Metadata
class Metadata {
  String? title;
  String? description;
  String? image;
  String? url;

  Metadata({
    this.title,
    this.description,
    this.image,
    this.url,
  });

  bool get hasAllMetadata {
    return (title != null &&
        description != null &&
        image != null &&
        url != null);
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, String?> toMap() {
    return {
      MetadataKeys.title: title,
      MetadataKeys.description: description,
      MetadataKeys.image: image,
      MetadataKeys.url: url,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Metadata copyFrom(Metadata other) => copyWith(
        title: other.title,
        description: other.description,
        image: other.image,
        url: other.url,
      );

  Metadata merge(Metadata other) {
    title ??= other.title;
    description ??= other.description;
    image ??= other.image;
    url ??= other.url;
    return this;
  }

  Metadata copyWith({
    String? title,
    String? description,
    String? image,
    String? url,
  }) =>
      Metadata(
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        url: url ?? this.url,
      );

  static Metadata fromJson(Map<String, dynamic> json) {
    return Metadata(
      title: json[MetadataKeys.title],
      description: json[MetadataKeys.description],
      image: json[MetadataKeys.image],
      url: json[MetadataKeys.url],
    );
  }
}
