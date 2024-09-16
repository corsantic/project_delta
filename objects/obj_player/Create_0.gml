/// @description player create event
function set_on_ground(_val = true)
{
	if(_val)
	{
		on_ground = true;
		coyote_hang_timer = coyote_hang_frames;
	}
	else
	{
		on_ground = false;
		coyote_hang_timer = 0;
	}
	
}


controls_setup();

#region Moving
	move_dir = 0;
	move_spd = 2;
	x_spd = 0;
	y_spd = 0;
#endregion

#region Jumping
	grav = .275;
	term_vel = 4; // fastest player can fall
	//jump values for each successive jump
	jump_spd = [-3.15, -2.85];
	jump_hold_frames = [18, 15];
	
	jump_max = 2;
	jump_count = 0;
	jump_hold_timer = 0;
	
	on_ground = true;
	
	#region Coyote Time
		coyote_hang_frames = 2;
		coyote_hang_timer = 0;
		
		//Jump buffer time
		coyote_jump_frames = 4;
		coyote_jump_timer = 0;
		
	#endregion
	
#endregion


