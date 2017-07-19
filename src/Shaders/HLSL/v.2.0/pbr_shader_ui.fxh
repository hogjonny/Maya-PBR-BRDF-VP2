/**
@file shader_pbr.fxh
@brief Contains the Maya UI for setting material parameters for pbr shaders
*/

/**
@file 
@brief
@copyright
*/
#ifndef _SHADER_PBR_FXH_
#define _SHADER_PBR_FXH_ 

#include "propertyNames.fxh"

// ---------------------------------------------
// string UIGroup = "Material Maps"; UI 100+
// ---------------------------------------------
// #define HOG_GRP_MATERIAL_MAPS "Material Maps"

/**
@brief baseColor input for diffuse/albedo color shading calculations
*/
#define HOG_MAP_BASECOLOR Texture2D baseColorMap			\
<															\
	string UIGroup = HOG_GRP_MATERIAL_MAPS;					\
	string ResourceName = "";								\
	string UIWidget = "FilePicker";							\
	string UIName = HOG_BASECOLOR_MAP;						\
	string ResourceType = "2D";								\
	int mipmaplevels = NumberOfMipMaps;						\
	int UIOrder = 100;										\
	int UVEditorOrder = 1;									\
>;

/**
@brief The NormalMap used to peturb normals for shading calculations
*/
#define HOG_MAP_BASENORMAL Texture2D baseNormalMap			\
<															\
	string UIGroup = HOG_GRP_MATERIAL_MAPS;					\
	string ResourceName = "";								\
	string UIWidget = "FilePicker";							\
	string UIName = HOG_NORMAL_MAP;							\
	string ResourceType = "2D";								\
	/** If mip maps exist in texture, Maya will load them.	\
	So user can pre-calculate and re-normalize mip maps		\
	for normal maps in .dds */								\
	int mipmaplevels = 0;									\
	int UIOrder = 101;										\
	int UVEditorOrder = 1;									\
>;

/**
@brief The NormalMap used to peturb normals for shading calculations
	R = Metalness (might have little or very broad change)
	G = Roughness (most important in pbr, that's why it's in green)
	B = AO        (this might really suck when compressed)
	A = Cavity    (likely finest grain lines, needs good compression)

	Note:	IOR conversion into color space is:
			F0 = pow(abs((1.0f - IOR) / (1.0f + IOR)), 2.0f);
			pow(F0, 1/2.2333 ) * 255;
*/
#define HOG_MAP_PBRMASKS Texture2D pbrMasksMap				\
<															\
	string UIGroup = HOG_GRP_MATERIAL_MAPS;					\
	string ResourceName = "";								\
	string UIWidget = "FilePicker";							\
	string UIName = HOG_PBRMASKSMAP_MAP;					\
	string ResourceType = "2D";								\
	/** If mip maps exist in texture, Maya will load them.	\
	So user can pre-calculate and re-normalize mip maps		\
	for normal maps in .dds */								\
	int mipmaplevels = 0;									\
	int UIOrder = 102;										\
	int UVEditorOrder = 1;									\
>;

// ---------------------------------------------
// string UIGroup = "Enrironment Maps"; UI 125+
// ---------------------------------------------
//#define HOG_GRP_ENV_LIGHTING "Enrironment Lighting"	

#define HOG_ENV_BOOL bool useEnvMaps											\
<																				\
	string UIGroup = HOG_GRP_ENV_LIGHTING;										\
	string UIName = HOG_SCENE_USE_ENV;											\
	int UIOrder = 125;															\
> = true;

#define HOG_ENVMAP_TYPE int envMapType											\
<																				\
	string UIGroup = HOG_GRP_ENV_LIGHTING;										\
	string UIWidget = "Slider";													\
	string UIFieldNames = "cubemap:LatLong[2D]";								\
	string UIName = HOG_SCENE_ENV_TYPE;											\
	int UIOrder = 126;															\
> = 0;

#define HOG_MAP_BRDF Texture2D brdfTextureMap									\
<																				\
    string UIGroup = HOG_GRP_ENV_LIGHTING;										\
    string ResourceName = "";													\
    string UIWidget = "FilePicker";												\
    string UIName = HOG_SCENE_BRDF;												\
    string ResourceType = "2D";													\
    int mipmaplevels = 0;														\
    int UIOrder = 127;															\
