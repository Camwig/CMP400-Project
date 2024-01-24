float Distance_between_3Dpoints_2_(float3 b, float3 a)
{
    return distance(b, a);
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

float3 phongIllumination(float3 k_a,float3 k_d,float3 k_s,float alpha,float3 p, float3 eye)
{
    const float3 ambientLight = 0.5f * float3(1.0, 1.0, 1.0);
    float3 colour = ambientLight * k_a;
    
    //The values in the sin and cos can be anything its for light position
    float3 Light1Pos = float3(4.0f * sin(10), 2.0f, 4.0f * cos(10));
    
    float3 Light1Intensity = float3(0.4f,0.4f,0.4f);
    
    //colour += //PhongContribForLight

    float3 Light2Pos = float3(2.0f * sin(10 * 0.37), 2.0f * cos(10 * 0.37),2.0f);
    
    float3 Light2Intensity = float3(0.4f,0.4f,0.4f);
    
    //colour += //PhongContribForLight
    
    return colour;

}