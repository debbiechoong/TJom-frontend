class FlightInfo {
  String? airlineLogo;
  CarbonEmissions? carbonEmissions;
  String? departureToken;
  List<Flights>? flights;
  List<Layovers>? layovers;
  int? price;
  int? totalDuration;
  String? type;

  FlightInfo(
      {this.airlineLogo,
      this.carbonEmissions,
      this.departureToken,
      this.flights,
      this.layovers,
      this.price,
      this.totalDuration,
      this.type});

  FlightInfo.fromJson(Map<String, dynamic> json) {
    airlineLogo = json['airline_logo'];
    carbonEmissions = json['carbon_emissions'] != null
        ? CarbonEmissions.fromJson(json['carbon_emissions'])
        : null;
    departureToken = json['departure_token'];
    if (json['flights'] != null) {
      flights = <Flights>[];
      json['flights'].forEach((v) {
        flights!.add(Flights.fromJson(v));
      });
    }
    if (json['layovers'] != null) {
      layovers = <Layovers>[];
      json['layovers'].forEach((v) {
        layovers!.add(Layovers.fromJson(v));
      });
    }
    price = json['price'];
    totalDuration = json['total_duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airline_logo'] = airlineLogo;
    if (carbonEmissions != null) {
      data['carbon_emissions'] = carbonEmissions!.toJson();
    }
    data['departure_token'] = departureToken;
    if (flights != null) {
      data['flights'] = flights!.map((v) => v.toJson()).toList();
    }
    if (layovers != null) {
      data['layovers'] = layovers!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['total_duration'] = totalDuration;
    data['type'] = type;
    return data;
  }
}

class CarbonEmissions {
  int? differencePercent;
  int? thisFlight;
  int? typicalForThisRoute;

  CarbonEmissions(
      {this.differencePercent, this.thisFlight, this.typicalForThisRoute});

  CarbonEmissions.fromJson(Map<String, dynamic> json) {
    differencePercent = json['difference_percent'];
    thisFlight = json['this_flight'];
    typicalForThisRoute = json['typical_for_this_route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['difference_percent'] = differencePercent;
    data['this_flight'] = thisFlight;
    data['typical_for_this_route'] = typicalForThisRoute;
    return data;
  }
}

class Flights {
  String? airline;
  String? airlineLogo;
  String? airplane;
  ArrivalAirport? arrivalAirport;
  ArrivalAirport? departureAirport;
  int? duration;
  List<String>? extensions;
  String? flightNumber;
  String? legroom;
  bool? oftenDelayedByOver30Min;
  bool? overnight;
  String? travelClass;

  Flights(
      {this.airline,
      this.airlineLogo,
      this.airplane,
      this.arrivalAirport,
      this.departureAirport,
      this.duration,
      this.extensions,
      this.flightNumber,
      this.legroom,
      this.oftenDelayedByOver30Min,
      this.overnight,
      this.travelClass});

  Flights.fromJson(Map<String, dynamic> json) {
    airline = json['airline'];
    airlineLogo = json['airline_logo'];
    airplane = json['airplane'];
    arrivalAirport = json['arrival_airport'] != null
        ? ArrivalAirport.fromJson(json['arrival_airport'])
        : null;
    departureAirport = json['departure_airport'] != null
        ? ArrivalAirport.fromJson(json['departure_airport'])
        : null;
    duration = json['duration'];
    extensions = json['extensions'].cast<String>();
    flightNumber = json['flight_number'];
    legroom = json['legroom'];
    oftenDelayedByOver30Min = json['often_delayed_by_over_30_min'];
    overnight = json['overnight'];
    travelClass = json['travel_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airline'] = airline;
    data['airline_logo'] = airlineLogo;
    data['airplane'] = airplane;
    if (arrivalAirport != null) {
      data['arrival_airport'] = arrivalAirport!.toJson();
    }
    if (departureAirport != null) {
      data['departure_airport'] = departureAirport!.toJson();
    }
    data['duration'] = duration;
    data['extensions'] = extensions;
    data['flight_number'] = flightNumber;
    data['legroom'] = legroom;
    data['often_delayed_by_over_30_min'] = oftenDelayedByOver30Min;
    data['overnight'] = overnight;
    data['travel_class'] = travelClass;
    return data;
  }
}

class ArrivalAirport {
  String? id;
  String? name;
  String? time;

  ArrivalAirport({this.id, this.name, this.time});

  ArrivalAirport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['time'] = time;
    return data;
  }
}

class Layovers {
  int? duration;
  String? id;
  String? name;
  bool? overnight;

  Layovers({this.duration, this.id, this.name, this.overnight});

  Layovers.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    id = json['id'];
    name = json['name'];
    overnight = json['overnight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['id'] = id;
    data['name'] = name;
    data['overnight'] = overnight;
    return data;
  }
}
