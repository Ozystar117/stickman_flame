import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'body_component.dart';

class Ground extends BodyComponent{
  @override
  FutureOr<void> onLoad() {
    isDynamic = false;
    add(
        RectangleHitbox()
          ..collisionType = CollisionType.passive
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(getRRect(), Paint()..color = Colors.greenAccent);
  }
  RRect getRRect() {
    return RRect.fromRectAndRadius(
        size.toRect(), Radius.circular(0));
  }

  Ground({required super.position, required super.size});

  @override
  bool get debugMode => true;
}