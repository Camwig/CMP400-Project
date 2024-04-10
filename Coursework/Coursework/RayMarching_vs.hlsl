//float4 main( float4 pos : POSITION ) : SV_POSITION
//{
//	return pos;
//}

#define NUM_LIGHTS 1

cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

cbuffer CameraBuffer : register(b1)
{
    float3 CameraOrigin;
    float padding;
    float3 CameraForwardDirection;
    float padding2;
    float distance_from_shape;
    float3 padding3;
    float deltaTime;
    float3 padding4;
};

cbuffer ExtraBuffer : register(b2)
{
    matrix lightViewMatrix[NUM_LIGHTS];
    matrix lightProjectionMatrix[NUM_LIGHTS];
    //float Ocatves;
    //float Hurst;
    //float2 padding2;
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
    float4 lightViewPos : TEXCOORD3;
};

OutputType main(InputType input)
{
    OutputType output;
    
    //float3x3 TextureTrans =
    //{
    //    0.5f, 0.0f, 0.0f,
    //                         0.0f, 0.05f, 0.0f,
    //                         0.5f, 0.5f, 1.0f
    //};
    
    //float3 Coord = (0.5f, 0.5f, 0.0f);
    
    //Coord = mul(Coord, TextureTrans);
    
    //input.tex = Coord.xy / Coord.z;
    
    float4 worldPosition = mul(input.position, worldMatrix);
    output.viewVector = CameraOrigin.xyz - worldPosition.xyz;
    output.viewVector = normalize(output.viewVector);
	
	// Change the position vector to be 4 units for proper matrix calculations.
    input.position.w = 1.0f;
    
	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
    output.lightViewPos = mul(input.position, worldMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightViewMatrix[0]);
    output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix[0]);

    //output.colour = input.colour;
    output.tex = input.tex;
    
    // Calculate the normal vector against the world matrix only and normalise.
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    output.worldPosition = mul(input.position, worldMatrix).xyz;
	

    return output;
}