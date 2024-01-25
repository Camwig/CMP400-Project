// Lab1.cpp
// Lab 1 example, simple coloured triangle mesh
#include "App1.h"

App1::App1()
{

}

void App1::init(HINSTANCE hinstance, HWND hwnd, int screenWidth, int screenHeight, Input *in, bool VSYNC, bool FULL_SCREEN)
{
	// Call super/parent init function (required!)
	BaseApplication::init(hinstance, hwnd, screenWidth, screenHeight, in, VSYNC, FULL_SCREEN);

	// Initalise scene variables.
	//XMFLOAT3 a = XMFLOAT3(-7,11,12);
	//XMFLOAT3 b = XMFLOAT3(0, 0, 0);

	//float v = distance_from_sphere(a,b,3);
	sx = screenWidth;
	sy = screenHeight;
	orthoMesh = new OrthoMesh(renderer->getDevice(), renderer->getDeviceContext(), screenWidth, screenHeight);	// Full screen size
	sampleMesh = new OrthoMesh(renderer->getDevice(), renderer->getDeviceContext(), screenWidth, screenHeight);

	shader = new RayMarchingShader(renderer->getDevice(), hwnd);
	textureShader = new TextureShader(renderer->getDevice(), hwnd);

	renderTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
	DownSampletexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
	FinalTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
}


App1::~App1()
{
	// Run base application deconstructor
	BaseApplication::~BaseApplication();

	// Release the Direct3D object.
	if (shader)
	{
		delete shader;
		shader = 0;
	}
}


bool App1::frame()
{
	bool result;

	result = BaseApplication::frame();
	if (!result)
	{
		return false;
	}
	
	// Render the graphics.
	result = render();
	if (!result)
	{
		return false;
	}

	return true;
}

bool App1::render()
{
	//// Clear the scene. (default blue colour)
	////renderer->beginScene(0.39f, 0.58f, 0.92f, 1.0f);

	//// Set the render target to be the render to texture and clear it
	//renderTexture->setRenderTarget(renderer->getDeviceContext());
	//renderTexture->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 0.0f, 1.0f, 1.0f);

	//// Generate the view matrix based on the camera's position.
	//camera->update();

	//// Get the world, view, projection, and ortho matrices from the camera and Direct3D objects.
	//XMMATRIX worldMatrix = renderer->getWorldMatrix();
	//XMMATRIX viewMatrix = camera->getViewMatrix();
	//XMMATRIX projectionMatrix = renderer->getProjectionMatrix();

	////shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, viewMatrix, projectionMatrix, camera->getPosition(), camera->getForwardVector(),0.0f);
	////shader->render(renderer->getDeviceContext(),0);

	//renderer->setBackBufferRenderTarget();

	firstPass();
	SamplePass();
	RenderedPass();
	finalPass();

	//gui();

	// Present the rendered scene to the screen.
	renderer->endScene();

	return true;
}

void App1::gui()
{
	// Force turn off unnecessary shader stages.
	renderer->getDeviceContext()->GSSetShader(NULL, NULL, 0);
	renderer->getDeviceContext()->HSSetShader(NULL, NULL, 0);
	renderer->getDeviceContext()->DSSetShader(NULL, NULL, 0);

	// Build UI
	ImGui::Text("FPS: %.2f", timer->getFPS());
	ImGui::Checkbox("Wireframe mode", &wireframeToggle);

	// Render UI
	ImGui::Render();
	ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
}

void App1::firstPass()
{
	// Clear the scene. (default blue colour)
//renderer->beginScene(0.39f, 0.58f, 0.92f, 1.0f);

// Set the render target to be the render to texture and clear it
	renderTexture->setRenderTarget(renderer->getDeviceContext());
	renderTexture->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 0.0f, 1.0f, 1.0f);

	// Generate the view matrix based on the camera's position.
	camera->update();

	// Get the world, view, projection, and ortho matrices from the camera and Direct3D objects.
	XMMATRIX worldMatrix = renderer->getWorldMatrix();
	XMMATRIX viewMatrix = camera->getViewMatrix();
	XMMATRIX projectionMatrix = renderer->getProjectionMatrix();

	//shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, viewMatrix, projectionMatrix, camera->getPosition(), camera->getForwardVector(),0.0f);
	//shader->render(renderer->getDeviceContext(),0);

	renderer->setBackBufferRenderTarget();
}

