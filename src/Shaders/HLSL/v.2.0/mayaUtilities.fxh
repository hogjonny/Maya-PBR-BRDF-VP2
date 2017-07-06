/**
@file mayaUtilities.fxh
@brief
*/

#ifndef _MAYAUTILITIES_FXH_
#define _MAYAUTILITIES_FXH_

//static const float cg_PI = 3.141592f;

/**
@brief 
*/
#ifdef _MAYA_
	RasterizerState WireframeCullFront
	{
		CullMode = Front;
		FillMode = WIREFRAME;
	};

	BlendState PMAlphaBlending
	{
		AlphaToCoverageEnable = FALSE;
		BlendEnable[0] = TRUE;
		SrcBlend = ONE;
		DestBlend = INV_SRC_ALPHA;
		BlendOp = ADD;
		SrcBlendAlpha = ONE;	// Required for hardware frame render alpha channel
		DestBlendAlpha = INV_SRC_ALPHA;
		BlendOpAlpha = ADD;
		RenderTargetWriteMask[0] = 0x0F;
	};
#endif

//------------------------------------
// Internal depth textures for Maya depth-peeling transparency
//------------------------------------
#ifdef _MAYA_

	Texture2D transpDepthTexture : transpdepthtexture
	<
		string UIWidget = "None";
	>;

	Texture2D opaqueDepthTexture : opaquedepthtexture
	<
		string UIWidget = "None";
	>;

#endif

/**
@brief
@return
@param
*/
float4 pickColorSet(int index, float4 c0, float4 c1, float4 c2, float4 c3, float4 c4, float4 c5)
{
	float4 colorSet = c0;

	if (index == 1)
		colorSet = c1;

	if (index == 2)
		colorSet = c1;

	if (index == 3)
		colorSet = c3;

	if (index == 4)
		colorSet = c4;

	if (index == 5)
		colorSet = c5;

	return colorSet;
}

/**
@brief
@return
@param
*/
float2 pickUvSet(int index, float2 uv0, float2 uv1, float2 uv2, float2 uv3, float2 uv4, float2 uv5)
{
	float2 uvSet = uv0;

	if (index == 1)
		uvSet = uv1;

	if (index == 2)
		uvSet = uv1;

	if (index == 3)
		uvSet = uv3;

	if (index == 4)
		uvSet = uv4;

	if (index == 5)
		uvSet = uv4;

	return uvSet;
}

//------------------------------------
// functions
//------------------------------------

/**
@brief Function for masking out fragments based upon a masking texture
@param hasAlpha - bool declaring whether the caller providing the fragment supports alpha masking
@param samplerState - the sampler state used to sample from the provided texture
@param maskedTexture - the texture to sample from
@param uv - the index into the fragment masking texture
@param opacityMaskBias - the bias used as a threshold in dermining if the fagment should be masked
*/
// Clip pixel away when opacity mask is used
void OpacityMaskClip(bool hasAlpha, in SamplerState samplerState, in Texture2D maskedTexture, float2 uv, float opacityMaskBias)
{
	if (hasAlpha)
	{
		float OpacityMaskMap = maskedTexture.Sample(samplerState, uv).w;

		// clip value when less then 0 for punch-through alpha.
		clip( OpacityMaskMap < opacityMaskBias ? -1:1 );
	}
}

void OpacityClip(bool hasAlpha, float opacity, float opacityMaskBias)
{
	if (hasAlpha)
	{
		// clip value when less then 0 for punch-through alpha.
		clip( opacity < opacityMaskBias ? -1:1 );
	}
}

void OpacityClip(float opacity, float opacityMaskBias)
{

	// clip value when less then 0 for punch-through alpha.
	clip( opacity < opacityMaskBias ? -1:1 );
}

// ---------------------------------------------
// string UIGroup = "Normals Flipping"; UI 200+
// ---------------------------------------------
#define MAYA_DEBUG_NORMALX int NormalCoordsysX		\
<													\
	string UIGroup = "Normals Flipping";			\
	string UIFieldNames = "Positive:Negative";		\
	string UIName = "Normal X (Red) [*]";			\
	int UIOrder = 207;								\
> = 0;

#define MAYA_DEBUG_NORMALY int NormalCoordsysY		\
<													\
	string UIGroup = "Normals Flipping";			\
	string UIFieldNames = "Positive:Negative";		\
	string UIName = "Normal Y (Green) [*]";			\
	int UIOrder = 208;								\
> = 0;

#define MAYA_DEBUG_NORMALZ int NormalCoordsysZ		\
<													\
	string UIGroup = "Normals Flipping";			\
	string UIFieldNames = "Positive:Negative";		\
	string UIName = "Normal Z (Blue) [*]";			\
	int UIOrder = 209;								\
> = 0;

#endif //_MAYAUTILITIES_FXH_
