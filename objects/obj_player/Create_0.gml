/// @description player create event
#region Jumping
	grav = .275;
	term_vel = 4; // fastest player can fall
	jump_spd = -4.15;
#endregion

#region Moving
	move_dir = 0;
	move_spd = 2;
	x_spd = 0;
	y_spd = clamp(0, 0, term_vel);
#endregion


