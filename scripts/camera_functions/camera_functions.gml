/// @desc  set_cam_x_y(_follow_object)  follow given object with current camera
/// @param {asset.GMObject} _follow_object  camera will follow this object
/// @returns {struct}  struct like cam_x,cam_y
function set_cam_x_y(_follow_object){
	//Exist if there is no player
	if !instance_exists(_follow_object) exit;


	//Get camera target coordinates
	var _cam_x = _follow_object.x - CAM_W/2;
	var _cam_y = _follow_object.y - CAM_H/2;


	//Constrain cam to room borders
	_cam_x = clamp(_cam_x, 0, room_width - CAM_W);
	_cam_y = clamp(_cam_y, 0, room_height - CAM_H);
	
	var _cam_position = {
		cam_x: _cam_x,
		cam_y: _cam_y
	};
	
	return _cam_position;
}