/**
 * @description check if object_index is equal to given object or ancestor of it
 * @param {Asset.GMObject} _object_index object_index of a object
 * @param {Asset.GMObject} _object_to_check equality check object
 */
function check_equal_or_ancestor(_object_index, _object_to_check){
	return (_object_index == _object_to_check || object_is_ancestor(_object_index, _object_to_check));
}