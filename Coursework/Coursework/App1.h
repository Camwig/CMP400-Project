// Application.h
#ifndef _APP1_H
#define _APP1_H

// Includes
#include "DXF.h"
#include <cmath>

#include "RayMarchingShader.h"
#include "TextureShader.h"
#include "PerlinTextureShader.h"



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

	//Initial SDF Render
	//float distance_from_sphere(XMFLOAT3 p, XMFLOAT3 c, float r);
	//

	//Function to calculate the distance between two 3D points
	//float Distance_between_3Dpoints_2_(XMFLOAT3 a, XMFLOAT3 b);

private:

	RayMarchingShader* shader;
	TextureShader* textureShader;
	PerlinTextureShader* perlinShader;
	

	OrthoMesh* orthoMesh;
	OrthoMesh* sampleMesh;

	RenderTexture*/*ID3D10Texture3D**/ PerlinTexture;

	//ThreeD_Render

	

	ID3D11Texture3D* PerlinTexture_2;

	RenderTexture* renderTexture;

	RenderTexture* FinalTexture;

	RenderTexture* DownSampletexture;

	float sx;
	float sy;

	bool started = false;
};

#endif