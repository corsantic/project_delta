/// @description player step event
var _sub_pixel = .5;


#region Get Inputs
var _right_key = keyboard_check(vk_right);
var _left_key = keyboard_check(vk_left);
var _jump_key_pressed = keyboard_check_pressed(vk_space);
#endregion

#region X Movement Direction
	move_dir = _right_key - _left_key;
	x_spd = move_dir * move_spd;
#endregion

#region X Collision

	if(place_meeting(x + x_spd, y, obj_wall))
	{
		//Scoot up to wall precisely
		var _pixel_check = _sub_pixel * sign(x_spd);
		
		while(!place_meeting(x +_pixel_check, y, obj_wall))
		{
			x += _pixel_check;
		}
		
		// set x_spd to zero to "collide"
		x_spd = 0;
	}
#endregion


#region Y movement
	//gravity
		y_spd += grav;

	//Jump
	if(_jump_key_pressed && place_meeting(x, y + 1, obj_wall))
	{
		y_spd = jump_spd;
	}

	
	if(place_meeting(x, y+y_spd,obj_wall))
	{
		//Scoot up  to the wall precisesly
		var _pixel_check = _sub_pixel * sign(y_spd);
		
		while (!place_meeting(x,y + _pixel_check, obj_wall))
		{
			y += _pixel_check;
		}
		
		//set yspd to 0 to collide
		y_spd = 0;
	}
	
	
	
#endregion


#region Move Player
	x += x_spd;
	y += y_spd;
#endregion





