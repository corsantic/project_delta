/// @description player create event
function set_on_ground(_val = true)
{
	if(_val)
	{
		on_ground = true;
		coyote_hang_timer = coyote_hang_frames;
		//We set y_spd here but we can get back to it later
		y_spd = 0;
	}
	else
	{
		on_ground = false;
		my_floor_plat = noone;
		coyote_hang_timer = 0;
	}	
}

function check_for_semi_solid_platform(_x, _y)
{
	//Create a return variable
	var _return_instance = noone;
	
	// We must not be moving upwards and then we check for a normal collision
	if(y_spd >= 0 && place_meeting(_x, _y, obj_semi_solid_wall))
	{
		//Create a ds list to store all colliding instance of obj_semi_solid_wall
		var _list = ds_list_create();
		var _list_size = instance_place_list(_x, _y, obj_semi_solid_wall, _list, false);
		//Loog through the colliding instances and only return one of it's top is below player
		for(var _i = 0; _i < _list_size; _i++ )
		{
			//Get an instance from wall object list
			var _instance = _list[| _i];
			var _instance_object_index = _instance.object_index;
			
			if (_instance != forget_semi_solid && floor(bbox_bottom) <= ceil(_instance.bbox_top - _instance.y_spd))
			{
				_return_instance = _instance;
				//Exit the loop
				break;
			}
		}
		//Destroy for memory sake
		ds_list_destroy(_list);
	}
	
	
	return _return_instance;
}

function is_crouching(){
	if(run_type == PLAYER_RUN_TYPE.CROUCH)
		return true;
	
	return false;
}
depth = -10;

controls_setup();

#region Sprites
sprites = {	idle: spr_player_idle, walk: spr_player_walk,
			run: spr_player_run, jump: spr_player_jump, 
			crouch: spr_player_crouch};



#endregion


#region Moving
	face = 1;
	move_dir = 0;
	move_spd[PLAYER_RUN_TYPE.WALK] = 2;
	move_spd[PLAYER_RUN_TYPE.RUN] = 3.5;
	crouch_spd = 1;
	run_type = PLAYER_RUN_TYPE.WALK;
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

#region State variables
	crouching = false;

#endregion

//Pixel checks
sub_pixel = .5;
slope_pixel = 1;
 
#region Moving Platform
	early_move_plat_x_spd = false;
	my_floor_plat = noone;
	move_plat_x_spd = 0;
	down_slope_semi_solid = noone;
	forget_semi_solid = noone;

#endregion

crush_timer = 0;
crush_death_time = 5;



