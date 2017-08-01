/**
@file shader_HOG_t_uv0bn-pbs_IBLenv.fx
@brief Contains the Maya Implementation of the shader_HOG_t_uv0bn-pbs_IBLenv shader program
*/

// uncomment to force true for compiling in VS
//#define _MAYA_ 1

//------------------------------------
// Defines
//------------------------------------
// how many mip map levels should Maya generate or load per texture. 
// 0 means all possible levels
// some textures may override this value, but most textures will follow whatever we have defined here
// If you wish to optimize performance (at the cost of reduced quality), you can set NumberOfMipMaps below to 1

static const float cg_PI = 3.141592f;

#define NumberOfMipMaps 0
#define ROUGHNESS_BIAS 0.005
#define TEMP_IOR 0.03
#define EPSILON 10e-5f
//#define saturate(value) clamp(value, 0.000001f, 1.0f)

#define _3DSMAX_SPIN_MAX 99999

#ifndef _MAYA_
#define _3DSMAX_	// at time of writing this shader, Nitrous driver did not have the _3DSMAX_ define set
#define _ZUP_		// Maya is Y up, 3dsMax is Z up
#endif

// general includes
#include "samplers.fxh"

// maxplay includes
#include "lighting.sif"
#include "pbr.sif"
#include "pbr_shader_ui.fxh"
#include "toneMapping.fxh"

// Maya includes
#include "mayaUtilities.fxh"
#include "mayaLightsShadowMaps.fxh"
#include "mayaLights.fxh"
#include "mayaLightsUtilities.fxh"

// max includes
#include "maxUtilities.fxh"

//------------------------------------
// Map Channels
//------------------------------------
#ifdef _3DSMAX_
MAXTEXCOORD0
#endif

//------------------------------------
// Samplers
//------------------------------------
// from samplers.fxh
// SamplerLinearClamp
SAMPLERMINMAGMIPLINEARCLAMP
// SamplerLinearWrap
SAMPLERMINMAGMIPLINEARWRAP
// SamplerAnisoWrap
SAMPLERSTATEANISOWRAP
// SamplerShadowDepth
SAMPLERSTATESHADOWDEPTH
// SamplerCubeMap
SAMPLERCUBEMAP
// SamplerBrdfLUT
SAMPLERBRDFLUT

// macro to include Vertex Elements
// from HOG_shader_ui.fxh macros
// vertexElementPosition
HOG_PROPERTY_VERTEX_ELEMENT_POSITION
// vertexElementColor
HOG_PROPERTY_VERTEX_ELEMENT_COLOR
// vertexElementUV
HOG_PROPERTY_VERTEX_ELEMENT_UV
// vertexElementNormal
HOG_PROPERTY_VERTEX_ELEMENT_NORMAL
// vertexElementBinormal
HOG_PROPERTY_VERTEX_ELEMENT_BINORMAL
// vertexElementTangent
HOG_PROPERTY_VERTEX_ELEMENT_TANGENT

//------------------------------------
// Textures
//------------------------------------
// string UIGroup = "Material Maps"; UI 050+
// from pbr.fxh macros
// baseColorMap:			Texture2D
HOG_MAP_BASECOLOR
// baseNormalMap:			Texture2D
HOG_MAP_BASENORMAL
// roughnessMap:			Texture2D
HOG_MAP_ROUGHNESS
// metalnessMap:			Texture2D		
HOG_MAP_METALNESS 
// specularF0Map:			Texture2D
HOG_MAP_SPECF0 
// specularMap:				Texture2D
HOG_MAP_SPECULAR
// heightMap:				Texture2D
HOG_MAP_HEIGHT
// ambOccMap:				Texture2D
HOG_MAP_AMBOCC
// cavityMap:				Texture2D
HOG_MAP_CAVITY
// emissiveMap:				Texture2D
HOG_MAP_EMISSIVE
// anisotropicMap:			Texture2D
HOG_MAP_ANISOTROPIC 

// pbrMasksMap:				Texture2D
HOG_MAP_PBRMASKS
//filmLutMap:				Texture2D
HOG_MAP_FILMLUT

// These are PBR IBL env related texture inputs
// Plus additional hemispherical ambient properties
// useEnvMaps
HOG_ENV_BOOL
// envMapType
HOG_ENVMAP_TYPE
// brdfTextureMap
HOG_MAP_BRDF
// diffuseEnvTextureCube
HOG_CUBEMAP_IBLDIFF
// specularEnvTextureCube
HOG_CUBEMAP_IBLSPEC
// diffuseEnvTextureLatlong
HOG_LATLONG_IBLDIFF
// specularEnvTextureLatlong
HOG_LATLONG_IBLSPEC
// envLightingExp
HOG_ENVLIGHTING_EXP
// sceneAmbientLight ... DEPRECATED
//HOG_PROPERTY_SCENE_AMBIENTLIGHT
// ambientSkyColor
HOG_PROPERTY_SCENE_AMBIENTSKY
// ambientGroundColor
HOG_PROPERTY_SCENE_AMBIENTGRND
// ambientSkyIntensity
HOG_PROPERTY_SCENE_AMBSKYINT
// ambientGrndIntensity
HOG_PROPERTY_SCENE_AMBGRNDINT
// hemisphericalAmbientyMode
HOG_PROPERTY_SCENE_AMBHEMIMODE

//------------------------------------
// Per Frame constant buffer
//------------------------------------
cbuffer UpdatePerFrame : register(b0)
{
	float4x4 viewInv 			: ViewInverse < string UIWidget = "None"; > ;
	float4x4 view				: View < string UIWidget = "None"; > ;
	float4x4 prj				: Projection < string UIWidget = "None"; > ;
	float4x4 viewPrj			: ViewProjection < string UIWidget = "None"; > ;
	float4x4 worldViewInvTrans	: WorldViewInverseTranspose < string UIWidget = "None"; > ;

	// A shader may wish to do different actions when Maya is rendering the preview swatch (e.g. disable displacement)
	// This value will be true if Maya is rendering the swatch
	bool IsSwatchRender : MayaSwatchRender < string UIWidget = "None"; > = false;

	// If the user enables viewport gamma correction in Maya's global viewport rendering settings, the shader should not do gamma again
	bool MayaFullScreenGamma : MayaGammaCorrection < string UIWidget = "None"; > = false;
}

