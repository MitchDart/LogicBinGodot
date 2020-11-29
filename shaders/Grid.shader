shader_type canvas_item;

uniform vec3 gridColor;
uniform float scale = 10.0;
uniform float thickness = 0.04;
uniform float blurRatio = 0.1;

uniform mat4 global_transform = mat4(1.0);
varying vec2 world_position;
uniform float zoom = 1.0;

void vertex(){
    world_position = (global_transform * vec4(VERTEX ,0.0,1.0)).xy;
}


void fragment() {
	float x = fract(world_position.x / scale);
	x = min(x, 1.0 - x);
	
	float y = fract(world_position.y / scale);
	y = min(y, 1.0 - y);
	
	float delta = zoom*blurRatio;
	float edge = thickness/2.0;
	
    float gridX = smoothstep(x - delta, x + delta, thickness);
	float gridY = smoothstep(y - delta, y + delta, thickness);

  	COLOR.a = min(1.0,gridX + gridY);
	COLOR.rgb = gridColor; 
}