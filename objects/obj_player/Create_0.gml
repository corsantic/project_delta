/// @description player create event

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
	jump_spd = -4.15;
	jump_max = 2;
	jump_count = 0;
	jump_hold_timer = 0;
	jump_hold_frames = 18;
	on_ground = true;
#endregion