//------------------------------------
// Per Object constant buffer
//------------------------------------
cbuffer UpdatePerObject : register(b1)
{
	float4x4	World				: World < string UIWidget = "None"; > ;
	float4x4	WorldView			: WorldView < string UIWidget = "None"; > ;
	float4x4	WorldIT 			: WorldInverseTranspose < string UIWidget = "None"; > ;
	float4x4	WorldViewProj		: WorldViewProjection < string UIWidget = "None"; > ;

	//these are per-object includes for this cBuffer
	// they come from pbr_shader_ui.fxh
	// "Material Properties" UI group
	// hasAlpha
	HOG_PROPERTY_HAS_ALPHA
	// useCutoutAlpha:				bool
	HOG_PROPERTY_CUTOUT_ALPHA
	// opacityMaskBias:				scalar 0..1
	HOG_PROPERTY_OPACITY_MASK_BIAS
	// opacity:						scalar 1..0
	HOG_PROPERTY_OPACITY
	// materialBaseColor:			sRGB
	HOG_PROPERTY_MATERIAL_BASECOLOR
	// materialAnisotropic			scalar 0..1
	HOG_PROPERTY_MATERIAL_ANISOTROPIC
	// materialRoughness:			scalar 0..1
	HOG_PROPERTY_MATERIAL_ROUGHNESS
	// materialMetalness:			scalar 0.001 .. 0.999  // either end causes anomilies
	HOG_PROPERTY_MATERIAL_METALNESS
	// materialSpecular				scalar 0..1
	HOG_PROPERTY_MATERIAL_SPECULAR
	// materialSpecTint				scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_SPECTINT
	// materialSheen				scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_SHEEN
	// materialSheentint			scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_SHEENTINT
	// materialClearcoat			scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_CLEARCOAT
	// materialClearcoatGloss		scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_CLEARCOATGLOSS
	// materialEmissive				sRGB
	HOG_PROPERTY_MATERIAL_EMISSIVE
	// materialEmissiveIntensity	scalar 0..3 (soft)
	HOG_PROPERTY_MATERIAL_EMISSIVEINT
	// materialIOR:					scalar 1..3 (soft)
	HOG_PROPERTY_MATERIAL_IOR
	// materialBumpIntensity:		scalar 0..1 (soft)
	HOG_PROPERTY_MATERIAL_BUMPINTENSITY
	// useVertexC0_RGBA:			bool
	HOG_PROPERTY_USE_VERTEX_C0_RGBA
	// hasVertexAlpha:				bool
	HOG_PROPERTY_HAS_VERTEX_ALPHA
	// useVertexC1_AO:				bool
	HOG_PROPERTY_USE_VERTEX_C1_AO

	// "Parallax Occlusion" UI Group
	// useParallaxOcclusionMapping:	bool
	HOG_PROPERTY_POM
	// materialPomHeightScale:		float
	HOG_PROPERTY_MATERIAL_POMHEIGHTSCALE
	// usePOMselfShadow:			bool
	HOG_PROPERTY_USEPOMSHDW  
	// pomMinSamples:				float
	HOG_PROPERTY_MATERIAL_POMMINSAMPLES
	// pomMaxSamples:				float
	HOG_PROPERTY_MATERIAL_POMMAXSAMPLES
	// selfOccOffset:				float
	HOG_PROPERTY_MATERIAL_POMOCCOFFSET  
	// selfOccStrength:				float
	HOG_PROPERTY_MATERIAL_POMOCCSTRENGTH  
	// usePOMsoftShadow:			bool
	HOG_PROPERTY_USEPOMSOFTSHDW	  
	// pomSoftShadowAmount:				float
	HOG_PROPERTY_MATERIAL_POMSOFTSHDWAMT  

	// "Lighting Properties"
	// materialAmbient:				sRGB
	// this is the amount of ambient influence 3-channel
	//HOG_PROPERTY_MATERIAL_AMBIENT
	// linearSpaceLighting:			bool
	HOG_PROPERTY_LINEAR_SPACE_LIGHTING
	// flipBackfaceNormals:			bool
	HOG_PROPERTY_FLIP_BACKFACE_NORMALS

	// "Shadows"
	// isShadowCaster:				bool
	HOG_PROPERTY_IS_SHADOW_CASTER
	// isShadowReceiver:			bool
	HOG_PROPERTY_IS_SHADOW_RECEIVER
	// shadowRangeAuto:				bool
	HOG_PROPERTY_SHADOW_RANGE_AUTO
	// shadowRangeMax:				float 0..1000
	HOG_PROPERTY_SHADOW_RANGE_MAX
	// Maya shadow preview stuff
	// shadowDepthBias:				float 0..10
	HOG_PROPERTY_SHADOW_DEPTH_BIAS
	// shadowMultiplier:			scalar 0..1
	HOG_PROPERTY_SHADOW_MULTIPLIER
	// useShadows:					bool
	HOG_PROPERTY_SHADOW_USE_SHADOWS

	// "Engine | Scene Preview"
	// These are proxies for viewing in maya
	// sceneAmbientLight:		sRGB
	//HOG_PROPERTY_SCENE_AMBIENTLIGHT

	// gammaCorrectionValue:	float 2.2333
	HOG_PROPERTY_GAMMA_CORRECTION_VALUE
	// bloomExp:				float 1.6
	HOG_PROPERTY_BLOOM_EXP
	// useLightColorAsLightSpecularColor:	bool
	HOG_PROPERTY_USE_LIGHT_COLOR_AS_LIGHT_SPECULAR_COLOR
	// useApproxToneMapping:				bool
	//HOG_PROPERTY_USE_APPROX_TONE_MAPPING
	// useGammaCorrectShader:				bool
	HOG_PROPERTY_GAMMA_CORRECT_SHADER

	// these macros come from mayaUtilities.fxh
	// NormalCoordsysX
	MAYA_DEBUG_NORMALX
	// NormalCoordsysY
	MAYA_DEBUG_NORMALY
	// NormalCoordsysZ
	MAYA_DEBUG_NORMALZ

} //end UpdatePerObject cbuffer

  //------------------------------------
  // DEBUG
  //------------------------------------
  /**
  @Widget DebugMenu
  @brief provides a menu to the user for enabling debug modes supported by this fx file
  */
int g_DebugMode
<
	string UIGroup = "DEBUG [Preview]";
	string UIWidget = "Slider";
	string UIFieldNames = "o.m_Color.rgb:baseColorTex.rgb:baseColorTex.aaa:bColorLin.rgb:mColorLin.rgb:p.m_albedoRGBA.rgb:p.m_albedoRGBA.aaa:pbrMetalness.xxx:pbrRoughness.xxx:pbrAO.xxx:pbrCavity.xxx:baseNormalMap.xyz:normalRaw.xyz:F0.xxx:bClum.xxx:Ctint.rgb:Cspec0.rgb:diffuse.rgb:specular.rgb:pbrRoughness.xxx:roughA.xxx:roughA2.xxx:roughnessBiasedA.xxx:roughnessBiasedA2.xxx:NdotV:ambDomeColor.rgb:ambDomeLinColor.rgb:diffEnvLin.rgb:specEnvLin.rgb:cSpecLin:baseUV:selfOccShadow";
	string UIName = "DEBUG VIEW";
	int UIOrder = 0;
> = 0;

/**
@Widget tone mapping pull down
@brief provides a pull down menu, to select the tone mapping to be applied to the fragment shader
*/
int tonempappingType
<
	string UIGroup = HOG_GRP_ENGN_PREV;
	string UIWidget = "Slider";
	string UIFieldNames = "none:approx:linear:linearExp:reinhard:reinhardExp:HaarmPeterCurve:HaarmPeterCurveExp:uncharted2FilmicTonemapping:uncharted2FilmicTonemappingExp";
	string UIName = HOG_TONEMAPPING_TYPE;
	int UIOrder = 610;
> = 0;

//------------------------------------
// Hardware Fog parameters
//------------------------------------
bool MayaHwFogEnabled : HardwareFogEnabled < string UIWidget = "None"; > = false;
int MayaHwFogMode : HardwareFogMode < string UIWidget = "None"; > = 0;
float MayaHwFogStart : HardwareFogStart < string UIWidget = "None"; > = 0.0f;
float MayaHwFogEnd : HardwareFogEnd < string UIWidget = "None"; > = 100.0f;
float MayaHwFogDensity : HardwareFogDensity < string UIWidget = "None"; > = 0.1f;
float4 MayaHwFogColor : HardwareFogColor < string UIWidget = "None"; > = { 0.5f, 0.5f, 0.5f , 1.0f };

//------------------------------------
// Vertex Shader
//------------------------------------
/**
@struct VsInput
@brief Input to the vertex unit from the vertex assembly unit
*/
struct vsInput
{
	float3 m_Position		: POSITION0;
	float4 m_AlbedoRGBA     : COLOR0;
	float4 m_VertexAO		: COLOR1;
	float2 m_Uv0			: TEXCOORD0;
	float3 m_Normal			: NORMAL;
	float3 m_Tangent		: TANGENT;
	float3 m_Binormal		: BINORMAL;
};