>;

#define HOG_CUBEMAP_IBLDIFF TextureCube diffuseEnvTextureCube : environment		\
<																				\
    string UIGroup = HOG_GRP_ENV_LIGHTING;										\
    string ResourceName = "";													\
    string UIWidget = "FilePicker";												\
    string UIName = HOG_SCENE_CUBE_IBLDIFF;										\
    string ResourceType = "Cube";												\
    int mipmaplevels = 0;														\
    int UIOrder = 128;															\
>;

#define HOG_CUBEMAP_IBLSPEC TextureCube specularEnvTextureCube : environment	\
<																				\
    string UIGroup = HOG_GRP_ENV_LIGHTING;										\
    string ResourceName = "";													\
    string UIWidget = "FilePicker";												\
    string UIName = HOG_SCENE_CUBE_IBLSPEC;										\
    string ResourceType = "Cube";												\
    int mipmaplevels = 0;														\
    int UIOrder = 129;															\
>;

#define HOG_LATLONG_IBLDIFF Texture2D diffuseEnvTextureLatlong : environment	\
<																				\
    string UIGroup = HOG_GRP_ENV_LIGHTING;										\
    string ResourceName = "";													\
    string UIWidget = "FilePicker";												\
    string UIName = HOG_SCENE_LATLONG_IBLDIFF;									\
    string ResourceType = "Cube";												\
    int mipmaplevels = 0;														\
    int UIOrder = 130;															\
>;

#define HOG_LATLONG_IBLSPEC Texture2D specularEnvTextureLatlong : environment	\
<																				\
    string UIGroup = HOG_GRP_ENV_LIGHTING;										\
    string ResourceName = "";													\
    string UIWidget = "FilePicker";												\
    string UIName = HOG_SCENE_LATLONG_IBLSPEC;									\
    string ResourceType = "Cube";												\
    int mipmaplevels = 0;														\
    int UIOrder = 131;															\
>;

#define HOG_ENVLIGHTING_EXP float envLightingExp	\
<													\
    string UIGroup = HOG_GRP_ENV_LIGHTING;			\
    string UIWidget = "Slider";						\
    float UIMin = 0.001;							\
    float UISoftMax = 100.000;						\
    float UIStep = 0.001;							\
    string UIName = HOG_SCENE_IBLEXP;				\
    int UIOrder = 132;								\
> = {5.0f};

/**
@brief faux scene based global ambient (color value)
*/
#define HOG_PROPERTY_SCENE_AMBIENTLIGHT float3 sceneAmbientLight			\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIName = HOG_SCENE_AMBIENT_LIGHT;								\
	string UIWidget = "ColorPicker";										\
	int UIOrder = 133;														\
> = { 0.1f, 0.1f, 0.1f};

#define HOG_PROPERTY_SCENE_AMBHEMIMODE int hemisphericalAmbientyMode		\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIWidget = "Slider";												\
	string UIFieldNames = "NONE:ADD:MULTIPLY";								\
	string UIName = HOG_SCENE_AMBHEMIMODE;									\
	int UIOrder = 134;														\
> = 0;		

#define HOG_PROPERTY_SCENE_AMBIENTSKY float3 ambientSkyColor : Ambient		\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIName = HOG_SCENE_AMBSKY;										\
	string UIWidget = "ColorPicker";										\
	int UIOrder = 135;														\
> = {0.0f, 1.0f, 1.0f };

#define HOG_PROPERTY_SCENE_AMBIENTGRND float3 ambientGroundColor : Ambient	\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIName = HOG_SCENE_AMBGRND;										\
	string UIWidget = "ColorPicker";										\
	int UIOrder = 136;														\
> = {0.087f, 0.064f, 0.032f };

#define HOG_PROPERTY_SCENE_AMBSKYINT float ambientSkyIntensity				\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIName = HOG_SCENE_AMBSKYINT;									\
	string UIWidget = "Slider";												\
	float UIMin = 0.000;													\
	float UISoftMax = 5.000;												\
	float UIStep = 0.001;													\
	int UIOrder = 137;														\
> = {0.500f};

