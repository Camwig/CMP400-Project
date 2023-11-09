
cbuffer CameraBuffer : register(b0)
{
    float3 CameraOrigin;
    float padding;
    float3 CameraForwardDirection;
    float padding2;
};

struct InputType
{
    float4 position : SV_POSITION;
    float4 colour : COLOR;
};

float4 main(InputType input) : SV_TARGET
{
    input.colour = float4(1.0f, 0.0f, 0.0f, 1.0f);
    return input.colour;
    
    //RayDesc ray;
    
    //Origin position so the camera position
    //ray.Origin = camera position
    
    //Just need the forward vector from the origin
    //ray.Direction = camera forward direction
    //ray.TMax = maximum extent of the ray
    //ray.TMin = minimum extent of the ray
    
    /*
    
    Loop for length of the ray
    -move along the ray by a set step amount
    -check if we have intersected with the shape
        -if we have set pixel to bright colout
        -if we have NOT keep going
    -if we do not find any intersection set pixel to be some dark colour for background
    
    */
    
    
}