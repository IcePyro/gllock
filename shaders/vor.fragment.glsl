// http://www.shadertoy.com/view/MtfXRN
#version 330 core

// ---- gllock required fields -----------------------------------------------------------------------------------------
#define RATE 1.0

uniform float time;
uniform float end;
uniform sampler2D imageData;
uniform vec2 screenSize;
// ---------------------------------------------------------------------------------------------------------------------


#define MIN_SIZE 0.0f
#define MAX_SIZE 1.0f

int arrSize = 70;

vec2 p[70] = vec2[70] (vec2(0.745, 0.666), vec2(0.739, 0.987), vec2(0.189, 0.109), vec2(0.631, 0.035), vec2(0.579, 0.349), vec2(0.863, 0.238), vec2(0.845, 0.158), vec2(0.887, 0.887), vec2(0.362, 0.261), vec2(0.873, 0.585), vec2(0.771, 0.244), vec2(0.57, 0.909), vec2(0.565, 0.377), vec2(0.906, 0.832), vec2(0.829, 0.284), vec2(0.301, 0.86), vec2(0.104, 0.667), vec2(0.037, 0.287), vec2(0.701, 0.349), vec2(0.628, 0.728), vec2(0.198, 0.36), vec2(0.76, 0.246), vec2(0.507, 0.841), vec2(0.81, 0.482), vec2(0.846, 0.093), vec2(0.36, 0.418), vec2(0.697, 0.864), vec2(0.197, 0.326), vec2(0.989, 0.226), vec2(0.786, 0.517), vec2(0.505, 0.873), vec2(0.752, 0.032), vec2(0.831, 0.179), vec2(0.483, 0.929), vec2(0.071, 0.445), vec2(0.196, 0.945), vec2(0.246, 0.603), vec2(0.193, 0.409), vec2(0.033, 0.666), vec2(0.743, 0.744), vec2(0.113, 0.521), vec2(0.46, 0.093), vec2(0.061, 0.639), vec2(0.471, 0.894), vec2(0.48, 0.99), vec2(0.149, 0.327), vec2(0.724, 0.705), vec2(0.943, 0.67), vec2(0.88, 0.884), vec2(0.521, 0.75), vec2(0.198, 0.552), vec2(0.38, 0.032), vec2(0.445, 0.397), vec2(0.914, 0.626), vec2(0.699, 0.53), vec2(0.136, 0.326), vec2(0.663, 0.833), vec2(0.2, 0.83), vec2(0.417, 0.642), vec2(0.355, 0.969), vec2(0.185, 0.658), vec2(0.159, 0.134), vec2(0.161, 0.182), vec2(0.881, 0.13), vec2(0.412, 0.443), vec2(0.101, 0.694), vec2(0.087, 0.891), vec2(0.075, 0.228), vec2(0.772, 0.295), vec2(0.548, 0.151));

int closest(float x, float y, int maxI){
    int m = 0;
    float md = distance(vec2(x,y), p[0]);
    for(int i = 1; i < min(maxI, arrSize); i++){
        float dist = distance(vec2(x,y), p[i]);
        
        if(dist < md){
            md = dist;
            m = i;
        }
    }
    return m;
}

mat2 rotateFromIndex(int i){
     return mat2(cos(float(i)),-sin(float(i)),
                sin(float(i)),cos(float(i)));
}

vec2 getNewAbsoluteCoordinate(vec2 rawPos, int i){
    vec2 offset = rawPos - p[i];
    
    return p[(i + 1) % (arrSize - 1)] + offset;
    
}
void main(void) {
    float shaderTime = smoothstep(0.0,1.0,(time-end)*RATE);
    shaderTime = (end==0)?shaderTime:(1.0-shaderTime);

    float radius = mix(MIN_SIZE, MAX_SIZE, shaderTime);

    vec2 uv = gl_FragCoord.xy/screenSize;
    
    int maxI = int(radius * arrSize + 1.);
    
    int closeI = closest(uv.x, uv.y, maxI);
    
    mat2 rotation = rotateFromIndex(closeI);
    
    vec2 absolute = rotation * getNewAbsoluteCoordinate(uv.xy, closeI);
    // Time varying pixel color
    vec4 col = texture(imageData, absolute); 

    // Output to screen
    gl_FragColor = col;
}
//
