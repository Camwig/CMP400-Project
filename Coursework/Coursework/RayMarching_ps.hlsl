#include "Header.hlsli"

Texture2D shaderTexture : register(t0);
Texture2D PerlinTexture : register(t1);
SamplerState SampleType : register(s0);

cbuffer CameraBuffer : register(b0)
{
    float3 CameraOrigin;
    float padding;
    float3 CameraForwardDirection;
    float padding2;
    float distance_from_shape;
    float3 padding3;
    float deltaTime;
    float3 padding4;
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
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOOORD2;
};

float4 main(InputType input) : SV_TARGET
{
    //bool UpdatePerlin = true;
    
    
    float3 camPos = CameraOrigin;
    
    //float stepSize = 1000.0f;
    int num_of_steps = 5000;
    float total_distance = 0.0f;
    
    float2 Resoloution = float2(screenWidth, screenheight);
    
    float xc = input.tex.x * screenWidth;
    float yc = input.tex.y * screenheight;
    
    
    float4 newCoords = float4( (2.0 * xc / Resoloution.x - 1.0f) /** CameraForwardDirection.x*/, (-2.0 * yc / Resoloution.y + 1.0f), 1.0f, 0.0f);

    float xcoord = newCoords.x / Projection[0][0];
    float ycoord = newCoords.y / Projection[1][1];

    float4 v = float4(xcoord, ycoord, 1, 0);
    float3 viewVector = normalize(mul(v, View));
    
    float3 Test = mul(viewVector, World);
    
    viewVector = normalize(mul(viewVector,World));
    
    Test = viewVector;
    
    float shininess = 20.0f;
    
    bool Perlin = false;

    float3 Result = float3(0.0, 0.0, 0.0);
    
    float4 height = PerlinTexture.Sample(SampleType, input.tex,0);
    
    
    //height = mul(height, World);
    
    //height = height * 1.0f;
    
    //if (height < 0.0f)
    //{
    //    height = 0.001f;
    //}
    
    float3 Startpoint = camPos /** viewVector*/;
    
    float3 EndPoint = float3(Test.x - Startpoint.x, Test.y - Startpoint.y, Test.z - Startpoint.z);
    
    
    //Need to figure out how to move from input.tex equivilent of the SDF shape
    
    float4 textureColour = PerlinTexture.Sample(SampleType, input.tex.xy);
    
    
    //EndPoint = mul(EndPoint, World);
    
    float3 new_vector = float3(camPos.xyz - EndPoint.xyz);
    
    new_vector = normalize(new_vector);
    
    //new_vector = viewVector;
    //return height * 30.0f;
    
    for (int i = 0; i < num_of_steps; i++)
    {
        
        float3 currentPos = camPos + total_distance * viewVector; /*CameraForwardDirection*/
        
        //if (i == 0)
        //{
        //    EndPoint = float3(viewVector.x - currentPos.x, viewVector.y - currentPos.y, viewVector.z - currentPos.z);
        //}
        
        //float3 currentPos = (camPos * newCoords) + total_distance * CameraForwardDirection; /*CameraForwardDirection*/;
            
        //float distance_to_currentPos = min(distance_from_sphere(currentPos, float3(1.5f, 0.0f, 0.0f), 2.0f), distance_from_sphere(currentPos, -1 * float3(1.5f, 0.0f, 0.0f), 2.0f));
        
        //float distance_to_currentPos = distance_from_Elipsoid_bound(currentPos, float3(0.2f, 0.25f, 0.05f), 0.1f);
        
        //float3 value = currentPos - 25*(round(currentPos/25.0f));
        
        //float distance_to_currentPos = distance_from_sphere(currentPos, float3(0.0, 0.0f, 0.6f), 1.0f);
        //UpdatePerlin = false;
        
        //float distance_to_currentPos2 = distance_from_sphere(currentPos, EndPoint, 1.0f);
        
        //if (i == 0)
        //{
            //EndPoint = float3(Test.x /*- camPos.x*/, Test.y /*- camPos.y*/, Test.z /*- camPos.z*/);
            //EndPoint += distance_to_currentPos;
            //EndPoint = mul(EndPoint, World);
        //}
        
        //float distance_to_currentPos = distance_from_plane(currentPos, normalize(float3(0.0021f, 0.0045f, 0.001f)), 200.0f);
        
        //float distance_to_currentPos = distance_from_box(currentPos, float3(0.3f, 0.3f, 1.0f));
        
        //float distance_to_currentPos = distance_from_quad(currentPos, float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f));
        
        //float distance_to_currentPos = distance_from_quad(currentPos, float3(0.0f, 0.0f, 0.0f), float3(0.0f,10.0f, 0.0f), float3(10.0f, 10.0f, 0.0f), float3(10.0f, 0.0f, 0.0f));
        
        //vec2 p = (fragCoord.xy / iResolution.y) * 2.0 - 1.0;
        //vec3 xyz = vec3(p, 0);
        //float n = color(xyz.xy * 4.0);
        
        //float2 p = ()

        //float distance_to_currentPos = Random_Sphere(currentPos, float3(0.0, 0.0f, 0.6f), 1.0f, newCoords.x, newCoords.y, newCoords.z, height.r);
        
        //float multiple = 0.25f;
        //float3 Input = float3(currentPos.x * multiple, currentPos.y * multiple, currentPos.z * multiple);
        //float n = color2(Input);
        
        //if (n < 0.0f)
        //{
        //    n = 0.001f;
        //}
        
        //float noise = n * 0.25f;
        
        //distance_to_currentPos -= noise;
        
        //Inital values for the perlin noise to be generated from
        //distance_to_currentPos -= (0.38f*height.r);
        
        
        //float3 xyz = float3(newCoords.xy, -sqrt(distance_to_currentPos));
        //float n = color(xyz * 4.0f);
        //float3 Result = mix3(0.0f, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, distance_to_currentPos)) * float3(1, 1, 1);
        
        //return float4(Result.x, Result.y, Result.z, 1.0f);
        
        //float distance_to_currentPos2 = distance_from_Line(currentPos, float3(camPos.x,camPos.y,camPos.z + 1.0f), EndPoint, 0.1f);
        
        float distance_to_currentPos = Random_Sphere(currentPos, float3(0.0, 0.0f, 0.6f), 1.0f);
        //float distance_to_currentPos = New_Random_Sphere(currentPos, float3(0.0, 0.0f, 0.6f), 1.0f);
            
        if (distance_to_currentPos < 0.01f)
        {
            
            /*new_vector = (camPos + total_distance) + distance_to_currentPos * viewVector*/;
            float3 p = currentPos + (distance_to_currentPos);
            
            float3 SDF_Position = /*currentPos * distance_to_currentPos;*/ float3(5.0f, 0.0f, 5.0f);
            
            new_vector = float3(currentPos.x + distance_to_currentPos * viewVector.x, currentPos.y + distance_to_currentPos * viewVector.y, currentPos.z + distance_to_currentPos * viewVector.z);
            //SDF_Position -= (n * 0.5f);
            
            float4 col = float4(1.0f, 0.5f, 0.5f, 1.0f);
            float4 col2 = phongIllumination(shininess, viewVector, float3(0.0, 0.0f, 0.6f), currentPos, World, camPos, new_vector);
            col = float4(col.x * col2.x, col.y * col2.y, col.z * col2.z, col.w * col2.w);
            return col /** textureColour*/;
        }
            
        if (total_distance > 1000.0f)
        {
            break;
        }

        //Check this is proper sphere tracing
        total_distance += /*0.1f*/distance_to_currentPos;
    }
    
    //float4 col = float4(viewVector.x, viewVector.y, viewVector.z, 1.0f);
    float4 col = float4(0.39f, 0.58f, 0.92f, 1.0f);
    return col;
    
    /*
    
    Loop for length of the ray
    -move along the ray by a set step amount
    -check if we have intersected with the shape
        -if we have set pixel to bright colout
        -if we have NOT keep going
    -if we do not find any intersection set pixel to be some dark colour for background
    
    */
    
    //float3 camPos = float3(0, 0, -1);
    //float3 camTarget = float3(0, 0, 0);
    
    //Normalize screen coordinates
    
    //Then render the image
}