// Light vertex shader
// Standard issue vertex shader, apply matrices, pass info to pixel shader

#define NUM_LIGHTS 1

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
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
}

struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOOORD1;
    float3 viewVector : TEXCOORD2;
    float4 lightViewPos : TEXCOORD3;
};

OutputType main(InputType input)
{
 //   OutputType output;
	
 //   float4 worldPosition = mul(input.position, worldMatrix);
 //   output.viewVector = cameraPosition.xyz - worldPosition.xyz;
 //   output.viewVector = normalize(output.viewVector);

	//// Calculate the position of the vertex against the world, view, and projection matrices.
 //   output.position = mul(input.position, worldMatrix);
 //   output.position = mul(output.position, viewMatrix);
 //   output.position = mul(output.position, projectionMatrix);

	//// Store the texture coordinates for the pixel shader.
 //   output.tex = input.tex;

	//// Calculate the normal vector against the world matrix only and normalise.
 //   output.normal = mul(input.normal, (float3x3) worldMatrix);
 //   output.normal = normalize(output.normal);

 //   output.worldPosition = mul(input.position, worldMatrix).xyz;

 //   return output;
    
    OutputType output;
	
    //input.position.x += sine_wave * (texture_uv);
    float4 worldPosition = mul(input.position, worldMatrix);
    output.viewVector = cameraPosition.xyz - worldPosition.xyz;
    output.viewVector = normalize(output.viewVector);
    
    input.position.w = 1.0f;
    
    //output.position = input.position;
    //input.position.y += getHeight(input.tex, texture0, sampler0, height);

	// Calculate the position of the vertex against the world, view, and projection matrices.
    //output.position = mul(input.position, worldMatrix);
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
    // Calculate the position of the vertice as viewed by the light source.
    /*--------------------------------------------*/
    output.lightViewPos = mul(input.position, worldMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightViewMatrix[0]);
    output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix[0]);
    
    //output.lightViewPos2 = mul(input.position, worldMatrix);
    //output.lightViewPos2 = mul(output.lightViewPos2, lightViewMatrix[1]);
    //output.lightViewPos2 = mul(output.lightViewPos2, lightProjectionMatrix[1]);
    /*--------------------------------------------*/
    
    // Store the texture coordinates for the pixel shader.
    output.tex = input.tex;
    
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);
    
    output.worldPosition = mul(input.position, worldMatrix).xyz;

    return output;
}