#define Pseudo3D
//Overridable values.
pseudo3d_zgravity_effect = false;
pseudo3d_diameter = 20;
pseudo3d_height = 64;
pseudo3d_action_height = 30;
pseudo3d_shadow_sprite = shadow;
pseudo3d_shadow_opacity = 0.7;
pseudo3d_max_shadow_height = 300;
pseudo3d_ground = 0;
pseudo3d_xscale = 1;
pseudo3d_yscale = 1;

//Initialize
pseudo3d_z = 0;
pseudo3d_zspeed = 0;

//Shadow
pseudo3d_shadow_instance = instance_create(x, y, null);
pseudo3d_shadow_instance.visible = true;

//Show
pseudo3d_show_instance = instance_create(x, y, null);
pseudo3d_show_instance.sprite_index = sprite_index;
pseudo3d_show_instance.visible = true;

//Hide this instance.
visible = false;

#define Pseudo3DStep
var _z_gravity = argument0;
var _speed_factor = argument1;
var _max_delta_time = argument2;

var _delta_factor = DeltaTime(_max_delta_time)/_speed_factor;

if pseudo3d_zgravity_effect {
  pseudo3d_zspeed -= _z_gravity * _delta_factor;
}
pseudo3d_z += pseudo3d_zspeed * _delta_factor;
if pseudo3d_z <= pseudo3d_ground {
  pseudo3d_zgravity_effect = false;
  pseudo3d_zspeed = 0;
  pseudo3d_z = pseudo3d_ground;
}
if pseudo3d_z > pseudo3d_ground {
  pseudo3d_zgravity_effect = true;
}

// Increase xscale to not skip collisions
var _speed_collision_diameter = speed*2 + pseudo3d_diameter;
image_xscale = _speed_collision_diameter / sprite_get_width(sprite_index);
image_yscale = _speed_collision_diameter / sprite_get_height(sprite_index);

#define Pseudo3DEndStep
var _shadow_depth = argument0
var _z_draw_factor = argument1

// Depth
depth = -y;

// Shadow
pseudo3d_shadow_instance.x = round(x);
pseudo3d_shadow_instance.y = round(y);
pseudo3d_shadow_instance.depth = depth+_shadow_depth;
pseudo3d_shadow_instance.sprite_index = pseudo3d_shadow_sprite;
var _shadow_sprite = pseudo3d_shadow_instance.sprite_index;
// Reduce shadow when the object is floating.
var _height_factor = 1;
if pseudo3d_z < 0 or pseudo3d_z > pseudo3d_max_shadow_height {
  pseudo3d_shadow_instance.visible = false;
}
else {
  pseudo3d_shadow_instance.visible = true;
  if pseudo3d_z > 0 {
    _height_factor = 1-(pseudo3d_z/pseudo3d_max_shadow_height);
  }
}
pseudo3d_shadow_instance.image_xscale = pseudo3d_diameter * _height_factor / sprite_get_width(_shadow_sprite);
pseudo3d_shadow_instance.image_yscale = pseudo3d_diameter * _height_factor / sprite_get_height(_shadow_sprite);
pseudo3d_shadow_instance.image_alpha = pseudo3d_shadow_opacity*_height_factor;

//Show
pseudo3d_show_instance.sprite_index = sprite_index;
pseudo3d_show_instance.image_alpha = image_alpha;
pseudo3d_show_instance.image_xscale = pseudo3d_xscale;
pseudo3d_show_instance.image_yscale = pseudo3d_yscale;
pseudo3d_show_instance.image_angle = image_angle;
pseudo3d_show_instance.image_blend = image_blend;
pseudo3d_show_instance.image_index = image_index;
pseudo3d_show_instance.x = round(x);
pseudo3d_show_instance.y = round(y-pseudo3d_z*_z_draw_factor);
pseudo3d_show_instance.depth = depth;

#define Pseudo3DDestroy
with pseudo3d_shadow_instance instance_destroy();
with pseudo3d_show_instance instance_destroy();
#define Pseudo3DCollision
var _object = argument0;

