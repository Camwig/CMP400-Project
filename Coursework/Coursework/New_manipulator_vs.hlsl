// texture vertex shader
// Basic shader for rendering textured geometry

#define NUM_LIGHTS 1

//#include "Perlin_noise.hlsli"
#include "Vertex_manipulation_header_.hlsli"

//Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

cbuffer CameraBuffer : register(b1)
{
    float3 cameraPosition;
    float padding;
};

cbuffer ExtraBuffer : register(b2)
{
    matrix lightViewMatrix[NUM_LIGHTS];
    matrix lightProjectionMatrix[NUM_LIGHTS];
    //float Ocatves;
    //float Hurst;
    //float2 padding2;
}

cbuffer SettingsBuffer : register(b3)
{
    float Octaves;
    float Hurst;
    //float radius;
    float2 Padding1;
    //float3 Position;
    float SmoothSteps;
    //float4 Colour;
    //float MAx_Distance;
    float3 Padding2;
    float Freq;
    float Amp;
    float2 Padding3;
}

struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
    //float4 lightViewPos : TEXCOORD3;
};

//void SmoothNoise()
//{
//     temp_map = new float [resolution*resolution];
//	float temp;
//	for (int j = 0; j < resolution; j++) {
//		for (int i = 0; i < resolution; i++) {
//			temp = 0.0f;
//			temp += heightMap[(j * resolution) + i];
//			if (j > 0)
//			{
//				temp += heightMap[((j - 1) * resolution) + i];
//			}
//			if (j < resolution-1)
//			{
//				temp += heightMap[((j + 1) * resolution) + i];
//			}
//			if (i < resolution-1)
//			{
//				temp += heightMap[(j * resolution) + (i + 1)];
//			}
//			if (i > 0)
//			{
//				temp += heightMap[(j * resolution) + (i - 1)];
//			}
//			if (i > 0 && j < resolution-1)
//			{
//				temp += heightMap[((j + 1) * resolution) + (i - 1)];
//			}
//			if (j > 0 && i < resolution-1)
//			{
//				temp += heightMap[((j - 1) * resolution) + (i + 1)];
//			}
//			if (i > 0 && j > 0)
//			{
//				temp += heightMap[((j - 1) * resolution) + (i - 1)];
//			}
//			if (i < resolution-1 && j < resolution-1)
//			{
//				temp += heightMap[((j + 1) * resolution) + (i + 1)];
//			}
//			temp = temp / 9;
//			temp_map[(j * resolution) + i] = temp;
//		}
//	}

//	for (int j = 0; j < (resolution); j++) {
//		for (int i = 0; i < (resolution); i++) {
//			heightMap[(j * resolution) + i] = temp_map[(j * resolution) + i];
//		}
//	}
//}

OutputType main(InputType input)
{
    OutputType output;
    
    //float n = 0.0f;
    //float multiple = 0.25f;
    //float3 Input = float3(input.position.x * multiple, input.position.y * multiple, input.position.z * multiple);
    //n = color(Input);
    
    //if(n<= -1.0f)
    //{
    //    n = 0.0;
    //}
    
    /*    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f; //color2(Input);
        
    float noise = 0.0f;
    
    //Use the position of sphere
    //float3 d = Distance_between_3DPoints_3_(p, float3(0, 0, 0.6f));
        
    for (int i = 1; i <= Octave; i++)
    {
        //Should be passed in
        Frequency = /*0.5f;
    (i * i) / 5.f;
    Input = float3(p.x * Frequency, p.y * Frequency, p.z * Frequency);
    n = color2(Input);
        //Should be passed in
    Amplitude = /*0.1f;/pow(Frequency, Hurst);
    if (i != 1)
        Amplitude /= ((i) * (9 * i));
    noise += n * Amplitude /*(Amplitude/10.f);
}*/
    
    
    //float3 n = texture0.SampleLevel(sampler0, input.tex, 0).x;
    
    float Frequency = 0.5f;
    float Amplitude = 0.1f;
    float3 Input = float3(0, 0, 0);
    float n = 0.0f; //color2(Input);
        
    float noise = 0.0f;
    
    //Use the position of sphere
    //float3 d = Distance_between_3DPoints_3_(p, float3(0, 0, 0.6f));
   [unroll(10)]
   for (int i = 1; i <= Octaves; i++)
   {
        ////Should be passed in
        //Frequency = /*1.0f;*/(i * i);
        ////Frequency = (i * i);
        //Input = float3(input.position.x * Frequency, input.position.y * Frequency, input.position.z * Frequency);
        //n = color2(Input);
        ////n = Manipulate_shape_based_on_noise(texture0,sampler0,input.tex);
        ////Should be passed in
        //Amplitude = /*1.0f;*/pow(Frequency, -Hurst);
        ////Amplitude = pow(Frequency, -Hurst);
        ////if (i != 1)
        ////    Amplitude /= ((i) * (9 * i));
        //noise += n * Amplitude /*(Amplitude/10.f)*/;
        
        Frequency = (i)/Freq; //5.f
        Input = float3(input.position.x * Frequency, input.position.y * Frequency, input.position.z * Frequency);
        n = color2(Input);
        Amplitude = pow(Frequency, -Hurst);
        if (i != 1)
            Amplitude *= ((Amp));
        noise += n * Amplitude;
    }
    
    //noise = Smooth_Noise(noise,SmoothSteps);
    
    [unroll(10)]
    for (int k = 1; k <= SmoothSteps; k++)
        noise = smoothstep(-2.5, 2.5, noise);
    
    //noise = noise/Ocatves;
    
    //Should maybe set this to use the output normal
    input.position.xyz += (noise * input.normal);
    
    float4 worldPosition = mul(input.position, worldMatrix);
    output.viewVector = cameraPosition.xyz - worldPosition.xyz;
    output.viewVector = normalize(output.viewVector);
    
    	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
    //output.lightViewPos = mul(input.position, worldMatrix);
    //output.lightViewPos = mul(output.lightViewPos, lightViewMatrix[0]);
    //output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix[0]);

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;

	// Calculate the normal vector against the world matrix only and normalise.
    //input.normal = CalcNormal(Input,input.normal);
    
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);
    
    output.worldPosition = mul(input.position, worldMatrix).xyz;

    return output;

	//// Store the texture coordinates for the pixel shader.
 //   output.tex = input.tex;

 //   output.normal = input.normal;

 //   return output;
}