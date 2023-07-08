shader_type canvas_item;
render_mode unshaded;

const float PI2 = PI / 2.0;
const vec3 UP = vec3(0.0, 0.0, 1.0);

uniform vec2 texture_scale = vec2(0.5, 0.5);
uniform vec2 texture_offset = vec2(0.0, 0.0);

uniform vec3 atmosphere_color = vec3(1.0, 1.0, 1.0);
uniform float atmosphere_intensity = 0.0;

uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
uniform vec3 light_direction = vec3(0.0, 0.0, 1.0);
uniform float light_minimum = 0.0;
uniform float light_maximum = 1.0;

uniform vec3 specular_color = vec3(1.0, 1.0, 1.0);
uniform float specular_intensity = 0.1;
uniform float specular_shininess = 1.0;

uniform float fade = 0.0;

uniform bool pixelize_enabled = false;
uniform float pixelize_scale = 1.0;

float z_from_xy(vec2 vector) {
	return sqrt(1.0 - vector.x * vector.x - vector.y * vector.y);
}

vec2 transform_uv(vec2 uv, vec2 texel) {
	// Center uv coordinates
	uv = (uv - vec2(0.5, 0.5)) * 2.0;
	// Quantize UV resolution
	vec2 resolution = (1.0 / texel) * pixelize_scale;
	return mix(uv, round(uv * resolution) / resolution, float(pixelize_enabled));
}

vec2 spherical_distort(vec2 uv) {
	// Spherical Displacement
	float radius = length(uv);
	float displacement_scale = (radius != 0.0 ? asin(radius) / radius : 0.0) / PI2;
	vec2 displacement = uv * displacement_scale;
	return (displacement + texture_offset) * texture_scale;
}

mat3 generate_normal_matrix(vec3 normal) {
	vec3 T = normalize(cross(normal, vec3(normal.z, -normal.y, -normal.x)));
	vec3 B = normalize(cross(normal, T));
	vec3 N = normal;
	return mat3(T, B, N);
}

vec3 atmospherics(vec3 color, vec3 normal) {
	// Atmospherics
	float atmospheric_coefficient = 1.0 - max(dot(normal, UP), 0.0);
	float atmospheric_density = mix(atmosphere_intensity, 1.0, atmospheric_coefficient);
	
	return mix(color, atmosphere_color, atmospheric_density);
}

vec3 get_diffuse(vec3 normal, vec3 light_normal, vec3 color) {
	// Diffuse
	float light_dot = max(dot(normal, light_normal), 0.0);
	float diffuse_coefficient = mix(light_minimum, light_maximum, light_dot);
	return (color * diffuse_coefficient) * light_color;
}

vec3 get_specular(vec3 normal, vec3 light_normal, float shininess) {
	// Specular
	shininess = mix(1.0, specular_shininess * specular_shininess, shininess);
	float reflect_dot = dot(reflect(-light_normal, normal), UP);
	float specular_coefficient = specular_intensity * pow(max(0.0, reflect_dot), shininess);
	return (specular_color * specular_coefficient) * light_color;
}

void fragment() {
	vec2 uv = transform_uv(UV, TEXTURE_PIXEL_SIZE);
	vec3 normal = vec3(uv, z_from_xy(uv));
	float radius = length(uv);

	vec3 light_normal = normalize(light_direction);

	// Spherical Displacement
	vec2 displaced_uv = spherical_distort(uv);
	
	// Get inputs from samplers
	vec4 input_color = texture(TEXTURE, displaced_uv);
	vec4 input_shininess = texture(SPECULAR_SHININESS_TEXTURE, displaced_uv);
	vec3 input_normal = texture(NORMAL_TEXTURE, displaced_uv).xyz * 2.0 - 1.0;
	input_normal.xy = -input_normal.yx;
	
	// Adjust Normal to Normal Map
	mat3 normal_matrix = generate_normal_matrix(normal);
	vec3 displaced_normal = normal_matrix * input_normal;
	
	float light_dot = smoothstep(-0.4, 0.0, dot(normal, light_normal));
	float global_light = mix(light_minimum, light_maximum, light_dot);
	
	vec3 diffuse = get_diffuse(displaced_normal, light_normal, input_color.rgb);
	vec3 specular = get_specular(displaced_normal, light_normal, input_shininess.r);

	COLOR.rgb = (diffuse + specular) * global_light;
	
	float fade_texels = length(TEXTURE_PIXEL_SIZE) * fade;
	float alpha = 1.0 - smoothstep(1.0 - fade_texels, 1.0, radius);
	COLOR.a = alpha * input_color.a;
}