/**
@struct VsOutput
@brief Output from the vertex unit to later stages of GPU execution
*/
struct VsOutput
{
	float4 m_Position		: SV_POSITION;
	float4 m_albedoRGBA     : COLOR0;
	float4 m_VertexAO		: COLOR1;
	float2 m_Uv0			: TEXCOORD0;
	float4 m_WorldPosition	: TEXCOORD1_centroid;
	float4 m_View			: TEXCOORD2_centroid;
	float3x3 m_TWMtx		: TEXCOORD3_centroid;
	//float3x3 m_WTMtx		: TEXCOORD8_centroid;
	float3 m_NormalW		: TEXCOORD6;
	float3 m_TangentW		: TEXCOORD7;
	float3 m_BinormalW		: TEXCOORD8;
};

/**
@brief Entry point to the vertex shader
@return VsOutput The results from the vertex shader passed to later GPU stages
@param[in] v Input from the vertex assembly unit
*/
VsOutput vsMain(vsInput v)
{
	VsOutput OUT = (VsOutput)0;


	//OUT.eye = normalize(mul(World, v.m_Position) - mul(viewInv, float4(0,0,0,1))).xyz;

	OUT.m_Position = mul(float4(v.m_Position, 1.0f), WorldViewProj);

	//OUT.m_NormalW = normalize(mul(v.m_Normal, WorldIT));
	OUT.m_NormalW = normalize(mul(v.m_Normal, World));
	OUT.m_TangentW = normalize(mul(v.m_Tangent, World));
	OUT.m_BinormalW = normalize(mul(v.m_Binormal, World));

	// we pass vertices in world space
	OUT.m_WorldPosition = mul(float4(v.m_Position, 1), World);

	if (useVertexC0_RGBA)
	{
		// Interpolate and ouput vertex color 0
		OUT.m_albedoRGBA.rgb = v.m_AlbedoRGBA.rgb;
		OUT.m_albedoRGBA.w = v.m_AlbedoRGBA.w;
	}

	// setup Gamma Corrention
	float gammaCexp = linearSpaceLighting ? gammaCorrectionValue : 1.0;

	// convert sRGB color per-vertex to linear?
	OUT.m_albedoRGBA.rgb = linearSpaceLighting ? pow(v.m_AlbedoRGBA.rgb, gammaCexp) : OUT.m_albedoRGBA.rgb;

	if (useVertexC1_AO)
	{
		// Interpolate and ouput vertex color 1
		OUT.m_VertexAO.rgb = v.m_VertexAO.rgb;
		OUT.m_VertexAO.w = v.m_VertexAO.w;
	}

	// Pass through texture coordinates
	// flip Y for Maya
#ifdef _MAYA_
	OUT.m_Uv0 = float2(v.m_Uv0.x, - v.m_Uv0.y);
#else
	OUT.m_Uv0 = v.m_Uv0;
#endif

	// Build the view vector and cache its length in W
	// pulling the view position in world space from the inverse view matrix 4th row
	OUT.m_View.xyz = viewInv[3].xyz - OUT.m_WorldPosition.xyz;
	OUT.m_View.w = length(OUT.m_View.xyz);
	// normalize
	OUT.m_View.xyz *= rcp(OUT.m_View.w);

	// Compose the tangent space to local space matrix
	float3x3 tLocal;
	tLocal[0] = v.m_Tangent;
	tLocal[1] = v.m_Binormal;
	tLocal[2] = v.m_Normal;

	// Calculate the tangent to world space matrix
	OUT.m_TWMtx = mul(tLocal, (float3x3)World);

	// world space to tangent matrix?
	//OUT.m_WTMtx = transpose(tLocal);

	return OUT;
}

//------------------------------------
// Pixel Shader
//------------------------------------
/**
@struct PsOutput
@brief Output that written to the render target
*/
struct PsOutput  // was APPDATA
{
	float4 m_Color			: SV_TARGET;
};

