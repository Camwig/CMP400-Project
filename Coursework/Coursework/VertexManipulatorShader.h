#pragma once

#include "BaseShader.h"
#include "DXF.h"

const int NUM_LIGHTS = 1;

using namespace std;
using namespace DirectX;

class VertexManipulatorShader : public BaseShader
{
private:

	//Buffer to pass the lighting data into the shader
	struct LightBufferType
	{
		XMFLOAT4 ambient;
		XMFLOAT4 diffuse[NUM_LIGHTS];
		XMFLOAT4 position[NUM_LIGHTS];
		XMFLOAT4 direction[NUM_LIGHTS];
		float specularPower;
		XMFLOAT3 padding;
	};

	//Buffer to pass extra lighting data to the shader
	//Specifically the light view matrix and the light projection matrix
	struct ExtraBufferType
	{
		XMMATRIX lightView[NUM_LIGHTS];
		XMMATRIX lightProjection[NUM_LIGHTS];
	};

	//Buffer to pass data in about the noise generation into the shader
	struct SettingsBufferVs
	{
		float Octaves;
		float Hurst;
		XMFLOAT2 Padding1;
		float SmoothSteps;
		XMFLOAT3 Padding2;
		float Frequency;
		float Amplitude;
		XMFLOAT2 Padding3;
	};

	//Buffer to pass in the colour
	struct SettingsBufferPs
	{
		XMFLOAT4 Colour;
	};

	//Buffer to pass in camera position data
	struct CameraBufferType
	{
		float padding;
		XMFLOAT3 cameraPosition;
	};
public:
	VertexManipulatorShader(ID3D11Device* device, HWND hwnd);
	~VertexManipulatorShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, Light* light[NUM_LIGHTS], XMFLOAT3 CameraPosition, float Octaves, float Hurst,float SmoothSteps, XMFLOAT4 Colour,bool light_type,float Frequency,float Amplitude);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* cameraBuffer;
	ID3D11Buffer* settingsBufferVs;
	ID3D11Buffer* settingsBufferPs;
	ID3D11Buffer* lightBuffer;
	ID3D11Buffer* extr_buffer;
};

