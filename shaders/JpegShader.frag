#pragma header
vec2 uvv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define m 2.*asin(1.)
#define a(x) (x!=0.?1.:1./sqrt(2.))

uniform float ycmpr;


vec3 toYCbCr(vec3 rgb)
{
    return rgb*mat3(0.299,0.587,0.114,-0.168736,-0.331264,0.5,0.5,-0.418688,-0.081312)+vec3(0,.5,.5);
}

vec3 pre( vec2 coord ){
    return floor(256.*(toYCbCr(flixel_texture2D(iChannel0, coord/iResolution.xy).xyz) - .5));
}

vec3 DCT8x8( vec2 coord, vec2 z ) {
    vec3 res = vec3(0);
    for(float x = 0.; x < 8.; x++){
        for(float y = 0.; y < 8.; y++){
            res += pre(coord + vec2(x,y)) *
                cos((2.*x+1.)*z.x*m/16.) *
                cos((2.*y+1.)*z.y*m/16.);
        }
    }
    return res * .25 * a(z.x) * a(z.y);
}

vec3 bufferA(in vec2 fragCoord )
{
    vec2 uv = floor(fragCoord-8.*floor(fragCoord/8.));
    int val = 16;
    int vv = int(uv.x+uv.y*8.);
    if(vv == 0) val = 16;
    else if(vv == 1) val = 11;
    else if(vv == 2) val = 10;
    else if(vv == 3) val = 16;
    else if(vv == 4) val = 24;
    else if(vv == 5) val = 40;
    else if(vv == 6) val = 51;
    else if(vv == 7) val = 51;

    else if(vv == 8) val = 12;
    else if(vv == 9) val = 12;
    else if(vv == 10) val = 14;
    else if(vv == 11) val = 19;
    else if(vv == 12) val = 26;
    else if(vv == 13) val = 58;
    else if(vv == 14) val = 60;
    else if(vv == 15) val = 55;

    else if(vv == 16) val = 14;
    else if(vv == 17) val = 13;
    else if(vv == 18) val = 16;
    else if(vv == 19) val = 24;
    else if(vv == 20) val = 40;
    else if(vv == 21) val = 57;
    else if(vv == 22) val = 69;
    else if(vv == 23) val = 56;

    else if(vv == 24) val = 14;
    else if(vv == 25) val = 17;
    else if(vv == 26) val = 22;
    else if(vv == 27) val = 29;
    else if(vv == 28) val = 51;
    else if(vv == 29) val = 87;
    else if(vv == 30) val = 80;
    else if(vv == 31) val = 62;

    else if(vv == 32) val = 18;
    else if(vv == 33) val = 22;
    else if(vv == 34) val = 37;
    else if(vv == 35) val = 56;
    else if(vv == 36) val = 68;
    else if(vv == 37) val = 109;
    else if(vv == 38) val = 102;
    else if(vv == 39) val = 77;

    else if(vv == 40) val = 24;
    else if(vv == 41) val = 35;
    else if(vv == 42) val = 55;
    else if(vv == 43) val = 64;
    else if(vv == 44) val = 81;
    else if(vv == 45) val = 104;
    else if(vv == 46) val = 113;
    else if(vv == 47) val = 92;

    else if(vv == 48) val = 49;
    else if(vv == 49) val = 64;
    else if(vv == 50) val = 78;
    else if(vv == 51) val = 87;
    else if(vv == 52) val = 103;
    else if(vv == 53) val = 121;
    else if(vv == 54) val = 120;
    else if(vv == 55) val = 101;
    else if(vv == 56) val = 72;
    else if(vv == 57) val = 92;
    else if(vv == 58) val = 95;
    else if(vv == 59) val = 98;

    else if(vv == 60) val = 112;
    else if(vv == 61) val = 100;
    else if(vv == 62) val = 103;
    else if(vv == 63) val = 99;
    float q = (1.+ycmpr*20.)*float(val);
    return vec3((floor(.5+DCT8x8(8.*floor(fragCoord/8.),uv)/q))*q);

}
vec3 toRGB(vec3 ybr)
{
    return (ybr-vec3(0,.5,.5))*mat3(1.,0.,1.402,1.,-.344136,-0.714136,1.,1.772,0.);
}

vec3 inp(vec2 coord){
    return bufferA((coord));
}

vec3 IDCT8x8( vec2 coord, vec2 z ) {
    vec3 res = vec3(0);
    for(float u = 0.; u < 2.; u++){
        for(float v = 0.; v < 2.; v++){
            res += inp(coord + vec2(u,v)) *
                a(u) * a(v) *
                cos((2.*z.x+1.)*u*m/16.) *
                cos((2.*z.y+1.)*v*m/16.);
        }
    }
    return res * .25;
}


void main()
{
    vec2 uv = floor(fragCoord-8.*floor(fragCoord/8.));
    gl_FragColor.rgb = toRGB(IDCT8x8(8.*floor(fragCoord/8.),uv)/256.+.5);
    gl_FragColor.a = flixel_texture2D(bitmap, uvv).a;

}