/**
@brief Entry point to the pixel shader
@return PsOutput Results written to the rendering target
@param[in] p Input from the interpolation units
*/
PsOutput pMain(VsOutput p, bool FrontFace : SV_IsFrontFace)
{
	PsOutput o;

	// MAYA | MAX Stuff
#ifdef _3DSMAX_
	FrontFace = !FrontFace;
#endif
	// I think we need to POM before we clip?
	// 1) silohuette pom clips
	// 2) we can/should set up UV's before we start sampling textures?
	
	// unabashed modification of:  https://github.com/hamish-milne/POMUnity/blob/master/Assets/ParallaxOcclusion.cginc
	// and: https://www.gamedev.net/articles/programming/graphics/a-closer-look-at-parallax-occlusion-mapping-r3262
	// with help from:  http://www.d3dcoder.net/Data/Resources/ParallaxOcclusion.pdf
	// To Do: Put all of this in a function and include file (after it is working)
	float2 baseUV = p.m_Uv0;
	float2 pomSsUV = baseUV;

	// Parallax Mapping
	// Parallax Releif Mapping
	// http://sunandblackcat.com/tipFullView.php?topicid=28

	// these are also later used in POM self-occlusion
	float lastSampledHeight = 1;
	float zStepSize = 0.0;
	float2 finalTexOffset = 0;
	float3x3 worldToTangent;

	// To Do: expose these in the UI
	// The mip level id for transitioning between the full computation
	// for parallax occlusion mapping and the bump mapping computation
	bool pomVisualizeLOD = false;
	int pomLODThreshold = 3;
	float2 pomTextureDimensions = float2(1024, 1024);
	float  minTexCoordDelta;
	float2 deltaTexCoords;

	// store gradients
	float2 dxSize, dySize;
	float2 dx, dy;
	// Compute the current gradients:
	float2 texCoordsPerSize = baseUV * pomTextureDimensions;
	// Compute all 4 derivatives in x and y in a single instruction to optimize:
	float4(dxSize, dx) = ddx(float4(texCoordsPerSize, baseUV));
	float4(dySize, dy) = ddy(float4(texCoordsPerSize, baseUV));

	float  pomMipLevel;
	float  pomMipLevelInt;    // mip level integer portion
	float  pomMipLevelFrac;   // mip level fractional amount for blending in between levels

	// Multiplier for visualizing the level of detail (see notes for 'nLODThreshold' variable
	// for how that is done visually)
	float4 pomLODColoring = float4(1, 1, 3, 1);

	if (useParallaxOcclusionMapping)
	// To Do: make this a function call in parallax.sif
	// POM self shadowing
	// POM Clipping
	{

		// Precompute texture gradients since we cannot compute texture
		// gradients in a loop. Texture gradients are used to select the right
		// mipmap level when sampling textures. Then we use Texture2D.SampleGrad()
		// instead of Texture2D.Sample().
		//dx = ddx(baseUV);
		//dy = ddy(baseUV);

		// Find min of change in u and v across quad: compute du and dv magnitude across quad
		deltaTexCoords = dxSize * dxSize + dySize * dySize;

		// Standard mipmapping uses max here
		minTexCoordDelta = max(deltaTexCoords.x, deltaTexCoords.y);

		// Compute the current mip level  (* 0.5 is effectively computing a square root before )
		pomMipLevel = max( 0.5f * log2( minTexCoordDelta ), 0.0f);

		if (pomMipLevel <= (float)pomLODThreshold)
		{
			float3 viewDirW = -p.m_View.xyz;
			//float3 viewDirTS = mul(viewDirW, p.m_WTMtx);

			// Build orthonormal basis.
			// Interpolating normal can unnormalize it, so normalize it.
			p.m_NormalW = normalize(p.m_NormalW);

			// T
			worldToTangent[0] = normalize(p.m_TangentW - dot(p.m_TangentW, p.m_NormalW) * p.m_NormalW);
			// B
			//worldToTangent[1] = cross(p.m_NormalW, worldToTangent[0]);
			worldToTangent[1] = -p.m_BinormalW;  // had to -, why!?
			// N
			worldToTangent[2] = p.m_NormalW;

			worldToTangent = transpose(worldToTangent);

			float3 viewDirTS = mul(viewDirW, worldToTangent);

			float2 maxParallaxOffset = -viewDirTS.xy * materialPomHeightScale / viewDirTS.z;

			// sampleCount
			int pomNumSamples = (int)lerp(pomMinSamples, pomMaxSamples, dot(p.m_View.xyz, p.m_NormalW));

			// zStep
			zStepSize = 1.0 / (float)pomNumSamples;

			// texStep
			float2 vMaxOffset = maxParallaxOffset * zStepSize;

			// sampleIndex
			int currSampleIndex = 0;

			float2 currTexOffset = 0;
			float2 prevTexOffset = 0;
			float currRayZ = 1.0f - zStepSize;
			float prevRayZ = 1.0f;
			float currHeight = 0.0f;
			float prevHeight = 0.0f;

			// Ray trace the heightfield.
			while (currSampleIndex < pomNumSamples + 1)
			{
				// fetch height
				currHeight = heightMap.SampleGrad(SamplerAnisoWrap, baseUV + currTexOffset, dx, dy).r;

				// Did we cross the height profile?
				if (currHeight > currRayZ)
				{
					// Do ray/line segment intersection and compute final tex offset.
					float t = (prevHeight - prevRayZ) /
						(prevHeight - currHeight + currRayZ - prevRayZ);

					finalTexOffset = prevTexOffset + t * vMaxOffset;

					lastSampledHeight = prevHeight + t * vMaxOffset;

					// Exit loop.
					currSampleIndex = pomNumSamples + 1;
				}
				else
				{
					++currSampleIndex;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += vMaxOffset;
					// Negative because we are going "deeper" into the surface.
					currRayZ -= zStepSize;

					lastSampledHeight = currHeight;
				}
			}
			// Use these texture coordinates for subsequent texture
			// fetches (color map, normal map, etc.).
			baseUV += finalTexOffset;

			// store this value off, for pom soft shadowing
			pomSsUV = baseUV;

			// Lerp to bump mapping only if we are in between, transition section:

			pomLODColoring = float4(1, 1, 1, 1);

			if (pomMipLevel > (float)(pomLODThreshold - 1))
			{
				// Lerp based on the fractional part:
				pomMipLevelFrac = modf(pomMipLevel, pomMipLevelInt);

				if (pomVisualizeLOD)
				{
					// For visualizing: lerping from regular POM-resulted color through blue color for transition layer:
					pomLODColoring = float4(1, 1, max(1, 2 * pomMipLevelFrac), 1);
				}

				// Lerp the texture coordinate from parallax occlusion mapped coordinate to bump mapping
				// smoothly based on the current mip level:
				baseUV = lerp(baseUV, p.m_Uv0, pomMipLevelFrac);
			}
		}
	}

	// Parallax Mapping and Self-Shadowing
	// // http://sunandblackcat.com/tipFullView.php?topicid=28

	// Silohuette Parallax Occlusion Mapping
	// POM clipping, this doesn't work ... and I don't know how to do it properly.
	//clip(baseUV);
	//clip(1.0f - baseUV);

	//if (baseUV.x < 0.0 || baseUV.x > 1.0 || baseUV.y < 0.0 || baseUV.y > 1.0)
	//{
		//discard;
	//}

	// texture maps and such
	//baseColor, need to fetch it now so we can clip against albedo alpha channel
	float4 baseColorTex = baseColorMap.Sample(SamplerAnisoWrap, baseUV).rgba;

	// we need to calculate and store a transperancy value to clip against
	float transperancy = 1.0f;
	transperancy = hasAlpha ? baseColorTex.a : transperancy;
	transperancy = hasVertexAlpha ? (transperancy * p.m_albedoRGBA.a) : transperancy;

	//hasVertexAlpha || hasAlpha || useCutoutAlpha
	if (useCutoutAlpha)
	{
		// clip as early as possible
		// v1
		//OpacityMaskClip(hasAlpha, SamplerLinearWrap, diffuseMap0, baseUV, opacityMaskBias);
		// v2
		OpacityClip(hasAlpha, transperancy, opacityMaskBias);
	}

	// setup Gamma Corrention
	float gammaCorrectionExponent = linearSpaceLighting ? gammaCorrectionValue : 1.0;

	// roughnessMap:			Texture2D
	float pbrRoughness = 0.0f;
	float roughnessTex = roughnessMap.Sample(SamplerAnisoWrap, baseUV).g;
	if (roughnessTex > 0)
		pbrRoughness = roughnessTex;
	pbrRoughness = lerp(float(0.0f).xxx, pbrRoughness, materialRoughness);


	// metalnessMap:			Texture2D
	float pbrMetalness = 0.0f;
	float metalnessTex = metalnessMap.Sample(SamplerAnisoWrap, baseUV).g;
	if (metalnessTex > 0)
		pbrMetalness = metalnessTex;
	pbrMetalness = lerp(float(0.0f).xxx, pbrMetalness, materialMetalness);

	// specularF0Map:			Texture2D
	float pbrSpecF0 = 0.0f;
	float specF0Tex = specularF0Map.Sample(SamplerAnisoWrap, baseUV).g;
	if (specF0Tex > 0)
		pbrSpecF0 = specF0Tex;

	// specularMap:				Texture2D
	float pbrSpecAmount = 0.0f;
	float specAmountTex = specularMap.Sample(SamplerAnisoWrap, baseUV);
	if (specAmountTex > 0)
		pbrSpecAmount = specAmountTex;
	pbrSpecAmount = lerp(float(0.0f).xxx, pbrSpecAmount, materialSpecular);

	// ambOccMap:				Texture2D
	float pbrAmbOcc = 0.0f;
	float ambOccTex = ambOccMap.Sample(SamplerAnisoWrap, baseUV);
	if (ambOccTex > 0)
		pbrAmbOcc = ambOccTex;

	// cavityMap:				Texture2D
	float pbrCavity = 0.0f;
	float cavityTex = cavityMap.Sample(SamplerAnisoWrap, baseUV);
	if (cavityTex > 0)
		pbrCavity = cavityTex;

	// emissiveMap:				Texture2D
	float3 emissiveTex = emissiveMap.Sample(SamplerAnisoWrap, baseUV).rgb;
	float3 pbrEmssive = emissiveTex.rgb;

	// anisotropicMap:			Texture2D

	float bumpAO = lerp(float(1.0f), pbrAmbOcc, materialBumpIntensity);
	float bumpCavity = lerp(float(1.0f), pbrCavity, materialBumpIntensity);

	// Normal Map
	float3 normalRaw = (baseNormalMap.Sample(SamplerAnisoWrap, baseUV).xyz * 2.0f) - 1.0f;

	// FIX UP all color values --> Linear
	// base color linear
	float3 bColorLin = pow(materialBaseColor.rgb * baseColorTex.rgb, gammaCorrectionExponent);

	// combine the linear vertex color RGB and the linear base color
	if (useVertexC0_RGBA)
		bColorLin.rgb *= p.m_albedoRGBA.rgb;

	// set up the vertex AO
	float3 vertAO = (1.0f, 1.0f, 1.0f);
	if (useVertexC1_AO)
		vertAO.rgb = p.m_VertexAO.rgb;

	// Calculate the normals with intensity and derive Z
	float3 nTS = float3(normalRaw.xy * materialBumpIntensity, sqrt(1.0 - saturate(dot(normalRaw.xy, normalRaw.xy))));

	// DEBUG controls for flipping any normal component in Maya
	// (needed to figure out proper directions for X|Y)
	// PLEASE leave for now
	if (NormalCoordsysX > 0)
		nTS.x = -nTS.x;
	if (NormalCoordsysY > 0)
		nTS.y = -nTS.y;
	if (NormalCoordsysZ > 0)
		nTS.z = -nTS.z;

	// Transform the normal into world space where the light data is
	// Normalize proper normal lengths after decoding dxt normals and creating Z
	float3 n = normalize(mul(nTS, p.m_TWMtx));

	// Set up hemispherical ambient done values
	float3 ambSkyLinColor = pow(ambientSkyColor.rgb, gammaCorrectionExponent);
	ambSkyLinColor *= ambientSkyIntensity;
	float3 ambGrdLinColor = pow(ambientGroundColor.rgb, gammaCorrectionExponent);
	ambGrdLinColor *= ambientGrndIntensity;

	// calculate the hemispherical ambient value
#ifndef _ZUP_
	float ambientUpAxis = n.y;
#else
	float ambientUpAxis = n.z;
#endif
	float3 ambDomeLinColor = (lerp(ambGrdLinColor.rgb, ambSkyLinColor.rgb, saturate((ambientUpAxis * 0.5) + 0.5)));

	// setup lights
	MayaLight lights[4];
	//build4MayaLights(lights, matDiffLin, matSpecLin, gammaCorrectionExponent);
	build4MayaLights(lights, float3(1.0f, 1.0f, 1.0f), float3(1.0f, 1.0f, 1.0f), gammaCorrectionExponent);

	// We'll use Maya's SSAO this is mainly here for reference in porting the data to engine
	//float ssao = ssaoTexture.Sample(ssaoSampler, p.m_Position.xy * targetDimensions.xy).x;
	// I have no idea if there is a way to retreive the viewport AO buffer
	// I think not, because I beleive it's applied as post processing
	float ssao = 1.0;  // REPLACED with constant, Maya applies it's own

	// For calculate lighting contribution per light type
	// diffuse : Resulting diffuse color
	float4 diffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	// specular : Resulting specular color
	float4 specular = float4(0.0f, 0.0f, 0.0f, 0.0f);

	// base color variant for metals
	float3 mColorLin = bColorLin.rgb * (1.0f - pbrMetalness);

	// F0 : Specular reflection coefficient (this is a scalar, not a color value!)
	//non-metals are 3% reflective... approximately
	// if you were going to hard code something, this would be a good guess
	//float3 F0 = lerp(float3(0.03, 0.03, 0.03), mColorLin, pbrMetalness);
	// but some escoteric materials might have different rgb values for F0?

	// If we want to replace this with an F0 input texture
	// the conversion into color space is pow(F0, 1/2.2333 ) * 255;
	// Not a bad idea, so we can have per-pixel F0 value changes
	// Pretty sure this is what most engines do actually

	// but lets not hard code it!
	// IOR values: http://www.pixelandpoly.com/ior.html#C
	// More IOR:  http://forums.cgsociety.org/archive/index.php?t-513458.html
	// water has a IOR of 1.333, converted it's F0 is appox 0.02
	//float3 F0 = abs(pow((1.0f - materialIOR), 2.0f) / pow((1.0f + materialIOR), 2.0f));
	float F0 = abs((1.0f - materialIOR) / (1.0f + materialIOR));
	F0 = F0 * F0;  // to the power of 2

	if (pbrSpecF0 > 0)
		F0 = pbrSpecF0;

	// Specular tint (from disney plausible)
	//float3 bColorLin = albedo.rgb; // pass in color already converted to linear

	// materialSpecular				scalar 0..1
	// materialSpecTint				scalar 0..1 (soft)

	// luminance approx.
	float bClum = 0.3f * bColorLin[0] + 0.6f * bColorLin[1] + 0.1f * bColorLin[2];
	// normalize lum. to isolate hue+sat
	float3 Ctint = bClum > 0.0f ? bColorLin / bClum : 1.0f.xxx;

	// calculate the colored specular F0
	float3 Cspec0 = lerp(materialSpecular * F0 * lerp(1.0f.xxx, Ctint, materialSpecTint), bColorLin, pbrMetalness);

	// build variations of roughness
	float pbrRoughnessBiased = pbrRoughness * (1.0 - ROUGHNESS_BIAS) + ROUGHNESS_BIAS;
	float roughA = pbrRoughness * pbrRoughness;
	float roughA2 = roughA * roughA;

	// build roughness biased
	float roughnessBiasedA = roughA * (1.0 - ROUGHNESS_BIAS) + ROUGHNESS_BIAS;
	float roughnessBiasedA2 = roughnessBiasedA * roughnessBiasedA;

	// This won't change per-light so calulate it outside of the loop
	//float NdotV = clamp(dot(n, p.m_View.xyz), 0.00001, 1.0);
	// constant to prevent NaN
	//float NdotV = max(dot(n, p.m_View.xyz), 1e-5);	
	// Avoid artifact - Ref: SIGGRAPH14 - Moving Frosbite to PBR
	float NdotV = abs(dot(n, p.m_View.xyz)) + EPSILON;

	//going to just use a constant value for shadow instead (to disregard)
	float4 shadow = (1.0f, 1.0f, 1.0f, 1.0f);
	float selfOccShadow = 1.0;

	// This is here for reference, the engine directional sunlight
	// We need this in maya - just let the artist use a bound light as directional
	// Although, we could add sun properties and expose this so we don't use up a light
	//i = 0;
	//float n_dot_l = saturate(dot(n, lightDirection[i].m_Direction.xyz));
	//float diffuse_term = n_dot_l;
	//float specular_term = calculate_specular_term_physically(p.m_View.xyz, n, lightDirection[i].m_Direction.xyz, materialShine.x, materialFresnel.x, n_dot_l);

	//diffuse += (diffuse_term * lightDirection[i].m_Diffuse * shadow);
	//specular += (specular_term * lightDirection[i].m_Specular * shadow);

	// Maya light types
	// string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
	// 5 : ambient
	// 4 : directional
	// 3 : point
	// 2 : spot
	// 1 : default (directional)
	// 0 : none
	const int MAX_NUM_MAYA_LIGHTS = 4;
	for (int i = 0; i < MAX_NUM_MAYA_LIGHTS; ++i)
	{

		if (lights[i].m_Enabled == false)
		// if the light is disabled/hidden in Maya skip it
		{
			continue;
		}

		if (lights[i].m_Type == 4 || lights[i].m_Type == 1) //Directional
		{
			// half angle of light direction and the view
			float3 H = normalize(lights[i].m_Direction.xyz + p.m_View.xyz);
			// dot product of the normal and the light direction
			float NdotL = saturate(dot(n, lights[i].m_Direction.xyz));
			// dot product of the light direction and the half angle
			float LdotH = saturate(dot(lights[i].m_Direction.xyz, H));
			// dot product of the normal and halfAngle
			float NdotH = saturate(dot(n, H));

			// dot of view and half angle
			float VdotH = saturate(dot(p.m_View.xyz, H));

			// calculate the diffuse term
			float diffuse_term = bigD_DiffuseBRDF(roughnessBiasedA, NdotL, NdotV, LdotH);
			// calculate the specular term
			float specular_term = LightingFuncGGX_REF(H, NdotL, NdotV, NdotH, LdotH, roughnessBiasedA, roughnessBiasedA2, Cspec0);

			diffuse += (diffuse_term * lights[i].m_Diffuse * lights[i].m_Intensity * NdotL);
			specular += (specular_term * lights[i].m_Specular * lights[i].m_Intensity * NdotL);

			if (useShadows && lights[i].m_LightShadowOn)
			{
				shadow = lightShadow(i, lights[i].m_LightViewPrj, SamplerShadowDepth, p.m_WorldPosition.xyz, shadowMultiplier, shadowDepthBias);
				diffuse *= shadow;
				specular *= shadow;
			}

			// Parallax Occlusion Self-Shadowing
			// Implementing just on the directional light to begin with
			// To Do: make this a function call in parallax.sif

			if (useParallaxOcclusionMapping && usePOMselfShadow)
				// this doesn't work well, not sure why exactly ... I mean it does something, but not what I'd expect.
				// 1) it creates shadows, but they aren't as soft as I would have expected
				// 2) they blow up (stepping artifacts) if the height is increased too much
				//    - you could probably build an iterative loop and increase the number of steps
				// 3) the length, amount and impact of details doesn't very well match non-soft
				//    - I can probably sync them up better
				//    - can add weighting per-step to make softer?
				//    - maybe we could bias the miplevel?
				//    - and I need to make adjustments to which paramters are used and how so the two are more similar usage
				if (usePOMsoftShadow)
				{
					float3 lightDirTS = mul(lights[i].m_Direction.xyz, worldToTangent);

					float2 lightRayTS = ( float2(lightDirTS.x, lightDirTS.y) ) * materialPomHeightScale;					float h0 = 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV).r;
					float h = h0;					h = min(1.0, 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV + 1.0 * lightRayTS).r);					h = min(h, 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV + 0.8 * lightRayTS).r);					h = min(h, 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV + 0.6 * lightRayTS).r);					h = min(h, 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV + 0.4 * lightRayTS).r);					h = min(h, 1 - heightMap.Sample(SamplerAnisoWrap, pomSsUV + 0.2 * lightRayTS).r);
					selfOccShadow = 1.0 - saturate( (h0 - h) * selfOccStrength );
				}

				else
				{
					float3 lightDirTS = mul(lights[i].m_Direction.xyz, worldToTangent);

					float occlusionLimit = length(lightDirTS.xy) / lightDirTS.z;
					occlusionLimit *= materialPomHeightScale;

					float2 occOffsetDir = normalize(-lightDirTS.xy);
					float2 maxOccOffset = occOffsetDir * occlusionLimit;

					int nNumSamplesOcclusion = (int)lerp(pomMaxSamples, pomMinSamples, NdotL);
					float fStepSizeOcclusion = (1.0 - lastSampledHeight) / (float)nNumSamplesOcclusion;

					float fCurrRayHeightOcclusion = lastSampledHeight + selfOccOffset;
					float2 vCurrOffsetOcclusion = finalTexOffset;
					float2 vLastOffsetOcclusion = finalTexOffset;

					float fLastSampledHeightOcclusion = lastSampledHeight + selfOccOffset;
					float fCurrSampledHeightOcclusion = lastSampledHeight + selfOccOffset;

					int nCurrSampleOcclusion = 0;

					while (nCurrSampleOcclusion < nNumSamplesOcclusion)
					{
						fCurrSampledHeightOcclusion = heightMap.SampleGrad(SamplerAnisoWrap, p.m_Uv0 + vCurrOffsetOcclusion, dx, dy).r;
						if (fCurrSampledHeightOcclusion > fCurrRayHeightOcclusion)
						{
							selfOccShadow = 1.0 - selfOccStrength;

							nCurrSampleOcclusion = nNumSamplesOcclusion + 1;
						}
						else
						{
							nCurrSampleOcclusion++;

							fCurrRayHeightOcclusion += zStepSize;

							vLastOffsetOcclusion = vCurrOffsetOcclusion;
							vCurrOffsetOcclusion -= fStepSizeOcclusion * maxOccOffset;

							fLastSampledHeightOcclusion = fCurrSampledHeightOcclusion;
						}
					}
				}

			diffuse *= selfOccShadow;
			specular *= selfOccShadow;
		}
		else if (lights[i].m_Type == 3) //Point
		{
			// construct light direction
			float3 l = lights[i].m_Position.xyz - p.m_WorldPosition.xyz;
			// distance is length
			float d = length(l);
			float ood = rcp(d);
			// attenuation
			float a = 1 / (d * lights[i].m_Attenuation);
			l *= ood;
			//l = normalize(l);

			l = normalize(lights[i].m_Position.xyz - p.m_WorldPosition.xyz);

			float3 H = normalize(l + p.m_View.xyz);
			float NdotL = saturate(dot(n, l));
			float LdotH = saturate(dot(l, H));
			float NdotH = saturate(dot(n, H));
			float VdotH = saturate(dot(p.m_View.xyz, H));

			float diffuse_term = bigD_DiffuseBRDF(roughnessBiasedA, NdotL, NdotV, LdotH);
			float specular_term = LightingFuncGGX_REF(H, NdotL, NdotV, NdotH, LdotH, roughnessBiasedA, roughnessBiasedA2, Cspec0);

			diffuse += (diffuse_term * lights[i].m_Diffuse * lights[i].m_Intensity * NdotL * a);
			specular += (specular_term * lights[i].m_Specular * lights[i].m_Intensity * NdotL * a);
		}
		else if (lights[i].m_Type == 2) //Spot
		{
			float3 l = lights[i].m_Position.xyz - p.m_WorldPosition.xyz;
			float d = length(l);
			l *= rcp(d);
			float direction_dot_light = saturate(dot(lights[i].m_Direction.xyz, l));

			if (direction_dot_light > 0.0f)
			{
				float ood = rcp(d);
				float a = 1 / (d * lights[i].m_Attenuation);
				l *= ood;
				l = normalize(l);

				float spot = pow(direction_dot_light, 1);// lights[i].m_Cone.x);

				float3 H = normalize(l + p.m_View.xyz);
				float NdotL = saturate(dot(n, l));
				float LdotH = saturate(dot(l, H));
				float NdotH = saturate(dot(n, H));
				float VdotH = saturate(dot(p.m_View.xyz, H));

				float diffuse_term = bigD_DiffuseBRDF(roughnessBiasedA, NdotL, NdotV, LdotH);
				float specular_term = LightingFuncGGX_REF(H, NdotL, NdotV, NdotH, LdotH, roughnessBiasedA, roughnessBiasedA2, Cspec0);

				diffuse += (diffuse_term * lights[i].m_Diffuse * lights[i].m_Intensity * NdotL * a * spot);
				specular += (specular_term * lights[i].m_Specular * lights[i].m_Intensity * NdotL * a * spot);
			}
		}
		else if (lights[i].m_Type == 5) //Ambient
		{
			// I am pretty sure I shouldn't be doing all of this work for an ambient light!
			float3 H = normalize(-n + p.m_View.xyz);
			float NdotL = saturate(dot(n, -n));
			float LdotH = saturate(dot(-n, H));
			float NdotH = saturate(dot(n, H));
			float VdotH = saturate(dot(p.m_View.xyz, H));

			float diffuse_term = bigD_DiffuseBRDF(roughnessBiasedA, NdotL, NdotV, LdotH);
			float specular_term = LightingFuncGGX_REF(H, NdotL, NdotV, NdotH, LdotH, roughnessBiasedA, roughnessBiasedA2, Cspec0);

			diffuse += (diffuse_term * lights[i].m_Diffuse * lights[i].m_Intensity * NdotL);
			specular += (specular_term * lights[i].m_Diffuse * lights[i].m_Intensity * NdotL);
		}
	}
	// Set up envmap values
	float3 diffEnvLin = (0.0f, 0.0f, 0.0f);
	float3 specEnvLin = (0.0f, 0.0f, 0.0f);
	float3 brdfMap = (0.0f, 0.0f, 0.0f);
	float4 diffEnvMap = (0.0f, 0.0f, 0.0f, 0.0f);
	float4 specEnvMap = (0.0f, 0.0f, 0.0f, 0.0f);

	// set up hemispherical ambient
	if (useEnvMaps)
	{
		// reflection is incoming light
		float3 R = -reflect(p.m_View.xyz, n);
		// this probably should not be a constant!
		const float rMipCount = 9.0f;
		// calc the mip level to fetch based on roughness
		//float roughMip = roughA * rMipCount;
		float roughMip = pbrRoughnessBiased * rMipCount;

		// load brdf lookup
		brdfMap = brdfTextureMap.Sample(SamplerBrdfLUT, float2(NdotV, pbrRoughnessBiased), 0.0f).xyz;

		float offset = 0.05f;
		float3 refractedColor;

		// load cubemaps
		if (envMapType == 0)
		{
			diffEnvMap = diffuseEnvTextureCube.SampleLevel(SamplerCubeMap, n, 0.0f).rgba;
			specEnvMap = specularEnvTextureCube.SampleLevel(SamplerCubeMap, R, roughMip).rgba;
		}

		// load latlong maps (ToDo: not implemented yet)
		if (envMapType == 1)
		{
			diffEnvMap = diffuseEnvTextureCube.SampleLevel(SamplerCubeMap, n, 0.0f).rgba;
			specEnvMap = specularEnvTextureCube.SampleLevel(SamplerCubeMap, R, roughMip).rgba;
		}

		// decode RGBM --> HDR
		diffEnvLin = RGBMDecode(diffEnvMap, envLightingExp, gammaCorrectionExponent).rgb;
		specEnvLin = RGBMDecode(specEnvMap, envLightingExp, gammaCorrectionExponent).rgb;
	}

	// tinted specular verus colored specular for metalness
	float3 cSpecLin = lerp(Cspec0.rgb, bColorLin.rgb, pbrMetalness) * brdfMap.x + brdfMap.y;
	//float3 fcSpecLin = Specular_F_Roughness(cSpecLin, roughnessBiased, NdotV);

	// set up hemispherical ambient
	if (hemisphericalAmbientyMode > 0)
	{
		// 0 is None, so don't include the hemispherical ambient
		// 1 is ADD, so we add it's contribution (to the env maps, or lack there of)
		if (hemisphericalAmbientyMode == 1)
		{
			diffEnvLin.rgb += ambDomeLinColor.rgb;
			specEnvLin.rgb += ambDomeLinColor.rgb;
		}
		// 2 is MULTIPLY, multiply the env maps by the hemispherical ambient i.e. tint
		if (hemisphericalAmbientyMode == 2)
		{
			diffEnvLin.rgb *= ambDomeLinColor.rgb;
			specEnvLin.rgb *= ambDomeLinColor.rgb;
		}
	}

	diffuse.rgb += diffEnvLin;

	// Multiply the specular by colored specular and specular amount
	specular.rgb *= cSpecLin.rgb * materialSpecular;
	specEnvLin.rgb *= cSpecLin.rgb * materialSpecular;
	specular.rgb += specEnvLin;

	// ----------------------
	// FINAL COLOR AND ALPHA:
	// ----------------------
	// add the cumulative diffuse and specular
	//o.m_Color.xyz = (diffuse.xyz * base.xyz) + (specular.xyz * base.xyz) + matEmissive.xyz;
	o.m_Color.rgb = (diffuse.rgb * mColorLin.rgb * bumpAO * vertAO * ssao);
	o.m_Color.rgb += (specular.rgb * bColorLin.rgb * bumpAO * vertAO * ssao * pbrCavity);

	// final alpha:
	transperancy = opacity < 1.0f ? (transperancy * opacity) : transperancy;
	o.m_Color.w = transperancy;

	float3 result = o.m_Color.rgb * transperancy;

	// do gamma correction in shader:
	//if (!MayaFullScreenGamma)
		//if (useGammaCorrectShader)
			//// this might need to be here with tonemapping?
			//result = pow(result, 1 / gammaCorrectionExponent);

