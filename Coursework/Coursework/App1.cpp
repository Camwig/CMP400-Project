#include "App1.h"

App1::App1()
{

}

void App1::init(HINSTANCE hinstance, HWND hwnd, int screenWidth, int screenHeight, Input* in, bool VSYNC, bool FULL_SCREEN)
{
	// Call super/parent init function (required!)
	BaseApplication::init(hinstance, hwnd, screenWidth, screenHeight, in, VSYNC, FULL_SCREEN);

	//Defines the size of the screen as well as the size the orthomesh should cover
	sx = screenWidth;
	sy = screenHeight;
	orthoMesh = new OrthoMesh(renderer->getDevice(), renderer->getDeviceContext(), screenWidth, screenHeight);	// Full screen size

	//Initalises the shaders
	shader = new RayMarchingShader(renderer->getDevice(), hwnd);
	textureShader = new TextureShader(renderer->getDevice(), hwnd);
	vertex_shader = new VertexManipulatorShader(renderer->getDevice(), hwnd);

	//Initialises the render textures
	renderTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);
	FinalTexture = new RenderTexture(renderer->getDevice(), screenWidth, screenHeight, SCREEN_NEAR, SCREEN_DEPTH);

	//Creates the sphere mesh
	mesh = new SphereMesh(renderer->getDevice(), renderer->getDeviceContext());

	//Defines the light defintions and properties
	light[0] = new Light();
	light[0]->setAmbientColour(AmbientColour.x, AmbientColour.y, AmbientColour.z, AmbientColour.w);
	light[0]->setDiffuseColour(DiffuseColour.x, DiffuseColour.y, DiffuseColour.z, 1.0f);
	light[0]->setPosition(LightPosition.x, LightPosition.y, LightPosition.z);
	light[0]->setDirection(LightDirection.x, LightDirection.y, LightDirection.z);
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
	if (textureShader)
	{
		delete textureShader;
		textureShader = 0;
	}
	if (vertex_shader)
	{
		delete vertex_shader;
		vertex_shader = 0;
	}
	if (renderTexture)
	{
		delete renderTexture;
		renderTexture = 0;
	}
	if (FinalTexture)
	{
		delete FinalTexture;
		FinalTexture = 0;
	}
	if (mesh)
	{
		delete mesh;
		mesh = 0;
	}
	for (int i =0; i< NUM_LIGHTS; i++)
	{
		if (light[i])
		{
			delete light[i];
			light[i] = 0;
		}
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
	//Memory leak in one of these functions
	if (!VertexBased)
		RenderedPass();
	finalPass();

	//Updates the lighting values
	//Could of used a check but activley checking the change in the GUI was actively more computationally intensive
	light[0]->setAmbientColour(AmbientColour.x, AmbientColour.y, AmbientColour.z, AmbientColour.w);
	light[0]->setDiffuseColour(DiffuseColour.x, DiffuseColour.y, DiffuseColour.z, 1.0f);
	light[0]->setPosition(LightPosition.x, LightPosition.y, LightPosition.z);
	light[0]->setDirection(LightDirection.x, LightDirection.y, LightDirection.z);

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
	ImGui::Checkbox("VertexBase", &VertexBased);
	ImGui::Checkbox("Point light True/Directional Light false", &point);

	ImGui::SliderInt("Octaves", &Octaves, 0, 10);
	ImGui::SliderFloat("Hurst", &Hurst, 0, 1);
	ImGui::SliderFloat("Frequency", &Frequency, 1, 10);
	ImGui::SliderFloat("Amplitude", &Amplitude, 1, 10);

	ImGui::SliderFloat("Radius", &radius, 0, 10);

	if (ImGui::CollapsingHeader("Position"))
	{
		ImGui::SliderFloat("Position X", &Position.x, -10, 10);
		ImGui::SliderFloat("Position Y", &Position.y, -10, 10);
		ImGui::SliderFloat("Position Z", &Position.z, -10, 10);
	}

	ImGui::SliderInt("Smooth Steps", &SmoothSteps, 0, 6);

	if (ImGui::CollapsingHeader("Colour"))
	{
		ImGui::SliderFloat("Colour R", &Colour.x, 0, 1);
		ImGui::SliderFloat("Colour G", &Colour.y, 0, 1);
		ImGui::SliderFloat("Colour B", &Colour.z, 0, 1);
		ImGui::SliderFloat("Colour A", &Colour.w, 0, 1);
	}

	if (ImGui::CollapsingHeader("Light"))
	{

		if (ImGui::CollapsingHeader("Ambient Colour"))
		{
			ImGui::SliderFloat("Ambient R", &AmbientColour.x, 0, 0.5);
			ImGui::SliderFloat("Ambient G", &AmbientColour.y, 0, 0.5);
			ImGui::SliderFloat("Ambient B", &AmbientColour.z, 0, 0.5);
		}

		if (ImGui::CollapsingHeader("Diffuse Colour"))
		{
			ImGui::SliderFloat("Diffuse R", &DiffuseColour.x, 0, 1);
			ImGui::SliderFloat("Diffuse G", &DiffuseColour.y, 0, 1);
			ImGui::SliderFloat("Diffuse B", &DiffuseColour.z, 0, 1);
		}

		if (point)
		{
			//Only if point light
			if (ImGui::CollapsingHeader("Light Position"))
			{
				ImGui::SliderFloat("Light X", &LightPosition.x, -10, 10);
				ImGui::SliderFloat("Light Y", &LightPosition.y, -10, 10);
				ImGui::SliderFloat("Light Z", &LightPosition.z, -10, 10);
			}
		}
		else
		{
			//only if directional
			if (ImGui::CollapsingHeader("Light Direction"))
			{
				ImGui::SliderFloat("Direction X", &LightDirection.x, -1, 1);
				ImGui::SliderFloat("Direction Y", &LightDirection.y, -1, 1);
				ImGui::SliderFloat("Direction Z", &LightDirection.z, -1, 1);
			}
		}
	}

	ImGui::SliderInt("Ray Trace Maximum Distance", &MAx_Distance, 0, 5000);

	// Render UI
	ImGui::Render();
	ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
}

