import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:stickman_flame/game.dart';

void main() {
  runApp(GameWidget.controlled(gameFactory: StickGame.new));
}
