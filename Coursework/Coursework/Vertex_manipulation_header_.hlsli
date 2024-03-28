
#include "Perlin_noise.hlsli"

float Manipulate_shape_based_on_noise(Texture2D texture0, SamplerState sampler0,float2 tex)
{
    float r = texture0.SampleLevel(sampler0, tex,0).x;
    return r;
}

float Smooth_Noise(float3 Position,int repeat)
{
    float noise = 0.0f;
    
    for (int i = 0; i < repeat; i++)
    {
        float3 Input = float3(Position.x, Position.y, Position.z);
        noise += color(Input);
    
        Input = float3(Position.x + 1, Position.y, Position.z);
        noise += color(Input);
    
        Input = float3(Position.x - 1, Position.y, Position.z);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y - 1, Position.z);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y + 1, Position.z);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y, Position.z + 1);
        noise += color(Input);
    
    
        Input = float3(Position.x, Position.y + 1, Position.z + 1);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y - 1, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y + 1, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x, Position.y - 1, Position.z + 1);
        noise += color(Input);
    
    
    
        Input = float3(Position.x + 1, Position.y, Position.z + 1);
        noise += color(Input);
    
        Input = float3(Position.x - 1, Position.y, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x + 1, Position.y, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x - 1, Position.y, Position.z + 1);
        noise += color(Input);
    
    
    
        Input = float3(Position.x + 1, Position.y + 1, Position.z + 1);
        noise += color(Input);
    
        Input = float3(Position.x - 1, Position.y - 1, Position.z - 1);
        noise += color(Input);
    
    
    
        Input = float3(Position.x - 1, Position.y + 1, Position.z + 1);
        noise += color(Input);
    
        Input = float3(Position.x + 1, Position.y - 1, Position.z + 1);
        noise += color(Input);
    
        Input = float3(Position.x + 1, Position.y + 1, Position.z - 1);
        noise += color(Input);
    
        Input = float3(Position.x - 1, Position.y - 1, Position.z + 1);
        noise += color(Input);
    
        noise = noise / 21.0f;
    }
    
    return noise;
    
}