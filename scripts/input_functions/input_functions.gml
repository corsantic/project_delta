//@description input functions

/// @desc Setup some control values
function controls_setup()
{
	jump_buffer_time = 3;
	jump_key_buffered = false;
	jump_key_buffer_timer = 0;
}


/**
 * Get Player Controls
 */
function get_controls()
{	
	#region movement
		//gamepad keys
		var _gamepad = 0;
		gamepad_set_axis_deadzone(_gamepad, 0.5);
		var _gamepad_right_key_check = gamepad_button_check(_gamepad, gp_padr) + gamepad_axis_value(_gamepad, gp_axislh) > 0;
		var _gamepad_left_key_check =  gamepad_button_check(_gamepad, gp_padl) + gamepad_axis_value(_gamepad, gp_axislh) < 0;
		//keyboard keys
		var _keyboard_right_key_check = keyboard_check(ord("D")) + keyboard_check(vk_right);
		var _keyboard_left_key_check =  keyboard_check(ord("A")) + keyboard_check(vk_left);
			
		right_key =  _keyboard_right_key_check + _gamepad_right_key_check;
		right_key = clamp(right_key, 0, 1);
	
		left_key = _keyboard_left_key_check + _gamepad_left_key_check;
		left_key = clamp(left_key, 0, 1);
	#endregion
	
	#region action
	//Jump
		jump_key_pressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(_gamepad, gp_face1);
		jump_key_pressed = clamp(jump_key_pressed, 0, 1);
	
		jump_key = keyboard_check(vk_space) + gamepad_button_check(_gamepad, gp_face1);
		jump_key = clamp(jump_key, 0, 1);
	
		jump_key_released = keyboard_check_released(vk_space) + gamepad_button_check_released(_gamepad, gp_face1);
		jump_key_released = clamp(jump_key_released, 0, 1);
	//Run
		run_key_check = keyboard_check(vk_shift) + gamepad_button_check(_gamepad, gp_face2);
		run_key_check = clamp(run_key_check, 0, 1);

	
	#endregion
	//Jump key buffering
	if(jump_key_pressed)
	{
		jump_key_buffer_timer = jump_buffer_time;
	}
	
	if(jump_key_buffer_timer > 0)
	{
		jump_key_buffered = true;
		jump_key_buffer_timer--;
	}
	else
	{
		jump_key_buffered = false;
	}


}