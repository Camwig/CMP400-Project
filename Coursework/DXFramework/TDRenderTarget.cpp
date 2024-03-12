#include "TDRenderTarget.h"

// Initialise texture object based on provided dimensions. Usually to match window.
TDRenderTarget::TDRenderTarget(ID3D11Device* device, int ltextureWidth, int ltextureHeight, float screenNear, float screenFar)
{

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

	D3D11_TEXTURE3D_DESC textureDesc;
	HRESULT result;
	D3D11_RENDER_TARGET_VIEW_DESC renderTargetViewDesc;
	D3D11_SHADER_RESOURCE_VIEW_DESC shaderResourceViewDesc;
	D3D11_TEXTURE2D_DESC depthBufferDesc;
	D3D11_DEPTH_STENCIL_VIEW_DESC depthStencilViewDesc;

	textureWidth = ltextureWidth;
	textureHeight = ltextureHeight;

	ZeroMemory(&textureDesc, sizeof(textureDesc));

	// Setup the render target texture description.

		//desc.Width = 256;
	//desc.Height = 256;
	//desc.Depth = 256;
	//desc.MipLevels = 1;
	//desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	//desc.Usage = D3D11_USAGE_DEFAULT;
	//desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
	//desc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	//desc.MiscFlags = 0;

	textureDesc.Width = textureWidth;
	textureDesc.Height = textureHeight;
	textureDesc.MipLevels = 1;
	//textureDesc.ArraySize = 1;
	textureDesc.Format = DXGI_FORMAT_R32G32B32A32_FLOAT;
	//textureDesc.SampleDesc.Count = 1;
	textureDesc.Usage = D3D11_USAGE_DEFAULT;
	textureDesc.BindFlags = D3D11_BIND_RENDER_TARGET | D3D11_BIND_SHADER_RESOURCE;
	textureDesc.CPUAccessFlags = 0;
	textureDesc.MiscFlags = 0;

	//Should pass this in
	textureDesc.Depth = 256;
	
	// Create the render target texture.

	//Fails to create the texture?

	result = device->CreateTexture3D(&textureDesc, NULL, &renderTargetTexture);

	if (result != S_OK)
	{
		int i = 0;
	}

	// Setup the description of the render target view.
	renderTargetViewDesc.Format = textureDesc.Format;
	renderTargetViewDesc.ViewDimension = D3D11_RTV_DIMENSION_TEXTURE3D;
	renderTargetViewDesc.Texture3D.MipSlice = 1;
	//-----------------------------------
	renderTargetViewDesc.Texture3D.FirstWSlice = 1;
	renderTargetViewDesc.Texture3D.WSize = 1;
	renderTargetViewDesc.Texture2D.MipSlice = 0;
	//renderTargetViewDesc.Buffer = 

	//renderTargetViewDesc.
	
	// Create the render target view.
	result = device->CreateRenderTargetView(renderTargetTexture, &renderTargetViewDesc, &renderTargetView);

	if (result != S_OK)
	{
		int i = 0;
	}

	// Setup the description of the shader resource view.
	shaderResourceViewDesc.Format = textureDesc.Format;
	shaderResourceViewDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE3D;
	shaderResourceViewDesc.Texture3D.MostDetailedMip = 0;
	shaderResourceViewDesc.Texture3D.MipLevels = 1;

	//shaderResourceViewDesc.

	// Create the shader resource view.
	result = device->CreateShaderResourceView(renderTargetTexture, &shaderResourceViewDesc, &shaderResourceView);

	if (result == S_OK)
	{
		int i = 0;
	}

	// Set up the description of the depth buffer.
	ZeroMemory(&depthBufferDesc, sizeof(depthBufferDesc));
	depthBufferDesc.Width = textureWidth;
	depthBufferDesc.Height = textureHeight;
	//depthBufferDesc.Depth = 256;
	depthBufferDesc.MipLevels = 1;
	depthBufferDesc.ArraySize = 1;
	//Using the incorrect format I just need to figure out the correct one
	depthBufferDesc.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
	depthBufferDesc.SampleDesc.Count = 1;
	depthBufferDesc.SampleDesc.Quality = 0;
	depthBufferDesc.Usage = D3D11_USAGE_DEFAULT;
	depthBufferDesc.BindFlags = D3D11_BIND_DEPTH_STENCIL;
	depthBufferDesc.CPUAccessFlags = 0;
	depthBufferDesc.MiscFlags = 0;

	//depthBufferDesc.

	//Need to check whats actually needed for a 3D texture

	// Create the texture for the depth buffer using the filled out description.
	result = device->CreateTexture2D(&depthBufferDesc, NULL, &depthStencilBuffer);

	if (result != S_OK)
	{
		int i = 0;
	}


	// Set up the depth stencil view description.
	ZeroMemory(&depthStencilViewDesc, sizeof(depthStencilViewDesc));
	// Set up the depth stencil view description.
	depthStencilViewDesc.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
	depthStencilViewDesc.ViewDimension = D3D11_DSV_DIMENSION_TEXTURE2D;
	depthStencilViewDesc.Texture2D.MipSlice = 0;
	//depthStencilViewDesc.

	// Create the depth stencil view.
	result = device->CreateDepthStencilView(depthStencilBuffer, &depthStencilViewDesc, &depthStencilView);

	if (result != S_OK)
	{
		int i = 0;
	}

	// Setup the viewport for rendering.
	viewport.Width = (float)textureWidth;
	viewport.Height = (float)textureHeight;
	viewport.MinDepth = 0.0f;
	viewport.MaxDepth = 256.0f;
	viewport.TopLeftX = 0.0f;
	viewport.TopLeftY = 0.0f;

	// Setup the projection matrix.
	projectionMatrix = XMMatrixPerspectiveFovLH(((float)XM_PI / 4.0f), ((float)textureWidth / (float)textureHeight), screenNear, screenFar);

	// Create an orthographic projection matrix for 2D rendering.
	orthoMatrix = XMMatrixOrthographicLH((float)textureWidth, (float)textureHeight, screenNear, screenFar);
}

