#pragma header

void main() {
    vec2 pos = openfl_TextureCoordv;
    pos = floor(pos * vec2(320, 224)) / vec2(320, 224);
gl_FragColor = flixel_texture2D(bitmap, pos);
}