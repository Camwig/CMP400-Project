#pragma once

#include "BaseShader.h"

using namespace std;
using namespace DirectX;

class PerlinTextureShader : public BaseShader
{
private:

	struct ScreenSizeBuffer
	{
		float screenWidth;
		XMFLOAT3 padding;
		float screenheight;
		XMFLOAT3 padding2;
	};

public:
	PerlinTextureShader(ID3D11Device* device, HWND hwnd);
	~PerlinTextureShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture,float height,float width);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* screenSizeBuffer;
};

