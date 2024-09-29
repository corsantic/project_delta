/// @description we are using begin step event for the platforms because we want to make sure platforms code is done before player show up on them

//Move in a circle
dir += rot_spd;

//Get our target position

var _target_x = xstart + lengthdir_x(radius, dir);
var _target_y = ystart + lengthdir_y(radius, dir);

// Get our xspd and yspd
x_spd = _target_x - x;
y_spd = _target_y - y;


//Move
x += x_spd;
y += y_spd;