//Move in a circle
dir += rot_spd;

//Get our target position

var _target_x = xstart + lengthdir_x(radius, dir);
var _target_y = ystart + lengthdir_y(radius, dir);

// Get our xspd and yspd
x_spd = _target_x - x;
//x_spd = 0;
y_spd = _target_y - y;
//y_spd = 0;


//Move
x += x_spd;
y += y_spd;