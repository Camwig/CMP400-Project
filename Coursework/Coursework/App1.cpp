// Lab1.cpp
// Lab 1 example, simple coloured triangle mesh
#include "App1.h"

App1::App1()
{

}

void App1::init(HINSTANCE hinstance, HWND hwnd, int screenWidth, int screenHeight, Input* in, bool VSYNC, bool FULL_SCREEN)
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
	perlinShader = new PerlinTextureShader(renderer->getDevice(), hwnd);

	vertex_shader = new VertexManipulatorShader(renderer->getDevice(), hwnd);

	PerlinTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);

	//ID3D11Device::CreateRenderTargetView(D3D11_BIND_RENDER_TARGET);

	renderTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
	DownSampletexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
	FinalTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);

	mesh = new SphereMesh(renderer->getDevice(), renderer->getDeviceContext());

	started = false;
	VertexBased = true;

	//TD_Text = new TDRenderTarget(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);

	//PerlinGeneration();


	//D3D11_TEXTURE3D_DESC desc;
	//desc.Width = 256;
	//desc.Height = 256;
	//desc.Depth = 256;
	//desc.MipLevels = 1;
	//desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	//desc.Usage = D3D11_USAGE_DEFAULT;
	//desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
	//desc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	//desc.MiscFlags = 0;

	//ID3D11Device* pd3dDevice;
	//pd3dDevice = renderer->getDevice();
	//ID3D11Texture3D* pTexture = NULL;
	//pd3dDevice->CreateTexture3D(&desc, NULL, &pTexture);
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

	//FillTDText();
	//finalPass();

	firstPass();
	if (!started)
	{
		PerlinGeneration();
		started = true;
	}
	//SamplePass();
	RenderedPass();
	finalPass();

	//gui();

	// Present the rendered scene to the screen.
	//renderer->endScene();

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

void App1::FillTDText()
{
	TD_Text->setRenderTarget(renderer->getDeviceContext());
	TD_Text->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 1.0f, 0.0f, 1.0f);

	renderer->setBackBufferRenderTarget();
}

void App1::firstPass()
{
	// Clear the scene. (default blue colour)
//renderer->beginScene(0.39f, 0.58f, 0.92f, 1.0f);

// Set the render target to be the render to texture and clear it
	renderTexture->setRenderTarget(renderer->getDeviceContext());
	renderTexture->clearRenderTarget(renderer->getDeviceContext(), 1.0f, 0.0f, 1.0f, 1.0f);

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

//--------------------------------------------------
void App1::PerlinGeneration()
{
	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;

	float screenSizeY = (float)PerlinTexture->getTextureHeight();
	float screenSizeX = (float)PerlinTexture->getTextureWidth();

	PerlinTexture->setRenderTarget(renderer->getDeviceContext());
	PerlinTexture->clearRenderTarget(renderer->getDeviceContext(), 0.0f, 0.0f, 1.0f, 1.0f);

	//PerlinTexture_2->

	worldMatrix = renderer->getWorldMatrix();
	baseViewMatrix = camera->getOrthoViewMatrix();
	orthoMatrix = PerlinTexture->getOrthoMatrix();

	// Render for Horizontal Blur
	renderer->setZBuffer(false);

	sampleMesh->sendData(renderer->getDeviceContext());

	//Replace with the Perlin texture
	perlinShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView(),screenSizeY,screenSizeX);
	perlinShader->render(renderer->getDeviceContext(), sampleMesh->getIndexCount());

	renderer->setZBuffer(true);

	// Reset the render target back to the original back buffer and not the render to texture anymore.
	renderer->setBackBufferRenderTarget();
}
//--------------------------------------------------

//void App1::SamplePass()
//{
//	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;
//
//	DownSampletexture->setRenderTarget(renderer->getDeviceContext());
//	DownSampletexture->clearRenderTarget(renderer->getDeviceContext(), 1.0f, 1.0f, 1.0f, 1.0f);
//
//	worldMatrix = renderer->getWorldMatrix();
//	baseViewMatrix = camera->getOrthoViewMatrix();
//	orthoMatrix = renderTexture->getOrthoMatrix();
//
//	// Render for Horizontal Blur
//	renderer->setZBuffer(false);
//
//	sampleMesh->sendData(renderer->getDeviceContext());
//	textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView());
//	textureShader->render(renderer->getDeviceContext(), sampleMesh->getIndexCount());
//
//	renderer->setZBuffer(true);
//
//	// Reset the render target back to the original back buffer and not the render to texture anymore.
//	renderer->setBackBufferRenderTarget();
//}

void App1::RenderedPass()
{
	XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;

	float screenSizeY = (float)FinalTexture->getTextureHeight();
	float screenSizeX = (float)FinalTexture->getTextureWidth();

	FinalTexture->setRenderTarget(renderer->getDeviceContext());
	FinalTexture->clearRenderTarget(renderer->getDeviceContext(), 1.0f, 0.0f, 0.0f, 1.0f);

	worldMatrix = renderer->getWorldMatrix();
	baseViewMatrix = camera->getOrthoViewMatrix();
	orthoMatrix = FinalTexture->getOrthoMatrix();

	// Render for Horizontal Blur
	renderer->setZBuffer(false);

	orthoMesh->sendData(renderer->getDeviceContext());
	//textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView());
	shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix, renderTexture->getShaderResourceView(), camera->getPosition(), camera->getForwardVector(), 0.0f, sy, sx, renderer->getWorldMatrix(), camera->getViewMatrix(), renderer->getProjectionMatrix(), timer->getTime(), PerlinTexture->getShaderResourceView());
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

	if (!VertexBased)
	{
		renderer->setZBuffer(false);
		XMMATRIX worldMatrix = renderer->getWorldMatrix();
		XMMATRIX orthoMatrix = renderer->getOrthoMatrix();  // ortho matrix for 2D rendering
		XMMATRIX orthoViewMatrix = camera->getOrthoViewMatrix();	// Default camera position for orthographic rendering

		orthoMesh->sendData(renderer->getDeviceContext());
		//textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, orthoViewMatrix, orthoMatrix, /*FinalTexture*/TD_Text->getShaderResourceView());
		textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, orthoViewMatrix, orthoMatrix, FinalTexture->getShaderResourceView());
		textureShader->render(renderer->getDeviceContext(), orthoMesh->getIndexCount());
		renderer->setZBuffer(true);
	}
	else
	{
		camera->update();

		// Get the world, view, projection, and ortho matrices from the camera and Direct3D objects.
		XMMATRIX worldMatrix = renderer->getWorldMatrix();
		XMMATRIX viewMatrix = camera->getViewMatrix();
		XMMATRIX projectionMatrix = renderer->getProjectionMatrix();

		// Send geometry data, set shader parameters, render object with shader
		mesh->sendData(renderer->getDeviceContext());
		vertex_shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, viewMatrix, projectionMatrix, PerlinTexture->getShaderResourceView());
		vertex_shader->render(renderer->getDeviceContext(), mesh->getIndexCount());
	}

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

