shader_type canvas_item;

// Comment this if you want to use custom radius
#define USE_CIRCUMRADIUS

/** Transition of the mask effect. */
uniform float progress: hint_range(0.0, 1.0) = 0.5;
/** Center of the circle in normalized UV coordinates. */
uniform vec2 center = vec2(0.5);

#ifndef USE_CIRCUMRADIUS
uniform float radius = 0.5;
#endif

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	// Scale coords to non-square screens.
	vec2 ar_uv = vec2(aspect_ratio * UV.x, UV.y);
	vec2 ar_center = vec2(aspect_ratio * center.x, center.y);

	vec2 mask = ar_uv - ar_center;

	#ifdef USE_CIRCUMRADIUS
	float d1 = distance(ar_center, vec2(0.0, 0.0));
	float d2 = distance(ar_center, vec2(0.0, 1.0));
	float d3 = distance(ar_center, vec2(aspect_ratio * 1.0, 0.0));
	float d4 = distance(ar_center, vec2(aspect_ratio * 1.0, 1.0));
	float radius = max(max(d1, d2), max(d3, d4));
	#endif

	COLOR.a = step((1.0 - progress) * radius, length(mask));
}