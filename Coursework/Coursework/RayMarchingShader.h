#pragma once

#include "DXF.h"

using namespace std;
using namespace DirectX;

class RayMarchingShader: public BaseShader
{
private:

	//Will need a struct to be able to pass the data of the shape
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
	};

public:
	RayMarchingShader(ID3D11Device* device, HWND hwnd);
	~RayMarchingShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture,XMFLOAT3 cameraPos,XMFLOAT3 camForwardVec,float distance_from_shape,float height,float width, const XMMATRIX& world2, const XMMATRIX& view2, const XMMATRIX& projection2,float deltaTime, ID3D11ShaderResourceView* p_texture,float Octaves,float Hurst,float Radius,XMFLOAT3 Position,float SmoothSteps,XMFLOAT4 Colour, float Max_distance);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);
private:
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* cameraBuffer;
	ID3D11Buffer* settingsBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* screenSizeBuffer;
};

