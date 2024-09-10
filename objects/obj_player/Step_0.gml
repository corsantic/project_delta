/// @description player step event
var _sub_pixel = .5;


#region Get Inputs
	get_controls();
#endregion


#region X Collision and Movement
	//X Movement
	move_dir = right_key - left_key;
	x_spd = move_dir * move_spd;

	//X Collision
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


#region Y Collision and Movement
	//gravity
		y_spd += grav;
	//Cap falling speed
	if(y_spd > term_vel) { y_spd = term_vel;}
	//Reset/Prepare jump count
	if(on_ground)
	{
		jump_count = 0;
	}
	else
	{
		//if the player is in the air dont do extra jump
		if(jump_count = 0)
		{
			jump_count = 1;
		}
	}
	
	
	//Jump
	if(jump_key_buffered && jump_count < jump_max)
	{
		//Reset the timer
		jump_key_buffered = false;
		jump_key_buffer_timer = 0;
		
		//Increase the number of performed jumps
		jump_count++;
		
		//set yspd to jump speed
		y_spd = jump_spd;
	}
	//Y Collision
	if(place_meeting(x, y + y_spd, obj_wall))
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
	
	if(y_spd >= 0 && place_meeting(x, y+1, obj_wall))
	{
		on_ground = true;
	}
	else{
		on_ground = false;
	}

#endregion



#region Move Player
	x += x_spd;
	y += y_spd;
#endregion





