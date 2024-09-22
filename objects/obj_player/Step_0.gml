/// @description player step event
var _sub_pixel = .5;


#region Get Inputs
	get_controls();
#endregion


#region X Collision and Movement
	//X Movement
	move_dir = right_key - left_key;
	x_spd = move_dir * move_spd[run_type];
	
	if(run_key_check)
	{
		run_type = PLAYER_RUN_TYPE.RUN;
	}
	else
	{
		run_type = PLAYER_RUN_TYPE.WALK;
	}
	
	//Get my face
	if(move_dir != 0 )
	{
		face = move_dir;
	}

	//X Collision
	if(place_meeting(x + x_spd, y, obj_wall))
	{
		//first check if there is a slope to go up
		var _slop_pixel = 2;
		if(!place_meeting(x + x_spd, y - abs(x_spd) - _slop_pixel, obj_wall))
		{
			while (place_meeting(x + x_spd, y, obj_wall))
			{
				y -= _sub_pixel;
			}
		
		}
		//if there is no sloop regular collison
		else{
		
			//Scoot up to wall precisely
			var _pixel_check = _sub_pixel * sign(x_spd);
		
			while(!place_meeting(x +_pixel_check, y, obj_wall))
			{
				x += _pixel_check;
			}
		
			// set x_spd to zero to "collide"
			x_spd = 0;
		}
	}
		

#endregion


#region Y Collision and Movement
	//gravity
		if(coyote_hang_timer > 0)
		{
			//Count down hang timer
			coyote_hang_timer--;
		}
		else
		{	//Apply gravity to the player
			y_spd += grav;
			//No long on the ground
			set_on_ground(false);
		}
	
	//Cap falling speed
		y_spd = clamp(y_spd, 0, term_vel);
	#region Jump
		//Reset/Prepare jump count
			if(on_ground)
			{
				jump_count = 0;
				jump_hold_timer = 0;
				coyote_jump_timer = coyote_jump_frames;
			}
			else
			{
				//if the player is in the air dont do extra jump
				coyote_jump_timer--;
				if(jump_count = 0 && coyote_jump_timer <= 0)
				{
					jump_count = 1;
				}
			}
	
		//Initiate the Jump
			if(jump_key_buffered && jump_count < jump_max)
			{
				//Reset the timer
				jump_key_buffered = false;
				jump_key_buffer_timer = 0;
		
				//Increase the number of performed jumps
				jump_count++;
		
				//Set the jump hold timer
				jump_hold_timer = jump_hold_frames[jump_count - 1];
				
				set_on_ground(false);
			}
		
		//Cut of the jump by releasing the jump button
			if(jump_key_released)
			{
				jump_hold_timer = 0;
			}
	
		// Jump based on the timer/holding the button
			if(jump_hold_timer > 0)
			{
				// Constantly set the yspd to be jumping speed
				y_spd = jump_spd[jump_count - 1];
		
				//Count down the timer
				jump_hold_timer--;
			}
	
	#endregion
	
	
	#region Y Collision
		if(place_meeting(x, y + y_spd, obj_wall))
		{
			//Scoot up  to the wall precisesly
			var _pixel_check = _sub_pixel * sign(y_spd);
		
			while (!place_meeting(x,y + _pixel_check, obj_wall))
			{
				y += _pixel_check;
			}
			
			//Bonk code
			if (y_spd < 0)
			{
				jump_hold_timer = 0;
			}
		
			//set yspd to 0 to collide
			y_spd = 0;
			
		}
	
		if(y_spd >= 0 && place_meeting(x, y+1, obj_wall))
		{
			set_on_ground(true);
		}
		
	#endregion

#endregion



#region Move Player
	x += x_spd;
	y += y_spd;
#endregion



#region Sprite Control
	//walking
	if (abs(x_spd) > 0) {
		//check run_type
		switch(run_type)
		{
			case PLAYER_RUN_TYPE.RUN:
				sprite_index = sprites.run;
				break;
			case PLAYER_RUN_TYPE.WALK:
				//default is just walk so we dont break
			default:
				sprite_index = sprites.walk
				break;
		}
	}
	//not moving
	if (x_spd == 0) {
		sprite_index = sprites.idle;
	}
	//in the air
	if (!on_ground) {
		sprite_index = sprites.jump;
	}
	
	
	//set the collision mask
	mask_index = sprites.idle;
#endregion




