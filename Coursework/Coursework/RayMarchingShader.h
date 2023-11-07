#pragma once

#include "DXF.h"

using namespace std;
using namespace DirectX;

class RayMarchingShader: public BaseShader
{
private:
	//Will need a struct to be able to pass the data of the shape
public:
	RayMarchingShader(ID3D11Device* device, HWND hwnd);
	~RayMarchingShader();

	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);
private:
	ID3D11Buffer* matrixBuffer;
};

