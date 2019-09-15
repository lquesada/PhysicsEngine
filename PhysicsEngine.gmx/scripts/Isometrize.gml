#define Isometrize

#define IsometrizeEndStep
depth = -y

#define IsometrizeScale
var _isometric_factor = argument0;
var _isometrize_xscale = argument1;
var _isometrize_yscale = argument2;

//TODO: make local?
result[0] = _isometrize_xscale;
result[1] = _isometrize_yscale * _isometric_factor;
return result;