//@description Player Function we are using in player object


/// @desc  Y Collision check
/// @param {bool} [_is_upward]=false check if upward collision because of the bonk
function y_collision_check(_is_upward = false)
{
	//Scoot up to the wall precisesly
	var _pixel_check = sub_pixel * sign(y_spd);
		
	while (!place_meeting(x,y + _pixel_check, obj_wall))
	{
		y += _pixel_check;
	}
			
	//Bonk code
	if (_is_upward && y_spd < 0)
	{
		jump_hold_timer = 0;
	}
		
	//set yspd to 0 to collide
	y_spd = 0;
				
}