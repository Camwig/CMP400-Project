//float4 main( float4 pos : POSITION ) : SV_POSITION
//{
//	return pos;
//}

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

struct InputType
{
    float4 position : POSITION;
    //float4 colour : COLOR;
    float2 tex : TEXCOORD0;
};

struct OutputType
{
    float4 position : SV_POSITION;
    //float4 colour : COLOR;
    float2 tex : TEXCOORD0;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
};

OutputType main(InputType input)
{
    OutputType output;
    
    float4 worldPosition = mul(input.position, worldMatrix);
    output.viewVector = CameraOrigin.xyz - worldPosition.xyz;
    output.viewVector = normalize(output.viewVector);
	
	// Change the position vector to be 4 units for proper matrix calculations.
    input.position.w = 1.0f;
    
	// Calculate the position of the vertex against the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

    //output.colour = input.colour;
    output.tex = input.tex;

    output.worldPosition = mul(input.position, worldMatrix).xyz;
	

    return output;
}