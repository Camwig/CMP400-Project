#include "VertexManipulatorShader.h"



VertexManipulatorShader::VertexManipulatorShader(ID3D11Device* device, HWND hwnd) : BaseShader(device, hwnd)
{
	initShader(L"New_manipulator_vs.cso", L"New_manipulator_ps.cso");
}


VertexManipulatorShader::~VertexManipulatorShader()
{
	// Release the sampler state.
	if (sampleState)
	{
		sampleState->Release();
		sampleState = 0;
	}

	// Release the matrix constant buffer.
	if (matrixBuffer)
	{
		matrixBuffer->Release();
		matrixBuffer = 0;
	}

	if (settingsBufferVs)
	{
		settingsBufferVs->Release();
		settingsBufferVs = 0;
	}

	if (settingsBufferPs)
	{
		settingsBufferPs->Release();
		settingsBufferPs = 0;
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


void VertexManipulatorShader::initShader(const wchar_t* vsFilename, const wchar_t* psFilename)
{
	//D3D11_BUFFER_DESC matrixBufferDesc;
	//D3D11_SAMPLER_DESC samplerDesc;

	//// Load (+ compile) shader files
	//loadVertexShader(vsFilename);
	//loadPixelShader(psFilename);

	//// Setup the description of the dynamic matrix constant buffer that is in the vertex shader.
	//matrixBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	//matrixBufferDesc.ByteWidth = sizeof(MatrixBufferType);
	//matrixBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	//matrixBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	//matrixBufferDesc.MiscFlags = 0;
	//matrixBufferDesc.StructureByteStride = 0;

	//// Create the constant buffer pointer so we can access the vertex shader constant buffer from within this class.
	//renderer->CreateBuffer(&matrixBufferDesc, NULL, &matrixBuffer);

	//// Create a texture sampler state description.
	//samplerDesc.Filter = D3D11_FILTER_ANISOTROPIC;
	//samplerDesc.AddressU = D3D11_TEXTURE_ADDRESS_CLAMP;
	//samplerDesc.AddressV = D3D11_TEXTURE_ADDRESS_CLAMP;
	//samplerDesc.AddressW = D3D11_TEXTURE_ADDRESS_CLAMP;
	//samplerDesc.MipLODBias = 0.0f;
	//samplerDesc.MaxAnisotropy = 1;
	//samplerDesc.ComparisonFunc = D3D11_COMPARISON_ALWAYS;
	//samplerDesc.MinLOD = 0;
	//samplerDesc.MaxLOD = D3D11_FLOAT32_MAX;

	//// Create the texture sampler state.
	//renderer->CreateSamplerState(&samplerDesc, &sampleState);

	D3D11_BUFFER_DESC matrixBufferDesc;
	D3D11_BUFFER_DESC cameraBufferDesc;
	D3D11_SAMPLER_DESC samplerDesc;
	D3D11_BUFFER_DESC lightBufferDesc;

	D3D11_BUFFER_DESC extraBufferDesc;
	D3D11_BUFFER_DESC settingsBufferDesc;
	D3D11_BUFFER_DESC settingsBufferDesc2;

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
	renderer->CreateBuffer(&matrixBufferDesc, NULL, &matrixBuffer);


	extraBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	extraBufferDesc.ByteWidth = sizeof(ExtraBufferType);
	extraBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	extraBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	extraBufferDesc.MiscFlags = 0;
	extraBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&extraBufferDesc, NULL, &extr_buffer);

	//Create and setup the camera buffer
	cameraBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	cameraBufferDesc.ByteWidth = sizeof(MatrixBufferType);
	cameraBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	cameraBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	cameraBufferDesc.MiscFlags = 0;
	cameraBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&cameraBufferDesc, NULL, &cameraBuffer);

	// Create a texture sampler state description.
	samplerDesc.Filter = D3D11_FILTER_ANISOTROPIC;
	samplerDesc.AddressU = D3D11_TEXTURE_ADDRESS_WRAP;
	samplerDesc.AddressV = D3D11_TEXTURE_ADDRESS_WRAP;
	samplerDesc.AddressW = D3D11_TEXTURE_ADDRESS_WRAP;
	samplerDesc.MipLODBias = 0.0f;
	samplerDesc.MaxAnisotropy = 1;
	samplerDesc.ComparisonFunc = D3D11_COMPARISON_ALWAYS;
	samplerDesc.MinLOD = 0;
	samplerDesc.MaxLOD = D3D11_FLOAT32_MAX;
	renderer->CreateSamplerState(&samplerDesc, &sampleState);

	// Setup light buffer
	// Setup the description of the light dynamic constant buffer that is in the pixel shader.
	// Note that ByteWidth always needs to be a multiple of 16 if using D3D11_BIND_CONSTANT_BUFFER or CreateBuffer will fail.
	lightBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	lightBufferDesc.ByteWidth = sizeof(LightBufferType);
	lightBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	lightBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	lightBufferDesc.MiscFlags = 0;
	lightBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&lightBufferDesc, NULL, &lightBuffer);

	settingsBufferDesc.Usage = D3D11_USAGE_DYNAMIC;
	settingsBufferDesc.ByteWidth = sizeof(SettingsBufferVs);
	settingsBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	settingsBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	settingsBufferDesc.MiscFlags = 0;
	settingsBufferDesc.StructureByteStride = 0;
	renderer->CreateBuffer(&settingsBufferDesc, NULL, &settingsBufferVs);

	settingsBufferDesc2.Usage = D3D11_USAGE_DYNAMIC;
	settingsBufferDesc2.ByteWidth = sizeof(SettingsBufferPs);
	settingsBufferDesc2.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	settingsBufferDesc2.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	settingsBufferDesc2.MiscFlags = 0;
	settingsBufferDesc2.StructureByteStride = 0;
	renderer->CreateBuffer(&settingsBufferDesc2, NULL, &settingsBufferPs);
}


