shader_type canvas_item;
render_mode unshaded;

const float PI2 = PI / 2.0;
const vec3 UP = vec3(0.0, 0.0, 1.0);

uniform vec2 texture_scale = vec2(0.5, 0.5);
uniform vec2 texture_offset = vec2(0.0, 0.0);

uniform vec3 atmosphere_color = vec3(1.0, 1.0, 1.0);
uniform float atmosphere_intensity = 4.0;

uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
uniform vec3 light_direction = vec3(0.0, 0.0, 1.0);
uniform float light_minimum = 0.0;
uniform float light_maximum = 1.0;

uniform vec3 specular_color = vec3(1.0, 1.0, 1.0);
uniform float specular_intensity = 0.5;
uniform float specular_shininess = 1.0;

float z_from_xy(vec2 vector) {
	return sqrt(1.0 - vector.x * vector.x - vector.y * vector.y);
}

void fragment() {
	vec2 uv = (UV - vec2(0.5, 0.5)) * 2.0;
	float r = length(uv);

	float displacement_scale = (r != 0.0 ? asin(r) / r : 0.0) / PI2;
	vec2 displacement = uv * displacement_scale;
	
	float z = z_from_xy(displacement);
	vec3 normal = normalize(vec3(displacement, z));
	
	float normal_dot = 1.0 - max(dot(normal, UP), 0.0);
	float atmospheric_density = mix(atmosphere_intensity, 1.0, normal_dot);
	
	float light_dot = max(dot(normal, normalize(light_direction)), 0.0);
	float luminosity = mix(light_minimum, light_maximum, light_dot);
	
	float light_reflect = dot(reflect(-normalize(light_direction), normal), UP);
	float specular = specular_intensity * pow(max(0.0, light_reflect), specular_shininess);
	
	vec2 p = displacement * texture_scale + texture_offset * texture_scale;
	
	vec4 input_color = texture(TEXTURE, p);
	vec3 color = min(mix(input_color.rgb, atmosphere_color, atmospheric_density) * light_color, vec3(1.0, 1.0, 1.0));
	
	COLOR.rgb = color * luminosity + specular * specular_color;
	COLOR.a = (1.0 - floor(r)) * max(atmospheric_density, input_color.a);
}