#ifdef _MAYA_
	// do gamma correction and tone mapping in shader:
	// "none:approx:linear:linearExp:reinhard:reinhardExp:HaarmPeterCurve:HaarmPeterCurveExp:uncharted2FilmicTonemapping:uncharted2FilmicTonemappingExp"
	if (!MayaFullScreenGamma)
	{
		if (useGammaCorrectShader)
		{
			if (tonempappingType > 0)
			{
				if (tonempappingType == 1) result = approxToneMapping(result, bloomExp).rgb;
				if (tonempappingType == 2) result = linearTonemapping(result, gammaCorrectionExponent).rgb;
				if (tonempappingType == 3) result = linearExpTonemapping(result, bloomExp, gammaCorrectionExponent).rgb;
				if (tonempappingType == 4) result = reinhard(result, gammaCorrectionExponent).rgb;
				if (tonempappingType == 5) result = reinhardExp(result, bloomExp, gammaCorrectionExponent).rgb;
				if (tonempappingType == 6) result = HaarmPeterCurve(result, filmLutMap);
				if (tonempappingType == 7) result = HaarmPeterCurveExp(result, filmLutMap, bloomExp);
				if (tonempappingType == 8) result = JimHejlRichardBurgessDawson(result);
				if (tonempappingType == 9) result = JimHejlRichardBurgessDawsonExp(result, bloomExp);
				if (tonempappingType == 10) result = uncharted2FilmicTonemapping(result, gammaCorrectionExponent);
				if (tonempappingType == 11) result = uncharted2FilmicTonemappingExp(result, gammaCorrectionExponent, bloomExp);
			}
		}
	}
