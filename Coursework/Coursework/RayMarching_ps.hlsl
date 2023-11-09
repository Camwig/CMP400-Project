Texture2D shaderTexture : register(t0);
SamplerState SampleType : register(s0);

cbuffer CameraBuffer : register(b0)
{
    float3 CameraOrigin;
    float padding;
    float3 CameraForwardDirection;
    float padding2;
    float distance_from_shape;
    float3 padding3;
};

struct InputType
{
    float4 position : SV_POSITION;
    float4 colour : COLOR;
};

float Distance_between_3Dpoints_2_(float3 b, float3 a)
{
    float x = (pow((b.x - a.x), 2.0));
    float y = (pow((b.y - a.y), 2.0));
    float z = (pow((b.z - a.z), 2.0));
    float d = (x + y + z);
    d = sqrt(d);
    return d;
}

float distance_from_sphere(float3 p, float3 c, float r)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
	//answer < 0 is inside the sphere
	//answer = 0 is on the surface of the sphere
	//answer > 0 is outside the sphere
    return answer;
}

float4 main(InputType input) : SV_TARGET
{
    
    //RayDesc ray;
    
    //Origin position so the camera position
    //ray.Origin = CameraOrigin;
    
    //Just need the forward vector from the origin
    //ray.Direction = CameraForwardDirection;
    
    //ray.TMax = 1000000.0f; //maximum extent of the ray
    //ray.TMin = 0.f; //minimum extent of the ray
    
    //float3 camPos = CameraOrigin;
    
    //float stepSize = 100.0f;
    //int num_of_steps = 32;
    //float total_distance = 0.0f;
    
    //for (int i = 0.f; i < num_of_steps; i++)
    //{
    //    //if (camPos = distance_from_shape)
    //    //{
    //    float currentPos = CameraOrigin + total_distance *CameraForwardDirection;
            
    //        currentPos = distance_from_sphere(CameraOrigin, float3(0.0f, 1.0f, 0.0f), 3.0f);
            
    //        if (currentPos < 0.f)
    //        {
    //            input.colour = float4(1.0f, 0.0f, 0.0f, 1.0f);
    //            return input.colour;
    //        }
            
    //        if (currentPos > 1000.0f)
    //        {
    //            break;
    //        }

    //        total_distance += currentPos;
    //    //}
    //}
    input.colour = float4(1.0f, 1.0f, 1.0f, 1.0f);
    return input.colour;
    
    /*
    
    Loop for length of the ray
    -move along the ray by a set step amount
    -check if we have intersected with the shape
        -if we have set pixel to bright colout
        -if we have NOT keep going
    -if we do not find any intersection set pixel to be some dark colour for background
    
    */
    
    
}