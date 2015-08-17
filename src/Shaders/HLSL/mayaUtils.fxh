// shadertype=hlsl

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

#define SHADOW_FILTER_TAPS_CNT 10
float2 SuperFilterTaps[SHADOW_FILTER_TAPS_CNT] 
< 
	string UIWidget = "None"; 
> = 
{ 
    {-0.84052f, -0.073954f}, 
    {-0.326235f, -0.40583f}, 
    {-0.698464f, 0.457259f}, 
    {-0.203356f, 0.6205847f}, 
    {0.96345f, -0.194353f}, 
    {0.473434f, -0.480026f}, 
    {0.519454f, 0.767034f}, 
    {0.185461f, -0.8945231f}, 
    {0.507351f, 0.064963f}, 
    {-0.321932f, 0.5954349f} 
};

float shadowMapTexelSize 
< 
	string UIWidget = "None"; 
> = {0.00195313}; // (1.0f / 512)

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

//------------------------------------
// functions
//------------------------------------

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

float lightShadow(float4x4 LightViewPrj, in SamplerState samplerState, uniform Texture2D ShadowMapTexture, 
float3 VertexWorldPosition, float shadowMultiplier, float shadowDepthBias)
{	
	float shadow = 1.0f;

	float4 Pndc = mul( float4(VertexWorldPosition.xyz,1.0) ,  LightViewPrj); 
	Pndc.xyz /= Pndc.w; 
	if ( Pndc.x > -1.0f && Pndc.x < 1.0f && Pndc.y  > -1.0f   
		&& Pndc.y <  1.0f && Pndc.z >  0.0f && Pndc.z <  1.0f ) 
	{ 
		float2 uv = 0.5f * Pndc.xy + 0.5f; 
		uv = float2(uv.x,(1.0-uv.y));	// maya flip Y
		float z = Pndc.z - shadowDepthBias / Pndc.w; 

		// we'll sample a bunch of times to smooth our shadow a little bit around the edges:
		shadow = 0.0f;
		for(int i=0; i<SHADOW_FILTER_TAPS_CNT; ++i) 
		{ 
			float2 suv = uv + (SuperFilterTaps[i] * shadowMapTexelSize);
			float val = z - ShadowMapTexture.SampleLevel(samplerState, suv, 0 ).x;
			shadow += (val >= 0.0f) ? 0.0f : (1.0f / SHADOW_FILTER_TAPS_CNT);
		}

		// a single sample would be:
		// shadow = 1.0f;
		// float val = z - ShadowMapTexture.SampleLevel(SamplerShadowDepth, uv, 0 ).x;
		// shadow = (val >= 0.0f)? 0.0f : 1.0f;
		
		shadow = lerp(1.0f, shadow, shadowMultiplier);  
	} 

	return shadow;
}