// Release resources.
TDRenderTarget::~TDRenderTarget()
{
	if (depthStencilView)
	{
		depthStencilView->Release();
		depthStencilView = 0;
	}

	if (depthStencilBuffer)
	{
		depthStencilBuffer->Release();
		depthStencilBuffer = 0;
	}

	if (shaderResourceView)
	{
		shaderResourceView->Release();
		shaderResourceView = 0;
	}

	if (renderTargetView)
	{
		renderTargetView->Release();
		renderTargetView = 0;
	}

	if (renderTargetTexture)
	{
		renderTargetTexture->Release();
		renderTargetTexture = 0;
	}
}

// Set this renderTexture as the current render target.
// All rendering is now store here, rather than the back buffer.
void TDRenderTarget::setRenderTarget(ID3D11DeviceContext* deviceContext)
{
	deviceContext->OMSetRenderTargets(1, &renderTargetView, depthStencilView);
	deviceContext->RSSetViewports(1, &viewport);
}

// Clear render texture to specified colour. Similar to clearing the back buffer, ready for the next frame.
void TDRenderTarget::clearRenderTarget(ID3D11DeviceContext* deviceContext, float red, float green, float blue, float alpha)
{
	float color[4];
	color[0] = red;
	color[1] = green;
	color[2] = blue;
	color[3] = alpha;

	// Clear the back buffer and depth buffer.
	deviceContext->ClearRenderTargetView(renderTargetView, color);
	deviceContext->ClearDepthStencilView(depthStencilView, D3D11_CLEAR_DEPTH, 1.0f, 0);
}

ID3D11ShaderResourceView* TDRenderTarget::getShaderResourceView()
{
	return shaderResourceView;
}

XMMATRIX TDRenderTarget::getProjectionMatrix()
{
	return projectionMatrix;
}

XMMATRIX TDRenderTarget::getOrthoMatrix()
{
	return orthoMatrix;
}

int TDRenderTarget::getTextureWidth()
{
	return textureWidth;
}

int TDRenderTarget::getTextureHeight()
{
	return textureHeight;
}