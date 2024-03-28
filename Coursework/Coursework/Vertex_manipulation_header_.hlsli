
#include "Perlin_noise.hlsli"

float Manipulate_shape_based_on_noise(Texture2D texture0, SamplerState sampler0,float2 tex)
{
    float r = texture0.SampleLevel(sampler0, tex,0).x;
    return r;
}

float3 Smooth_Noise(float3 Position,int repeat)
{
    //temp += heightMap[(j * resolution) + i];
    //if (j > 0)
    //{
    //    temp += heightMap[((j - 1) * resolution) + i];
    //}
    //if (j < resolution - 1)
    //{
    //    temp += heightMap[((j + 1) * resolution) + i];
    //}
    //if (i < resolution - 1)
    //{
    //    temp += heightMap[(j * resolution) + (i + 1)];
    //}
    //if (i > 0)
    //{
    //    temp += heightMap[(j * resolution) + (i - 1)];
    //}
    //if (i > 0 && j < resolution - 1)
    //{
    //    temp += heightMap[((j + 1) * resolution) + (i - 1)];
    //}
    //if (j > 0 && i < resolution - 1)
    //{
    //    temp += heightMap[((j - 1) * resolution) + (i + 1)];
    //}
    //if (i > 0 && j > 0)
    //{
    //    temp += heightMap[((j - 1) * resolution) + (i - 1)];
    //}
    //if (i < resolution - 1 && j < resolution - 1)
    //{
    //    temp += heightMap[((j + 1) * resolution) + (i + 1)];
    //}
    //temp = temp / 9;
    //temp_map[(j * resolution) + i] = temp;
    
    float noise = 0.0f;
    
    for (int i = 1; i <= repeat;i++)
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