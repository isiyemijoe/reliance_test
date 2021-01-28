class Provider {
  int id;
  String name;
  String description;
  int rating;
  String address;
  String activeStatus;
  ProviderType providerType;
  String createdAt;
  String updatedAt;
  ProviderType state;
  List<Images> images;

  Provider(
      {this.id,
      this.name,
      this.description,
      this.rating,
      this.address,
      this.activeStatus,
      this.providerType,
      this.createdAt,
      this.updatedAt,
      this.state,
      this.images});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    rating = json['rating'];
    address = json['address'];
    activeStatus = json['active_status'];
    providerType = json['provider_type'] != null
        ? new ProviderType.fromJson(json['provider_type'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state =
        json['state'] != null ? new ProviderType.fromJson(json['state']) : null;
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['active_status'] = this.activeStatus;
    if (this.providerType != null) {
      data['provider_type'] = this.providerType.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderType {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  ProviderType({this.id, this.name, this.createdAt, this.updatedAt});

  ProviderType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Images {
  int id;
  String name;
  Null alternativeText;
  Null caption;
  int width;
  int height;
  Formats formats;
  String hash;
  String ext;
  String mime;
  double size;
  String url;
  Null previewUrl;
  String provider;
  ProviderMetadata providerMetadata;
  String createdAt;
  String updatedAt;

  Images(
      {this.id,
      this.name,
      this.alternativeText,
      this.caption,
      this.width,
      this.height,
      this.formats,
      this.hash,
      this.ext,
      this.mime,
      this.size,
      this.url,
      this.previewUrl,
      this.provider,
      this.providerMetadata,
      this.createdAt,
      this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    width = json['width'];
    height = json['height'];
    formats =
        json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];
    previewUrl = json['previewUrl'];
    provider = json['provider'];
    providerMetadata = json['provider_metadata'] != null
        ? new ProviderMetadata.fromJson(json['provider_metadata'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alternativeText'] = this.alternativeText;
    data['caption'] = this.caption;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.formats != null) {
      data['formats'] = this.formats.toJson();
    }
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;
    data['previewUrl'] = this.previewUrl;
    data['provider'] = this.provider;
    if (this.providerMetadata != null) {
      data['provider_metadata'] = this.providerMetadata.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Formats {
  Large large;
  Large small;
  Large medium;
  Large thumbnail;

  Formats({this.large, this.small, this.medium, this.thumbnail});

  Formats.fromJson(Map<String, dynamic> json) {
    large = json['large'] != null ? new Large.fromJson(json['large']) : null;
    small = json['small'] != null ? new Large.fromJson(json['small']) : null;
    medium = json['medium'] != null ? new Large.fromJson(json['medium']) : null;
    thumbnail = json['thumbnail'] != null
        ? new Large.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.large != null) {
      data['large'] = this.large.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium.toJson();
    }
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail.toJson();
    }
    return data;
  }
}

class Large {
  String ext;
  String url;
  String hash;
  String mime;
  var path;
  var size;
  var width;
  var height;
  ProviderMetadata providerMetadata;

  Large(
      {this.ext,
      this.url,
      this.hash,
      this.mime,
      this.path,
      this.size,
      this.width,
      this.height,
      this.providerMetadata});

  Large.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
    hash = json['hash'];
    mime = json['mime'];
    path = json['path'];
    size = json['size'];
    width = json['width'];
    height = json['height'];
    providerMetadata = json['provider_metadata'] != null
        ? new ProviderMetadata.fromJson(json['provider_metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ext'] = this.ext;
    data['url'] = this.url;
    data['hash'] = this.hash;
    data['mime'] = this.mime;
    data['path'] = this.path;
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.providerMetadata != null) {
      data['provider_metadata'] = this.providerMetadata.toJson();
    }
    return data;
  }
}

class ProviderMetadata {
  String publicId;
  String resourceType;

  ProviderMetadata({this.publicId, this.resourceType});

  ProviderMetadata.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    resourceType = json['resource_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['resource_type'] = this.resourceType;
    return data;
  }
}