#endif

// Debug views
//"o.m_Color.rgb:baseColorTex.rgb:baseColorTex.aaa:bColorLin.rgb:mColorLin.rgb:p.m_albedoRGBA.rgb:p.m_albedoRGBA.aaa:pbrMetalness.xxx:pbrRoughness.xxx:pbrAO.xxx:pbrCavity.xxx:baseNormalMap.xyz:normalRaw.xyz:F0.xxx:bClum.xxx:Ctint.rgb:Cspec0.rgb:diffuse.rgb:specular.rgb:pbrRoughness.xxx:roughA.xxx:roughA2.xxx:roughnessBiasedA.xxx:roughnessBiasedA2.xxx:NdotV:ambDomeColor.rgb:ambDomeLinColor.rgb:diffEnvLin.rgb:specEnvLin.rgb:cSpecLin:baseUV:selfOccShadow"
#ifdef _MAYA_
	if (g_DebugMode > 0)
	{
		if (g_DebugMode == 1) result = baseColorTex.rgb;
		if (g_DebugMode == 2) result = baseColorTex.aaa;
		if (g_DebugMode == 3) result = bColorLin.rgb;
		if (g_DebugMode == 4) result = mColorLin.rgb;
		if (g_DebugMode == 5) result = p.m_albedoRGBA.rgb;
		if (g_DebugMode == 6) result = p.m_albedoRGBA.aaa;
		if (g_DebugMode == 7) result = pbrMetalness.xxx;
		if (g_DebugMode == 8) result = pbrRoughness.xxx;
		if (g_DebugMode == 9) result = bumpAO.xxx;
		if (g_DebugMode == 10) result = pbrCavity.xxx;
		if (g_DebugMode == 11) result = baseNormalMap.Sample(SamplerAnisoWrap, p.m_Uv0).xyz;
		if (g_DebugMode == 12) result = normalRaw.xyz;
		if (g_DebugMode == 13) result = F0.xxx;
		if (g_DebugMode == 14) result = bClum.xxx;
		if (g_DebugMode == 15) result = Ctint.rgb;
		if (g_DebugMode == 16) result = Cspec0.rgb;
		if (g_DebugMode == 17) result = diffuse.rgb;
		if (g_DebugMode == 18) result = specular.rgb;
		if (g_DebugMode == 19) result = pbrRoughness.xxx;
		if (g_DebugMode == 20) result = roughA.xxx;
		if (g_DebugMode == 21) result = roughA2.xxx;
		if (g_DebugMode == 22) result = roughnessBiasedA.xxx;
		if (g_DebugMode == 23) result = roughnessBiasedA2.xxx;
		if (g_DebugMode == 24) result = NdotV;
		if (g_DebugMode == 25) result = (lerp(ambientGroundColor.rgb, ambientSkyColor.rgb, saturate((ambientUpAxis * 0.5) + 0.5))).rgb;
		if (g_DebugMode == 26) result = ambDomeLinColor.rgb;
		if (g_DebugMode == 27) result = diffEnvLin.rgb;
		if (g_DebugMode == 28) result = specEnvLin.rgb;
		if (g_DebugMode == 29) result = cSpecLin;
		if (g_DebugMode == 30)
		{
			// why isn't this working???
			float3 uvColor = float3(0.0, 0.0, 0.0);
			if (baseUV.x < 0)
				uvColor = float3(0, 1, 0); // output green 

			if (baseUV.y < 0)
				uvColor = float3(0, 0, 1); // output blue

			if (baseUV.x > 1)
				uvColor = float3(1, 0, 0); // output red

			if (baseUV.y > 1)
				uvColor = float3(1, 0, 1); // output magenta

			float3 result = float4(uvColor.rgb, 1.0);
		}
		if (g_DebugMode == 31) result = selfOccShadow.xxx;
	}
