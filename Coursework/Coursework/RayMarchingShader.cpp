#include "RayMarchingShader.h"

RayMarchingShader::RayMarchingShader(ID3D11Device* device, HWND hwnd) : BaseShader(device, hwnd)
{
	initShader(L"RayMarching_vs.cso", L"RayMarching_ps.cso");
}


RayMarchingShader::~RayMarchingShader()
{
	// Release the matrix constant buffer.
	if (matrixBuffer)
	{
		matrixBuffer->Release();
		matrixBuffer = 0;
	}

	if (cameraBuffer)
	{
		cameraBuffer->Release();
		cameraBuffer = 0;
	}

	if (screenSizeBuffer)
	{
		screenSizeBuffer->Release();
		screenSizeBuffer = 0;
	}

	if (settingsBuffer)
	{
		settingsBuffer->Release();
		settingsBuffer = 0;
	}

	if (extr_buffer)
	{
		extr_buffer->Release();
		extr_buffer = 0;
	}

	if (lightBuffer)
	{
		lightBuffer->Release();
		lightBuffer = 0;
	}

	// Release the layout.
	if (layout)
	{
		layout->Release();
		layout = 0;
	}

	//Release base shader components
	BaseShader::~BaseShader();
}


void RayMarchingShader::initShader(const wchar_t* vsFilename, const wchar_t* psFilename)
{
	D3D11_BUFFER_DESC matrixBufferDesc;
	D3D11_BUFFER_DESC cameraBufferDesc;
	D3D11_BUFFER_DESC screenSizeBufferDesc;
	D3D11_BUFFER_DESC settingsBufferDesc;
	D3D11_BUFFER_DESC lightBufferDesc;
	D3D11_BUFFER_DESC extraBufferDesc;

	// Load (+ compile) shader files
	loadVertexShader(vsFilename);
	loadPixelShader(psFilename);

	// Setup the description of the dynamic matrix constant buffer that is in the vertex shader.
	matrixBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	matrixBufferDesc.ByteWidth = sizeof(MatrixBufferType);
	matrixBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	matrixBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	matrixBufferDesc.MiscFlags = 0;
	matrixBufferDesc.StructureByteStride = 0;

	// Create the constant buffer pointer so we can access the vertex shader constant buffer from within this class.
	renderer->CreateBuffer(&matrixBufferDesc, NULL, &matrixBuffer);
	cameraBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	cameraBufferDesc.ByteWidth = sizeof(CameraBufferType);
	cameraBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	cameraBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	cameraBufferDesc.MiscFlags = 0;
	cameraBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&cameraBufferDesc, NULL, &cameraBuffer);

	// Setup the description of the shaders.
	screenSizeBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	screenSizeBufferDesc.ByteWidth = sizeof(ScreenSizeBuffer);
	screenSizeBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	screenSizeBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	screenSizeBufferDesc.MiscFlags = 0;
	screenSizeBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&screenSizeBufferDesc, NULL, &screenSizeBuffer);

	settingsBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	settingsBufferDesc.ByteWidth = sizeof(SettingsBuffer);
	settingsBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	settingsBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	settingsBufferDesc.MiscFlags = 0;
	settingsBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&settingsBufferDesc,NULL,&settingsBuffer);

	lightBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	lightBufferDesc.ByteWidth = sizeof(LightBufferType);
	lightBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	lightBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	lightBufferDesc.MiscFlags = 0;
	lightBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&lightBufferDesc, NULL, &lightBuffer);

	extraBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	extraBufferDesc.ByteWidth = sizeof(ExtraBufferType);
	extraBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	extraBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	extraBufferDesc.MiscFlags = 0;
	extraBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&extraBufferDesc, NULL, &extr_buffer);
}