#define HOG_PROPERTY_SCENE_AMBGRNDINT float ambientGrndIntensity			\
<																			\
	string UIGroup = HOG_GRP_ENV_LIGHTING;									\
	string UIName = HOG_SCENE_AMBGRNDINT;									\
	string UIWidget = "Slider";												\
	float UIMin = 0.000;													\
	float UISoftMax = 5.000;												\
	float UIStep = 0.001;													\
	int UIOrder = 138;														\
> = {0.100f};

// ---------------------------------------------
// string UIGroup = "Material Properties"; UI 150+
// ---------------------------------------------
//#define HOG_GRP_MAT_PROPS "Material Properties"

/**
@brief Macro to define Has Alpha for use with opacity
*/
#define HOG_PROPERTY_HAS_ALPHA bool hasAlpha							\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_HAS_ALPHA;										\
	int UIOrder = 150;													\
> = false;

/**
@brief Macro to define whether or not to use cutout alpha
*/
#define HOG_PROPERTY_CUTOUT_ALPHA bool useCutoutAlpha					\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_USE_CUTOUT_ALPHA;								\
	int UIOrder = 151;													\
> = false;

/**
@breif at what value do we clip away pixels
*/
#define HOG_PROPERTY_OPACITY_MASK_BIAS float opacityMaskBias	\
<																\
	string UIGroup = HOG_GRP_MAT_PROPS;							\
	string UIName = HOG_OPACITY_BIAS;							\
	string UIWidget = "Slider";									\
	float UIMin = 0.0;											\
	float UIMax = 1.0;											\
	float UIStep = 0.001;										\
	int UIOrder = 153;											\
> = 0.1;

// maya needs an opacity semantic ... this might not be the correct way to handle this but it works for now
#define HOG_PROPERTY_OPACITY float opacity : OPACITY			\
<																\
	string UIGroup = HOG_GRP_MAT_PROPS;							\
	string UIWidget = "Slider";									\
	float UIMin = 0.0;											\
	float UIMax = 1.0;											\
	float UIStep = 0.001;										\
	string UIName = HOG_OPACITY;								\
	int UIOrder = 154;											\
> = 1.0;

/**
@brief Marco to define base color material property for metalic workflow
*/
#define HOG_PROPERTY_MATERIAL_BASECOLOR float3 materialBaseColor		\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_BASECOLOR;								\
	string UIWidget = "ColorPicker";									\
	int UIOrder = 155;													\
> = { 0.6f, 0.6f, 0.6f};

/**
@brief Marco to define diffuse reflective material property
*/
#define HOG_PROPERTY_MATERIAL_DIFFUSE float3 materialDiffuse			\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_DIFFUSE;								\
	string UIWidget = "ColorPicker";									\
	int UIOrder = 156;													\
> = { 0.6f, 0.6f, 0.6f};

/**
@brief Macro to define the roughness for the surface
*/
#define HOG_PROPERTY_MATERIAL_ROUGHNESS float materialRoughness			\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_ROUGHNESS;								\
	string UIWidget = "Slider";											\
	float UIMin = 0.001;												\
	float UISMax = 1.0;													\
	float UIStep = 0.001;												\
	int UIOrder = 157;													\
> = 0.50f;

/**
@brief Macro to define the metalness of the surface
*/
#define HOG_PROPERTY_MATERIAL_METALNESS float materialMetalness			\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_METALNESS;								\
	string UIWidget = "Slider";											\
	float UIMin = 0.00;													\
	float UIMax = 1.0;													\
	float UIStep = 0.01;												\
	int UIOrder = 158;													\
> = 0.00f;

/**
@brief Macro to define the emissive color of the surface
*/
#define HOG_PROPERTY_MATERIAL_EMISSIVE	float3 materialEmissive			\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_EMISSIVE;								\
	string UIWidget = "ColorPicker";									\
	int UIOrder = 159;													\
> = {0.0f, 0.0f, 0.0f};

/**
@brief Macro to define the emissive intensity
*/
#define HOG_PROPERTY_MATERIAL_EMISSIVEINT float materialEmissiveIntensity	\
<																			\
	string UIGroup = HOG_GRP_MAT_PROPS;										\
	string UIName = HOG_MATERIAL_EMISSIVEINT;								\
	string UIWidget = "Slider";												\
	float UIMin = 0.00;														\
	float UISoftMax = 3.0;													\
	float UIStep = 0.01;													\
	int UIOrder = 160;														\
