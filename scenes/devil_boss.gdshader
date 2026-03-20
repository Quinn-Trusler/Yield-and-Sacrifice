shader_type canvas_item;
render_mode unshaded;

// No source_texture needed — Godot passes the sprite's texture automatically
// via the built-in TEXTURE sampler and UV coords.

// --- Color controls ---
uniform float brightness : hint_range(0.0, 2.0) = 1.02;
uniform float contrast   : hint_range(0.0, 2.0) = 1.08;
uniform float saturation : hint_range(0.0, 2.0) = 1.10;
uniform float gamma      : hint_range(0.2, 3.0) = 1.05;

// --- CRT geometry / lens ---
uniform float curvature     : hint_range(0.0, 0.40) = 0;//0.14;
uniform float corner_soften : hint_range(0.0, 0.20) = 0.06;
uniform float vignette      : hint_range(0.0, 1.00) = 0.38;

// --- Scanlines / phosphor ---
uniform float scanline_strength  : hint_range(0.0, 2.0) = 0;//0.95;
uniform float scanline_density   : hint_range(0, 3.0) = 1.15;
uniform float interlace_strength : hint_range(0.0, 1.0) = 0.20;

// Shadow mask (RGB triads)
uniform float mask_strength : hint_range(0.0, 1.0) = 0.22;
uniform float mask_scale    : hint_range(0.5, 4.0) = 1.0;

// --- VHS/VCR artifacts ---
uniform float chroma_offset_px : hint_range(0.0, 6.0) = 1.6;
uniform float luma_smear_px    : hint_range(0.0, 8.0) = 2.2;
uniform float jitter_px        : hint_range(0.0, 8.0) = 1.8;
uniform float wobble_px        : hint_range(0.0, 10.0) = 1.5;

uniform float tape_noise : hint_range(0.0, 1.0) = 0.22;
uniform float tape_lines : hint_range(0.0, 1.0) = 0.35;

uniform float roll_speed    : hint_range(0.0, 1.5) = 0.10;
uniform float roll_strength : hint_range(0.0, 0.6) = 0.15;

// --- Bloom-ish glow ---
uniform float glow_strength  : hint_range(0.0, 2.0) = 0.25;
uniform float glow_threshold : hint_range(0.0, 1.0) = 0.65;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

float hash11(float n) {
	return fract(sin(n) * 43758.5453123);
}

