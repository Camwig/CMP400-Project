// Texture pixel/fragment shader
// Basic fragment shader for rendering textured geometry

// Texture and sampler registers
Texture2D texture0 : register(t0);
SamplerState Sampler0 : register(s0);

#include "Perlin_noise.hlsli"

struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

cbuffer ScreenSizeBuffer : register(b0)
{
    float screenWidth;
    float3 Spadding;
    float screenheight;
    float3 Spadding2;
}


float4 main(InputType input) : SV_TARGET
{
	// Sample the pixel color from the texture using the sampler at this texture coordinate location.
    float4 textureColor = float4(0.0, 1.0, 0.0, 1.0); /*texture0.Sample(Sampler0, input.tex);*/

    //Need to do what I did for the ray marching shader so it should get in the newcoords for this to generate properly
    
    float2 Resoloution = float2(screenWidth, screenheight);
    
    float xc = input.tex.x * screenWidth;
    float yc = input.tex.y * screenheight;
    
    float4 newCoords = float4((2.0 * xc / Resoloution.x - 1.0f) /** CameraForwardDirection.x*/, (-2.0 * yc / Resoloution.y + 1.0f), 1.0f, 0.0f);
    
    //float3 xyz = (newCoords.xy, 0);
    
    float n = color(float3(newCoords.x,newCoords.y,newCoords.z));
    
    //float3 Result = float3(0.5 + 0.5 * float3(n,n,n));
    
    return float4(n, n, n, 1.0f);
    
    //float3 xyz = float3(float2(x, y), -sqrt(answer));
    //float n = color(xyz * 4.0f);
    //Result = mix3(0.0f, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, answer)) * float3(1, 1, 1);
    
    return textureColor;
}