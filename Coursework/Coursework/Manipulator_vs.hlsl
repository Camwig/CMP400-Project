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
    
    //    //output.position = input.position;
    //input.position.y += getHeight(input.tex, texture0, sampler0, height);
    
    /*float getHeight(float2 _uv, Texture2D texture0, SamplerState sampler0, float offset)
{
    //Sample the height map texture and then multiplies it by the offset value
    //Which then returns the height value
    float3 height = texture0.SampleLevel(sampler0, _uv, 0).x;
    return height.r * offset;
}*/
    
    //float3 height = texture0.SampleLevel(sampler0, input.tex, 0).x;
    //input.position.xyz += height * 1.f;

	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
    float n = 0.0f;
    float multiple = 0.25f;
    float3 Input = float3(input.normal.x * multiple, input.normal.y * multiple, input.normal.z * multiple);
    n = color(Input);
    
    //if(n<= -1.0f)
    //{
    //    n = 0.0;
    //}
    
    
    //float3 n = texture0.SampleLevel(sampler0, input.tex, 0).x;
    
    output.position.xyz += (n * input.normal)*0.5f;

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

    output.normal = input.normal;

    return output;
}