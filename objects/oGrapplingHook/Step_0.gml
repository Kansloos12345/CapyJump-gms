// Move the hook
if (!retracting) {
    x += lengthdir_x(speed, direction);
    y += lengthdir_y(speed, direction);
    
    // Check if max distance is reached or collision with walls (oCol)
    if (place_meeting(x, y, oCol) || point_distance(x, y, global.owner.x, global.owner.y) >= max_distance || !keyboard_check(ord("Z"))) {
        retracting = true;
    }
} 
else {
    // Retract the hook faster
    move_towards_point(global.owner.x, global.owner.y, retract_speed);
    
    // If close to the player, destroy the hook
    if (point_distance(x, y, global.owner.x, global.owner.y) < 6) {
        instance_destroy();
    }
}

if (speed == 0) {
	if (keyboard_check_released(ord("Z"))) {
	    with (global.owner) { 
	        swing_state = false;
	        player_state = pState.NORMAL;
	    }
    instance_destroy();
	}
}