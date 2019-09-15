#define Distance

#define shortest_distance_between_lines
_tx1 = argument0;
_ty1 = argument1;
_tx2 = argument2;
_ty2 = argument3;
_ox1 = argument4;
_oy1 = argument5;
_ox2 = argument6;
_oy2 = argument7;

var _eps = 0.00000001;
var _ux = _tx2-_tx1+_eps;
var _uy = _ty2-_ty1+_eps;

var _vx = _ox2-_ox1+_eps;
var _vy = _oy2-_oy1+_eps;

var _wx = _tx1-_ox1+_eps;
var _wy = _ty1-_oy1+_eps;

var _a = ux*ux+uy*uy;
var _b = ux*vx+uy*vy;
var _c = vx*vx+vy*vy;
var _d = ux*wx+uy*wy;
var _e = vx*wx+vy*wy;

var _D = a*c - b*b;

var _sc;
var _sN;
var _sD = D;

var _tc;
var _tN;
var _tD = D;
        
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