void RayMarchingShader::setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& worldMatrix, const XMMATRIX& viewMatrix, const XMMATRIX& projectionMatrix, Light* light[NUM_LIGHTS_],XMFLOAT3 cameraPos, XMFLOAT3 camForwardVec, float distance_from_shap, float height, float width, const XMMATRIX& world2, const XMMATRIX& view2, const XMMATRIX& projection2, float deltaTime, float Octaves, float Hurst, float Radius, XMFLOAT3 Position, float SmoothSteps, XMFLOAT4 Colour, float Max_distance,bool light_type)
{
	D3D11_MAPPED_SUBRESOURCE mappedResource;
	MatrixBufferType* dataPtr;
	XMMATRIX tworld, tview, tproj;

	CameraBufferType* camPtr;
	ScreenSizeBuffer* screen_;
	SettingsBuffer* settings_;

	ExtraBufferType* extra;
	LightBufferType* lightPtr;

	// Transpose the matrices to prepare them for the shader.
	tworld = XMMatrixTranspose(worldMatrix);
	tview = XMMatrixTranspose(viewMatrix);
	tproj = XMMatrixTranspose(projectionMatrix);

	XMMATRIX tLightViewMatrix1 = XMMatrixTranspose(light[0]->getViewMatrix());
	XMMATRIX tLightProjectionMatrix1 = XMMatrixTranspose(light[0]->getOrthoMatrix());

	// Lock the constant buffer so it can be written to.
	deviceContext->Map(matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	dataPtr = (MatrixBufferType*)mappedResource.pData;
	dataPtr->world = tworld;// worldMatrix;
	dataPtr->view = tview;
	dataPtr->projection = tproj;
	deviceContext->Unmap(matrixBuffer, 0);
	// Now set the constant buffer in the vertex shader with the updated values.
	deviceContext->VSSetConstantBuffers(0, 1, &matrixBuffer);

	//Map the appropriate data to the buffer and pass it to the correct shader
	deviceContext->Map(cameraBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	camPtr = (CameraBufferType*)mappedResource.pData;
	camPtr->CameraOrigin = cameraPos;
	camPtr->CameraForwardDirection = camForwardVec;
	camPtr->distance_from_shape = distance_from_shap;
	camPtr->deltaTime = deltaTime;
	camPtr->padding = 0.0f;
	camPtr->padding2 = 0.0f;
	camPtr->padding3 = XMFLOAT3(0.0f,0.0f,0.0f);
	camPtr->padding4 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	deviceContext->Unmap(cameraBuffer, 0);
	deviceContext->PSSetConstantBuffers(0, 1, &cameraBuffer);
	deviceContext->VSSetConstantBuffers(1, 1, &cameraBuffer);

	deviceContext->Map(screenSizeBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	screen_ = (ScreenSizeBuffer*)mappedResource.pData;
	screen_->screenheight = height;
	screen_->screenWidth = width;
	screen_->padding = XMFLOAT3(1.0f, 1.f, 1.f);
	screen_->padding2 = XMFLOAT3(1.0f, 1.f, 1.f);

	screen_->Projection = projection2;
	screen_->View = view2;
	screen_->World = world2;

	deviceContext->Unmap(screenSizeBuffer, 0);
	deviceContext->PSSetConstantBuffers(1, 1, &screenSizeBuffer);

	deviceContext->Map(settingsBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	settings_ = (SettingsBuffer*)mappedResource.pData;
	settings_->Octaves = Octaves;
	settings_->Hurst = Hurst;
	settings_->radius = Radius;
	settings_->Padding1 = 0.0f;
	settings_->Position = Position;
	settings_->SmoothSteps = SmoothSteps;
	settings_->Colour = Colour;
	settings_->MAx_Distance = Max_distance;
	settings_->Padding2 = XMFLOAT3(0.0f,0.0f,0.0f);
	deviceContext->Unmap(settingsBuffer, 0);
	deviceContext->PSSetConstantBuffers(2, 1, &settingsBuffer);

	deviceContext->Map(lightBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	lightPtr = (LightBufferType*)mappedResource.pData;
	lightPtr->diffuse[0] = light[0]->getDiffuseColour();
	lightPtr->direction[0] = XMFLOAT4(light[0]->getDirection().x, light[0]->getDirection().y, light[0]->getDirection().z, 1.0f);
	//Check the lighting boolean to set the light positions w value as it is not used we can use it to set what kind of lighting the passed data represents 
	if (light_type)
	{
		lightPtr->position[0] = XMFLOAT4(light[0]->getPosition().x, light[0]->getPosition().y, light[0]->getPosition().z, 1.0f);
	}
	else
	{
		lightPtr->position[0] = XMFLOAT4(light[0]->getPosition().x, light[0]->getPosition().y, light[0]->getPosition().z, 2.0f);
	}

	lightPtr->ambient = light[0]->getAmbientColour();
	lightPtr->specularPower = 2.0f;
	lightPtr->padding = XMFLOAT3(0.0f, 0.0f, 0.0f);
	deviceContext->Unmap(lightBuffer, 0);
	deviceContext->PSSetConstantBuffers(3, 1, &lightBuffer);

	deviceContext->Map(extr_buffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	extra = (ExtraBufferType*)mappedResource.pData;
	extra->lightView[0] = tLightViewMatrix1;
	extra->lightProjection[0] = tLightProjectionMatrix1;
	deviceContext->Unmap(extr_buffer, 0);
	deviceContext->VSSetConstantBuffers(2, 1, &extr_buffer);
}