
const float EPSILON = 0.0001f;

float Distance_between_3Dpoints_(float3 a)
{
    //return distance(b, a);
    
    float x1 = a.x;
    float y1 = a.y;
    float z1 = a.z;
    
    float x = (pow(x1, 2.0));
    float y = (pow(y1, 2.0));
    float z = (pow(z1, 2.0));
    
    //float bums = y - (x * ((20 - x) / 100));
    //float d = ((x * x) + (bums * bums) + (z * z));
    
    float d = (x + y + z);
    d = sqrt(d);
    return d;
}


float Distance_between_3Dpoints_2_(float3 b, float3 a)
{
    return distance(b, a);
    
    float x1 = b.x - a.x;
    float y1 = b.y - a.y;
    float z1 = b.z - a.z;
    
    float x = (pow((x1), 2.0));
    float y = (pow((y1), 2.0));
    float z = (pow((z1), 2.0));
    
    //float bums = y - (x * ((20 - x) / 100));
    //float d = ((x * x) + (bums * bums) + (z * z));
    
    float d = (x + y + z);
    d = sqrt(d);
    return d;
}

float distance_from_sphere(float3 p, float3 c, float r)
{
    float answer = Distance_between_3Dpoints_2_(p,c);
    //float answer = Distance_between_3Dpoints_(p);
    answer = answer - r;
    
    //Add these to the answer for diffrent effects
    //float d2 = (sin(5 * p.x) * sin(5 * p.y) * sin(5 * p.z));
    //float bums = p.y - (p.x * ((20 - p.x) / 100));
    
    //return (distance(p, c) - r);
	//answer < 0 is inside the sphere
	//answer = 0 is on the surface of the sphere
	//answer > 0 is outside the sphere
    return answer;
}

float distance_from_Elipsoid_bound(float3 p, float3 c, float r)
{
   //Better version
    float k0 = Distance_between_3Dpoints_2_(p / c,c);
    float k1 = Distance_between_3Dpoints_2_(p / (c * c), c);
    return (k0 * (k0 - 1.0f)) / k1;
    
    //Worse version
    //float answer = Distance_between_3Dpoints_2_(p / c,c);
    //return ((answer - 1.0f) * min(min(c.x, c.y), c.z)) - r;
}

float distance_from_plane(float3 p,float3 n, float h)
{
    //n must be normalised
    return dot(p, n) + h;
}

//--------------------------------------------------------------------------------

// Calculate lighting intensity based on direction and normal. Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse, float4 position)
{
    float intensity = 1.0f;
    if (position.w == 1.0f)
    {
        intensity = saturate(dot(normal, lightDirection));
}
    else if (position.w == 2.0f)
    {
        intensity = saturate(dot(normal, -lightDirection));
        //return float4(0, 1, 0, 1);
    }
    float4 colour = saturate(ldiffuse * intensity);
    return colour;
}

float4 calcSpecular(float3 lightDirection, float3 normal, float3 viewVector, float4 specularColour, float specularPower)
{
    float3 halfway = normalize(lightDirection + viewVector);
    float specularIntensity = pow(max(dot(normal, halfway), 0.0f), specularPower);
    return saturate(specularColour * specularIntensity);
}

float4 calcAttenuation(float distance, float constantfactor, float linearFactor, float quadraticfactor)
{
    float attenuation = 1.f / ((constantfactor + (linearFactor * distance) + (quadraticfactor * pow(distance, 2))));
    return attenuation;
}

//--------------------------------------------------------------------------------

float3 estimateNormal(float3 p, float3x3 World)
{   
    const float2 k = float2(1, -1);
    
    //Epsilon is not working properly
    const float E = 0.0001f; /*0.0001f;*/
    
    float Additive_x = k.xyy * 0.0001f;
    float Additive_y = k.yyx * 0.0001f;
    float Additive_z = k.yxy * 0.0001f;
    float Additive_w = k.xxx * 0.0001f;
    
    float3 Normal_x = k.xyy * (distance_from_sphere(float3(p + Additive_x), float3(0.0f, 0.0f, 0.6f), 1.0f));
    float3 Normal_y = k.yyx * (distance_from_sphere(float3(p + Additive_y), float3(0.0f, 0.0f, 0.6f), 1.0f));
    float3 Normal_z = k.yxy * (distance_from_sphere(float3(p + Additive_z), float3(0.0f, 0.0f, 0.6f), 1.0f));
    float3 Normal_w = k.xxx * (distance_from_sphere(float3(p + Additive_w), float3(0.0f, 0.0f, 0.6f), 1.0f));
    
    float3 Final_Normal = Normal_x * Normal_y * Normal_z * Normal_w;
    
    Final_Normal = mul(Final_Normal, World);
    
    return normalize(Final_Normal);
    
    
    //float3 Final_Normal = (float3(
    //distance_from_sphere(float3(p.x + 0.0001f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x - 0.0001f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y + 0.0001f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x, p.y - 0.0001f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y, p.z + 0.0001f), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x, p.y, p.z - 0.0001f), float3(0.0f, 0.0f, 0.6f), 1.0f)
    //));
    
    //Final_Normal = mul(Final_Normal, World);
    
    //return normalize(Final_Normal);
    
}

float4 phongIllumination(float3 k_a,float3 k_d,float3 k_s,float alpha,float3 p, float3 eye, float DeltaTime,float3 ViewVector,float3 Position,float3 view2,float3x3 World)
{
    float4 ambientLight = float4(0.5, 0.5, 0.5, 1.0f);
    float4 colour = float4(0.0f, 0.0f, 0.0f,0.0f);
    //ambientLight = ambientLight * k_a;
    //colour = ambientLight * k_a;
    
    //The values in the sin and cos can be anything its for light position
    
    //The lightposition doesnt work as it should not entirley sure
    float4 Light1Pos = float4(4.0f, 0.0f, 0.6f,1.0f); //float3(4.0f * sin(DeltaTime), 2.0f, 4.0f * cos(DeltaTime));
    
    //float3 Light1Intensity = float3(0.8f,0.8f,0.8f);
    
    float3 light1Vector = float3(0.0f,0.0f,0.0f);
    
    float3 Test = mul(Position, World);
    
    light1Vector = (float3(Light1Pos.x, Light1Pos.y, Light1Pos.z) - eye/*eye*/);
    
    float3 light1Direction = (float3(0.6f, 0.0f, -0.3f));
    
    float3 Normal = estimateNormal(view2,World); /*float3(0.0f, 0.0f, 1.0f);*/
    
    //return float4(Normal.x,Normal.y,Normal.z,1.0f);
    
    //Normal = mul(Normal, World);
    //Normal = normalize(Normal);
    
    float attenuation = 0.0f;
    
    attenuation = calcAttenuation(length(light1Vector), 0.0f, 0.125f, 0.0f); 
    
    light1Vector = normalize(light1Vector);
    
    colour = ambientLight + attenuation * calculateLighting(light1Vector, Normal, float4(0.5f, 0.5f, 0.0f, 0.0f), Light1Pos);
    
    colour *= calcSpecular(light1Vector, Normal, ViewVector, float4(1, 1, 1, 1), alpha);
    
    return colour;
}