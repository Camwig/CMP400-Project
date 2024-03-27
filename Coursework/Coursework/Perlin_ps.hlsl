// Texture pixel/fragment shader
// Basic fragment shader for rendering textured geometry

// Texture and sampler registers
Texture2D texture0 : register(t0);
SamplerState Sampler0 : register(s0);

#include "Perlin_noise.hlsli"

cbuffer CameraBuffer : register(b0)
{
    float3 CameraOrigin;
    float padding;
};

cbuffer ScreenSizeBuffer : register(b1)
{
    float screenWidth;
    float3 Spadding;
    float screenheight;
    float3 Spadding2;
    float4x4 Projection;
    float4x4 World;
    float4x4 View;
};

struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

float4 main(InputType input) : SV_TARGET
{
    float3 camPos = CameraOrigin;
    
	// Sample the pixel color from the texture using the sampler at this texture coordinate location.
    float4 textureColor = float4(0.0, 1.0, 0.0, 1.0); /*texture0.Sample(Sampler0, input.tex);*/

    //Need to do what I did for the ray marching shader so it should get in the newcoords for this to generate properly
    
    float2 Resoloution = float2(screenWidth, screenheight);
    
    float xc = input.tex.x * screenWidth;
    float yc = input.tex.y * screenheight;
    
    float4 newCoords = float4((2.0 * xc / Resoloution.x - 1.0f) /** CameraForwardDirection.x*/, (-2.0 * yc / Resoloution.y + 1.0f), 1.0f, 0.0f);
    
    float xcoord = newCoords.x / Projection[0][0];
    float ycoord = newCoords.y / Projection[1][1];
    
    float4 v = float4(xcoord, ycoord, 1, 0);
    float3 viewVector = normalize(mul(v, View));
    
    viewVector = normalize(mul(viewVector, World));
    
    float3 currentPos = camPos * viewVector; /*CameraForwardDirection*/
    
    //float3 xyz = (newCoords.xy, 0);
    
    float n = color2(float3(currentPos.x * 0.5, currentPos.y * 0.5, currentPos.z * 0.5));
    
    //float3 Result = float3(0.5 + 0.5 * float3(n,n,n));
    
    return float4(n, n, n, 1.0f);
    
    //float3 xyz = float3(float2(x, y), -sqrt(answer));
    //float n = color(xyz * 4.0f);
    //Result = mix3(0.0f, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, answer)) * float3(1, 1, 1);
    
    //return textureColor;
}