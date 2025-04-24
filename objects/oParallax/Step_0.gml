var bg1 = layer_get_id("parallax1");
var bg2 = layer_get_id("parallax2");
var bg3 = layer_get_id("parallax3");

layer_x(bg1, lerp(0, camera_get_view_x(view_camera[0]), 0.5 ) );
layer_x(bg2, lerp(0, camera_get_view_x(view_camera[0]), 0.7 ) );
layer_x(bg3, lerp(0, camera_get_view_x(view_camera[0]), 0.9 ) );