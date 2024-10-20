import 'package:flutter/material.dart';

class FavoriteItems {
  static List<String> favorites = [];

  static void addFavorite(String itemName) {
    if (!favorites.contains(itemName)) {
      favorites.add(itemName);
    }
  }

  static void removeFavorite(String itemName) {
    favorites.remove(itemName);
  }

  static bool isFavorite(String itemName) {
    return favorites.contains(itemName);
  }
}