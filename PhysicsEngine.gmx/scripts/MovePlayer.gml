///MovePlayer
maxspeed = 10
acceleration = 3
shot_speed = 10

movement = InputMovement()
if movement[1] > 0 {
  direction = movement[0]
  speed += acceleration
}