> = 0.00f;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_MATERIAL_SPECTINT	float materialSpecTint			\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_SPECTINT;								\
	string UIWidget = "Slider";											\
	float UIMin = 0.0;													\
	float UISoftMax = 1.0;												\
	float UIStep = 0.01;												\
	int UIOrder = 161;													\
> = 0.0f;

/**
@brief Macro to define surface IOR value

	Note:	IOR conversion into color space is:
			F0 = pow(abs((1.0f - IOR) / (1.0f + IOR)), 2.0f);
			pow(F0, 1/2.2333 ) * 255;

Various Material IOR values
https://pixelandpoly.com/ior.html

*/
#define HOG_PROPERTY_MATERIAL_IOR	float materialIOR					\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_MATERIAL_IOR;									\
	string UIWidget = "Slider";											\
	float UISoftMin = 1.0;												\
	float UISoftMax = 3.0;												\
	float UIStep = 0.01;												\
	int UIOrder = 162;													\
> = 1.45f;  //default to plastic

/**
@brief Macro to define the height of the normal bump
*/
#define HOG_PROPERTY_MATERIAL_BUMPINTENSITY float materialBumpIntensity		\
<																			\
	string UIGroup = HOG_GRP_MAT_PROPS;										\
	string UIName = HOG_MATERIAL_BUMPINTENSITY;								\
	string UIWidget = "Slider";												\
	float UISoftMin = 0.020;												\
	float UISoftMax = 1.0;													\
	float UIStep = 0.01;													\
	int UIOrder = 163;														\
> = 1.00f;

/**
@brief Macro to define switch for vertex color0, albedo RGBA
*/
#define HOG_PROPERTY_USE_VERTEX_C0_RGBA bool useVertexC0_RGBA				\
<																			\
	string UIGroup = HOG_GRP_MAT_PROPS;										\
	string UIName = HOG_USE_VERTEX_C0_RGBA;									\
	int UIOrder = 164;														\
> = false;

/**
@brief Macro to define Has Vertex Alpha for use with opacity
*/
#define HOG_PROPERTY_HAS_VERTEX_ALPHA bool hasVertexAlpha				\
<																		\
	string UIGroup = HOG_GRP_MAT_PROPS;									\
	string UIName = HOG_HAS_VERTEX_ALPHA;								\
	int UIOrder = 165;													\
> = false;

/**
@brief Macro to define switch for vertex color1, AO
*/
#define HOG_PROPERTY_USE_VERTEX_C1_AO bool useVertexC1_AO					\
<																			\
	string UIGroup = HOG_GRP_MAT_PROPS;										\
	string UIName = HOG_USE_VERTEX_C1_AO;									\
	int UIOrder = 166;														\
> = false;

// ---------------------------------------------
// string UIGroup = "Lighting Properties"; UI 300+
// ---------------------------------------------
//#define HOG_GRP_LIGHT_PROPS "Lighting Properties"

/**
@brief Marco to define ambient reflective material property
*/
#define HOG_PROPERTY_MATERIAL_AMBIENT float3 materialAmbient			\
<																		\
	string UIGroup = HOG_GRP_LIGHT_PROPS;								\
	string UIName = HOG_MATERIAL_AMBIENT;								\
	string UIWidget = "ColorPicker";									\
	int UIOrder = 300;													\
> = {0.1f, 0.1f, 0.1f};	

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_LINEAR_SPACE_LIGHTING bool linearSpaceLighting		\
<																		\
string UIGroup = HOG_GRP_LIGHT_PROPS;									\
string UIName = HOG_LINEAR_SPACE_LIGHTING;								\
int UIOrder = 301;														\
> = true;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_LINEAR_VERTEX_COLOR bool linearVertexColor			\
<																		\
string UIGroup = HOG_GRP_LIGHT_PROPS;									\
string UIName = HOG_LINEAR_VERTEX_COLORS;								\
int UIOrder = 302;														\
> = false;																	

/**
@brief flips back facing normals to improve lighting for things like sheets of hair or leaves
*/
#define HOG_PROPERTY_FLIP_BACKFACE_NORMALS bool flipBackfaceNormals		\
<																		\
string UIGroup = HOG_GRP_LIGHT_PROPS;									\
string UIName = HOG_FLIP_BACKFACE_NORMALS;								\
int UIOrder = 303;														\
> = true;																

