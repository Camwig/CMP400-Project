// Application.h
#ifndef _APP1_H
#define _APP1_H

// Includes
#include "DXF.h"
#include <cmath>

#include "RayMarchingShader.h"
#include "TextureShader.h"
#include "PerlinTextureShader.h"
#include "VertexManipulatorShader.h"

#include "LightShader.h"

#define NUM_LIGHTS 1


class App1 : public BaseApplication
{
public:

	App1();
	~App1();
	void init(HINSTANCE hinstance, HWND hwnd, int screenWidth, int screenHeight, Input* in, bool VSYNC, bool FULL_SCREEN);

	bool frame();

protected:
	bool render();
	void gui();

	//void SamplePass();
	void RenderedPass();
	void finalPass();
	void firstPass();
	void PerlinGeneration();

	void FillTDText();

	//Initial SDF Render
	//float distance_from_sphere(XMFLOAT3 p, XMFLOAT3 c, float r);
	//

	//Function to calculate the distance between two 3D points
	//float Distance_between_3Dpoints_2_(XMFLOAT3 a, XMFLOAT3 b);

private:

	RayMarchingShader* shader;
	TextureShader* textureShader;
	PerlinTextureShader* perlinShader;

	LightShader* light_shader;

	VertexManipulatorShader* vertex_shader;

	OrthoMesh* orthoMesh;
	OrthoMesh* sampleMesh;

	RenderTexture*/*ID3D10Texture3D**/ PerlinTexture;

	TDRenderTarget* TD_Text;

	SphereMesh* mesh;
	PlaneMesh* plane;


	ID3D11Texture3D* PerlinTexture_2;

	RenderTexture* renderTexture;

	RenderTexture* FinalTexture;

	RenderTexture* DownSampletexture;

	int Octaves = 3;
	float Hurst = 0.5f;
	float radius = 2.5f;
	XMFLOAT3 Position = XMFLOAT3(0.0f, 0.0f, 0.6f);
	int SmoothSteps = 2;
	XMFLOAT4 Colour = XMFLOAT4(0.00f, 0.40f, 0.07f, 0.0f);
	int MAx_Distance = 3000;

	XMFLOAT4 AmbientColour = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	XMFLOAT3 DiffuseColour = XMFLOAT3(1.0f, 0.0f, 0.0f);
	XMFLOAT3 LightPosition = XMFLOAT3(0.0f, 4.0f, 0.0f);

	float sx;
	float sy;

	bool started = false;
	bool VertexBased = false;

	Light* light[NUM_LIGHTS];

	//D3DMatr#
};

#endif