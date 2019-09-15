#define ShootLogic

#define ShootCreate
//TODO move zIfy to entity
//TODO adjust parameters
ShootConfig()
zIfy(z_gravity, 8, 8, 3, null, shadow, 0.7, 300);
Isometrize(isometric_factor)
speed = initial_speed

#define ShootStep
zGravity()
MoveToDirection(direction, 1, minspeed, maxspeed, acceleration, my_friction);


#define ShootEndStep
zIfyEndStep()
IsometrizeEndStep()