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

float3 CalcNormal(float3 n,float3 Normal)
{
    float tw = 256.0f;
    float val;
    texture0.GetDimensions(0, tw, tw, val);
    float uvOff = 1.0f / 100.0f; //sub sampling half the min rate
    float heightN = color(float3(n.x, n.y + uvOff, n.z)*Normal); /*getHeight(float2(uv.x, uv.y + uvOff))*/;
    float heightS = color(float3(n.x, n.y - uvOff, n.z)*Normal); //getHeight(float2(uv.x, uv.y - uvOff));
    float heightE = color(float3(n.x + uvOff, n.y, n.z)*Normal); //getHeight(float2(uv.x + uvOff, uv.y));
    float heightW = color(float3(n.x - uvOff, n.y, n.z)*Normal); //getHeight(float2(uv.x - uvOff, uv.y));
	
    float worldstep = uvOff * 100.0f;
    float3 tangent = normalize(float3(2.0f * worldstep, heightE - heightW, 0.0f));
    float3 bi_tangent = normalize(float3(0.0f, heightN - heightS, 2.0f * worldstep));
    
    float3 Result_1 = cross(bi_tangent, tangent);
    
    float heightN_2 = color(float3(n.x, n.y, n.z + uvOff)*Normal); /*getHeight(float2(uv.x, uv.y + uvOff))*/;
    float heightS_2 = color(float3(n.x, n.y, n.z - uvOff)*Normal); //getHeight(float2(uv.x, uv.y - uvOff));
    float heightE_2 = color(float3(n.x + uvOff, n.y, n.z)*Normal); //getHeight(float2(uv.x + uvOff, uv.y));
    float heightW_2 = color(float3(n.x - uvOff, n.y, n.z)*Normal); //getHeight(float2(uv.x - uvOff, uv.y));
	
    float3 tangent_2 = normalize(float3(2.0f * worldstep, heightE_2 - heightW_2, 0.0f));
    float3 bi_tangent_2 = normalize(float3(0.0f, heightN_2 - heightS_2, 2.0f * worldstep));
    
    float3 Result_2 = cross(bi_tangent_2, tangent_2);
    
    return cross(Result_1, Result_2);
}

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
    //input.normal = CalcNormal(Input,input.normal);
    
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    return output;

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

    output.normal = input.normal;

    return output;
}