void VertexManipulatorShader::setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture, Light* light[NUM_LIGHTS], XMFLOAT3 CameraPosition, float Octaves, float Hurst,float SmoothSteps, XMFLOAT4 Colour)
{
	//HRESULT result;
	//D3D11_MAPPED_SUBRESOURCE mappedResource;
	//MatrixBufferType* dataPtr;
	//XMMATRIX tworld, tview, tproj;


	//// Transpose the matrices to prepare them for the shader.
	//tworld = XMMatrixTranspose(worldMatrix);
	//tview = XMMatrixTranspose(viewMatrix);
	//tproj = XMMatrixTranspose(projectionMatrix);

	//// Sned matrix data
	//result = deviceContext->Map(matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	//dataPtr = (MatrixBufferType*)mappedResource.pData;
	//dataPtr->world = tworld;// worldMatrix;
	//dataPtr->view = tview;
	//dataPtr->projection = tproj;
	//deviceContext->Unmap(matrixBuffer, 0);
	//deviceContext->VSSetConstantBuffers(0, 1, &matrixBuffer);

	//// Set shader texture and sampler resource in the pixel shader.
	//deviceContext->PSSetShaderResources(0, 1, &texture);
	//deviceContext->PSSetSamplers(0, 1, &sampleState);

	//deviceContext->VSSetShaderResources(0, 1, &texture);
	//deviceContext->VSSetSamplers(0, 1, &sampleState);

	HRESULT result;
	D3D11_MAPPED_SUBRESOURCE mappedResource;
	MatrixBufferType* dataPtr;
	CameraBufferType* camPtr;
	ExtraBufferType* extra;

	SettingsBufferVs* settings_;
	SettingsBufferPs* settings_2;

	XMMATRIX tworld, tview, tproj;


	// Transpose the matrices to prepare them for the shader.
	tworld = XMMatrixTranspose(world);
	tview = XMMatrixTranspose(view);
	tproj = XMMatrixTranspose(projection);

	//Defines and sets up each light view matrix along with the projection matrix
	XMMATRIX tLightViewMatrix1 = XMMatrixTranspose(light[0]->getViewMatrix());
	XMMATRIX tLightProjectionMatrix1 = XMMatrixTranspose(light[0]->getOrthoMatrix());
	//XMMATRIX tLightViewMatrix2 = XMMatrixTranspose(light[1]->getViewMatrix());
	//XMMATRIX tLightProjectionMatrix2 = XMMatrixTranspose(light[1]->getOrthoMatrix());

	result = deviceContext->Map(matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	dataPtr = (MatrixBufferType*)mappedResource.pData;
	dataPtr->world = tworld;// worldMatrix;
	dataPtr->view = tview;
	dataPtr->projection = tproj;
	deviceContext->Unmap(matrixBuffer, 0);
	deviceContext->VSSetConstantBuffers(0, 1, &matrixBuffer);


	result = deviceContext->Map(extr_buffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	extra = (ExtraBufferType*)mappedResource.pData;
	extra->lightView[0] = tLightViewMatrix1;
	extra->lightProjection[0] = tLightProjectionMatrix1;
	//extra->Ocatves = Octaves;
	//extra->Hurst = Hurst;
	//extra->padding = XMFLOAT2(0.0f,0.0f);
	//dataPtr->lightView[1] = tLightViewMatrix2;
	//dataPtr->lightProjection[1] = tLightProjectionMatrix2;
	deviceContext->Unmap(extr_buffer, 0);
	deviceContext->VSSetConstantBuffers(2, 1, &extr_buffer);

	deviceContext->Map(cameraBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	camPtr = (CameraBufferType*)mappedResource.pData;
	camPtr->cameraPosition = CameraPosition;
	camPtr->padding = 0.0f;
	deviceContext->Unmap(cameraBuffer, 1);
	deviceContext->VSSetConstantBuffers(1, 1, &cameraBuffer);

	//Additional
	// Send light data to pixel shader
	LightBufferType* lightPtr;
	deviceContext->Map(lightBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	lightPtr = (LightBufferType*)mappedResource.pData;

	//Setting the lighing values
	lightPtr->diffuse[0] = light[0]->getDiffuseColour();
	lightPtr->position[0] = XMFLOAT4(light[0]->getPosition().x, light[0]->getPosition().y, light[0]->getPosition().z, 1.0f);

	//lightPtr->diffuse[1] = light[1]->getDiffuseColour();
	//lightPtr->position[1] = XMFLOAT4(light[1]->getPosition().x, light[1]->getPosition().y, light[1]->getPosition().z, 1.0f);

	//lightPtr->direction = XMFLOAT4(light[2]->getDirection().x, light[2]->getDirection().y, light[2]->getDirection().z, 1.0f);
	//lightPtr->diffuse[2] = light[2]->getDiffuseColour();
	//lightPtr->position[2] = XMFLOAT4(light[2]->getPosition().x, light[2]->getPosition().y, light[2]->getPosition().z, 2.0f);

	lightPtr->ambient = light[0]->getAmbientColour();
	lightPtr->specularPower = 2.0f;
	lightPtr->padding = XMFLOAT3(0.0f, 0.0f, 0.0f);
	deviceContext->Unmap(lightBuffer, 0);
	deviceContext->PSSetConstantBuffers(0, 1, &lightBuffer);

	deviceContext->Map(settingsBufferVs, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	settings_ = (SettingsBufferVs*)mappedResource.pData;
	settings_->Octaves = Octaves;
	settings_->Hurst = Hurst;
	//settings_->radius = Radius;
	settings_->Padding1 = XMFLOAT2(0.0f,0.0f);
	//settings_->Position = Position;
	settings_->SmoothSteps = SmoothSteps;
	//settings_->Colour = Colour;
	//settings_->MAx_Distance = Max_distance;
	settings_->Padding2 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	deviceContext->Unmap(settingsBufferVs, 0);
	deviceContext->VSSetConstantBuffers(3, 1, &settingsBufferVs);
	//deviceContext->PSSetConstantBuffers(1, 1, &settingsBufferVs);

	deviceContext->Map(settingsBufferPs, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
	settings_2 = (SettingsBufferPs*)mappedResource.pData;
	settings_2->Colour = Colour;
	deviceContext->Unmap(settingsBufferPs, 0);
	//deviceContext->VSSetConstantBuffers(3, 1, &settingsBufferVs);
	deviceContext->PSSetConstantBuffers(1, 1, &settingsBufferPs);

	// Set shader texture resource in the pixel shader.
	deviceContext->PSSetShaderResources(0, 1, &texture);
	deviceContext->PSSetSamplers(0, 1, &sampleState);

	deviceContext->VSSetShaderResources(0, 1, &texture);
	deviceContext->VSSetSamplers(0, 1, &sampleState);
}