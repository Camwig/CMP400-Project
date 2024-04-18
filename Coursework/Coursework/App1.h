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

	//Defines the passes to render the geometry
	void RenderedPass();
	void finalPass();

private:
	//Creates pointers to objects
	RayMarchingShader* shader;
	TextureShader* textureShader;
	VertexManipulatorShader* vertex_shader;

	OrthoMesh* orthoMesh;
	SphereMesh* mesh;

	RenderTexture* renderTexture;
	RenderTexture* FinalTexture;

	//Defines the inital values of the shape and the scene that can be editied using the GUI
	int Octaves = 5;
	float Hurst = 0.65606f;
	float radius = 2.5f;
	XMFLOAT3 Position = XMFLOAT3(0.0f, 0.0f, 0.6f);
	int SmoothSteps = 2;
	XMFLOAT4 Colour = XMFLOAT4(0.00f, 0.40f, 0.07f, 0.0f);
	int MAx_Distance = 3000;

	XMFLOAT4 AmbientColour = XMFLOAT4(0.5f, 0.5f, 0.5f, 1.0f);
	XMFLOAT3 DiffuseColour = XMFLOAT3(1.0f, 0.0f, 0.0f);
	XMFLOAT3 LightPosition = XMFLOAT3(0.0f, 6.0f, 0.0f);
	XMFLOAT3 LightDirection = XMFLOAT3(0.0f, -1.0f, 0.0f);

	float Frequency = 3.545f;
	float Amplitude = 1.699f;

	bool point = true;
	float sx;
	float sy;
	bool VertexBased = false;

	//Holds the light
	Light* light[NUM_LIGHTS];

	//Defines the matrices and screen size variables for later use
	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix, orthoViewMatrix, viewMatrix, projectionMatrix, scaleMatrix;
	float screenSizeY;
	float screenSizeX;
};

#endif