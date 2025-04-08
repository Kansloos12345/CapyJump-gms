if (place_meeting(x, y, oCol)) {
    
    // Step back until no collision
    while (place_meeting(x, y, oCol)) {
        x -= lengthdir_x(1, direction);
        y -= lengthdir_y(1, direction);
    }

    swing_ang_vel = 0; // Stop unintended velocity

    if (keyboard_check(ord("Z"))) {
        retract_speed = 0;
        with (global.owner) { 
            swing_state = true; 
            player_state = pState.SWING;
        }
    }
}

if (keyboard_check_released(ord("Z"))) {
    with (global.owner) {
        swing_state = false;
        swing_ang_vel = 0;
        player_state = pState.NORMAL;
    }
    instance_destroy();
}
