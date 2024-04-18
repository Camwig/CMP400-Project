#include "RayHeader.hlsli"

#define NUM_LIGHTS 1

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

cbuffer SettingsBuffer : register(b2)
{
    float Octaves;
    float Hurst;
    float radius;
    float Padding1;
    float3 Position;
    float SmoothSteps;
    float4 Colour;
    float MAx_Distance;
    float3 Padding2;
    float Freq;
    float Amp;
    float2 Padding3;
}

cbuffer LightBuffer : register(b3)
{
    float4 lightambient;
    float4 lightdiffuse[NUM_LIGHTS];
    float4 lightposition[NUM_LIGHTS];
    float4 lightdirection[NUM_LIGHTS];
    float specularPower;
    float3 padding5;
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
    //Set the camera position
    float3 camPos = CameraOrigin;
    //Sets the maximum number of steps for the raymarching
    int num_of_steps = MAx_Distance;
    float total_distance = 0.0f;
    
    float2 Resoloution = float2(screenWidth, screenheight);
    
    //Translates the texture coordinates of the orthomesh we are using as a render target 
    //into screen space(as the quads texture coordinates are often clamped between 0 and 1)
    float xc = input.tex.x * screenWidth;
    float yc = input.tex.y * screenheight;
    
    //We can now translate these screen space coordinates into normalised device coordinates using the the equation used to calculate the 
    //screen space coordinates we can solve for normalised device coordinates
    
    //Xs = (Xndc*(W+W))/2
    //Ys = -(Yndc*(H+H))/2
    
    //Where Xndc,Yndc are position coordinates in normalised device space
    //Xs,Ys are the coordinates in screen space
    //W is the width of the screens resoloutuion
    //H is the height of the screens resoloution
    
    float4 newCoords = float4( (2.0 * xc / Resoloution.x - 1.0f) , (-2.0 * yc / Resoloution.y + 1.0f), 1.0f, 0.0f);
    
    //We then divide by the given values of the projection matrix to allow for the rays to accuratley shoot
    //through the x and y in the near plane
    float xcoord = newCoords.x / Projection[0][0];
    float ycoord = newCoords.y / Projection[1][1];

    //We then translate this vector into the view space of the camera
    //as currently it exists in the view space of the render target mesh
    float4 v = float4(xcoord, ycoord, 1, 0);
    //Normalised in unit length
    float3 viewVector = normalize(mul(v, View));
    //Then translates that direction into world space
    viewVector = normalize(mul(viewVector,World));
    
    //Defines the variables here as to save on GPU writings as much as I can
    //so they are not defined every frame
    float3 currentPos = float3(0, 0, 0);
    float distance_to_currentPos = 0;
    float4 col = Colour;
    float4 new_col = float4(0.0f, 0.0f, 0.0f, 1.0f);
    float4 col2 = float4(0.0f, 0.0f, 0.0f, 1.0f);
    
    //Informs the shader compiler make use of the loop as an
    //iterative process rather than performing each loop indivdually unrolled
    [loop]
    for (int i = 0; i < num_of_steps; i++)
    {
        //Determine the point along a cast ray
        currentPos = camPos + total_distance * viewVector;
        //Determines the distance between the current point along a ray and the defined shape
        distance_to_currentPos = New_Random_Sphere(currentPos, Position, radius, Octaves, Hurst);
        //Applies noise value to the distance between the point along the ray and the surface
        distance_to_currentPos = Apply_Noise(currentPos, distance_to_currentPos, Octaves, Hurst,SmoothSteps,Freq,Amp);

        //Check if the distance is within a certain distance to confirm a hit of the surface
        if (distance_to_currentPos < 0.01f)
        {
            //Apply the colour and lighting value to the point on the screen
            new_col = float4(0.0f, 0.0f, 0.0f, 1.0f);
            col2 = BlingphongIllumination(specularPower, viewVector, Position, currentPos, World, Octaves, Hurst, Position, SmoothSteps, lightambient, lightposition[0], lightdirection[0], lightdiffuse[0], Freq, Amp);
            new_col.xyz += col2;
            return col + new_col;
        }
        //Checks if the total distance we have travelled along the ray has surrpassed the maximum amount of distance the shader is allowed to travel    
        if (total_distance > num_of_steps)
        {
            break;
        }
        //If no intersection is found add the current distance between the two points to the distance to travel
        total_distance += distance_to_currentPos;
    }

    col = float4(0.39f, 0.58f, 0.92f, 1.0f);
    return col;
}