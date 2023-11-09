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

cbuffer ScreenSizeBuffer : register(b1)
{
    float screenWidth;
    float3 Spadding;
    float screenheight;
    float3 Spadding2;
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
    
    float3 camPos = CameraOrigin;
    
    //float stepSize = 1000.0f;
    int num_of_steps = 32;
    float total_distance = 0.0f;
    
    //float texelSize = 1.0f / screenWidth;
    
    
    
    //No idea how to normalize these coordinates?
    //////
    float3 newCoords = ((2.0 * (input.position.x / screenWidth - 0.5f)), (2.0 * (input.position.y / screenheight - 0.5f)));
    newCoords.x *= screenWidth / screenheight;
    //////
    
    
    
    for (int i = 0.f; i < num_of_steps; i++)
    {
        float currentPos = newCoords + total_distance * CameraForwardDirection;
            
        float distance_to_currentPos = distance_from_sphere(currentPos, float3(screenWidth / 2, screenheight / 2, 6.0f), 3.0f);
        
        //currentPos = -1.f;
            
        if (distance_to_currentPos < 0.001f)
        {
            input.colour = float4(1.0f, 0.0f, 0.0f, 1.0f);
            return input.colour;
        }
            
        if (total_distance > 1000.0f)
        {
            break;
        }

        total_distance += distance_to_currentPos;
    }
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
    
    //float3 camPos = float3(0, 0, -1);
    //float3 camTarget = float3(0, 0, 0);
    
    //Normalize screen coordinates
    
    //Then render the image

}