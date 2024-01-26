
const float EPSILON = 0.0001f;

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
      //Normal comes out as negative everytime
    
    const float2 k = float2(1, -1);
    return normalize((k.xyy * distance_from_sphere(float3(p + k.xyy * EPSILON), float3(0.0f, 0.0f, 6.0f),1.0f)) +
                     (k.yyx * distance_from_sphere(float3(p + k.yyx * EPSILON), float3(0.0f, 0.0f, 6.0f),1.0f)) +
                     (k.yxy * distance_from_sphere(float3(p + k.yxy * EPSILON), float3(0.0f, 0.0f, 6.0f),1.0f)));
    
    
    //float2 h = float2(EPSILON, 0);
    //float3 value = normalize(float3((Distance_between_3Dpoints_2_(float3(p + h.xyy), float3(0.0f, 0.0f, 6.0f)) - Distance_between_3Dpoints_2_(float3(p - h.xyy), float3(0.0f, 0.0f, 6.0f))),
    //                        (Distance_between_3Dpoints_2_(float3(p + h.yxy), float3(0.0f, 0.0f, 6.0f)) - Distance_between_3Dpoints_2_(float3(p - h.yxy), float3(0.0f, 0.0f, 6.0f))),
    //                        (Distance_between_3Dpoints_2_(float3(p + h.yyx), float3(0.0f, 0.0f, 6.0f)) - Distance_between_3Dpoints_2_(float3(p - h.yyx), float3(0.0f, 0.0f, 6.0f)))));
    
    //return value;
    
    //This is not working right Need to work out the epsilon
    
    //float3 value =  normalize(float3(
    //((p.x + EPSILON, -p.y, -p.z) - (p.x - EPSILON, p.y, p.z)),
    //((p.x, -p.y + EPSILON, -p.z) - (p.x, p.y - EPSILON, p.z)),
    //(p.x, -p.y, -p.z + EPSILON) - (p.x, p.y, p.z - EPSILON))
    //);
    
    //value = float3(sqrt(value.x), sqrt(value.y), sqrt(value.z));
    //return value;
    
    //return normalize(float3(
    //((p.x + EPSILON, p.y, p.z) - (p.x - EPSILON, p.y, p.z)),
    //((p.x, p.y + EPSILON, p.z) - (p.x, p.y - EPSILON, p.z)),
    //(p.x, p.y, p.z + EPSILON) - (p.x, p.y, p.z - EPSILON))
    //);
    
    
    //return normalize(float3(
    //distance_from_sphere(float3(p.x + EPSILON, p.y, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f) - distance_from_sphere(float3(p.x - EPSILON, p.y, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y + EPSILON, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f) - distance_from_sphere(float3(p.x, p.y - EPSILON, p.z), float3(0.0f, 0.0f, 6.0f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y, p.z + EPSILON), float3(0.0f, 0.0f, 6.0f), 1.0f) - distance_from_sphere(float3(p.x, p.y, p.z - EPSILON), float3(0.0f, 0.0f, 6.0f), 1.0f)
    //));
}

float3 phongContributeForLight(float3 k_d, float3 k_s, float alpha, float3 p, float3 eye, float3 lightPos, float3 lightIntensity)
{
    float3 N = estimateNormal(p); /*float3(1.0f, 1.0f, 1.0f);*/
    //N = N * -1;
    
    //return float3(N.x, N.y, N.z);
    
    //if (N.x < 0)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    //if (N.y < 0)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    //if (N.z < 0)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    
    float3 L = normalize(lightPos - p);
    float3 V = normalize(eye - p);
    float3 R = normalize(reflect(-L, N));
    
    float dotLN = dot(L, N);
    //if (dotLN <= 0)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    float dotRV = dot(R, V);
    //if (dotRV >= 0)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    
    //dotLN is always less than zero
    if (dotLN < 0.0f)
    {
        //Light not visible from this point on the surface
        return float3(0.0f, 0.0f, 0.0f);
    }
    
    if (dotRV < 0.0f)
    {
        //Light reflection in opposite direction as viewer, apply only diffuse component
        return lightIntensity * (k_d * dotLN);
        //return float3(0.0f, 0.0f, 1.0f);
    }
    
    
    float3 check_value = lightIntensity * ((k_d * dotLN) + (k_s * pow(dotRV, alpha)));
    
    //if (check_value.x)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    //if (check_value.y)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    //if (check_value.z)
    //{
    //    return float3(0.0f, 1.0f, 0.0f);
    //}
    
    //I think something is up with this equation
    //return lightIntensity * ((k_d * dotLN) + (k_s * pow(dotRV, alpha)));
    return check_value;
    //return float3(1.0f, 1.0f, 0.0f);

}

float3 phongIllumination(float3 k_a,float3 k_d,float3 k_s,float alpha,float3 p, float3 eye, float DeltaTime)
{
    const float3 ambientLight = float3(0.5, 0.5, 0.5);
    float3 colour  /*= float3(0.0f,0.0f,0.0f);*/ = ambientLight * k_a;
    
    //The values in the sin and cos can be anything its for light position
    float3 Light1Pos = float3(0.0f, 0.0f, -7.0f); //float3(4.0f * sin(DeltaTime), 2.0f, 4.0f * cos(DeltaTime));
    
    float3 Light1Intensity = float3(0.8f,0.8f,0.8f);
    
    colour = phongContributeForLight(k_d, k_s, alpha, p, eye, Light1Pos, Light1Intensity);

    //float3 Light2Pos = float3(0.0f, 0.0f, 6.0f); //float3(2.0f * sin(DeltaTime * 0.37), 2.0f * cos(DeltaTime * 0.37), 2.0f);
    
    //float3 Light2Intensity = float3(0.4f,0.4f,0.4f);
    
    //colour += phongContributeForLight(k_d, k_s, alpha, p, eye, Light2Pos, Light2Intensity);
    
    return colour;

}