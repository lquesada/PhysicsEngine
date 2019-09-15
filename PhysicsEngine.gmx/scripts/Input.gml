#define Input


#define InputMovement
// returns [direction, amount]; amount is [0, 1].

var _read_keyboard = argument0; // (boolean) determines whether keyboard must be read.
var _keyboard;
if _read_keyboard {
  _keyboard = InputKeyboardMovement();
  if _keyboard[1] > 0 {
    return _keyboard;
  }
}
var _result;
_result[0] = 0;
_result[1] = 0;
return _result;

#define InputKeyboardMovement
// returns [direction, 1000] where direction is obtained from keyboard.

var _h = 0;
var _v = 0;
if keyboard_check(ord('A')) or keyboard_check(vk_left) {
  _h -= 1;
}
if keyboard_check(ord('D')) or keyboard_check(vk_right) {
  _h += 1;
}
if keyboard_check(ord('W')) or keyboard_check(vk_up) {
  _v -= 1;
}
if keyboard_check(ord('S')) or keyboard_check(vk_down) {
  _v += 1;
}
var _amount = 0;
if _h != 0 or _v != 0 {
  _amount = 1000;
}
var _result;
_result[0] = point_direction(0, 0, _h, _v);
_result[1] = _amount;
return _result;