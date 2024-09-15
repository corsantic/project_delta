//Fullscreen toggle
if(keyboard_check(vk_f7))
{
	window_set_fullscreen(!window_get_fullscreen());
}

var _cam_position = set_cam_x_y(follow_object);


//Set cam coordinates
final_cam_x += (_cam_position.cam_x - final_cam_x) * cam_trail_speed;
final_cam_y += (_cam_position.cam_y - final_cam_y) * cam_trail_speed;


//Set the camera coordinates
camera_set_view_pos(CAM, final_cam_x, final_cam_y);