// ---------------------------------------------
// string UIgroup = "Shadow"; UI 400+
// ---------------------------------------------
//#define HOG_GRP_SHADOW_PROPS "Shadow Properties"

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_IS_SHADOW_CASTER bool isShadowCaster				\
<																		\
	string UIGroup = HOG_GRP_SHADOW_PROPS;								\
	string UIName = HOG_IS_SHADOW_CASTER;								\
	int UIOrder = 400;													\
> = true;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_IS_SHADOW_RECEIVER bool isShadowReceiver			\
<																		\
	string UIGroup = HOG_GRP_SHADOW_PROPS;								\
	string UIName = HOG_IS_SHADOW_RECEIVER;								\
	int UIOrder = 401;													\
> = true;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_SHADOW_RANGE_AUTO	bool shadowRangeAuto			\
<																		\
	string UIGroup = HOG_GRP_SHADOW_PROPS;								\
	string UIName = HOG_SHADOW_RANGE_AUTO;								\
	int UIOrder = 402;													\
> = true;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_SHADOW_RANGE_MAX float shadowRangeMax				\
<																		\
	string UIGroup = HOG_GRP_SHADOW_PROPS;								\
	string UIName = HOG_SHADOW_RANGE_MAX;								\
	string UIWidget = "Slider";											\
	float UIMin = 0.0;													\
	float UISoftMax = 1000.0;											\
	float UIStep = 0.01;												\
	int UIOrder = 403;													\
> = 0.0f;

/**
@brief This offset allows you to fix any in-correct self shadowing caused by limited precision.
This tends to get affected by scene scale and polygon count of the objects involved.
*/
#define HOG_PROPERTY_SHADOW_DEPTH_BIAS float shadowDepthBias : ShadowMapBias	\
<																				\
	string UIGroup = HOG_GRP_SHADOW_PROPS;										\
	string UIName = HOG_SHADOW_DEPTH_BIAS;										\
	string UIWidget = "Slider";													\
	float UIMin = 0.000;														\
	float UISoftMax = 10.000;													\
	float UIStep = 0.001;														\
	int UIOrder = 405;															\
> = {0.01f};																	

/**
@brief Shadow Intensity
*/
#define HOG_PROPERTY_SHADOW_MULTIPLIER float shadowMultiplier	\
<																\
	string UIGroup = HOG_GRP_SHADOW_PROPS;						\
	string UIName = HOG_SHADOW_MULTIPLIER;						\
	string UIWidget = "Slider";									\
	float UIMin = 0.000;										\
	float UIMax = 1.000;										\
	float UIStep = 0.001;										\
	int UIOrder = 406;											\
> = { 1.0f };													

/**
@brief use shadows
*/
#define HOG_PROPERTY_SHADOW_USE_SHADOWS bool useShadows		\
<															\
	string UIGroup = HOG_GRP_SHADOW_PROPS;					\
	string UIName = HOG_SHADOW_USE_SHADOWS;					\
	int UIOrder = 407;										\
> = false;													

// ---------------------------------------------
// string UIGroup = "HOG_GRP_ADV_PROPS"; UI 500+
// ---------------------------------------------
//#define HOG_GRP_ADV_PROPS "HOG_GRP_ADV_PROPS Properties"

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_POSITION int vertexElementPosition	\
<																		\
	string UIGroup = HOG_GRP_ADV_PROPS;									\
	string UIFieldNames = "Auto:16:32:";								\
	string UIName = HOG_VERTEX_ELEMENT_POSITION;						\
	float UIMin = 0;													\
	float UIMax = 2;													\
	float UIStep = 1;													\
	int UIOrder = 500;													\
> = 0;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_COLOR int vertexElementColor	\
<																	\
	string UIGroup = HOG_GRP_ADV_PROPS;								\
	string UIFieldNames = "Auto:16:32:";							\
	string UIName = HOG_VERTEX_ELEMENT_COLOR;						\
	float UIMin = 0;												\
	float UIMax = 2;												\
	float UIStep = 1;												\
	int UIOrder = 501;												\