#endif

	// REAL return out...
	o.m_Color = float4(result.rgb, transperancy);
	return o;
}

/**
move these functiosn into mayaUtilities.fxh
call them where they are needed
*/
#ifdef _MAYA_
void Peel(VsOutput v)
{
	float currZ = abs(mul(v.m_WorldPosition, view).z);

	float4 Pndc = mul(v.m_WorldPosition, viewPrj);
	float2 UV = Pndc.xy / Pndc.w * float2(0.5f, -0.5f) + 0.5f;
	float prevZ = transpDepthTexture.Sample(SamplerShadowDepth, UV).r;
	float opaqZ = opaqueDepthTexture.Sample(SamplerShadowDepth, UV).r;
	float bias = 0.00002f;
	if (currZ < prevZ * (1.0f + bias) || currZ > opaqZ * (1.0f - bias))
	{
		discard;
	}
}

float4 LinearDepth(VsOutput v)
{
	return abs(mul(v.m_WorldPosition, view).z);
}

float4 DepthComplexity(float opacity)
{
	return opacity > 0.001f ? 1.0f : 0.0f;
}

struct MultiOut2
{
	float4 target0 : SV_Target0;
	float4 target1 : SV_Target1;
};

MultiOut2 fTransparentPeel(VsOutput v, bool FrontFace : SV_IsFrontFace)
{
	Peel(v);

	MultiOut2 OUT;
	OUT.target0 = pMain(v, FrontFace).m_Color;
	OUT.target1 = LinearDepth(v);
	return OUT;
}

