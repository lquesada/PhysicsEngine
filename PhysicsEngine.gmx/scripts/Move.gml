#define Move


#define MoveSetup
// Overridable
move_direction = null;
move_amount = null;

// Initialize
move_actual_speed = null;
move_just_created = true;

// Create just-created-callback.
var _just_created_callback = instance_create(x, y, just_created_callback);
_just_created_callback.just_created_entity = id;

#define MoveStep
var _min_speed = argument0;
var _max_speed = argument1;
var _acceleration = argument2;
var _friction = argument3;
var _speed_factor = argument4;
var _radius = argument5;
var _collision_objects = argument6;
var _slide_collision = argument7;
var _slide_full_speed = argument8;
var _max_delta_time = argument9;

// Inhibit movement before the item has been drawn.
if move_just_created {
  move_actual_speed = speed;
  speed = 0;
  exit;
}

var _delta_factor = DeltaTime(_max_delta_time)/_speed_factor;
// Apply friction.
speed *= power(1-_friction, _delta_factor);
// Apply acceleration.
if move_amount != null {
  // Apply the acceleration.
  speed += acceleration * power(1-_friction, _delta_factor/2) * _delta_factor;
  // Set the desired direction.
  direction = move_direction;
  // Apply the max speed limit.
  speed = min(speed, _max_speed);
}
// If no current movement, stop if under minspeed.
if move_amount == null and speed < _min_speed {
  speed = 0;
}

// Store the actual speed.
move_actual_speed = speed;
// Apply the delta factor before actually moving.
speed *= _delta_factor;
if move_amount != null {
  // Apply the move amount limit.
  speed = min(speed, move_amount)
}

// Check collisions with walls and sliding.
if speed {
  var _move_speed = speed;
  var _approach = move_with_collision(_radius, _collision_objects);
  speed *= _approach;
  if _slide_collision {
    x += hspeed;
    y += vspeed;
    speed = (1-_approach)*_move_speed;
    move_slide(_collision_objects, _radius, _slide_full_speed);
  }
}

#define MoveEndStep
// Restore the actual speed.
speed = move_actual_speed;

#define move_with_collision
var _radius = argument0;
var _collision_objects = argument1;

var _speed_factor = 1;
var _collision = false;
var _eps = 0.001;
// Check if it's possible to go all the way through.
for (var _i = array_length_1d(_collision_objects)-1; _i >= 0; _i--) {
  var _object = _collision_objects[_i]
  if position_meeting(x + hspeed + sign(hspeed) * _radius, y + vspeed + sign(vspeed) * _radius,  _object) {
    _collision = true;
    break;
  }
}
// If not, binary search.
if _collision {
  var _speed_step = 0.5;
  while _speed_step > _eps {
    _collision = false;
    for (var _i = array_length_1d(_collision_objects)-1; _i >= 0; _i--) {
      var _object = _collision_objects[_i]
      if position_meeting(x + hspeed * _speed_factor + sign(hspeed) * _radius, y + vspeed * _speed_factor + sign(vspeed) * _radius,  _object) {
        _collision = true;
        break;
      }
    }
    if _collision {
      _speed_factor = min(_speed_factor - _speed_step, 0);
    } else {
      _speed_factor = max(_speed_factor + _speed_step, 1);
    }
    _speed_step /= 2;
  }
}
if _speed_factor < _eps {
  _speed_factor = 0;
}
return _speed_factor;
#define move_slide
var _collision_objects = argument0;
var _radius = argument1;
var _slide_full_speed = argument2;

var _move_direction = direction;
var _h_approach = 0;
var _v_approach = 0;
var _move_speed;

// Focus all speed towards v axis.
if speed {
  direction = _move_direction;
  _move_speed = speed;
  hspeed = 0;
  if _slide_full_speed {
    speed = _move_speed;
  }
  _v_approach = move_with_collision(_radius, _collision_objects);
  if _v_approach {
    speed *= _v_approach;
    y += vspeed;
    speed = 0;
  }
}

// Focus all speed towards h axis.
if speed {
  direction = _move_direction;
  _move_speed = speed;
  vspeed = 0;
  if _slide_full_speed {
    speed = _move_speed;
  }
  _h_approach = move_with_collision(_radius, _collision_objects);
  if _h_approach {
    speed *= _h_approach;
    x += hspeed;
    speed = 0;
  }
}

// If couldn't approach in any of the two, just stop.
if not _h_approach and not _v_approach {
  speed = 0;
}