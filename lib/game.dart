import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:stickman_flame/ground.dart';
import 'package:stickman_flame/characters/player.dart';

class StickGame extends FlameGame with HasCollisionDetection{
  late final Player player;
  @override
  final World world = World();
  @override
  late final CameraComponent camera = CameraComponent(world: world)
    ..viewfinder.anchor = Anchor.topLeft;
  late final Vector2 gridSize = Vector2(size.x * 0.05, size.y * 0.1);
  late final joystick = JoystickComponent(
    knob: CircleComponent(radius: gridSize.x * 0.7, paint: Paint()
      ..color = Colors.white.withAlpha(60)),
    background: CircleComponent(radius: gridSize.x, paint: Paint()
      ..color = Colors.white.withAlpha(50)),
    margin: EdgeInsets.only(left: gridSize.x * 0.7, bottom: gridSize.x),
  );
  late final Ground ground;
  late final HudButtonComponent slideButton;
  late final HudButtonComponent jumpButton;


  @override
  FutureOr<void> onLoad() async {
    await enableLandScapeMode();

    // Load assets
    await images.loadAll([
      'spritesheet.png',
      'spritesheet2.png',
    ]);

    initHuds();

    final groundSize = Vector2(size.x, gridSize.y*3);
    ground = Ground(position: Vector2(0, size.y - groundSize.y), size: groundSize);
    player = Player(size: Vector2(gridSize.x * 0.5, gridSize.y), position: size / 2, runSpeed: gridSize.x * 2, runAcceleration: gridSize.x, joystick: joystick);

    addAll([world, camera]);
    addToViewport();
    addComponentsToWorld();

    return super.onLoad();
  }

  // @override
  // Color backgroundColor() => Colors.lightBlueAccent;

  // @override
  // bool get debugMode => true;

  Future<void> enableLandScapeMode() async {
    await Flame.device.setLandscapeRightOnly();
    await Future.delayed(Duration(milliseconds: 500));
  }

  void addComponentsToWorld() {
    world.addAll([player, ground]);
  }

  void addToViewport(){
    camera.viewport.addAll([joystick, slideButton, jumpButton]);
  }

  void initHuds(){
    initJumpHud();
    initSlideHud();
  }

  void initJumpHud(){
    final jumpSprite = getSprite(776, 776, 112, 203, 'spritesheet.png');
    final scaleFactor = gridSize.x * 1.2 / 203; // base on height
    final spriteWidth = 112 * scaleFactor;
    final spriteHeight = 203 * scaleFactor;

    SpriteComponent jumpIcon = SpriteComponent(
        sprite: jumpSprite,
        size: Vector2(spriteWidth, spriteHeight),
        anchor: Anchor.center,
        position: Vector2(gridSize.x, gridSize.x), // radius, radius
        paint: Paint()..color = Colors.white.withAlpha(50)
    );

    jumpButton = HudButtonComponent(
        position: Vector2(size.x - gridSize.x * 6, size.y - gridSize.y * 3.5),
        button: CircleComponent(
          // anchor: Anchor.center,
            radius: gridSize.x,
            paint: Paint()..color = Colors.white.withAlpha(50),
            children: [
              jumpIcon,
            ]
        ),
        onPressed: () async{
          await player.jump();
        }
    );
  }

  void initSlideHud(){
    // final slideSprite = getSprite(1112, 766, 256, 164, 'spritesheet2.png');
    final slideSprite = getSprite(176, 721, 224, 212, 'spritesheet2.png');
    // final slideSprite = getSprite(791, 269, 185, 218, 'spritesheet2.png');
    final scaleFactor = gridSize.x / 164; // base on height
    final spriteWidth = 112 * scaleFactor;
    final spriteHeight = 203 * scaleFactor;

    SpriteComponent slideIcon = SpriteComponent(
        sprite: slideSprite,
        size: Vector2(spriteWidth, spriteHeight),
        anchor: Anchor.center,
        position: Vector2(gridSize.x, gridSize.x), // radius, radius
        paint: Paint()..color = Colors.white.withAlpha(50)
    );

    CircleComponent background = CircleComponent(
        radius: gridSize.x,
        paint: Paint()..color = Colors.white.withAlpha(50),
        children: [
          slideIcon
        ]
    );

    slideButton = HudButtonComponent(
      position: Vector2(size.x - gridSize.x * 3, size.y - gridSize.y * 3.5),
      button: background,
      onPressed: () async{
        // background.add(OpacityEffect.by(0.2, EffectController(duration: 0.1)));
        background.paint.color = Colors.white.withAlpha(100);
        slideIcon.paint.color = Colors.white.withAlpha(100);
        await player.slide();
      },
      onReleased: (){
        background.paint.color = Colors.white.withAlpha(50);
        slideIcon.paint.color = Colors.white.withAlpha(50);
      }
    );
  }

  Sprite getSprite(double x, double y, double width, double height, String spriteName) {
    return Sprite(
      Flame.images.fromCache(spriteName),
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
  }
}