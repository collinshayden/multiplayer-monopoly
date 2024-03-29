// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:client/model/asset_enums.dart';
import 'package:flutter/material.dart';

const String LOCAL_ASSET_DIR = 'assets'; // Should match `pubspec.yaml` entry.
const String API_URL = 'http://jbourde2.w3.uvm.edu/game';
// const String API_URL = 'http://127.0.0.1:5000/game';
const Duration POLL_PERIOD = Duration(seconds: 1);
const int MAX_NUM_IMPROVEMENTS = 5;
const DESKTOP_MAX_SIZE = Size(1280, 720);

enum JailMethod {
  doubles,
  money,
  card,
}

Map<int, Color> COLOR_MAP = {
  1: Colors.red,
  2: Colors.blue,
  3: Colors.yellow,
  4: Colors.green,
  5: Colors.pink,
  6: Colors.purple,
  7: Colors.brown,
  8: Colors.orange
};

Map<int, Map<PropertyStatus, int>> RENTS = {
  // Browns
  1: {
    PropertyStatus.NO_MONOPOLY: 2,
    PropertyStatus.MONOPOLY: 4,
    PropertyStatus.ONE_IMPROVEMENT: 10,
    PropertyStatus.TWO_IMPROVEMENTS: 30,
    PropertyStatus.THREE_IMPROVEMENTS: 90,
    PropertyStatus.FOUR_IMPROVEMENTS: 160,
    PropertyStatus.FIVE_IMPROVEMENTS: 250,
  },
  3: {
    PropertyStatus.NO_MONOPOLY: 4,
    PropertyStatus.MONOPOLY: 8,
    PropertyStatus.ONE_IMPROVEMENT: 20,
    PropertyStatus.TWO_IMPROVEMENTS: 60,
    PropertyStatus.THREE_IMPROVEMENTS: 180,
    PropertyStatus.FOUR_IMPROVEMENTS: 320,
    PropertyStatus.FIVE_IMPROVEMENTS: 450,
  },
  // Light blues
  6: {
    PropertyStatus.NO_MONOPOLY: 6,
    PropertyStatus.MONOPOLY: 12,
    PropertyStatus.ONE_IMPROVEMENT: 30,
    PropertyStatus.TWO_IMPROVEMENTS: 90,
    PropertyStatus.THREE_IMPROVEMENTS: 270,
    PropertyStatus.FOUR_IMPROVEMENTS: 400,
    PropertyStatus.FIVE_IMPROVEMENTS: 550,
  },
  8: {
    PropertyStatus.NO_MONOPOLY: 6,
    PropertyStatus.MONOPOLY: 12,
    PropertyStatus.ONE_IMPROVEMENT: 30,
    PropertyStatus.TWO_IMPROVEMENTS: 90,
    PropertyStatus.THREE_IMPROVEMENTS: 270,
    PropertyStatus.FOUR_IMPROVEMENTS: 400,
    PropertyStatus.FIVE_IMPROVEMENTS: 550,
  },
  9: {
    PropertyStatus.NO_MONOPOLY: 8,
    PropertyStatus.MONOPOLY: 16,
    PropertyStatus.ONE_IMPROVEMENT: 40,
    PropertyStatus.TWO_IMPROVEMENTS: 100,
    PropertyStatus.THREE_IMPROVEMENTS: 300,
    PropertyStatus.FOUR_IMPROVEMENTS: 450,
    PropertyStatus.FIVE_IMPROVEMENTS: 600,
  },
  // Pinks
  11: {
    PropertyStatus.NO_MONOPOLY: 10,
    PropertyStatus.MONOPOLY: 20,
    PropertyStatus.ONE_IMPROVEMENT: 50,
    PropertyStatus.TWO_IMPROVEMENTS: 150,
    PropertyStatus.THREE_IMPROVEMENTS: 450,
    PropertyStatus.FOUR_IMPROVEMENTS: 625,
    PropertyStatus.FIVE_IMPROVEMENTS: 750,
  },
  13: {
    PropertyStatus.NO_MONOPOLY: 10,
    PropertyStatus.MONOPOLY: 20,
    PropertyStatus.ONE_IMPROVEMENT: 50,
    PropertyStatus.TWO_IMPROVEMENTS: 150,
    PropertyStatus.THREE_IMPROVEMENTS: 450,
    PropertyStatus.FOUR_IMPROVEMENTS: 625,
    PropertyStatus.FIVE_IMPROVEMENTS: 750,
  },
  14: {
    PropertyStatus.NO_MONOPOLY: 12,
    PropertyStatus.MONOPOLY: 24,
    PropertyStatus.ONE_IMPROVEMENT: 60,
    PropertyStatus.TWO_IMPROVEMENTS: 180,
    PropertyStatus.THREE_IMPROVEMENTS: 500,
    PropertyStatus.FOUR_IMPROVEMENTS: 700,
    PropertyStatus.FIVE_IMPROVEMENTS: 900,
  },
  // Oranges
  16: {
    PropertyStatus.NO_MONOPOLY: 14,
    PropertyStatus.MONOPOLY: 28,
    PropertyStatus.ONE_IMPROVEMENT: 70,
    PropertyStatus.TWO_IMPROVEMENTS: 200,
    PropertyStatus.THREE_IMPROVEMENTS: 550,
    PropertyStatus.FOUR_IMPROVEMENTS: 750,
    PropertyStatus.FIVE_IMPROVEMENTS: 950,
  },
  18: {
    PropertyStatus.NO_MONOPOLY: 14,
    PropertyStatus.MONOPOLY: 28,
    PropertyStatus.ONE_IMPROVEMENT: 70,
    PropertyStatus.TWO_IMPROVEMENTS: 200,
    PropertyStatus.THREE_IMPROVEMENTS: 550,
    PropertyStatus.FOUR_IMPROVEMENTS: 750,
    PropertyStatus.FIVE_IMPROVEMENTS: 950,
  },
  19: {
    PropertyStatus.NO_MONOPOLY: 16,
    PropertyStatus.MONOPOLY: 32,
    PropertyStatus.ONE_IMPROVEMENT: 80,
    PropertyStatus.TWO_IMPROVEMENTS: 220,
    PropertyStatus.THREE_IMPROVEMENTS: 600,
    PropertyStatus.FOUR_IMPROVEMENTS: 800,
    PropertyStatus.FIVE_IMPROVEMENTS: 1000,
  },
  // Reds
  21: {
    PropertyStatus.NO_MONOPOLY: 18,
    PropertyStatus.MONOPOLY: 36,
    PropertyStatus.ONE_IMPROVEMENT: 90,
    PropertyStatus.TWO_IMPROVEMENTS: 250,
    PropertyStatus.THREE_IMPROVEMENTS: 700,
    PropertyStatus.FOUR_IMPROVEMENTS: 875,
    PropertyStatus.FIVE_IMPROVEMENTS: 1050,
  },
  23: {
    PropertyStatus.NO_MONOPOLY: 18,
    PropertyStatus.MONOPOLY: 36,
    PropertyStatus.ONE_IMPROVEMENT: 90,
    PropertyStatus.TWO_IMPROVEMENTS: 250,
    PropertyStatus.THREE_IMPROVEMENTS: 700,
    PropertyStatus.FOUR_IMPROVEMENTS: 875,
    PropertyStatus.FIVE_IMPROVEMENTS: 1050,
  },
  24: {
    PropertyStatus.NO_MONOPOLY: 20,
    PropertyStatus.MONOPOLY: 40,
    PropertyStatus.ONE_IMPROVEMENT: 100,
    PropertyStatus.TWO_IMPROVEMENTS: 300,
    PropertyStatus.THREE_IMPROVEMENTS: 750,
    PropertyStatus.FOUR_IMPROVEMENTS: 925,
    PropertyStatus.FIVE_IMPROVEMENTS: 1100,
  },
  // Yellows
  26: {
    PropertyStatus.NO_MONOPOLY: 22,
    PropertyStatus.MONOPOLY: 44,
    PropertyStatus.ONE_IMPROVEMENT: 110,
    PropertyStatus.TWO_IMPROVEMENTS: 330,
    PropertyStatus.THREE_IMPROVEMENTS: 800,
    PropertyStatus.FOUR_IMPROVEMENTS: 975,
    PropertyStatus.FIVE_IMPROVEMENTS: 1150,
  },
  27: {
    PropertyStatus.NO_MONOPOLY: 22,
    PropertyStatus.MONOPOLY: 44,
    PropertyStatus.ONE_IMPROVEMENT: 110,
    PropertyStatus.TWO_IMPROVEMENTS: 330,
    PropertyStatus.THREE_IMPROVEMENTS: 800,
    PropertyStatus.FOUR_IMPROVEMENTS: 975,
    PropertyStatus.FIVE_IMPROVEMENTS: 1150,
  },
  29: {
    PropertyStatus.NO_MONOPOLY: 24,
    PropertyStatus.MONOPOLY: 48,
    PropertyStatus.ONE_IMPROVEMENT: 120,
    PropertyStatus.TWO_IMPROVEMENTS: 360,
    PropertyStatus.THREE_IMPROVEMENTS: 850,
    PropertyStatus.FOUR_IMPROVEMENTS: 1025,
    PropertyStatus.FIVE_IMPROVEMENTS: 1200,
  },
  // Greens
  31: {
    PropertyStatus.NO_MONOPOLY: 26,
    PropertyStatus.MONOPOLY: 52,
    PropertyStatus.ONE_IMPROVEMENT: 130,
    PropertyStatus.TWO_IMPROVEMENTS: 390,
    PropertyStatus.THREE_IMPROVEMENTS: 900,
    PropertyStatus.FOUR_IMPROVEMENTS: 1100,
    PropertyStatus.FIVE_IMPROVEMENTS: 1275,
  },
  32: {
    PropertyStatus.NO_MONOPOLY: 26,
    PropertyStatus.MONOPOLY: 52,
    PropertyStatus.ONE_IMPROVEMENT: 130,
    PropertyStatus.TWO_IMPROVEMENTS: 390,
    PropertyStatus.THREE_IMPROVEMENTS: 900,
    PropertyStatus.FOUR_IMPROVEMENTS: 1100,
    PropertyStatus.FIVE_IMPROVEMENTS: 1275,
  },
  34: {
    PropertyStatus.NO_MONOPOLY: 28,
    PropertyStatus.MONOPOLY: 56,
    PropertyStatus.ONE_IMPROVEMENT: 150,
    PropertyStatus.TWO_IMPROVEMENTS: 450,
    PropertyStatus.THREE_IMPROVEMENTS: 1000,
    PropertyStatus.FOUR_IMPROVEMENTS: 1200,
    PropertyStatus.FIVE_IMPROVEMENTS: 1400,
  },
  // Blues
  37: {
    PropertyStatus.NO_MONOPOLY: 35,
    PropertyStatus.MONOPOLY: 70,
    PropertyStatus.ONE_IMPROVEMENT: 175,
    PropertyStatus.TWO_IMPROVEMENTS: 500,
    PropertyStatus.THREE_IMPROVEMENTS: 1100,
    PropertyStatus.FOUR_IMPROVEMENTS: 1300,
    PropertyStatus.FIVE_IMPROVEMENTS: 1500,
  },
  39: {
    PropertyStatus.NO_MONOPOLY: 50,
    PropertyStatus.MONOPOLY: 100,
    PropertyStatus.ONE_IMPROVEMENT: 200,
    PropertyStatus.TWO_IMPROVEMENTS: 600,
    PropertyStatus.THREE_IMPROVEMENTS: 1400,
    PropertyStatus.FOUR_IMPROVEMENTS: 1700,
    PropertyStatus.FIVE_IMPROVEMENTS: 2000,
  },
};
