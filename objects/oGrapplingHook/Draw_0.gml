draw_set_color(c_black);
if (instance_exists(global.owner)) {
    draw_line(global.owner.x, global.owner.y, x, y);
}
draw_self();
