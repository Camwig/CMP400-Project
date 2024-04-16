#pragma once

#include "DXF.h"

const int NUM_LIGHTS_ = 1;

using namespace std;
using namespace DirectX;

class RayMarchingShader: public BaseShader
{
private:

	//Buffer to pass camera data into shader 
	struct CameraBufferType
	{
		XMFLOAT3 CameraOrigin;
		float padding;
		XMFLOAT3 CameraForwardDirection;
		float padding2;
		float distance_from_shape;
		XMFLOAT3 padding3;
		float deltaTime;
		XMFLOAT3 padding4;
	};

	//Screen size and matrix based data for shader
	struct ScreenSizeBuffer
	{
		float screenWidth;
		XMFLOAT3 padding;
		float screenheight;
		XMFLOAT3 padding2;
		XMMATRIX Projection;
		XMMATRIX World;
		XMMATRIX View;
	};

	//Buffer to pass data in about the noise generation into the shader
	struct SettingsBuffer
	{
		float Octaves;
		float Hurst;
		float radius;
		float Padding1;
		XMFLOAT3 Position;
		float SmoothSteps;
		XMFLOAT4 Colour;
		float MAx_Distance;
		XMFLOAT3 Padding2;
		float Frequency;
		float Amplitude;
		XMFLOAT2 Padding3;
	};

	//Buffer to pass the lighting data into the shader
	struct LightBufferType
	{
		XMFLOAT4 ambient;
		XMFLOAT4 diffuse[NUM_LIGHTS_];
		XMFLOAT4 position[NUM_LIGHTS_];
		XMFLOAT4 direction[NUM_LIGHTS_];
		float specularPower;
		XMFLOAT3 padding;
	};

	//Buffer to pass extra lighting data to the shader
	//Specifically the light view matrix and the light projection matrix
	struct ExtraBufferType
	{
		XMMATRIX lightView[NUM_LIGHTS_];
		XMMATRIX lightProjection[NUM_LIGHTS_];
	};

public:
	RayMarchingShader(ID3D11Device* device, HWND hwnd);
	~RayMarchingShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, Light* light[NUM_LIGHTS_],XMFLOAT3 cameraPos,XMFLOAT3 camForwardVec,float distance_from_shape,float height,float width, const XMMATRIX& world2, const XMMATRIX& view2, const XMMATRIX& projection2,float deltaTime,float Octaves,float Hurst,float Radius,XMFLOAT3 Position,float SmoothSteps,XMFLOAT4 Colour, float Max_distance,bool light_type,float Freq,float Amp);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);
private:
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* cameraBuffer;
	ID3D11Buffer* settingsBuffer;
	ID3D11Buffer* screenSizeBuffer;
	ID3D11Buffer* lightBuffer;
	ID3D11Buffer* extr_buffer;
};

