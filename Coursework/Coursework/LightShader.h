#pragma once

#include "DXF.h"

const int NUM_LIGHTS1 = 1;

using namespace std;
using namespace DirectX;

class LightShader : public BaseShader
{
private:

	/*each bit of data must add up to 4,

	so a float 4 doesn't need padding
	a float 3 either needs to be cast to a float 4 to be sent to buffer, or have a single float as padding
	a singular float would need a float3 as padding

	to keep things simple an array should always be a float4 (like you've already done here) */

	//IT ALWAYS HAS TO BE IN PACKETS OF FLOAT4S ALWAYS!
	struct LightBufferType
	{
		XMFLOAT4 ambient;
		XMFLOAT4 diffuse[NUM_LIGHTS1];
		XMFLOAT4 position[NUM_LIGHTS1];
		XMFLOAT4 direction;
		float specularPower;
		XMFLOAT3 padding;
	};

	struct ExtraBufferType
	{
		XMMATRIX lightView[NUM_LIGHTS1];
		XMMATRIX lightProjection[NUM_LIGHTS1];
	};

	struct CameraBufferType
	{
		XMFLOAT3 cameraPosition;
		float padding;
	};

public:
	LightShader(ID3D11Device* device, HWND hwnd);
	~LightShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture, Light* light[NUM_LIGHTS1], XMFLOAT3 CameraPosition);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* cameraBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* lightBuffer;
	ID3D11Buffer* extr_buffer;
};