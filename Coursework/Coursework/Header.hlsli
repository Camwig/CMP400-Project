#include "Perlin_noise.hlsli"

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
    float d2 = (sin(5 * p.x) * sin(5 * p.y) * sin(5 * p.z));
    //float bums = p.y - (p.x * ((20 - p.x) / 100));
    
    //return (distance(p, c) - r);
	//answer < 0 is inside the sphere
	//answer = 0 is on the surface of the sphere
	//answer > 0 is outside the sphere
    return answer;
}

float New_Random_Sphere(float3 p, float3 c, float r)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
    
    if (answer < 1.0f)
    {
        float multiple = 0.5f;
        float3 Input = float3(p.x * multiple, p.y * multiple, p.z * multiple);
        float n = color2(Input);
        
        //if (n < 0.0f)
        //{
        //    n = 0.001f;
        //}
        
        float noise = n * 0.1f;
        
        answer -= noise;
    }
    
    return answer /** Result*/;
}

float Random_Sphere(float3 p, float3 c, float r)
{
    float answer = Distance_between_3Dpoints_2_(p, c);
    answer = answer - r;
    
    float n = 0.0f;
    
    float multiple = 0.25f;
    float3 Input = float3(p.x * multiple, p.y * multiple, p.z * multiple);
    n = color2(Input);
    
    /*  if (n < 0.0f)
    {
        n = 0.001f;
    }
    */
        
    answer -= (n * 0.5);
    
    return answer /** Result*/;
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

/*float udQuad( vec3 p, vec3 a, vec3 b, vec3 c, vec3 d )
{
  vec3 ba = b - a; vec3 pa = p - a;
  vec3 cb = c - b; vec3 pb = p - b;
  vec3 dc = d - c; vec3 pc = p - c;
  vec3 ad = a - d; vec3 pd = p - d;
  vec3 nor = cross( ba, ad );

  return sqrt(
    (sign(dot(cross(ba,nor),pa)) +
     sign(dot(cross(cb,nor),pb)) +
     sign(dot(cross(dc,nor),pc)) +
     sign(dot(cross(ad,nor),pd))<3.0)
     ?
     min( min( min(
     dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
     dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
     dot2(dc*clamp(dot(dc,pc)/dot2(dc),0.0,1.0)-pc) ),
     dot2(ad*clamp(dot(ad,pd)/dot2(ad),0.0,1.0)-pd) )
     :
     dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}*/

/*float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}*/

float distance_from_Line(float3 p, float3 a, float3 b, float r)
{
    float3 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0f, 1.0f);
    float output = Distance_between_3Dpoints_(pa - ba * h);
    output = output - r;
    return output;

}

float dot2(float3 v)
{
    return dot(v, v);
}

float distance_from_quad(float3 p, float3 a, float3 b,float3 c,float3 d)
{
    float3 ba = b - a; 
    float3 pa = p - a;
    float3 cb = c - b; 
    float3 pb = p - b;
    float3 dc = d - c;
    float3 pc = p - c;
    float3 ad = a - d;
    float3 pd = p - d;
    
    float3 nor = cross(ba, ad);
    
    return sqrt(
    (sign(dot(cross(ba, nor), pa)) +
     sign(dot(cross(cb, nor), pb)) +
     sign(dot(cross(dc, nor), pc)) +
     sign(dot(cross(ad, nor), pd)) < 3.0)
     ?
     min(min(min(
     dot2(ba * clamp(dot(ba, pa) / dot2(ba), 0.0, 1.0) - pa),
     dot2(cb * clamp(dot(cb, pb) / dot2(cb), 0.0, 1.0) - pb)),
     dot2(dc * clamp(dot(dc, pc) / dot2(dc), 0.0, 1.0) - pc)),
     dot2(ad * clamp(dot(ad, pd) / dot2(ad), 0.0, 1.0) - pd))
     :
     dot(nor, pa) * dot(nor, pa) / dot2(nor));
    
}

/*float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}*/

float distance_from_box(float3 p, float3 b)
{
    float3 q = abs(p) - b;
    return length(max(q, 0.0f)) + min(max(q.x, max(q.y, q.z)), 0.0f);
}


//--------------------------------------------------------------------------------

