#define View


#define ViewSetup
view_enabled = true;
view_visible[0] = true;
view_hspeed[0] = -1;
view_vspeed[0] = -1;

#define ViewToInstance
var _instance = argument0;

view_xview[0] = round(_instance.x) - view_wview[0] / 2;
view_yview[0] = round(_instance.y) - view_hview[0] / 2;

#define ViewResize
var _xscale = argument0;
var _yscale = argument1;

var _wnew = window_get_width()*_xscale;
var _hnew = window_get_height()*_yscale;
if view_wview[0] != _wnew or view_hview[0] != _hnew {
  view_wview[0] = _wnew
  view_hview[0] = _hnew
  surface_resize(application_surface, window_get_width(), window_get_height());
}