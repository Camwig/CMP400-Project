// texture vertex shader
// Basic shader for rendering textured geometry

#define NUM_LIGHTS 1

#include "Perlin_noise.hlsli"

Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

cbuffer CameraBuffer : register(b1)
{
    float3 cameraPosition;
    float padding;
};

cbuffer ExtraBuffer : register(b2)
{
    matrix lightViewMatrix[NUM_LIGHTS];
    matrix lightProjectionMatrix[NUM_LIGHTS];
    float Ocatves;
    float Hurst;
    float2 padding2;
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
    float3 worldPosition : TEXCOOORD1;
    float3 viewVector : TEXCOORD2;
    float4 lightViewPos : TEXCOORD3;
};

OutputType main(InputType input)
{
    OutputType output;
    
    //float n = 0.0f;
    //float multiple = 0.25f;
    //float3 Input = float3(input.position.x * multiple, input.position.y * multiple, input.position.z * multiple);
    //n = color(Input);
    
    //if(n<= -1.0f)
    //{
    //    n = 0.0;
    //}
    
    /*    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f; //color2(Input);
        
    float noise = 0.0f;
    
    //Use the position of sphere
    //float3 d = Distance_between_3DPoints_3_(p, float3(0, 0, 0.6f));
        
    for (int i = 1; i <= Octave; i++)
    {
        //Should be passed in
        Frequency = /*0.5f;
    (i * i) / 5.f;
    Input = float3(p.x * Frequency, p.y * Frequency, p.z * Frequency);
    n = color2(Input);
        //Should be passed in
    Amplitude = /*0.1f;/pow(Frequency, Hurst);
    if (i != 1)
        Amplitude /= ((i) * (9 * i));
    noise += n * Amplitude /*(Amplitude/10.f);
}*/
    
    
    //float3 n = texture0.SampleLevel(sampler0, input.tex, 0).x;
    
    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f; //color2(Input);
        
    float noise = 0.0f;
    
    //Use the position of sphere
    //float3 d = Distance_between_3DPoints_3_(p, float3(0, 0, 0.6f));
        
    for (int i = 1; i <= Ocatves; i++)
    {
        //Should be passed in
        Frequency = 0.5f;/*(i * i);*/
        Input = float3(input.position.x * Frequency, input.position.y * Frequency, input.position.z * Frequency);
        n = color(Input);
        //Should be passed in
        Amplitude = 0.1f;/*pow(Frequency, -Hurst);*/
        //if (i != 1)
        //    Amplitude /= ((i) * (9 * i));
        noise += n * Amplitude /*(Amplitude/10.f)*/;
    }
    
    input.position.xyz += (noise * input.normal);
    
    	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
    output.lightViewPos = mul(input.position, worldMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightViewMatrix[0]);
    output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix[0]);

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

	// Calculate the normal vector against the world matrix only and normalise.
    //input.normal = CalcNormal(Input,input.normal);
    
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    return output;

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

    output.normal = input.normal;

    return output;
}