//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage.
//SHADERTOY PORT FIX

#define X_SCALE 0.95
#define Z_SCALE 0.40

#define Z_SPEED     0.3
#define X_SPEED_MAX 0.5
#define X_CYCLE_SPEED 0.1

#define CAM_YAW_CYCLE_SPEED 0.225
#define CAM_YAW_MAX_ANGLE 1.570796

#define CAM_ROLL_CYCLE_SPEED 0.168
#define CAM_ROLL_MAX_ANGLE 0.6642

#define CEN_POINT_CYCLE_SPEED1 0.562
#define CEN_POINT_CYCLE_SPEED2 0.383
#define CEN_POINT_CYCLE_MAG    0.3

#define COLOR_CYCLE 0.25
#define FADE_POWER 0.3

#define PI 3.1415926535897932384626

void main()
{
	float minRes = min(iResolution.x, iResolution.y);
	fragCoord /= minRes;

	vec2 center = (iResolution.xy / minRes) / 2.0;

	float angle1 = CEN_POINT_CYCLE_SPEED1 * iTime;
	float angle2 = CEN_POINT_CYCLE_SPEED2 * iTime;
	vec2 p = center + vec2(cos(angle1), sin(angle2)) * CEN_POINT_CYCLE_MAG;

	float angle = sin(iTime * CAM_ROLL_CYCLE_SPEED) * CAM_ROLL_MAX_ANGLE;
	float cs = cos(angle);
	float sn = sin(angle);
	fragCoord.xy -= p;
	vec2 newCoord = vec2(
		fragCoord.x * cs + fragCoord.y * sn,
		fragCoord.y * cs - fragCoord.x * sn);
	fragCoord.xy = newCoord;
	fragCoord.xy += p;

	vec2 dCenter = center - fragCoord.xy;

	float height = (iResolution.y / minRes) / 2.0;

	float zCamera = 1.0 / abs(dCenter.y);
	float xCamera = X_SCALE * dCenter.x * zCamera;
	float yCamera = Z_SCALE * zCamera;

	fragCoord.xy = vec2(xCamera, yCamera);

	angle = sin(iTime * CAM_YAW_CYCLE_SPEED) * CAM_YAW_MAX_ANGLE;
	cs = cos(angle);
	sn = sin(angle);
	newCoord = vec2(
		fragCoord.x * cs + fragCoord.y * sn,
		fragCoord.y * cs - fragCoord.x * sn);
	fragCoord.xy = newCoord;

	fragCoord.y += iTime * Z_SPEED;
	fragCoord.x += cos(iTime * X_CYCLE_SPEED) * X_SPEED_MAX;

	vec2 uv;
	if (dCenter.y > 0.0) {
		uv = fragCoord.xy;
	} else {
		uv = fragCoord.xy;
		uv.y *= -1.0;
	}

	uv.x = mod(uv.x, 1.0);
	uv.y = mod(uv.y, 1.0);

	vec4 sans = texture(iChannel0, uv);
	fragColor = vec4(0.0, 0.0, 0.1, 1.0);
	if (sans.w == 1.0)
		fragColor = sans;

	angle = iTime * COLOR_CYCLE;
	angle = mod(angle, 1.0);
	float mag = mod(angle, 1.0/6.0) * 6.0;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	if (angle < 1.0/6.0) {
		r = mag;
		b = 1.;
	} else if (angle < 2.0/6.0) {
		r = 1.;
		b = 1. - mag;
	} else if (angle < 3.0/6.0) {
		r = 1.;
		g = mag;
	} else if (angle < 4.0/6.0) {
		r = 1. - mag;
		g = 1.;
	} else if (angle < 5.0/6.0) {
		g = 1.;
		b = mag;
	} else {
		g = 1. - mag;
		b = 1.;
	}

	vec3 fadeColor = vec3(r,g,b);

	float fade = 1.0 - (1.0 / (1.0 + zCamera * FADE_POWER));
	fragColor.rgb = mix( fragColor.rgb, fadeColor.rgb, fade );
}