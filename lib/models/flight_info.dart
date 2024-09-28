class FlightInfo {
  DepartureFlight? departureFlight;
  int? priceTotal;
  ReturnFlight? returnFlight;

  FlightInfo({this.departureFlight, this.priceTotal, this.returnFlight});

  FlightInfo.fromJson(Map<String, dynamic> json) {
    departureFlight = json['departureFlight'] != null
        ? new DepartureFlight.fromJson(json['departureFlight'])
        : null;
    priceTotal = json['priceTotal'];
    returnFlight = json['returnFlight'] != null
        ? new ReturnFlight.fromJson(json['returnFlight'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.departureFlight != null) {
      data['departureFlight'] = this.departureFlight!.toJson();
    }
    data['priceTotal'] = this.priceTotal;
    if (this.returnFlight != null) {
      data['returnFlight'] = this.returnFlight!.toJson();
    }
    return data;
  }
}

class DepartureFlight {
  String? airlineLogo;
  CarbonEmissions? carbonEmissions;
  String? departureToken;
  List<Flights>? flights;
  List<Layovers>? layovers;
  String? totalDuration;
  String? type;

  DepartureFlight(
      {this.airlineLogo,
      this.carbonEmissions,
      this.departureToken,
      this.flights,
      this.layovers,
      this.totalDuration,
      this.type});

  DepartureFlight.fromJson(Map<String, dynamic> json) {
    airlineLogo = json['airline_logo'];
    carbonEmissions = json['carbon_emissions'] != null
        ? new CarbonEmissions.fromJson(json['carbon_emissions'])
        : null;
    departureToken = json['departure_token'];
    if (json['flights'] != null) {
      flights = <Flights>[];
      json['flights'].forEach((v) {
        flights!.add(new Flights.fromJson(v));
      });
    }
    if (json['layovers'] != null) {
      layovers = <Layovers>[];
      json['layovers'].forEach((v) {
        layovers!.add(new Layovers.fromJson(v));
      });
    }
    totalDuration = json['total_duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airline_logo'] = this.airlineLogo;
    if (this.carbonEmissions != null) {
      data['carbon_emissions'] = this.carbonEmissions!.toJson();
    }
    data['departure_token'] = this.departureToken;
    if (this.flights != null) {
      data['flights'] = this.flights!.map((v) => v.toJson()).toList();
    }
    if (this.layovers != null) {
      data['layovers'] = this.layovers!.map((v) => v.toJson()).toList();
    }
    data['total_duration'] = this.totalDuration;
    data['type'] = this.type;
    return data;
  }
}

class CarbonEmissions {
  int? thisFlight;

  CarbonEmissions({this.thisFlight});

  CarbonEmissions.fromJson(Map<String, dynamic> json) {
    thisFlight = json['this_flight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['this_flight'] = this.thisFlight;
    return data;
  }
}

class Flights {
  String? airline;
  String? airlineLogo;
  String? airplane;
  ArrivalAirport? arrivalAirport;
  ArrivalAirport? departureAirport;
  String? duration;
  List<String>? extensions;
  String? flightNumber;
  bool? oftenDelayedByOver30Min;
  bool? overnight;
  String? travelClass;
  String? legroom;

  Flights(
      {this.airline,
      this.airlineLogo,
      this.airplane,
      this.arrivalAirport,
      this.departureAirport,
      this.duration,
      this.extensions,
      this.flightNumber,
      this.oftenDelayedByOver30Min,
      this.overnight,
      this.travelClass,
      this.legroom});

  Flights.fromJson(Map<String, dynamic> json) {
    airline = json['airline'];
    airlineLogo = json['airline_logo'];
    airplane = json['airplane'];
    arrivalAirport = json['arrival_airport'] != null
        ? new ArrivalAirport.fromJson(json['arrival_airport'])
        : null;
    departureAirport = json['departure_airport'] != null
        ? new ArrivalAirport.fromJson(json['departure_airport'])
        : null;
    duration = json['duration'];
    extensions = json['extensions'].cast<String>();
    flightNumber = json['flight_number'];
    oftenDelayedByOver30Min = json['often_delayed_by_over_30_min'];
    overnight = json['overnight'];
    travelClass = json['travel_class'];
    legroom = json['legroom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airline'] = this.airline;
    data['airline_logo'] = this.airlineLogo;
    data['airplane'] = this.airplane;
    if (this.arrivalAirport != null) {
      data['arrival_airport'] = this.arrivalAirport!.toJson();
    }
    if (this.departureAirport != null) {
      data['departure_airport'] = this.departureAirport!.toJson();
    }
    data['duration'] = this.duration;
    data['extensions'] = this.extensions;
    data['flight_number'] = this.flightNumber;
    data['often_delayed_by_over_30_min'] = this.oftenDelayedByOver30Min;
    data['overnight'] = this.overnight;
    data['travel_class'] = this.travelClass;
    data['legroom'] = this.legroom;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    return data;
  }
}

class Layovers {
  String? duration;
  String? id;
  String? name;

  Layovers({this.duration, this.id, this.name});

  Layovers.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ReturnFlight {
  String? airlineLogo;
  String? bookingToken;
  CarbonEmissions? carbonEmissions;
  List<Flights>? flights;
  List<Layovers>? layovers;
  String? totalDuration;
  String? type;

  ReturnFlight(
      {this.airlineLogo,
      this.bookingToken,
      this.carbonEmissions,
      this.flights,
      this.layovers,
      this.totalDuration,
      this.type});

  ReturnFlight.fromJson(Map<String, dynamic> json) {
    airlineLogo = json['airline_logo'];
    bookingToken = json['booking_token'];
    carbonEmissions = json['carbon_emissions'] != null
        ? new CarbonEmissions.fromJson(json['carbon_emissions'])
        : null;
    if (json['flights'] != null) {
      flights = <Flights>[];
      json['flights'].forEach((v) {
        flights!.add(new Flights.fromJson(v));
      });
    }
    if (json['layovers'] != null) {
      layovers = <Layovers>[];
      json['layovers'].forEach((v) {
        layovers!.add(new Layovers.fromJson(v));
      });
    }
    totalDuration = json['total_duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airline_logo'] = this.airlineLogo;
    data['booking_token'] = this.bookingToken;
    if (this.carbonEmissions != null) {
      data['carbon_emissions'] = this.carbonEmissions!.toJson();
    }
    if (this.flights != null) {
      data['flights'] = this.flights!.map((v) => v.toJson()).toList();
    }
    if (this.layovers != null) {
      data['layovers'] = this.layovers!.map((v) => v.toJson()).toList();
    }
    data['total_duration'] = this.totalDuration;
    data['type'] = this.type;
    return data;
  }
}
