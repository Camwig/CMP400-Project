// texture vertex shader
// Basic shader for rendering textured geometry

#include "Perlin_noise.hlsli"

Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

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
};

OutputType main(InputType input)
{
    OutputType output;
    
    float n = 0.0f;
    float multiple = 0.25f;
    float3 Input = float3(input.position.x * multiple, input.position.y * multiple, input.position.z * multiple);
    n = color(Input);
    
    //if(n<= -1.0f)
    //{
    //    n = 0.0;
    //}
    
    
    //float3 n = texture0.SampleLevel(sampler0, input.tex, 0).x;
    
    input.position.xyz += (n * input.normal)*0.5f;
    
    	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

	// Calculate the normal vector against the world matrix only and normalise.
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    return output;

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

    output.normal = input.normal;

    return output;
}