if max(pseudo3d_z, _object.pseudo3d_z) <= min(pseudo3d_z + pseudo3d_height, _object.pseudo3d_z + _object.pseudo3d_height) {
  if shortest_distance_between_lines(xprevious, yprevious, x, y, _object.xprevious, _object.yprevious, _object.x, _object.y) <= (pseudo3d_diameter+_object.pseudo3d_diameter)/2 {
    return true;
  }
}
return false;

#define Pseudo3DShoot
var _shot_object = argument0
var _direction = argument1
var _speed = argument2

// Create shoot_callback before shoot, otherwise it doesn't work well in HTML5.
// If this is not in this order the shoots are shot from the old position when the shooter moves.
var _shoot_callback = instance_create(x, y, shoot_position_set_callback);

var _shoot = instance_create(x, y, shoot);
_shoot.x = x + cos(degtorad(_direction)) * pseudo3d_diameter/2;
_shoot.y = y - sin(degtorad(_direction)) * pseudo3d_diameter/2;
_shoot.pseudo3d_z = pseudo3d_z + pseudo3d_action_height - _shoot.pseudo3d_height/2;
_shoot.direction = _direction;
_shoot.speed = _speed;

_shoot_callback.shoot = _shoot.id;
_shoot_callback.shoot_direction = _direction;
_shoot_callback.shooter_radius = pseudo3d_diameter/2;
_shoot_callback.shooter = id;

return _shoot;

#define shortest_distance_between_lines
_tx1 = argument0;
_ty1 = argument1;
_tx2 = argument2;
_ty2 = argument3;
_ox1 = argument4;
_oy1 = argument5;
_ox2 = argument6;
_oy2 = argument7;

var _eps = 0.001;
var _ux = _tx2-_tx1+_eps;
var _uy = _ty2-_ty1+_eps;

var _vx = _ox2-_ox1+_eps;
var _vy = _oy2-_oy1+_eps;

var _wx = _tx1-_ox1+_eps;
var _wy = _ty1-_oy1+_eps;

var _a = _ux*_ux+_uy*_uy;
var _b = _ux*_vx+_uy*_vy;
var _c = _vx*_vx+_vy*_vy;
var _d = _ux*_wx+_uy*_wy;
var _e = _vx*_wx+_vy*_wy;

var _D = _a*_c - _b*_b;
var _sc;
var _sN;
var _sD = _D;

var _tc;
var _tN;
var _tD = _D;
        
if abs(_D) < _eps {
  _sN = 0.0;
  _sD = 1.0;
  _tN = _e;
  _tD = _c;
} else {
  _sN = (_b*_e - _c*_d);
  _tN = (_a*_e - _b*_d);
  if _sN < 0.0 {
      _sN = 0.0;
      _tN = _e;
      _tD = _c;
  } else if _sN > _sD {
      _sN = _sD;
      _tN = _e + _b;
      _tD = _c;
  }
}
        
if _tN < 0.0 {
  _tN = 0.0;
  if -_d < 0.0 {
    _sN = 0.0;
  } else if -_d > _a {
    _sN = _sD;
  } else {
    _sN = -_d;
    _sD = _a;
  }
} else if _tN > _tD {
  _tN = _tD;
  if (-_d + _b) < 0.0 {
    _sN = 0;
  } else if (-_d + _b) > _a {
    _sN = _sD;
  } else {
    _sN = (-_d + _b);
    _sD = _a;
  }
}

if abs(_sD) < _eps {
  _sc = 0.0
} else {
  _sc = _sN / _sD;
}
if abs(_tD) < _eps {
  _tc = 0.0
} else {
  _tc = _tN / _tD;
}

var _dpx = _wx+_ux*_sc-_vx*_tc;
var _dpy = _wy+_uy*_sc-_vy*_tc;

return sqrt(_dpx*_dpx+_dpy*_dpy);