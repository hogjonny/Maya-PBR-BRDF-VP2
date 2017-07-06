/**
@file mayaLightsUtilities.fxh
@brief
*/


#ifndef _MAYALIGHTSUTILITIES_FXH_
#define _MAYALIGHTSUTILITIES_FXH_

/**
@breif used for Maya shadows
*/
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


/**
@struct MayaLight
@brief Structure for wrapping up Maya lighting data
*/
struct MayaLight
{
	bool m_Enabled;
	int m_Type;
	float4 m_Diffuse;
	float4 m_Direction;
	float4 m_Specular;
	float4 m_Position;
	float m_Attenuation;
	// new adds
	float m_Intensity;
	bool m_LightShadowOn;
	float4x4 m_LightViewPrj;
	//Texture2D m_ShadowLightMap;
};


/**
@brief Function for sampling shadow depth from a shadow texture map
@param LightViewPrj - the light's ViewProjection Matrix
@param samplerState - the sampler state used to sample from the provided texture
@param ShadowMapTexture - the texture containing the shadowMap data
@param VertexWorldPosition - the position in projected shadow space

@param shadowMultiplier - the value by which to scale the amount of shadow
@param shadowDepthBias - the amount of bias to apply to the shadow map to account for shadow achne
@return float4 - the shadow color based on in or out of shadow
*/
float lightShadow(int lightIndex, float4x4 LightViewPrj, in SamplerState samplerState, 
float3 VertexWorldPosition, float shadowMultiplier, float shadowDepthBias)
{	
	float shadow = 1.0f;

	float4 Pndc = mul( float4(VertexWorldPosition.xyz, 1.0) , LightViewPrj); 
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
			float val = 1.0f;
			if (lightIndex == 0) val = z - light0ShadowMap.SampleLevel(samplerState, suv, 0 ).x;
			if (lightIndex == 1) val = z - light1ShadowMap.SampleLevel(samplerState, suv, 0 ).x;
			if (lightIndex == 2) val = z - light2ShadowMap.SampleLevel(samplerState, suv, 0 ).x;
			if (lightIndex == 3) val = z - light3ShadowMap.SampleLevel(samplerState, suv, 0 ).x;
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

//Texture2D lightShadowLightMap[4] = {light0ShadowMap, light1ShadowMap, light2ShadowMap, light3ShadowMap};

/**
@brief Function initializing an array of MayLight structs representing all
Maya Lights
@param lights - The MayaLight array to initialize
@param diffuse - The pre-gamma corrected material diffuse component
@param specular - The pre-gamma corrected material specular component
@param gammaCorrectionExponent - the gamma correction exponent used to initialize the light array
*/
void build4MayaLights(out MayaLight lights[4], float3 matDiffuse, float3 matSpecular, float gammaCorrectionExponent)
{
	// these already come in linear from the pMain
	//float3 matDiffuse = pow(diffuse, gammaCorrectionExponent);
	//float3 matSpecular = pow(specular, gammaCorrectionExponent);

	// let's convert to linear everythin that needs to be
	// Need to gamma correct Maya Light sRGB --> linear
	float3 lightDiffuseColors[4] = { pow(light0Color.rgb, gammaCorrectionExponent), pow(light1Color.rgb, gammaCorrectionExponent), pow(light2Color.rgb, gammaCorrectionExponent), pow(light3Color.rgb, gammaCorrectionExponent) };

	bool lightsEnabled[4] = { light0Enable, light1Enable, light2Enable, light3Enable };
	int lightTypes[4] = { light0Type, light1Type, light2Type, light3Type };

	float3 lightDirections[4] = { light0Dir, light1Dir, light2Dir, light3Dir };
	float3 lightPositions[4] = { light0Pos, light1Pos, light2Pos, light3Pos };
	float lightAttenuation[4] = { light0AttenScale, light1AttenScale, light2AttenScale, light3AttenScale };
	// new adds
	float lightIntensity[4] = { light0Intensity, light1Intensity, light2Intensity, light3Intensity };
	bool lightShadowOn[4] = { light0ShadowOn, light1ShadowOn, light2ShadowOn, light3ShadowOn };
	float4x4 lightViewPrj[4] = { light0Matrix, light1Matrix, light2Matrix, light3Matrix };

	//lightShadowMaps[0] = light0ShadowMap;
	//lightShadowMaps[1] = light1ShadowMap;
	//lightShadowMaps[2] = light2ShadowMap;
	//lightShadowMaps[3] = light3ShadowMap;

	//Texture2D lightShadowLightMap[4] = {light0ShadowMap, light1ShadowMap, light2ShadowMap, light3ShadowMap};

	// For Maya, flip the lightDir:
	#ifdef _MAYA_
		lightDirections[0] = -light0Dir;
		lightDirections[1] = -light1Dir;
		lightDirections[2] = -light2Dir;
		lightDirections[3] = -light3Dir;
	#endif

	for (int i = 0; i<4; ++i)
	{
		lights[i].m_Enabled = lightsEnabled[i];
		lights[i].m_Type = lightTypes[i];
		lights[i].m_Diffuse = float4(lightDiffuseColors[i].rgb * matDiffuse, 1.0f);
		lights[i].m_Specular = float4(lightDiffuseColors[i].rgb * matSpecular, 1.0f);
		lights[i].m_Position = float4(lightPositions[i], 1.0f);
		lights[i].m_Direction = float4(lightDirections[i], 1.0f);
		lights[i].m_Attenuation = lightAttenuation[i];
		// new adds
		lights[i].m_Intensity = lightIntensity[i];
		lights[i].m_LightShadowOn = lightShadowOn[i];
		lights[i].m_LightViewPrj = lightViewPrj[i];

		//lights[i].m_ShadowLightMap = lightShadowLightMap[i];
	}
}

#endif // #ifndef _MAYALIGHTSUTILITIES_FXH_