float hash12(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 crt_curve(vec2 uv, float k) {
	vec2 cc = uv * 2.0 - 1.0;
	vec2 d  = cc * cc;
	cc *= 1.0 + k * vec2(d.y, d.x);
	return cc * 0.5 + 0.5;
}

float inside01(vec2 uv) {
	return step(0.0, uv.x) * step(uv.x, 1.0)
	     * step(0.0, uv.y) * step(uv.y, 1.0);
}

vec3 apply_color_controls(vec3 c) {
	c *= brightness;
	c  = mix(vec3(0.5), c, contrast);
	float l = dot(c, vec3(0.2126, 0.7152, 0.0722));
	c  = mix(vec3(l), c, saturation);
	c  = pow(max(c, vec3(0.0)), vec3(1.0 / max(gamma, 0.0001)));
	return c;
}

vec3 triad_mask(vec2 frag_xy) {
	float x = floor(frag_xy.x / max(mask_scale, 0.0001));
	float m = mod(x, 3.0);
	if (m < 1.0) return vec3(1.10, 0.85, 0.85);
	if (m < 2.0) return vec3(0.85, 1.10, 0.85);
	return             vec3(0.85, 0.85, 1.10);
}

// Sample the sprite's built-in texture
vec3 sample_tex(sampler2D tex, vec2 uv) {
    return textureLod(tex, uv, 0.0).rgb;
}

// ---------------------------------------------------------------------------
// Fragment
// ---------------------------------------------------------------------------

void fragment() {
	// Pixel size and resolution derived from the sprite's own texture size
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	vec2 px  = 1.0 / tex_size;
	vec2 res = tex_size;

	float t = TIME;
	vec2 uv = UV;

	// --- VHS line jitter ---
	float y_line = floor(uv.y * res.y);
	float jitter  = (hash11(y_line + floor(t * 15.0) * 37.0) - 0.5) * 2.0;

	// Slow wobble
	uv.x += sin(uv.y * 8.0 + t * 1.2) * (wobble_px * px.x);

	// --- CRT barrel curve ---
	vec2 cuv = crt_curve(uv, curvature);
	float in_bounds   = inside01(cuv);

	// Rounded corners
	vec2 d     = abs(cuv - 0.5) * 2.0;
	float edge = max(d.x, d.y);
	float corner_mask = 1.0 - smoothstep(1.0 - corner_soften, 1.0, edge);

	// --- Chromatic aberration ---
	vec2 chroma = vec2(chroma_offset_px * px.x, 0.0);
	float r = sample_tex(TEXTURE, cuv + chroma).r;
	float g = sample_tex(TEXTURE, cuv).g;
	float b = sample_tex(TEXTURE, cuv - chroma).b;
	vec3 col = vec3(r, g, b);

	// --- Luma smear ---
	float smear = luma_smear_px * px.x;
	vec3 s1 = sample_tex(TEXTURE, cuv + vec2(smear, 0.0));
	vec3 s2 = sample_tex(TEXTURE, cuv - vec2(smear, 0.0));
	col = mix(col, (col + s1 + s2) / 3.0, 0.35);

	// --- Scanlines ---
	float scan     = sin((cuv.y * res.y) * 3.14159 * scanline_density);
	float scan_mul = 1.0 - scanline_strength * (0.5 - 0.5 * scan);
	col *= scan_mul;

	// --- Interlacing ---
	float frag_y = cuv.y * res.y;
	float field  = mod(floor(frag_y) + floor(t * 60.0), 2.0);
	col *= 1.0 - interlace_strength * field * 0.10;

	// --- Rolling tracking bar ---
	float roll_y = fract(t * max(roll_speed, 0.0001));
	float dist   = abs(cuv.y - roll_y);
	float bar    = smoothstep(0.20, 0.0, dist);
	col += bar * roll_strength * vec3(0.12, 0.12, 0.12);

	// --- Tape lines ---
	float line_n = hash11(y_line * 0.7 + floor(t * 12.0) * 11.0);
	float line   = smoothstep(0.985, 1.0, line_n) * tape_lines;
	col += line * vec3(0.18, 0.18, 0.18);

	// --- Grain / specks ---
	vec2 frag_coord = UV * res;
	float n     = hash12(frag_coord + vec2(t * 120.0, t * 90.0));
	float grain = (n - 0.5) * 2.0;
	col += grain * (tape_noise * 0.06);

	float speck = smoothstep(0.995, 1.0,
	              hash12(frag_coord * 0.73 + t * 40.0));
	col += speck * (tape_noise * 0.25);

	// --- Cheap glow ---
	vec3 c0  = col;
	vec3 cx1 = sample_tex(TEXTURE, cuv + vec2(px.x, 0.0));
	vec3 cx2 = sample_tex(TEXTURE, cuv - vec2(px.x, 0.0));
	vec3 cy1 = sample_tex(TEXTURE, cuv + vec2(0.0, px.y));
	vec3 cy2 = sample_tex(TEXTURE, cuv - vec2(0.0, px.y));
	vec3 blur = (c0 + cx1 + cx2 + cy1 + cy2) / 5.0;
	float br  = dot(blur, vec3(0.2126, 0.7152, 0.0722));
	vec3 glow = max(blur - vec3(glow_threshold), vec3(0.0));
	col += glow * glow_strength * (0.5 + 0.5 * br);

	// --- Vignette ---
	vec2 v    = cuv - 0.5;
	float vig = smoothstep(0.9, 0.2, dot(v, v) * 2.2);
	col *= mix(1.0 - vignette, 1.0, vig);

	// --- Shadow mask triads ---
	vec3 mask = triad_mask(UV * res);
	col *= mix(vec3(1.0), mask, mask_strength);

	// --- Color grading ---
	col = apply_color_controls(col);

	// Preserve original sprite alpha
	float alpha = texture(TEXTURE, UV).a;

	// Black outside CRT bounds / rounded corners
	float bounds = in_bounds * corner_mask;
	col *= bounds;

	COLOR = vec4(col, alpha * bounds);
}
