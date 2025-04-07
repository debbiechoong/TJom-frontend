import 'package:flutter/material.dart';

/// Standardized iconography system for the app
/// Provides consistent icon usage throughout the application
class AppIcons {
  // --- NAVIGATION ICONS ---
  static const IconData home = Icons.home_rounded;
  static const IconData trips = Icons.luggage_rounded;
  static const IconData explore = Icons.explore_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData settings = Icons.settings_rounded;

  // --- ACTION ICONS ---
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteBorder = Icons.favorite_border_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData success = Icons.check_circle_outline_rounded;

  // --- TRAVEL ICONS ---
  static const IconData flight = Icons.flight_rounded;
  static const IconData hotel = Icons.hotel_rounded;
  static const IconData restaurant = Icons.restaurant_rounded;
  static const IconData attraction = Icons.attractions_rounded;
  static const IconData transit = Icons.directions_transit_rounded;
  static const IconData car = Icons.directions_car_rounded;
  static const IconData weather = Icons.wb_sunny_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData location = Icons.place_rounded;
  static const IconData map = Icons.map_rounded;
  static const IconData camera = Icons.camera_alt_rounded;
  
  // --- MYSTERY GAME ICONS ---
  static const IconData game = Icons.games_rounded;
  static const IconData clue = Icons.lightbulb_outline_rounded;
  static const IconData character = Icons.person_outline_rounded;
  static const IconData notes = Icons.note_alt_rounded;
  static const IconData script = Icons.menu_book_rounded;
  static const IconData evidence = Icons.fact_check_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData unlock = Icons.lock_open_rounded;
  static const IconData timer = Icons.timer_rounded;
  
  // --- TAIWAN-SPECIFIC ICONS ---
  // Since Flutter doesn't have Taiwan-specific icons, we use the
  // closest matching icons from Material icons
  
  // MRT/Transit
  static const IconData mrt = Icons.train_rounded;       // Taipei MRT
  static const IconData bus = Icons.directions_bus_rounded;  // Taiwan buses
  static const IconData ferry = Icons.directions_boat_rounded;  // Taiwan ferries
  static const IconData highSpeedRail = Icons.directions_railway_rounded;  // Taiwan HSR
  
  // Taiwan Points of Interest
  static const IconData temple = Icons.account_balance_rounded;  // Taiwan temples
  static const IconData nightMarket = Icons.storefront_rounded;  // Night markets
  static const IconData hotSpring = Icons.hot_tub_rounded;  // Taiwan hot springs
  static const IconData mountain = Icons.landscape_rounded;  // Taiwan's mountains
  static const IconData beach = Icons.beach_access_rounded;  // Taiwan's beaches
  static const IconData teaPlantation = Icons.eco_rounded;  // Tea plantations
  
  // Taiwan Categories
  static const IconData food = Icons.restaurant_menu_rounded;  // Taiwan food
  static const IconData shopping = Icons.shopping_bag_rounded;  // Taiwan shopping
  static const IconData culture = Icons.museum_rounded;  // Taiwan culture
  static const IconData adventure = Icons.hiking_rounded;  // Taiwan adventure
  static const IconData nature = Icons.forest_rounded;  // Taiwan nature
  static const IconData cityLife = Icons.location_city_rounded;  // Taiwan urban areas
  
  // Taiwan Cultural Elements
  static const IconData lantern = Icons.lightbulb_rounded;  // Lantern festival 
  static const IconData bubble = Icons.water_drop_rounded;  // Bubble tea
  
  /// Get icon for a specific category based on string name
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining': 
        return food;
      case 'shopping':
      case 'markets':
        return shopping;
      case 'culture':
      case 'history':
      case 'heritage':
        return culture;
      case 'adventure':
      case 'activities':
        return adventure;
      case 'nature':
      case 'parks':
      case 'outdoors':
        return nature;
      case 'temples':
      case 'religious':
        return temple;
      case 'nightlife':
      case 'night market':
        return nightMarket;
      case 'hot springs':
      case 'spa':
        return hotSpring;
      case 'mountains':
      case 'hiking':
        return mountain;
      case 'beaches':
      case 'coast':
        return beach;
      case 'transportation':
      case 'transit':
      case 'mrt':
        return mrt;
      case 'high speed rail':
      case 'hsr':
      case 'trains':
        return highSpeedRail;
      case 'relax':
        return Icons.spa_rounded;
      default:
        return explore;
    }
  }
} 