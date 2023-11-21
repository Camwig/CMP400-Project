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