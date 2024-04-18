
#define NUM_LIGHTS 1

#include"LightHeader.hlsli"

cbuffer LightBuffer : register(b0)
{
    float4 ambient;
    float4 diffuse[NUM_LIGHTS];
    float4 position[NUM_LIGHTS];
    float4 direction[NUM_LIGHTS];
    float specularPower;
    float3 padding;
};

cbuffer SettingsBuffer : register(b1)
{
    float4 Colour;
}

struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
};

float4 main(InputType input) : SV_TARGET
{
    //Sets the intial values
    float4 textureColour = Colour;
    float3 lightVector;
    float attenuation;
    float4 lightColour[NUM_LIGHTS];
    float4 final_colour = float4(0.0f, 0.0f, 0.0f, 1.0f);
    
    
    if (NUM_LIGHTS > 0)
    {
        for (int i = 0; i < NUM_LIGHTS; i++)
        {
            attenuation = 0.0f;
            lightVector = float3(0.0f, 0.0f, 0.0f);
            lightColour[i] = float4(0.0f, 0.0f, 0.0f, 0.0f);
            
            switch (position[i].w)
            {
                case 1.0f:
                    //Light is in fact a point light
        
                    lightVector = (float3(position[i].x, position[i].y, position[i].z) - input.worldPosition);
	            
                    //Calculate the attenuation
                    attenuation = calcAttenuation(length(lightVector), 0.5f, 0.125f, 0.0f);
	            
                    lightVector = normalize(lightVector);
	                //Calculates the lighting
                    lightColour[i] = ambient + attenuation * calculateLighting(lightVector, input.normal, diffuse[i], position[i]);
	                //Adds the specular values
                    lightColour[i] *= calcSpecular(lightVector, input.normal, input.viewVector, float4(1, 1, 1, 1), specularPower);
                    break;
                case 2.0f:
                     //Light is in fact a directional light
                    lightVector = (float3(position[i].x, position[i].y, position[i].z) - input.worldPosition);;
	                //Calculate the attenuation
                    attenuation = calcAttenuation(length(lightVector), 0.5f, 0.125f, 0.0f);
	
                    lightVector = normalize(lightVector);
	                 //Calculates the lighting
                    lightColour[i] = ambient + attenuation * calculateLighting(float3(direction[i].x, direction[i].y, direction[i].z), input.normal, diffuse[i], position[i]);
	                //Adds the specular values
                    lightColour[i] *= calcSpecular(float3(-direction[i].x, -direction[i].y, -direction[i].z), input.normal, input.viewVector, float4(1, 1, 1, 1), specularPower);
                    break;
            }
            
            final_colour += lightColour[i];

        }
        
        return final_colour + textureColour;
    }
}