> = 0;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_UV int vertexElementUV	\
<															\
	string UIGroup = HOG_GRP_ADV_PROPS;						\
	string UIFieldNames = "Auto:16:32:";					\
	string UIName = HOG_VERTEX_ELEMENT_UV;					\
	float UIMin = 0;										\
	float UIMax = 2;										\
	float UIStep = 1;										\
	int UIOrder = 502;										\
> = 0;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_NORMAL int vertexElementNormal		\
<																		\
	string UIGroup = HOG_GRP_ADV_PROPS;									\
	string UIFieldNames = "Auto:16:32:";								\
	string UIName = HOG_VERTEX_ELEMENT_NORMAL;							\
	float UIMin = 0;													\
	float UIMax = 2;													\
	float UIStep = 1;													\
	int UIOrder = 503;													\
> = 0;									

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_BINORMAL int vertexElementBinormal		\
<																			\
	string UIGroup = HOG_GRP_ADV_PROPS;										\
	string UIFieldNames = "Auto:16:32:";									\
	string UIName = HOG_VERTEX_ELEMENT_BINORMAL;							\
	float UIMin = 0;														\
	float UIMax = 2;														\
	float UIStep = 1;														\
	int UIOrder = 504;														\
> = 0;

/**
@brief Macro to define 
*/
#define HOG_PROPERTY_VERTEX_ELEMENT_TANGENT int vertexElementTangent	\
<																		\
	string UIGroup = HOG_GRP_ADV_PROPS;									\
	string UIFieldNames = "Auto:16:32:";								\
	string UIName = HOG_VERTEX_ELEMENT_TANGENT;							\
	float UIMin = 0;													\
	float UIMax = 2;													\
	float UIStep = 1;													\
	int UIOrder = 505;													\
> = 0;	

// ---------------------------------------------
// string UIGroup = "Engine | Scene Preview"; UI 600+
// ---------------------------------------------
//#define HOG_GRP_ENGN_PREV "Engine | Scene Preview"

/**
@brief the gamma correct expoenent
*/
#define HOG_PROPERTY_GAMMA_CORRECTION_VALUE float gammaCorrectionValue	\
<																		\
	string UIGroup = HOG_GRP_ENGN_PREV;									\
	int UIOrder = 605;													\
> = 2.233333333f;														

/**
@brief the tone mapping bloom exponent
*/
#define HOG_PROPERTY_BLOOM_EXP float bloomExp							\
<																		\
	string UIGroup = HOG_GRP_ENGN_PREV;									\
	string UIName = HOG_GAMMA_BLOOM_EXP;								\
	string UIWidget = "Slider";											\
	float UIMin = 0.0;													\
	float UISoftMax = 3.0;												\
	float UIStep = 0.01;												\
	int UIOrder = 606;													\
> = 1.6f;																

/**
@brief Use the lights color value as the light/material specular color value
*/
#define HOG_PROPERTY_USE_LIGHT_COLOR_AS_LIGHT_SPECULAR_COLOR bool useLightColorAsLightSpecularColor		\
<																										\
string UIGroup = HOG_GRP_ENGN_PREV;																		\
string UIName = HOG_USE_LIGHT_COLOR_AS_LIGHT_SPECULAR_COLOR;											\
int UIOrder = 607;																						\
> = true;																								

/**
@brief turn on approximate tonemapping
@note: maya has it's own viewport tonemapping options, so turning this off
@note: this is for previewing your own tonemapping, if true turn mayas OFF in the viewport
*/
#define HOG_PROPERTY_USE_APPROX_TONE_MAPPING bool useApproxToneMapping					\
<																						\
string UIGroup = HOG_GRP_ENGN_PREV;														\
string UIName = HOG_USE_APPROX_TONE_MAPPING;											\
int UIOrder = 608;																		\
> = false;	

/**
@brief Gamma correct the shader [Debug]
*/
#define HOG_PROPERTY_GAMMA_CORRECT_SHADER bool useGammaCorrectShader	\
<																		\
string UIGroup = HOG_GRP_ENGN_PREV;										\
string UIName = HOG_GAMMA_CORRECT_SHADER;								\
int UIOrder = 609;														\
> = true;	

#endif // #ifndef _SHADER_PBR_FXH_