void App1::RenderedPass()
{
	//XMMATRIX worldMatrix, baseViewMatrix, orthoMatrix;

	//Defines the of the screen for use in the shader
	/*float*/ screenSizeY = (float)FinalTexture->getTextureHeight();
	/*float*/ screenSizeX = (float)FinalTexture->getTextureWidth();

	FinalTexture->setRenderTarget(renderer->getDeviceContext());
	FinalTexture->clearRenderTarget(renderer->getDeviceContext(), 1.0f, 0.0f, 0.0f, 1.0f);

	worldMatrix = renderer->getWorldMatrix();
	baseViewMatrix = camera->getOrthoViewMatrix();
	orthoMatrix = FinalTexture->getOrthoMatrix();

	// Render for Horizontal Blur
	renderer->setZBuffer(false);

	orthoMesh->sendData(renderer->getDeviceContext());
	shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, baseViewMatrix, orthoMatrix,light, camera->getPosition(), camera->getForwardVector(), 0.0f, sy, sx, renderer->getWorldMatrix(), camera->getViewMatrix(), renderer->getProjectionMatrix(), /*applied_noise*/timer->getTime(),Octaves,Hurst,radius,Position,SmoothSteps,Colour,MAx_Distance,point,10-Frequency,10-Amplitude);
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
	camera->update();

	if (!VertexBased)
	{
		renderer->setZBuffer(false);
		/*XMMATRIX*/ worldMatrix = renderer->getWorldMatrix();
		/*XMMATRIX*/ orthoMatrix = renderer->getOrthoMatrix();  // ortho matrix for 2D rendering
		/*XMMATRIX*/ orthoViewMatrix = camera->getOrthoViewMatrix();	// Default camera position for orthographic rendering

		orthoMesh->sendData(renderer->getDeviceContext());
		textureShader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, orthoViewMatrix, orthoMatrix, FinalTexture->getShaderResourceView());
		textureShader->render(renderer->getDeviceContext(), orthoMesh->getIndexCount());
		renderer->setZBuffer(true);
	}
	else
	{
		/*camera->update();*/

		// Get the world, view, projection, and ortho matrices from the camera and Direct3D objects.
		/*XMMATRIX*/ worldMatrix = renderer->getWorldMatrix();
		/*XMMATRIX*/ viewMatrix = camera->getViewMatrix();
		/*XMMATRIX*/ projectionMatrix = renderer->getProjectionMatrix();

		worldMatrix = XMMatrixTranslation(Position.x, Position.y, Position.z);
		/*XMMATRIX*/ scaleMatrix = XMMatrixScaling(radius, radius, radius);
		worldMatrix = XMMatrixMultiply(worldMatrix, scaleMatrix);

		// Send geometry data, set shader parameters, render object with shader
		mesh->sendData(renderer->getDeviceContext());
		vertex_shader->setShaderParameters(renderer->getDeviceContext(), worldMatrix, viewMatrix, projectionMatrix, light, camera->getPosition(), Octaves, Hurst, SmoothSteps, Colour,point,10-Frequency,Amplitude);
		vertex_shader->render(renderer->getDeviceContext(), mesh->getIndexCount());
	}

	// Render GUI
	gui();

	// Present the rendered scene to the screen.
	renderer->endScene();
}

