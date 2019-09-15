#define zIfy
var _z_gravity = argument0;
var _diameter = argument1;
var _height = argument2;
var _action_height = argument3;
var _null_object = argument4;
var _shadow_sprite = argument5;
var _shadow_opacity = argument6;
var _max_shadow_height = argument7;

z = 0;
zspeed = 0;
z_standing = false;
z_gravity = _z_gravity;
diameter = _diameter;
height = _height;
action_height = _action_height;
shadow_opacity = _shadow_opacity;
max_shadow_height = _max_shadow_height

//Shadow
shadow_instance = instance_create(x, y, _null_object);
shadow_instance.sprite_index = _shadow_sprite;
shadow_instance.visible = true;

//Show
show_instance = instance_create(x, y, _null_object);
show_instance.sprite_index = sprite_index;
show_instance.visible = true;

//Hide this object
visible = false;

#define zIfyEndStep
// Shadow
shadow_instance.x = x;
shadow_instance.y = y;
shadow_instance.depth = depth+1;
var _shadow_sprite = shadow_instance.sprite_index;

// Reduce shadow when the object is floating.
var _height_factor = 1;
if z < 0 or z > max_shadow_height {
  shadow_instance.visible = false;
}
else {
  shadow_instance.visible = true;
  if z > 0 {
    _height_factor = 1-(z/max_shadow_height);
  }
}

shadow_instance.image_xscale = diameter * _height_factor / sprite_get_width(_shadow_sprite);
shadow_instance.image_yscale = diameter * _height_factor / sprite_get_height(_shadow_sprite);
shadow_instance.image_alpha = shadow_opacity*_height_factor;
//TODO depth

//Show
show_instance.sprite_index = sprite_index;
show_instance.image_alpha = image_alpha;
show_instance.image_xscale = image_xscale;
show_instance.image_yscale = image_yscale;
show_instance.image_angle = image_angle;
show_instance.image_blend = image_blend;
show_instance.image_index = image_index;
show_instance.x = x;
show_instance.y = y-z;
//TODO depth

#define zGravity
z += zspeed;
if not z_standing {
  zspeed -= z_gravity;
}
if z <= 0 {
  z_standing = true;
  zspeed = 0;
  z = 0;
}