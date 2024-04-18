// Calculate lighting intensity based on direction and normal and then Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse, float4 position)
{
    float intensity;
    //Depending on the position w value we can tell the type of light being calculated
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

//Bling-phong speclar lighting calculation to determine the amount of specular light on the surface based on the position of the surface relative to the camera
float4 calcSpecular(float3 lightDirection, float3 normal, float3 viewVector, float4 specularColour, float specularPower)
{
    float3 halfway = normalize(lightDirection + viewVector);
    float specularIntensity = pow(max(dot(normal, halfway), 0.0f), specularPower);
    return saturate(specularColour * specularIntensity);
}

//Calculates the attenuation of the lighing using the factors of the light fall off
float4 calcAttenuation(float distance, float constantfactor, float linearFactor, float quadraticfactor)
{
    float attenuation = 1.f / ((constantfactor + (linearFactor * distance) + (quadraticfactor * pow(distance, 2))));
    return attenuation;
}