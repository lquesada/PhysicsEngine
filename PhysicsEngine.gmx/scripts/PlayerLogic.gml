#define PlayerLogic


#define PlayerCreate
//ViewSetup();
//TODO move zIfy to entity
//TODO adjust parameters
PlayerConfig();
zIfy(z_gravity, 20, 64, 38, null, shadow, 0.7, 300); //a
Isometrize(isometric_factor); //a
jumping = false; //a

#define PlayerStep
movement = InputMovement(true);
if z_standing {
  if keyboard_check(vk_space) {
    zspeed = jump_acceleration;
    z_standing = false;
    jumping = true;
  } else {
    jumping = false;
  }
}
if not jumping {
  MoveToDirection(movement[0], movement[1], minspeed, maxspeed, acceleration, my_friction);
}
zGravity() //a
if mouse_check_button_pressed(mb_left) {
  a = instance_create(x, y, PlaceholderPlayerShot);
  a.z = z+action_height;
  a.direction = point_direction(x, y, mouse_x, mouse_y);
}


#define PlayerEndStep
Discretize(); //a
zIfyEndStep(); //a
IsometrizeEndStep(); //a
//ViewToInstance);
//ViewResize(1., isometric_factor);
