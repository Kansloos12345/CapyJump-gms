enum pState {
    NORMAL,
    SWING
}

switch (player_state) {
    case pState.NORMAL:
	
        // Standard movement
        move_x = keyboard_check(vk_right) - keyboard_check(vk_left);
        move_x *= move_speed;
		
		if (place_meeting(x + move_x, y, oCol)) {
		    move_x = 0;
		}

        if (place_meeting(x, y+2, oCol)) {
            move_y = 0;
            if (keyboard_check(vk_up) || keyboard_check(ord("X"))) move_y = -jump_speed;
        } 
        else if (place_meeting(x, y-2, oCol) && move_y < 0) {
            move_y = 2;
        } 
        else if (move_y < 7) {
            move_y += 0.3;
        }

        move_and_collide(move_x, move_y, oCol);

		if keyboard_check(vk_right) || keyboard_check(vk_left) {
			 sprite_index = sCapyWalk;	
		} else {
			sprite_index = sCapy;
		}

        if (move_x != 0) {
            image_xscale = sign(move_x);
		}
		
		if (move_y > 0) {
			sprite_index = sCapyJump;
			image_index = 1;
		} else if (move_y < 0) {
			sprite_index = sCapyJump;
			image_index = 0;
		}
		
		if keyboard_check(vk_down) && !keyboard_check(vk_right) && !keyboard_check(vk_left) {
			sprite_index = sCapyDown;
		}

		if (keyboard_check(vk_nokey)) {
		    nokey_timer += delta_time / 1000000;
		    if (nokey_timer >= 5) {
		        sprite_index = sCapySit;
		        image_speed = 1;
		    }
		} else {
		    nokey_timer = 0;
		}
		
	    if (instance_exists(oGrapplingHook)) {
	        if (keyboard_check(vk_down)) {
	            sprite_index = sCapyDown_e;
	        } 
	        else if (move_y != 0) {
	            sprite_index = sCapyJump_e;
	        } 
	        else if (!keyboard_check(vk_left) && !keyboard_check(vk_right)) {
	            sprite_index = sCapyIdle_e;
	        }
			else if (keyboard_check(vk_left) || keyboard_check(vk_right)) {
				sprite_index = sCapyWalk_e
			}
	    }

        break;

	case pState.SWING:
	    if (!variable_instance_exists(self, "swing_angle")) {
	        swing_angle = point_direction(oGrapplingHook.x, oGrapplingHook.y, x, y);
	        swing_ang_vel = 0;
	    }
	    if (variable_instance_exists(self, "swing_angle")) {
	        swing_angle = point_direction(oGrapplingHook.x, oGrapplingHook.y, x, y);
	    }

	    var radius = point_distance(oGrapplingHook.x, oGrapplingHook.y, x, y);
	    var radius_change_speed = 2;
	    var input_force = 0.35;
	    var gravity_force = 0.5;
    
	    // Define a maximum swing velocity
	    var max_swing_velocity = 3; // Adjust this value as needed

	    if (keyboard_check(vk_right)) {
	        swing_ang_vel += input_force;
	    }
	    if (keyboard_check(vk_left)) {
	        swing_ang_vel -= input_force;
	    }

	    if (keyboard_check(vk_down)) {
	        radius += radius_change_speed;
	        if (radius > 240) radius = 240;
	    } 
	    if (keyboard_check(vk_up)) {
	        radius -= radius_change_speed;
	        if (radius < 30) radius = 30;
	    }

	    swing_ang_vel += gravity_force * sin(degtorad(swing_angle + 270));
    
	    // Clamp the swing angular velocity
	    if (abs(swing_ang_vel) > max_swing_velocity) {
	        swing_ang_vel = sign(swing_ang_vel) * max_swing_velocity;
	    }

	    swing_ang_vel *= 0.95;
	    swing_angle += swing_ang_vel;

	    var new_x = oGrapplingHook.x + lengthdir_x(radius, swing_angle);
	    var new_y = oGrapplingHook.y + lengthdir_y(radius, swing_angle);

	    var collided = false;

	    if (place_meeting(new_x, y, oCol)) {
	        collided = true;
	    } else {
	        x = new_x;
	    }

	    if (!collided && !place_meeting(x, new_y, oCol)) {
	        y = new_y;
	    } else {
	        swing_ang_vel = 0;
	    }

	    sprite_index = sCapyHang
	    image_index = 0;
    
	    if (abs(swing_ang_vel) > 0.1) {
	        image_xscale = (swing_ang_vel > 0 ? 1 : -1);
	    }
    
	    if (keyboard_check_released(ord("Z"))) {
	        var launch_force = 3;
	        move_x = lengthdir_x(swing_ang_vel * launch_force, swing_angle + 90);
	        move_y = lengthdir_y(swing_ang_vel * launch_force, swing_angle + 90);
        
	        player_state = pState.NORMAL;
	    }

	break;
}

if (player_state == pState.NORMAL) {
    move_speed = 3;
}


if (keyboard_check_pressed(ord("Z")) && !instance_exists(oGrapplingHook)) {
    var dir = image_xscale;
    var hook = instance_create_layer(x, y, layer, oGrapplingHook);
    hook.direction = point_direction(0, 0, dir, -1);
    hook.speed = 5;
    hook.max_distance = 240; 
    hook.owner = global.owner; 
    hook.retracting = false;
}
