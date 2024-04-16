#include "Perlin_noise.hlsli"

//Distance between 3D point functions make use of the distance equation to calculate the distance between two 3D points
// sqrt\(X2 - X1)^2 + (Y2 - Y1)^2 + (Z2 - Z1)^2


//Initial function to check distance from constant origin of (0,0,0)
float Distance_between_3Dpoints_(float3 a)
{
    float x1 = a.x;
    float y1 = a.y;
    float z1 = a.z;
    
    float x = (pow(x1, 2.0));
    float y = (pow(y1, 2.0));
    float z = (pow(z1, 2.0));
    
    float d = (x + y + z);
    d = sqrt(d);
    return d;
}

//Traditional function to determine the distance between two given points in 3D points
float Distance_between_3Dpoints_2_(float3 b, float3 a)
{
    //return distance(b, a);
    
    float x1 = b.x - a.x;
    float y1 = b.y - a.y;
    float z1 = b.z - a.z;
    
    float x = (pow((x1), 2.0));
    float y = (pow((y1), 2.0));
    float z = (pow((z1), 2.0));
    
    float d = (x + y + z);
    d = sqrt(d);
    return d;
}

//---Continue from here

float New_Random_Sphere(float3 p, float3 c, float r,int Octaves,float Hurst)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
    
    return answer;
}

float Apply_Noise(float3 p,float distance,int Octave,float Hurst,float SmoothSteps)
{
    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f;
        
    float noise = 0.0f;
    
    for (int i = 1; i <= Octave; i++)
    {
        Frequency = (i * i)/5.f;
        Input = float3(p.x * Frequency, p.y * Frequency, p.z * Frequency);
        n = color2(Input);
        Amplitude = pow(Frequency, Hurst);
        if(i != 1)
            Amplitude /= ((i) * (9*i));
        noise += n * Amplitude;
    }
    
    for (int k = 0; k < SmoothSteps; k++)
    {
        noise = smoothstep(-1, 1, noise);
    }

    float answer = distance - noise;
    return answer;
}

float Random_Sphere(float3 p, float3 c, float r)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
    
    float n = 0.0f;
    
    float multiple = 0.5f;
    float3 Input = float3(p.x * multiple, p.y * multiple, p.z * multiple);
    n = color2(Input);
        
    answer -= (n * 0.1);
    
    return answer;
}

float distance_from_Elipsoid_bound(float3 p, float3 c, float r)
{
   //Better version
    float k0 = Distance_between_3Dpoints_2_(p / c,c);
    float k1 = Distance_between_3Dpoints_2_(p / (c * c), c);
    return (k0 * (k0 - 1.0f)) / k1;
}

float distance_from_plane(float3 p,float3 n, float h)
{
    //n must be normalised
    return dot(p, n) + h;
}

float distance_from_Line(float3 p, float3 a, float3 b, float r)
{
    float3 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0f, 1.0f);
    float output = Distance_between_3Dpoints_(pa - ba * h);
    output = output - r;
    return output;

}

float dot2(float3 v)
{
    return dot(v, v);
}

float distance_from_quad(float3 p, float3 a, float3 b,float3 c,float3 d)
{
    float3 ba = b - a; 
    float3 pa = p - a;
    float3 cb = c - b; 
    float3 pb = p - b;
    float3 dc = d - c;
    float3 pc = p - c;
    float3 ad = a - d;
    float3 pd = p - d;
    
    float3 nor = cross(ba, ad);
    
    return sqrt(
    (sign(dot(cross(ba, nor), pa)) +
     sign(dot(cross(cb, nor), pb)) +
     sign(dot(cross(dc, nor), pc)) +
     sign(dot(cross(ad, nor), pd)) < 3.0)
     ?
     min(min(min(
     dot2(ba * clamp(dot(ba, pa) / dot2(ba), 0.0, 1.0) - pa),
     dot2(cb * clamp(dot(cb, pb) / dot2(cb), 0.0, 1.0) - pb)),
     dot2(dc * clamp(dot(dc, pc) / dot2(dc), 0.0, 1.0) - pc)),
     dot2(ad * clamp(dot(ad, pd) / dot2(ad), 0.0, 1.0) - pd))
     :
     dot(nor, pa) * dot(nor, pa) / dot2(nor));
    
}

float distance_from_box(float3 p, float3 b)
{
    float3 q = abs(p) - b;
    return length(max(q, 0.0f)) + min(max(q.x, max(q.y, q.z)), 0.0f);
}

// Calculate lighting intensity based on direction and normal. Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse, float4 position)
{
    float intensity;
    if (position.w == 1.0f)
    {
        intensity = saturate(dot(normal, lightDirection));
    }
    else if (position.w == 2.0f)
    {
        intensity = saturate(dot(normal, -lightDirection));
    }
    float4 colour = saturate(ldiffuse * intensity);
    return colour;
}

