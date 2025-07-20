import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:stickman_flame/game.dart';

abstract class BodyComponent extends PositionComponent with HasGameReference<StickGame>, CollisionCallbacks{
  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();
  // Vector2 direction = Vector2(0, 0);

  bool useGravity = true;
  bool isDynamic = true;
  bool underImpulse = false;
  late double gravity = game.gridSize.y * 10;

  Vector2? maxSpeed;
  double deltaTime = 0;

  @override
  FutureOr<void> onLoad() {
    useGravity = isDynamic;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is BodyComponent && other.isDynamic == false){
      stopGravity();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void applyFriction(double friction, double dt){
    // apply friction
    if(velocity.x > 0){
      velocity.x -= friction * dt;
      if(velocity.x < 0) velocity.x = 0;
    }else if(velocity.x < 0){
      velocity.x += friction * dt;
      if(velocity.x > 0) velocity.x = 0;
    }

  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if(other is BodyComponent && other.isDynamic == false){
      useGravity = true;
    }
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    super.update(dt);
    deltaTime = dt;


    // Apply gravity
    if (useGravity) {
      acceleration.y += gravity;
    }

    // Apply acceleration to velocity
    velocity += acceleration * dt;

    // Clamp speed if needed
    if (maxSpeed != null && !underImpulse) {
      if(velocity.y > maxSpeed!.y) velocity.y = maxSpeed!.y;
      if(velocity.x > maxSpeed!.x) velocity.x = maxSpeed!.x;
      if(velocity.x < 0 && velocity.x < -maxSpeed!.x){ // moving to the left
        velocity.x = -maxSpeed!.x;
      }
    }


    // Apply velocity to position
    position += velocity * dt;

    // Reset acceleration for next frame
    acceleration.setZero();
  }

  /// immediately increase the velocity of the component by the impulse
  /// duration will determine how long the component will be allowed to exceed its max speed when under impulse
  Future<void> applyImpulse({required Vector2 impulse, required duration, Vector2? velocityAfterImpulse}) async{
    underImpulse = true;
    velocityAfterImpulse = velocityAfterImpulse ?? velocity;
    velocity += impulse;

    await Future.delayed(duration);

    // if(velocityAfterImpulse != null) velocity = velocityAfterImpulse;
    underImpulse = false;
  }

  void applyForce(Vector2 force) {
    acceleration += force;
  }

  void stopVerticalMotion() {
    velocity.y = 0;
  }

  void stopHorizontalMotion() {
    velocity.x = 0;
  }

  void stopGravity(){
    stopVerticalMotion();
    useGravity = false;
  }

  BodyComponent({required super.size, required super.position});
}