void App1::SamplePass()
{
	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;

	DownSampletexture->setRenderTarget(renderer->getDeviceContext());
	DownSampletexture->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 0.0f, 1.0f, 1.0f);

	worldMatrix = renderer->getWorldMatrix();
	baseViewMatrix = camera->getOrthoViewMatrix();
	orthoMatrix = renderTexture->getOrthoMatrix();

	// Render for Horizontal Blur
	renderer->setZBuffer(false);

	sampleMesh->sendData(renderer->getDeviceContext());
	textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView());
	textureShader->render(renderer->getDeviceContext(), sampleMesh->getIndexCount());

	renderer->setZBuffer(true);

	// Reset the render target back to the original back buffer and not the render to texture anymore.
	renderer->setBackBufferRenderTarget();
}

void App1::RenderedPass()
{
	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;

	float screenSizeY = (float)FinalTexture->getTextureHeight();
	float screenSizeX = (float)FinalTexture->getTextureWidth();

	FinalTexture->setRenderTarget(renderer->getDeviceContext());
	FinalTexture->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 0.0f, 1.0f, 1.0f);

	worldMatrix = renderer->getWorldMatrix();
	baseViewMatrix = camera->getOrthoViewMatrix();
	orthoMatrix = DownSampletexture->getOrthoMatrix();

	// Render for Horizontal Blur
	renderer->setZBuffer(false);

	orthoMesh->sendData(renderer->getDeviceContext());
	//textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView());
	shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, DownSampletexture->getShaderResourceView(), camera->getPosition(), camera->getForwardVector(), 0.0f, sy,sx, renderer->getWorldMatrix(), camera->getViewMatrix(), renderer->getProjectionMatrix(),timer->getTime());
	shader->render(renderer->getDeviceContext(), orthoMesh->getIndexCount());

	renderer->setZBuffer(true);

	// Reset the render target back to the original back buffer and not the render to texture anymore.
	renderer->setBackBufferRenderTarget();
}

void App1::finalPass()
{
	// Clear the scene. (default blue colour)
	renderer->beginScene(0.39f, 0.58f, 0.92f, 1.0f);

	// RENDER THE RENDER TEXTURE SCENE
	// Requires 2D rendering and an ortho mesh.
	renderer->setZBuffer(false);
	XMMATRIX worldMatrix = renderer->getWorldMatrix();
	XMMATRIX orthoMatrix = renderer->getOrthoMatrix();  // ortho matrix for 2D rendering
	XMMATRIX orthoViewMatrix = camera->getOrthoViewMatrix();	// Default camera position for orthographic rendering

	orthoMesh->sendData(renderer->getDeviceContext());
	textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, orthoViewMatrix, orthoMatrix, FinalTexture->getShaderResourceView());
	textureShader->render(renderer->getDeviceContext(), orthoMesh->getIndexCount());
	renderer->setZBuffer(true);

	// Render GUI
	gui();

	// Present the rendered scene to the screen.
	renderer->endScene();
}

//
/*
float App1::distance_from_sphere(XMFLOAT3 p, XMFLOAT3 c, float r)
{
	float answer = Distance_between_3Dpoints_2_(p,c);
	answer = answer - r;
	//answer < 0 is inside the sphere
	//answer = 0 is on the surface of the sphere
	//answer > 0 is outside the sphere
	return answer;
}

float App1::Distance_between_3Dpoints_2_(XMFLOAT3 b, XMFLOAT3 a)
{
	float x =( pow((b.x - a.x),2.0));
	float y = (pow((b.y - a.y), 2.0));
	float z = (pow((b.z - a.z), 2.0));
	float d = (x + y + z);
	d = std::sqrt(d);
	return d;
}
*/

//

