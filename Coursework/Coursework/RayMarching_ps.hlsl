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
    float4x4 Projection;
    float4x4 World;
    float4x4 View;
};

struct InputType
{
    float4 position : SV_POSITION;
    //float4 colour : COLOR;
    float2 tex : TEXCOORD0;
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
    
    //return (distance(p, c) - r);
	//answer < 0 is inside the sphere
	//answer = 0 is on the surface of the sphere
	//answer > 0 is outside the sphere
    return answer;
}

float4 main(InputType input) : SV_TARGET
{
    ////return float4(input.tex.x, input.tex.y, 0, 1);
    ////RayDesc ray;
    
    ////Origin position so the camera position
    ////ray.Origin = CameraOrigin;
    
    ////Just need the forward vector from the origin
    ////ray.Direction = CameraForwardDirection;
    
    ////ray.TMax = 1000000.0f; //maximum extent of the ray
    ////ray.TMin = 0.f; //minimum extent of the ray
    
    //float3 camPos = CameraOrigin;
    
    ////float stepSize = 1000.0f;
    //int num_of_steps = 5000;
    //float total_distance = 0.0f;
    
    ////float texelSize = 1.0f / screenWidth;
    
    
    
    ////No idea how to normalize these coordinates?
    ////////
    
    ////Ortohgonal Matrix
    
    
    ////float3 newCoords = float3(input.tex.x * (screenWidth / 2) - (screenWidth / 4), input.tex.y * (screenheight / 2) - (screenheight / 4), 0); //((2.0 * (input.position.x * screenWidth) / screenWidth - 0.5f), (2.0 * (input.position.y * screenheight) / screenheight - 0.5f));
    ////newCoords.y = -newCoords.y;
    
    
    ////
    ////Perspective matrix
    
    //float2 Resoloution = float2(screenWidth, screenheight);
    //float3 newCoords = float3( (2.0 * (input.tex.x * Resoloution.x) / Resoloution.x - 1.0f), (-2.0 * (input.tex.y* Resoloution.y) / Resoloution.y + 1.0f), 1.0f); 
    
    ////newCoords = float3(newCoords.x * (Resoloution.x/Resoloution.y), newCoords.y, 1.0f);
    
    ////float P00 = 1 / Resoloution * tan(vertical field of view/2);
    ////float p11 = 1/ tan(vertical field of view/2);
    
    //newCoords = float3((newCoords.x / Projection[0][0]), (newCoords.y / Projection[1][1]), 1.0f);
    
    ////newCoords.y = -newCoords.y;
    ////////
    
    ////input.
    
    //for (int i = 0; i < num_of_steps; i++)
    //{
    //    //float3 currentPos = newCoords + total_distance * float3(0, 0, 1); /*CameraForwardDirection*/;
        
    //    float3 currentPos = (camPos * newCoords) + total_distance * CameraForwardDirection; /*CameraForwardDirection*/;
            
    //    float distance_to_currentPos = distance_from_sphere(currentPos, float3(0, 0, 6.0f), 5.0f);
        
    //    //currentPos = -1.f;
            
    //    if (distance_to_currentPos < 10.0f)
    //    {
    //        float4 col = float4(1.0f, 0.0f, 0.0f, 1.0f);
    //        return col;
    //    }
            
    //    if (total_distance > 1000.0f)
    //    {
    //        break;
    //    }

    //    total_distance += distance_to_currentPos;
    //}
    //float4 col = float4(newCoords.x, newCoords.y, 1.0f, 1.0f);
    //return col;
    
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
    
    
    
    
    
    ////////////Diffrent implimentation
    
    
    
    
    
    
    
    
        //return float4(input.tex.x, input.tex.y, 0, 1);
    //RayDesc ray;
    
    //Origin position so the camera position
    //ray.Origin = CameraOrigin;
    
    //Just need the forward vector from the origin
    //ray.Direction = CameraForwardDirection;
    
    //ray.TMax = 1000000.0f; //maximum extent of the ray
    //ray.TMin = 0.f; //minimum extent of the ray
    
    float3 camPos = CameraOrigin;
    
    //float stepSize = 1000.0f;
    int num_of_steps = 5000;
    float total_distance = 0.0f;
    
    //float texelSize = 1.0f / screenWidth;
    
    
    
    //No idea how to normalize these coordinates?
    //////
    
    //Ortohgonal Matrix
    
    
    //float3 newCoords = float3(input.tex.x * (screenWidth / 2) - (screenWidth / 4), input.tex.y * (screenheight / 2) - (screenheight / 4), 0); //((2.0 * (input.position.x * screenWidth) / screenWidth - 0.5f), (2.0 * (input.position.y * screenheight) / screenheight - 0.5f));
    //newCoords.y = -newCoords.y;
    
    
    //
    //Perspective matrix
    
    float2 Resoloution = float2(screenWidth, screenheight);
    float3 newCoords = float3((2.0 * (input.tex.x * (screenWidth) - (screenWidth / 2)) / Resoloution.x - 1.0f) /** CameraForwardDirection.x*/, (-2.0 * ( (input.tex.y * (screenheight) - (screenheight / 2)) / Resoloution.y) + 1.0f), 1.0f);
    
    //newCoords = float3(newCoords.x * (Resoloution.x/Resoloution.y), newCoords.y, 1.0f);
    
    //float P00 = 1 / Resoloution * tan(vertical field of view/2);
    //float p11 = 1/ tan(vertical field of view/2);
    
    newCoords = float3((newCoords.x / Projection[0][0]), (newCoords.y / Projection[1][1]), 1.0f);
    
    newCoords = float3((newCoords.x * View[0][0]), (newCoords.y * View[1][1]), 1.0f);
    
    newCoords = float3((newCoords.x * World[0][0]), (newCoords.y * World[1][1]), 1.0f);
    
    newCoords.y = -newCoords.y;
    //////
    
    //input.
    
    for (int i = 0; i < num_of_steps; i++)
    {
        float3 currentPos = camPos + total_distance * newCoords; /*CameraForwardDirection*/;
        
        //float3 currentPos = (camPos * newCoords) + total_distance * CameraForwardDirection; /*CameraForwardDirection*/;
            
        float distance_to_currentPos = distance_from_sphere(currentPos, float3(-Resoloution.x/2, -Resoloution.y/2, 6.0f), 100.0f);
        
        //currentPos = -1.f;
            
        if (distance_to_currentPos < 100.0f)
        {
            float4 col = float4(1.0f, 0.0f, 0.0f, 1.0f);
            return col;
        }
            
        if (total_distance > 1000.0f)
        {
            break;
        }

        total_distance += distance_to_currentPos;
    }
    float4 col = float4(1.0f ,1.0f, 1.0f, 1.0f);
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