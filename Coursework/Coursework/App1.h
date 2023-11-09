// Application.h
#ifndef _APP1_H
#define _APP1_H

// Includes
#include "DXF.h"
#include <cmath>

#include "RayMarchingShader.h"

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

	//Initial SDF Render
	float distance_from_sphere(XMFLOAT3 p, XMFLOAT3 c, float r);
	//

	//Function to calculate the distance between two 3D points
	float Distance_between_3Dpoints_2_(XMFLOAT3 a, XMFLOAT3 b);

private:
	RayMarchingShader* shader;
};

#endif