MultiOut2 fTransparentPeelAndAvg(VsOutput v, bool FrontFace : SV_IsFrontFace)
{
	Peel(v);

	MultiOut2 OUT;
	OUT.target0 = pMain(v, FrontFace).m_Color;
	OUT.target1 = DepthComplexity(OUT.target0.w);
	return OUT;
}

MultiOut2 fTransparentWeightedAvg(VsOutput v, bool FrontFace : SV_IsFrontFace)
{
	MultiOut2 OUT;
	OUT.target0 = pMain(v, FrontFace).m_Color;
	OUT.target1 = DepthComplexity(OUT.target0.w);
	return OUT;
}

//------------------------------------
// wireframe pixel shader
//------------------------------------
float4 fwire(VsOutput v) : SV_Target
{
	return float4(0, 0, 1, 1);
}


//------------------------------------
// pixel shader for shadow map generation
//------------------------------------
//float4 ShadowMapPS( float3 Pw, float4x4 shadowViewProj ) 
float4 ShadowMapPS(VsOutput v) : SV_Target
{
	// clip as early as possible
	if (useCutoutAlpha)
	{
		// clip as early as possible
		//OpacityMaskClip(hasAlpha, SamplerLinearWrap, diffuseMap0, v.m_Uv0, opacityMaskBias);
		OpacityClip(hasAlpha, opacity, opacityMaskBias);
	}

float4 Pndc = mul(v.m_WorldPosition, viewPrj);

// divide Z and W component from clip space vertex position to get final depth per pixel
float retZ = Pndc.z / Pndc.w;

retZ += fwidth(retZ);
return retZ.xxxx;
}
#endif

//------------------------------------
// Notes
//------------------------------------
// Shader uses 'pre-multiplied alpha' as its render state and this Uber Shader is build to work in unison with that.
// Alternatively, in Maya, the dx11Shader node allows you to set your own render states by supplying the 'overridesDrawState' annotation in the technique
// You may find it harder to get proper transparency sorting if you choose to do so.

// The technique annotation 'isTransparent' is used to tell Maya how treat the technique with respect to transparency.
//	- If set to 0 the technique is always considered opaque
//	- If set to 1 the technique is always considered transparent
//	- If set to 2 the plugin will check if the parameter marked with the OPACITY semantic is less than 1.0
//	- If set to 3 the plugin will use the transparencyTest annotation to create a MEL procedure to perform the desired test.
// Maya will then render the object twice. Front faces follow by back faces.

// For some objects you may need to switch the Transparency Algorithm to 'Depth Peeling' to avoid transparency issues.
// Models that require this usually have internal faces.

//------------------------------------
// Techniques
//------------------------------------
/**
@brief The technique set up for the FX framework
*/
technique11 TessellationOFF
<
	bool overridesDrawState = false;	// we do not supply our own render state settings
int isTransparent = 3;
// which values trigger a transparecy test
string transparencyTest = "opacity < 1.0 || hasAlpha || hasVertexAlpha";

#ifdef _MAYA_
// Tells Maya that the effect supports advanced transparency algorithm,
// otherwise Maya would render the associated objects simply by alpha
// blending on top of other objects supporting advanced transparency
// when the viewport transparency algorithm is set to depth-peeling or
// weighted-average.
bool supportsAdvancedTransparency = true;
#endif
>
{
	pass P0
		<
		string drawContext = "colorPass";	// tell maya during what draw context this shader should be active, in this case 'Color'
		>
	{
#ifdef _MAYA_
		SetBlendState(PMAlphaBlending, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
#endif
		SetVertexShader(CompileShader(vs_5_0, vsMain()));
		SetPixelShader(CompileShader(ps_5_0, pMain()));
	}



#ifdef _MAYA_

		pass pTransparentPeel
			<
			// Depth-peeling pass for depth-peeling transparency algorithm.
			string drawContext = "transparentPeel";
			>
		{
			SetVertexShader(CompileShader(vs_5_0, vsMain()));
			SetPixelShader(CompileShader(ps_5_0, fTransparentPeel()));
		}

			pass pTransparentPeelAndAvg
				<
				// Weighted-average pass for depth-peeling transparency algorithm.
				string drawContext = "transparentPeelAndAvg";
				>
			{
				SetVertexShader(CompileShader(vs_5_0, vsMain()));
				SetPixelShader(CompileShader(ps_5_0, fTransparentPeelAndAvg()));
			}

				pass pTransparentWeightedAvg
					<
					// Weighted-average algorithm. No peeling.
					string drawContext = "transparentWeightedAvg";
					>
				{
					SetVertexShader(CompileShader(vs_5_0, vsMain()));
					SetPixelShader(CompileShader(ps_5_0, fTransparentWeightedAvg()));
				}

					pass pShadow
						<
						string drawContext = "shadowPass";	// shadow pass
						>
					{
						SetVertexShader(CompileShader(vs_5_0, vsMain()));
						SetPixelShader(CompileShader(ps_5_0, ShadowMapPS()));
					}
#endif
}