/// @description player step event



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
	if(move_dir != PLAYER_MOVE_DIR.STATIC_X)
	{
		face = move_dir;
	}

	//X Collision
	if(place_meeting(x + x_spd, y, obj_wall))
	{
		//first check if there is a slope to go up
		if(!place_meeting(x + x_spd, y - abs(x_spd) - slope_pixel, obj_wall))
		{
			while (place_meeting(x + x_spd, y, obj_wall))
			{
				y -= sub_pixel;
			}
		
		}
		//next, check for ceiling slopes, otherwise, do a regular collison
		else
		{
			//Ceiling Slopes
			if(!place_meeting(x + x_spd, y + abs(x_spd) + slope_pixel, obj_wall))
			{
				while(place_meeting(x + x_spd, y, obj_wall))
				{
					y += sub_pixel;
				}
			}
			//Normal X Collision
			else
			{
				//Scoot up to wall precisely
				var _pixel_check = sub_pixel * sign(x_spd);
		
				while(!place_meeting(x + _pixel_check, y, obj_wall))
				{
					x += _pixel_check;
				}	
		
				// set x_spd to zero to "collide"
				x_spd = 0;
			}

		}
	}
	//Go Down Slopes
	down_slope_semi_solid = noone;
	if(y_spd >= 0 
		&&	!place_meeting(x + x_spd, y + 1, obj_wall) 
		&&	place_meeting(x + x_spd, y + abs(x_spd) + slope_pixel, obj_wall))
	{
		//Check for a semisolid in the way
		down_slope_semi_solid = check_for_semi_solid_platform(x+ x_spd, y + abs(x_spd) + 1)
		if(!instance_exists(down_slope_semi_solid))
		{
			while (!place_meeting(x + x_spd, y + sub_pixel, obj_wall))
			{
					y += sub_pixel;
			}
		}
	}
	
	
	//Move X
	x += x_spd;

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
		#region Upwards Y Collision(with ceiling)
		if(y_spd < 0 && place_meeting(x, y+ y_spd, obj_wall))
		{
			//Jump into sloped ceiling
			var _slope_slide = false;
			if(move_dir == PLAYER_MOVE_DIR.STATIC_X)
			{
				//SlideUpLeft slope
				if(!place_meeting(x - abs(y_spd) - slope_pixel, y + y_spd, obj_wall))
				{
					while(place_meeting(x, y + y_spd, obj_wall))
					{
						x -= 1;
					}
					_slope_slide = true;
				}
				//SlideUpRight slop
				if(!place_meeting(x+ abs(y_spd) + slope_pixel, y + y_spd, obj_wall) )
				{
					while (place_meeting(x, y+y_spd, obj_wall))
					{
						x += 1;
					}
					_slope_slide = true;
				}
			
			}
	
			
			//Normal Y Collision
			if(!_slope_slide)
			{
				y_collision_check(true);
			}
			
		}
		
		#endregion
	
		#region Floor Y Collision
		
		//Check for for solid and semisolid platforms under me
		var _clamp_y_spd = max(0, y_spd);
		var _list = ds_list_create();// create a ds list to store all of the objects we run into
		var _wall_array = array_create(0);
		array_push(_wall_array, obj_wall, obj_semi_solid_wall);
		
		
		//Do the actual check and add object to list
			//we check term_vel to because platforms can moves faster than player falling
		var _list_size = instance_place_list(x, y+1+ _clamp_y_spd + term_vel, _wall_array, _list, false);
		
		
		//Loop through the colliding instances and only return one if its top is bellow the player
		for(var _i = 0; _i < _list_size; _i++)
		{
			//Get an instance from wall object list
			var _instance = _list[| _i];
			var _instance_object_index = _instance.object_index;
			
			//Avoid magnetism
			if((_instance.y_spd <= y_spd || instance_exists(my_floor_plat))
			&& (_instance.y_spd > 0 || place_meeting(x, y+1 + _clamp_y_spd, _instance))) 
			{
				//Return a solid wall or any semisolid walls that are below the player
				if (_instance_object_index == obj_wall 
				|| object_is_ancestor(_instance_object_index, obj_wall))
				|| floor(bbox_bottom) <= ceil(_instance.bbox_top - _instance.y_spd)
				{
					//Return the "highest" wall object
					if(!instance_exists(my_floor_plat)
					|| (_instance.bbox_top + _instance.y_spd) <= (my_floor_plat.bbox_top + my_floor_plat.y_spd)
					|| (_instance.bbox_top + _instance.y_spd) <= bbox_bottom)
					{
						my_floor_plat = _instance;
					}
			
				}
			}
		}
		
		//Destroy the ds list to avoid memory leak
		ds_list_destroy(_list);
		
		//Downslope semisolid for making sure wee dont miss semisolid's while going own slopes
		if(instance_exists(down_slope_semi_solid))
		{
			my_floor_plat = down_slope_semi_solid;
		}
		
		
		
		//One last check to make sure the floor platform is actually below us
		if (instance_exists(my_floor_plat) && !place_meeting(x, y + term_vel, my_floor_plat))
		{
			my_floor_plat = noone;
		}
		
		//Land on the ground platform if there is one
		if(instance_exists(my_floor_plat))
		{
			//Scoot up to our wall precisely
			while(!place_meeting(x, y + sub_pixel, my_floor_plat) && !place_meeting(x, y, obj_wall))
			{
				y += sub_pixel;
			}
			var my_floor_plat_obj_index = my_floor_plat.object_index;
			if((my_floor_plat_obj_index == obj_semi_solid_wall)
			|| object_is_ancestor(my_floor_plat_obj_index, obj_semi_solid_wall))
			{
				while(place_meeting(x, y, my_floor_plat))
				{
					y -= sub_pixel;
				}
			}
			//Floor the y variable
			y = floor(y);
			set_on_ground(true);
		}
		
	#endregion


	#endregion

	//Move Y
	y += y_spd;

