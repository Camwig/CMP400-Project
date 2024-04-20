
#define NUM_LIGHTS 1

#include "Perlin_noise.hlsli"

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

cbuffer CameraBuffer : register(b1)
{
    float padding;
    float3 cameraPosition;
};

cbuffer ExtraBuffer : register(b2)
{
    matrix lightViewMatrix[NUM_LIGHTS];
    matrix lightProjectionMatrix[NUM_LIGHTS];
}

cbuffer SettingsBuffer : register(b3)
{
    float Octaves;
    float Hurst;
    float2 Padding1;
    float SmoothSteps;
    float3 Padding2;
    float Freq;
    float Amp;
    float2 Padding3;
}

struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
};

OutputType main(InputType input)
{
    OutputType output;
    
    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f;
        
    float noise = 0.0f;
    //float3 Normal = (input.normal);
    
    //Makes use of the [loop] propmpt
    //to make sure the shader iterates over the noise to build on top of it
   [loop]
   for (int i = 1; i <= Octaves; i++)
   {
        //Reduces the frequency so it is more visbly obvious to the user
        Frequency = (i)/Freq; //5.f
        //Makes use of the vertex position as the noise input
        Input = float3(input.position.x * Frequency, input.position.y * Frequency, input.position.z * Frequency);
        //Noise function
        n = color2(Input);
        //Calculates the amplitude we wish to use to edit the noise with
        Amplitude = pow(Frequency, -Hurst);
        if (i != 1) //This is to prevent the amplitude from being edited before the first ocatve of noise has been passed
            Amplitude /= ((Amp*i)); //Edit the amplitude by reducing it
        noise += (n) * Amplitude; //Final output of the noise
    }
    
    [loop]
    for (int k = 1; k <= SmoothSteps; k++)//Smooths the noise for the required amount of steps
        noise = smoothstep(-2.5, 2.5, noise);
    
    //Add ths noise to the current position of the normal by multiplying it to the normal of the position
    //since its a sphere will be perpendicular to the vertex
    input.position.xyz += (noise * input.normal);
    
    float4 worldPosition = mul(input.position, worldMatrix);
    output.viewVector = cameraPosition.xyz - worldPosition.xyz;
    output.viewVector = normalize(output.viewVector);
    
    // Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;
    
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);
    
    output.worldPosition = mul(input.position, worldMatrix).xyz;

    return output;
}