// Calculate lighting intensity based on direction and normal. Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse, float4 position)
{
    float intensity;
    if (position.w == 1.0f)
    {
        intensity = saturate(dot(normal, lightDirection));
    }
    else if (position.w == 2.0f)
    {
        intensity = saturate(dot(normal, -lightDirection));
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

float3 estimateNormal(float3 p, float4x4 World)
{
    
    
    //float3 Final_Normal = (float3(
    //New_Random_Sphere(float3(p.x + 0.002f /*0.00001f*/, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - New_Random_Sphere(float3(p.x - 0.002f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //New_Random_Sphere(float3(p.x, p.y + 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - New_Random_Sphere(float3(p.x, p.y - 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //New_Random_Sphere(float3(p.x, p.y, p.z + 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f) - New_Random_Sphere(float3(p.x, p.y, p.z - 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f)
    //));
    //Final_Normal = mul(Final_Normal, World);
    //return normalize(Final_Normal);
    
    
    
    float3 Final_Normal = (float3(
    Random_Sphere(float3(p.x + 0.002f /*0.00001f*/, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - Random_Sphere(float3(p.x - 0.002f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    Random_Sphere(float3(p.x, p.y + 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - Random_Sphere(float3(p.x, p.y - 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    Random_Sphere(float3(p.x, p.y, p.z + 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f) - Random_Sphere(float3(p.x, p.y, p.z - 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f)
    ));
    Final_Normal = mul(Final_Normal, World);
    return normalize(Final_Normal);
    
    
    
    //float3 Final_Normal = (float3(
    //distance_from_sphere(float3(p.x + 0.002f /*0.00001f*/, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x - 0.002f, p.y, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y + 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x, p.y - 0.002f, p.z), float3(0.0f, 0.0f, 0.6f), 1.0f),
    //distance_from_sphere(float3(p.x, p.y, p.z + 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f) - distance_from_sphere(float3(p.x, p.y, p.z - 0.002f), float3(0.0f, 0.0f, 0.6f), 1.0f)
    //));
    //Final_Normal = mul(Final_Normal, World);
    //return normalize(Final_Normal);
    
    //float Epsilon = 0.002f;
    //float3 Final_Normal = (float3(
    //distance_from_quad(float3(p.x + Epsilon /*0.00001f*/, p.y, p.z), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f)) - distance_from_quad(float3(p.x - Epsilon /*0.00001f*/, p.y, p.z), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f)),
    //distance_from_quad(float3(p.x /*0.00001f*/, p.y + Epsilon, p.z), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f)) - distance_from_quad(float3(p.x /*0.00001f*/, p.y - Epsilon, p.z), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f)),
    //distance_from_quad(float3(p.x /*0.00001f*/, p.y, p.z + Epsilon), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f)) - distance_from_quad(float3(p.x /*0.00001f*/, p.y, p.z - Epsilon), float3(0.0f, 0.0f, 0.0f), float3(0.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 10.0f), float3(10.0f, 0.0f, 0.0f))
    //));
    //Final_Normal = mul(Final_Normal, World);
    //return normalize(Final_Normal);
    
    //float3 Final_Normal = (float3(
    //distance_from_box(float3(p.x + 0.002f /*0.00001f*/, p.y, p.z), float3(0.3f, 0.3f, 1.0f)) - distance_from_box(float3(p.x - 0.002f /*0.00001f*/, p.y, p.z), float3(0.3f, 0.3f, 1.0f)),
    //distance_from_box(float3(p.x /*0.00001f*/, p.y + 0.002f, p.z), float3(0.3f, 0.3f, 1.0f)) - distance_from_box(float3(p.x /*0.00001f*/, p.y - 0.002f, p.z), float3(0.3f, 0.3f, 1.0f)),
    //distance_from_box(float3(p.x /*0.00001f*/, p.y, p.z + 0.002f), float3(0.3f, 0.3f, 1.0f)) - distance_from_box(float3(p.x /*0.00001f*/, p.y, p.z - 0.002f), float3(0.3f, 0.3f, 1.0f))
    //));
    
    //Final_Normal = mul(Final_Normal, World);
    
    //return normalize(Final_Normal);
    
}

float4 phongIllumination(float shininess, float3 ViewVector, float3 Position, float3 p, float4x4 World, float3 Campos, float3 Test)
{
    float4 ambientLight = float4(0.5, 0.5, 0.5, 1.0f);
    float4 colour = float4(0.0f, 0.0f, 0.0f,0.0f);
    //ambientLight = ambientLight * k_a;
    //colour = ambientLight * k_a;
    
    //The values in the sin and cos can be anything its for light position
    
    //The lightposition doesnt work as it should not entirley sure
    float4 Light1Pos = float4(0.0f, 3.0f, 0.6f, 1.0f); //float3(4.0f * sin(DeltaTime), 2.0f, 4.0f * cos(DeltaTime));
    //float4 Light1Pos = float4(3.0f, 5.0f, 5.0f, 1.0f);
    //float3 Light1Intensity = float3(0.8f,0.8f,0.8f);
    
    float3 light1Vector = float3(0.0f, 0.0f, 0.0f);
    
    //Do this without camera matrix applied
    
    //It has to be this but I have no idea where 
    
    //Use position for shapes that are not spheres or at least quads
    //Spheres use their origin coordinates
    
    float3 Result_pos = mul(Position, World);
    
    //Somewhere the camera is being multpiled onto the light vector and I cannot tell you where
    
    //So the lightVector is still wrong which is why this is still failing to figure out point lights
    light1Vector = (float3(Light1Pos.x, Light1Pos.y, Light1Pos.z) - Result_pos /*eye*/);
    
    //light1Vector /= Campos;
    
    float3 light1Direction = (float3(0.0f, -1.0f, 0.0f));
   
    float3 Normal = estimateNormal(p,World); /*float3(0.0f, 0.0f, 1.0f);*/
    
    //return float4(Normal.x,Normal.y,Normal.z,1.0f);
    
    //Normal = mul(Normal, World);
    //Normal = normalize(Normal);
    
    float attenuation = 0.0f;
    
    attenuation = calcAttenuation(length(light1Vector), 0.5f, 0.125f, 0.0f); 
    
    light1Vector = normalize(light1Vector);
    
    colour = ambientLight + attenuation * calculateLighting(light1Vector, Normal, float4(0.0f, 1.0f, 0.0f, 0.0f), Light1Pos);
    
    colour += calcSpecular(light1Vector, Normal, ViewVector, float4(1, 1, 1, 1), shininess);
    
    /*float spe = pow(clamp( dot( reflect(rd,nor), lgt ), 0.0, 1.0 ),500.);*/
    //colour += pow(clamp(dot(reflect(ViewVector, Normal), Light1Pos), 0.0f, 1.0f), 500);
    
    
    return colour;
    //return float4(Normal, 1.0f);
}