#pragma once

#include "BaseShader.h"
#include "DXF.h"

const int NUM_LIGHTS = 1;

using namespace std;
using namespace DirectX;

class VertexManipulatorShader : public BaseShader
{
private:
	struct LightBufferType
	{
		XMFLOAT4 ambient;
		XMFLOAT4 diffuse[NUM_LIGHTS];
		XMFLOAT4 position[NUM_LIGHTS];
		XMFLOAT4 direction[NUM_LIGHTS];
		float specularPower;
		XMFLOAT3 padding;
	};

	struct ExtraBufferType
	{
		XMMATRIX lightView[NUM_LIGHTS];
		XMMATRIX lightProjection[NUM_LIGHTS];
	};

	struct SettingsBufferVs
	{
		float Octaves;
		float Hurst;
		XMFLOAT2 Padding1;
		float SmoothSteps;
		XMFLOAT3 Padding2;
	};

	struct SettingsBufferPs
	{
		XMFLOAT4 Colour;
	};

	struct CameraBufferType
	{
		XMFLOAT3 cameraPosition;
		float padding;
	};
public:
	VertexManipulatorShader(ID3D11Device* device, HWND hwnd);
	~VertexManipulatorShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture, Light* light[NUM_LIGHTS], XMFLOAT3 CameraPosition, float Octaves, float Hurst,float SmoothSteps, XMFLOAT4 Colour,bool light_type);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* cameraBuffer;
	ID3D11Buffer* settingsBufferVs;
	ID3D11Buffer* settingsBufferPs;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* lightBuffer;
	ID3D11Buffer* extr_buffer;
};

