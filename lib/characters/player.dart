import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stickman_flame/characters/character.dart';

class Player extends Character{
  final JoystickComponent joystick;

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
  Player({required super.size, required super.position, required super.runSpeed, required super.runAcceleration, required this.joystick});
  @override
  bool get debugMode => true;
}