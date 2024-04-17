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

//Determines the distance from any point in space to the origin point of the sphere offset by the radius
float New_Random_Sphere(float3 p, float3 c, float r,int Octaves,float Hurst)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
    
    return answer;
}

//Applies perlin noise to the given surface
float Apply_Noise(float3 p,float distance,int Octave,float Hurst,float SmoothSteps,float Freq,float Amp)
{
    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f;
        
    float noise = 0.0f;
    
    //for each octave create the input for the nosie based on the current position of the point on the ray
    //Multiplying the input by a frequency value will result in a greater amount of occurance of the noise
    //and applying an amplitude value to the output will result in a greater change in the diffrence of the noise
    //[unroll(10)]
    for (int i = 1; i <= Octave; i++)
    {
        Frequency = (i*i)/Freq; //5.f
        Input = float3(p.x * Frequency, p.y * Frequency, p.z * Frequency);
        n = color2(Input);
        Amplitude = pow(Frequency, Hurst);
        if (i != 1)
            Amplitude /= Amp;
        noise += n * Amplitude;
    }
    
    //Number of times to run the Hermite interpolation
    for (int k = 1; k <= SmoothSteps; k++)
    {
        noise = smoothstep(-1, 1, noise);
    }

    float answer = distance + noise;
    return answer;
}

// Calculate lighting intensity based on direction and normal and then Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse, float4 position)
{
    float intensity;
    //Depending on the position w value we can tell the type of light being calculated
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

//Bling-phong speclar lighting calculation to determine the amount of specular light on the surface based on the position of the surface relative to the camera
float4 calcSpecular(float3 lightDirection, float3 normal, float3 viewVector, float4 specularColour, float specularPower)
{
    float3 halfway = normalize(lightDirection + viewVector);
    float specularIntensity = pow(max(dot(normal, halfway), 0.0f), specularPower);
    return saturate(specularColour * specularIntensity);
}

//Calculates the attenuation of the lighing using the factors of the light fall off
float4 calcAttenuation(float distance, float constantfactor, float linearFactor, float quadraticfactor)
{
    float attenuation = 1.f / ((constantfactor + (linearFactor * distance) + (quadraticfactor * pow(distance, 2))));
    return attenuation;
}

//Normal calculation making use of central diffrences to detrmine the rate of change at this point which equal to the gradient
//which is then translated into the world coordinates and normalised to unit length

//This version of the normal calculation is done without the noise
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

//This version applies the noise at the given locations based off the same factors as determinging its position in space
//Performs the same logic as above but with the noise correctly applied
float3 estimateNormal_2(float3 p,float3 c, float4x4 World, int Octave, float Hurst,float Smoothsteps,float Freq,float Amp)
{
    float Input_11 = New_Random_Sphere(float3(p.x + 0.002f, p.y, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_11 = Apply_Noise(float3(p.x + 0.002f, p.y, p.z), Input_11, Octave, Hurst,Smoothsteps,Freq,Amp);
    
    float Input_12 = New_Random_Sphere(float3(p.x - 0.002f, p.y, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_12 = Apply_Noise(float3(p.x - 0.002f, p.y, p.z), Input_12, Octave, Hurst, Smoothsteps, Freq, Amp);
    
    float Input_21 = New_Random_Sphere(float3(p.x, p.y + 0.002f, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_21 = Apply_Noise(float3(p.x, p.y + 0.002f, p.z), Input_21, Octave, Hurst, Smoothsteps, Freq, Amp);
    
    float Input_22 = New_Random_Sphere(float3(p.x, p.y - 0.002f, p.z), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_22 = Apply_Noise(float3(p.x, p.y - 0.002f, p.z), Input_22, Octave, Hurst, Smoothsteps, Freq, Amp);
    
    float Input_31 = New_Random_Sphere(float3(p.x, p.y, p.z + 0.002f), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_31 = Apply_Noise(float3(p.x, p.y, p.z + 0.002f), Input_31, Octave, Hurst, Smoothsteps, Freq, Amp);
    
    float Input_32 = New_Random_Sphere(float3(p.x, p.y, p.z - 0.002f), float3(c.x, c.y, c.z), 0.5f, Octave, Hurst);
    Input_32 = Apply_Noise(float3(p.x, p.y, p.z - 0.002f), Input_32, Octave, Hurst, Smoothsteps, Freq, Amp);
    
    float3 Final_Normal = (float3(
    Input_11 - Input_12,
    Input_21 - Input_22,
    Input_31 - Input_32
    ));
    Final_Normal = mul(Final_Normal, World);
    return normalize(Final_Normal);
}

//Function below applies the correct lighting resultant to a point on a surface
float4 BlingphongIllumination(float shininess, float3 ViewVector, float3 Position, float3 currentP, float4x4 World, int Octave, float Hurst, float3 Object_pos, float SmoothSteps, float4 ambientLight, float4 Light1Pos, float4 light1Direction, float4 lightColour,float Freq, float Amp)
{
    float4 colour = float4(0.0f, 0.0f, 0.0f,0.0f);
    
    float3 light1Vector = float3(0.0f, 0.0f, 0.0f);
    
    //Translates the position of the distance field to world space
    float3 Result_pos = mul(Position, World);
    
    //Vector denoting the direction of the light
    light1Vector = (float3(Light1Pos.x, Light1Pos.y, Light1Pos.z) - Result_pos);
   
    //Normal of the current point on the surface
    float3 Normal = estimateNormal_2(currentP, Object_pos, World, Octave, Hurst, SmoothSteps, Freq, Amp);
    
    float attenuation = 0.0f;
    
    attenuation = calcAttenuation(length(light1Vector), 0.5f, 0.125f, 0.0f); 
    
    //Normalise the light vector to unit length for the lighting calculation
    light1Vector = normalize(light1Vector);
    
    //Check the type of light based of the unused w value of the light position to determine the type of lighting the shader is performing
    //Make use of a switch statement to avoid unncesary branching and checks in the shader
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