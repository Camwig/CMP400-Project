
const float EPSILON = 0.0001;

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

float3 estimateNormal(float3 p)
{
    return normalize(float3(
    distance_from_sphere((float3(p.x + EPSILON, p.y, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f)) - distance_from_sphere((float3(p.x - EPSILON, p.y, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f)),
    distance_from_sphere((float3(p.x, p.y + EPSILON, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f)) - distance_from_sphere((float3(p.x, p.y - EPSILON, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f)),
    distance_from_sphere((float3(p.x, p.y, p.z + EPSILON), float3(0.0f, 0.0f, 6.0f), 1.0f)) - distance_from_sphere((float3(p.x, p.y, p.z - EPSILON), float3(0.0f, 0.0f, 6.0f), 1.0f))
    ));
}

float3 phongContributeForLight(float3 k_d, float3 k_s, float alpha, float3 p, float3 eye, float3 lightPos, float3 lightIntensity)
{
    float3 N = estimateNormal(p);
    float3 L = normalize(lightPos - p);
    float3 V = normalize(eye - p);
    float3 R = normalize(reflect(-L, N));
    
    float dotLN = dot(L, N);
    float dotRV = dot(R, V);
    
    if (dotLN < 0.0f)
    {
        //Light not visible from this point on the surface
        return float3(0.0f, 0.0f, 0.0f);
    }
    
    if (dotRV < 0.0f)
    {
        //Light reflection in opposite direction as viewer, apply only diffuse component
        return lightIntensity * (k_d * dotLN);
    }
    
    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));

}

float3 phongIllumination(float3 k_a,float3 k_d,float3 k_s,float alpha,float3 p, float3 eye)
{
    const float3 ambientLight = 0.5f * float3(1.0, 1.0, 1.0);
    float3 colour = ambientLight * k_a;
    
    //The values in the sin and cos can be anything its for light position
    float3 Light1Pos = float3(4.0f * sin(10), 2.0f, 4.0f * cos(10));
    
    float3 Light1Intensity = float3(0.4f,0.4f,0.4f);
    
    colour += phongContributeForLight(k_d, k_s, alpha, p.eye, Light1Pos, Light1Intensity);

    float3 Light2Pos = float3(2.0f * sin(10 * 0.37), 2.0f * cos(10 * 0.37),2.0f);
    
    float3 Light2Intensity = float3(0.4f,0.4f,0.4f);
    
    colour += phongContributeForLight(k_d, k_s, alpha, p.eye, Light2Pos, Light2Intensity);
    
    return colour;

}