float4 calcSpecular(float3 lightDirection, float3 normal, float3 viewVector, float4 specularColour, float specularPower)
{
    float3 halfway = normalize(lightDirection + viewVector);
    float specularIntensity = pow(max(dot(normal, halfway), 0.0f), specularPower);
    return saturate(specularColour * specularIntensity);
}

float4 calcAttenuation(float distance, float constantfactor, float linearFactor, float quadraticfactor)
{
    float attenuation = 1.f / ((constantfactor + (linearFactor * distance) + (quadraticfactor * pow(distance, 2))));
    return attenuation;
}

float3 estimateNormal(float3 p, float4x4 World, int Octave, float Hurst)
{
    
    float3 Final_Normal = (float3(
    New_Random_Sphere(float3(p.x + 0.002f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst) - New_Random_Sphere(float3(p.x - 0.002f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst),
    New_Random_Sphere(float3(p.x, p.y + 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst) - New_Random_Sphere(float3(p.x, p.y - 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst),
    New_Random_Sphere(float3(p.x, p.y, p.z + 0.002f), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst) - New_Random_Sphere(float3(p.x, p.y, p.z - 0.002f), float3(0.0f, 0.0f, 0.6f), 10.0f, Octave, Hurst)
    ));
    Final_Normal = mul(Final_Normal, World);
    return normalize(Final_Normal);
    
}

float3 estimateNormal_2(float3 p,float3 c, float4x4 World, int Octave, float Hurst,float Smoothsteps)
{
    float Input_11 = New_Random_Sphere(float3(p.x + 0.002f, p.y, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_11 = Apply_Noise(float3(p.x + 0.002f, p.y, p.z), Input_11, Octave, Hurst,Smoothsteps);
    
    float Input_12 = New_Random_Sphere(float3(p.x - 0.002f, p.y, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_12 = Apply_Noise(float3(p.x - 0.002f, p.y, p.z), Input_12, Octave, Hurst,Smoothsteps);
    
    float Input_21 = New_Random_Sphere(float3(p.x, p.y + 0.002f, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_21 = Apply_Noise(float3(p.x, p.y + 0.002f, p.z), Input_21, Octave, Hurst,Smoothsteps);
    
    float Input_22 = New_Random_Sphere(float3(p.x, p.y - 0.002f, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_22 = Apply_Noise(float3(p.x, p.y - 0.002f, p.z), Input_22, Octave, Hurst,Smoothsteps);
    
    float Input_31 = New_Random_Sphere(float3(p.x, p.y, p.z + 0.002f), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_31 = Apply_Noise(float3(p.x, p.y, p.z + 0.002f), Input_31, Octave, Hurst,Smoothsteps);
    
    float Input_32 = New_Random_Sphere(float3(p.x, p.y, p.z - 0.002f), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_32 = Apply_Noise(float3(p.x, p.y, p.z - 0.002f), Input_32, Octave, Hurst,Smoothsteps);
    
    float3 Final_Normal = (float3(
    Input_11 - Input_12,
    Input_21 - Input_22,
    Input_31 - Input_32
    ));
    Final_Normal = mul(Final_Normal, World);
    return normalize(Final_Normal);
}

float4 phongIllumination(float shininess, float3 ViewVector, float3 Position, float3 p, float4x4 World, int Octave, float Hurst, float3 Object_pos, float SmoothSteps, float4 ambientLight, float4 Light1Pos, float4 light1Direction, float4 lightColour)
{
    float4 colour = float4(0.0f, 0.0f, 0.0f,0.0f);
    
    float3 light1Vector = float3(0.0f, 0.0f, 0.0f);
    
    float3 Result_pos = mul(Position, World);
    
    light1Vector = (float3(Light1Pos.x, Light1Pos.y, Light1Pos.z) - Result_pos);
   
    float3 Normal = estimateNormal_2(p, Object_pos, World, Octave, Hurst,SmoothSteps);
    
    float attenuation = 0.0f;
    
    attenuation = calcAttenuation(length(light1Vector), 0.5f, 0.125f, 0.0f); 
    
    light1Vector = normalize(light1Vector);
    
    switch (Light1Pos.w)
    {
        case 1.0f:
            colour = ambientLight + attenuation * calculateLighting(light1Vector, Normal, lightColour, Light1Pos);
            colour += calcSpecular(light1Vector, Normal, ViewVector, float4(1, 1, 1, 1), shininess);
            break;
        case 2.0f:
            colour = ambientLight + attenuation * calculateLighting(light1Direction.xyz, Normal, lightColour, Light1Pos);
            colour += calcSpecular(-light1Direction.xyz, Normal, ViewVector, float4(1, 1, 1, 1), shininess);
            break;
    }
    
    return colour;
}