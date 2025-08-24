#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/ll2GWV

void main()
{
	vec2 uv = fragCoord.xy*2. / iResolution.xy-vec2(1.);

	//------------------------------------------------
	// To use in Godot, port this section:
	//------------------------------------------------

	// I picked these somewhat arbitrarily
	const float BARREL = 0.25;
	const float PINCUSHION = 0.25;

	float effect = PINCUSHION; // Set effect to either BARREL or PINCUSHION
	float effect_scale = 1.0;  // Play with this to slightly vary the results

	/// Fisheye Distortion ///
	float d=length(uv);
	float z = sqrt(1.0 + d * d * effect);
	float r = atan(d, z) / 3.14159;
	r *= effect_scale;
	float phi = atan(uv.y, uv.x);

	uv = vec2(r*cos(phi)+.5,r*sin(phi)+.5);

	//------------------------------------------------
	// end relevant logic
	//------------------------------------------------

	fragColor = texture(iChannel0, uv);
}