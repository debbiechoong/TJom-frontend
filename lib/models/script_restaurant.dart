class ScriptRestaurant {
  List<String>? types;
  List<String>? images;
  String? website;
  String? address;
  String? businessStatus;
  double? rating;
  String? description;
  String? url;
  CurrentOpeningHours? currentOpeningHours;
  int? userRatingsTotal;
  String? name;
  Geometry? geometry;
  String? placeId;

  ScriptRestaurant(
      {this.types,
      this.images,
      this.website,
      this.address,
      this.businessStatus,
      this.rating,
      this.description,
      this.url,
      this.currentOpeningHours,
      this.userRatingsTotal,
      this.name,
      this.geometry,
      this.placeId});

  ScriptRestaurant.fromJson(Map<String, dynamic> json) {
    types = json['types'].cast<String>();
    images = json['images'].cast<String>();
    website = json['website'];
    address = json['address'];
    businessStatus = json['business_status'];
    rating = json['rating'];
    description = json['description'];
    url = json['url'];
    currentOpeningHours = json['current_opening_hours'] != null
        ? new CurrentOpeningHours.fromJson(json['current_opening_hours'])
        : null;
    userRatingsTotal = json['user_ratings_total'];
    name = json['name'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['types'] = this.types;
    data['images'] = this.images;
    data['website'] = this.website;
    data['address'] = this.address;
    data['business_status'] = this.businessStatus;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['url'] = this.url;
    if (this.currentOpeningHours != null) {
      data['current_opening_hours'] = this.currentOpeningHours!.toJson();
    }
    data['user_ratings_total'] = this.userRatingsTotal;
    data['name'] = this.name;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['place_id'] = this.placeId;
    return data;
  }
}

class CurrentOpeningHours {
  List<String>? weekdayText;

  CurrentOpeningHours({this.weekdayText});

  CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    weekdayText = json['weekday_text'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weekday_text'] = this.weekdayText;
    return data;
  }
}

class Geometry {
  Location? location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  double? lng;
  double? lat;

  Location({this.lng, this.lat});

  Location.fromJson(Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }
}