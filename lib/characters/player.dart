import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stickman_flame/body_component.dart';

class Player extends BodyComponent{
  final JoystickComponent joystick;
  final double runSpeed;
  final double runAcceleration;
  late final double slideSpeed;
  late final double jumpForce;

  bool onGround = false;
  bool isMovingRight = false;

  Future<void> slide() async{
    final impulseX = isMovingRight ? slideSpeed : -slideSpeed;

    // todo: reduce height (maybe)
    await applyImpulse(
      impulse: Vector2(impulseX, 0),
      duration: Duration(milliseconds: 250),
      velocityAfterImpulse: Vector2(maxSpeed!.x, 0)
    );
    // todo: reset height
  }

  Future<void> jump() async{
    // await applyImpulse(impulse: Vector2(0, -jumpForce), duration: Duration(milliseconds: 250), velocityAfterImpulse: Vector2(maxSpeed!.x, 50));
    // await applyImpulse(impulse: Vector2(0, -jumpForce), duration: Duration(milliseconds: 0));
    applyForce(Vector2(0, -jumpForce * 100));
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    maxSpeed = Vector2(runSpeed, double.infinity);

    slideSpeed = runSpeed * 1.5;
    jumpForce = runSpeed * 2;

    return super.onLoad();
  }

  @override
  void update(double dt){
    if(joystick.isDragged && joystick.relativeDelta.x != 0){
      isMovingRight = joystick.relativeDelta.x > 0;

      if((isMovingRight && velocity.x < 0) || (!isMovingRight && velocity.x > 0)){
        // flip velocity for quick change in direction
        velocity.x = -velocity.x;
      }else{
        // accelerate to runSpeed when moved from idle state
        acceleration.x = joystick.relativeDelta.x > 0 ? runAcceleration : -runAcceleration;
      }
      // print("velocity: $velocity");
    }else{
      stopHorizontalMotion();
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(getRRect(), Paint()..color = Colors.tealAccent);
  }
  RRect getRRect() {
    return RRect.fromRectAndRadius(
        size.toRect(), Radius.circular(0));
  }
  Player({required super.size, required super.position, required this.runSpeed, required this.runAcceleration, required this.joystick});
  @override
  bool get debugMode => true;
}