#endregion

#region Final Moving platform collision and movement
	#region X - move plat x spd and collision
		// get the move_plat_x_spd
		move_plat_x_spd	= 0;
		if(instance_exists(my_floor_plat))
		{ 
			move_plat_x_spd = my_floor_plat.x_spd;
		}
		
		//Move with move_play_x_speed
		if(place_meeting(x + move_plat_x_spd, y, obj_wall))
		{
			//Scoot up to wall precisely
			var _pixel_check = sub_pixel * sign(move_plat_x_spd);
		
			while(!place_meeting(x + _pixel_check, y, obj_wall))
			{
				x += _pixel_check;
			}	
		
			// set the move_plat_x_spd to 0 to finish collision
			move_plat_x_spd = 0;
		}
	
	//Move 
		x += move_plat_x_spd;
	#endregion



	#region Y - Snap myself to my_floor_plat if its moving vertically
	if(instance_exists(my_floor_plat) 
	&& (my_floor_plat.y_spd != 0 
	||  check_equal_or_ancestor(my_floor_plat.object_index, obj_semi_solid_move_plat))
	)
	{
		//Snap to the top of the floor platform (un-floor our y variable so its not choppy)
		if(!place_meeting(x, my_floor_plat.bbox_top, obj_wall) 
			&& my_floor_plat.bbox_top >= bbox_bottom - term_vel)
		{
			
			y = my_floor_plat.bbox_top;
		}
		
		//Going up into a solid wall while on a semisolid platform
		if(my_floor_plat.y_spd < 0 
		&& place_meeting(x, y +my_floor_plat.y_spd, obj_wall))
		{
			//Get pushed down through the semisolid floor platform
			if(check_equal_or_ancestor(my_floor_plat.object_index, obj_semi_solid_wall))
			{
				var _sub_pixel = .25;
				//Get pushed down
				while place_meeting(x, y + my_floor_plat.y_spd, obj_wall)
				{
					y += _sub_pixel;
				}
				//if we got pushed into a solid wall while going downwards, push ourselves back out
				while place_meeting(x, y, obj_wall)
				{
					y -= _sub_pixel;
				}
				y = round(y);
			}
			//Cancel the my_floor_plat
			set_on_ground(false);
		}
	
	}
	#endregion

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




