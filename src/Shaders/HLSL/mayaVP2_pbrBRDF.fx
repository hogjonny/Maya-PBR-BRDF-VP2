// shadertype=hlsl

#define PI 3.14159265358979323846f

static const float INV_PI = ( 1.0 / PI );

#define NumberOfMipMaps 0

#define _3DSMAX_SPIN_MAX 99999

#ifndef _MAYA_
    #define _3DSMAX_    // at time of writing this shader, Nitrous driver did not have the _3DSMAX_ define set
    #define _ZUP_       // Maya is Y up, 3dsMax is Z up
#endif

#ifdef _MAYA_
    #define _SUPPORTTESSELLATION_   // at time of writing this shader, 3dsMax did not support tessellation
#endif

//------------------------------------
// State
//------------------------------------
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
        SrcBlendAlpha = ONE;    // Required for hardware frame render alpha channel
        DestBlendAlpha = INV_SRC_ALPHA;
        BlendOpAlpha = ADD;
        RenderTargetWriteMask[0] = 0x0F;
    };
#endif

//------------------------------------
// Samplers
//------------------------------------
SamplerState CubeMapSampler
{
    Filter = ANISOTROPIC;
    AddressU = Clamp;
    AddressV = Clamp;
    AddressW = Clamp;    
};

SamplerState SamplerAnisoWrap
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState SamplerAnisoClamp
{
    Filter = ANISOTROPIC;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState SamplerShadowDepth
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Border;
    AddressV = Border;
    BorderColor = float4(1.0f, 1.0f, 1.0f, 1.0f);
};

SamplerState SamplerGradientWrap
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState SamplerRamp
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState PointSampler
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

SamplerState LinearSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

SamplerState BrdfSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    //Filter = ANISOTROPIC;
    AddressU  = Wrap;
    AddressV  = Wrap;
	AddressW  = Wrap;
};



//------------------------------------
// Textures
//------------------------------------

Texture2D AlbedoTexture
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Albedo Map";
    string ResourceType = "2D"; 
    int mipmaplevels = NumberOfMipMaps;
    int UIOrder = 001;
    int UVEditorOrder = 1;
>;

Texture2D NormalTexture
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Normal Map";
    string ResourceType = "2D";
    int mipmaplevels = 0;   // If mip maps exist in texture, Maya will load them. So user can pre-calculate and re-normalize mip maps for normal maps in .dds
    int UIOrder = 002;
    int UVEditorOrder = 2;
>;

Texture2D SpecularTexure
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Specular Texture";
    string ResourceType = "2D"; 
    int mipmaplevels = NumberOfMipMaps;
    int UIOrder = 003;
    int UVEditorOrder = 3;
>;

Texture2D RoughnessTexure
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Roughness Texture";
    string ResourceType = "2D"; 
    int mipmaplevels = NumberOfMipMaps;
    int UIOrder = 004;
    int UVEditorOrder = 4;
>;

Texture2D MetalnessTexure
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Metal Texture";
    string ResourceType = "2D"; 
    int mipmaplevels = NumberOfMipMaps;
    int UIOrder = 005;
    int UVEditorOrder = 5;
>;

Texture2D AmbOccTexure
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Ambient Occlusion Texture";
    string ResourceType = "2D"; 
    int mipmaplevels = NumberOfMipMaps;
    int UIOrder = 006;
    int UVEditorOrder = 6;
>;

Texture2D BrdfTexture
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "BRDF Map";
    string ResourceType = "2D";
    int mipmaplevels = 0;
    int UIOrder = 010;
>;

TextureCube DiffuseEnvTextureCube : environment
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Diffuse Refl [cube]";   // Note: do not rename to 'Reflection Cube Map'. This is named this way for backward compatibilty (resave after compat_maya_2013ff10.mel)
    string ResourceType = "Cube";
    int mipmaplevels = 0; // Use (or load) max number of mip map levels so we can use blurring
    int UIOrder = 011;
>;

TextureCube SpecularEnvTextureCube : Environment
<
    string UIGroup = "Texture Inputs";
    string ResourceName = "";
    string UIWidget = "FilePicker";
    string UIName = "Specualar IBL / Irradiance [cube]";
    string ResourceType = "Cube";   
    int mipmaplevels = 0; // Use (or load) max number of mip map levels so we can use blurring
    int UIOrder = 012;
>;

//------------------------------------
// Shadow Maps
//------------------------------------
Texture2D light0ShadowMap : SHADOWMAP
<
    string Object = "Light 0";  // UI Group for lights, auto-closed
    string UIWidget = "None";
    int UIOrder = 5010;
>;

Texture2D light1ShadowMap : SHADOWMAP
<
    string Object = "Light 1";
    string UIWidget = "None";
    int UIOrder = 5020;
>;

Texture2D light2ShadowMap : SHADOWMAP
<
    string Object = "Light 2";
    string UIWidget = "None";
    int UIOrder = 5030;
>;

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
// Per Frame parameters
//------------------------------------
cbuffer UpdatePerFrame : register(b0)
{
    float4x4 viewInv        : ViewInverse           < string UIWidget = "None"; >;   
    float4x4 view           : View                  < string UIWidget = "None"; >;
    float4x4 prj            : Projection            < string UIWidget = "None"; >;
    float4x4 viewPrj        : ViewProjection        < string UIWidget = "None"; >;

    // A shader may wish to do different actions when Maya is rendering the preview swatch (e.g. disable displacement)
    // This value will be true if Maya is rendering the swatch
    bool IsSwatchRender             : MayaSwatchRender      < string UIWidget = "None"; > = false;

    // If the user enables viewport gamma correction in Maya's global viewport rendering settings, the shader should not do gamma again
    bool MayaFullScreenGamma        : MayaGammaCorrection   < string UIWidget = "None"; > = false;
}

//------------------------------------
// Per Object parameters
//------------------------------------
cbuffer UpdatePerObject : register(b1)
{
    float4x4    World               : World                 < string UIWidget = "None"; >;
    float4x4    WorldView           : WorldView             < string UIWidget = "None"; >;
    float4x4    WorldIT             : WorldInverseTranspose < string UIWidget = "None"; >;
    float4x4    WorldViewProj       : WorldViewProjection   < string UIWidget = "None"; >;  //<-- may not need?

    //# variables go here...
    //# [type] [name] [min val] [max val] [default val]
    //::begin parameters
	
	int roughIsGloss
	<
		string UIGroup = "Base Properties";
		string UIWidget = "Slider";
		string UIFieldNames = "Roughness:Glossiness";
		string UIName = "Rough or Gloss?";
		int UIOrder = 0;
	> = 0;

    //color baseColor .82 .67 .16
    float3 baseColor
	<
		string UIGroup = "Base Properties"; 
	> = {0.82f, 0.67f, 0.16f};

    //float metalness 0 1 0
    float metalness
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float subsurface 0 1 0
    float subsurface
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float specular 0 1 .5
    float specular
	<
		string UIGroup = "Base Properties"; 
	>  = 0.5f;

    //float roughness 0 1 .5
    float roughness
	<
		string UIGroup = "Base Properties"; 
        string UIWidget = "Slider";
		string UIName = "Roughness | Gloss";
        float UIMin = 0.001;
        float UISoftMax = 1.000;
        float UIStep = 0.001;
	> = {0.500f};

    //float specularTint 0 1 0
    float specularTint
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float anisotropic 0 1 0
    float anisotropic
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float sheen 0 1 0
    float sheen
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float sheenTint 0 1 .5
    float sheenTint
	<
		string UIGroup = "Base Properties"; 
	>  = 0.5f;

    //float clearcoat 0 1 0
    float clearcoat
	<
		string UIGroup = "Base Properties"; 
	>  = 0.0f;

    //float clearcoatGloss 0 1 1
    float clearcoatGloss
	<
		string UIGroup = "Base Properties"; 
	>  = 1.0f;

    // My Parameters
    // new params for maps etc
    bool useAlbedoMap
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useNormalMap
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useSpecularMap
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useRoughnessMap
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useMetalnessMap
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useAmbOccMap
	<
		string UIGroup = "Texture Inputs";
	> = 0;

	// NEXT 2 NOT USED ... YET
    bool useSpecularRGB
	<
		string UIGroup = "Texture Inputs";
	> = 0;
    bool useSpecularMask
	<
		string UIGroup = "Texture Inputs";
	> = 0;

	// These are for ENV IBL
    bool useDiffuseENv
	<
		string UIGroup = "Texture Inputs";
	> = 1;
    bool useSpecularEnv
	<
		string UIGroup = "Texture Inputs";
	> = 1;

    //::end parameters

    // ---------------------------------------------
    // string UIGroup = "Normal | Specular"; UI 200+
    // ---------------------------------------------
    int NormalCoordsysX
    <                                              
        string UIGroup = "Normal Group";           
        string UIFieldNames = "Positive:Negative";      
        string UIName = "Normal X (Red) [*]";       
        int UIOrder = 207;                              
    > = 0;

    int NormalCoordsysY      
    <                                                   
        string UIGroup = "Normal Group";           
        string UIFieldNames = "Positive:Negative";      
        string UIName = "Normal Y (Green) [*]"; 
        int UIOrder = 208;                              
    > = 0;

    int NormalCoordsysZ      
    <                                                   
        string UIGroup = "Normal Group";           
        string UIFieldNames = "Positive:Negative";      
        string UIName = "Normal Z (Blue) [*]";  
        int UIOrder = 209;                              
    > = 0;


    // more of my parameters	

    float3 AmbientSkyColor : Ambient
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Ambient Sky Color";
        string UIWidget = "ColorPicker";
        int UIOrder = 104;
    > = {0.0f, 1.0f, 1.0f };

    float3 AmbientGroundColor : Ambient
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Ambient Ground Color";
        string UIWidget = "ColorPicker";
        int UIOrder = 105;
    > = {0.087f, 0.064f, 0.032f };

    float AmbientLightIntensity
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Ambient Light Intensity";
        string UIWidget = "Slider";
        float UIMin = 0.000;
        float UIMax = 100.000;
        float UIStep = 0.001;
        int UIOrder = 106;
    > = {0.100f};

    // My Parameters

    float envLightingExp
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.001;
        float UISoftMax = 100.000;
        float UIStep = 0.001;
        string UIName = "Env Lighting Exposure";
        int UIOrder = 40;
    > = {5.0f};
	
	bool linearVertexColor
	<
		string UIGroup = "Material Properties | Lighting (Reflectance)";
		string UIName = "Linear Space Vertex Color";
		int UIOrder = 41;
	> = false;
	
	bool useVertexColorAO
	<
		string UIGroup = "Material Properties | Lighting (Reflectance)";
		string UIName = "Use Vertex AO";
		int UIOrder = 42;
	> = false;	

    bool linearSpaceLighting
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Linear Space Lighting";
        int UIOrder = 50;
    > = true;

    bool UseShadows
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Shadows";
        int UIOrder = 51;
    > = true;

    float shadowMultiplier
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.000;
        float UIMax = 1.000;
        float UIStep = 0.001;
        string UIName = "Shadow Strength";
        int UIOrder = 52;
    > = {1.0f};

    // This offset allows you to fix any in-correct self shadowing caused by limited precision.
    // This tends to get affected by scene scale and polygon count of the objects involved.
    float shadowDepthBias : ShadowMapBias
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.000;
        float UISoftMax = 10.000;
        float UIStep = 0.001;
        string UIName = "Shadow Bias";
        int UIOrder = 53;
    > = {0.01f};

    // flips back facing normals to improve lighting for things like sheets of hair or leaves
    bool flipBackfaceNormals
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Double Sided Lighting";
        int UIOrder = 54;
    > = true;
    
    bool UseToneMapping
    <
        string UIGroup = "Lighting and Ouptut";
        string UIName = "Use Basic Tone Mapping";
        int UIOrder = 56;
    > = true;

    float globalTonemap
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.0;
        float UISoftMax = 1.0;
        float UIStep = 0.01;
        string UIName = "Tone Mapping Amount";
        int UIOrder = 57;
    > = 1.0;

    float exposure
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UISoftMin = -10.0;
        float UISoftMax = 10.0;
        float UIStep = 0.1;
        string UIName = "Exposure";
        int UIOrder = 58;
    > = 1.0;

    float Opacity : OPACITY
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.0;
        float UIMax = 1.0;
        float UIStep = 0.001;
        string UIName = "Opacity";
        int UIOrder = 300;
    > = 1.0;

    // at what value do we clip away pixels
    float OpacityMaskBias
    <
        string UIGroup = "Lighting and Ouptut";
        string UIWidget = "Slider";
        float UIMin = 0.0;
        float UIMax = 1.0;
        float UIStep = 0.001;
        string UIName = "Opacity Mask Bias";
        int UIOrder = 302;
    > = 0.5;

    bool SupportNonUniformScale
    <
        string UIGroup = "Normal Group";
        string UIName = "Support Non-Uniform Scale";
        int UIOrder = 201;
    > = true;                                           

    float gammaCorrectionValue
    <
        string UIGroup = "Lighting and Ouptut";
        int UIOrder = 601;
    > = 2.233333333f;
}

//::begin shader

//------------------------------------
// Light parameters
//------------------------------------
cbuffer UpdateLights : register(b2)
{
    // ---------------------------------------------
    // Light 0 GROUP
    // ---------------------------------------------
    // This value is controlled by Maya to tell us if a light should be calculated
    // For example the artist may disable a light in the scene, or choose to see only the selected light
    // This flag allows Maya to tell our shader not to contribute this light into the lighting
    bool light0Enable : LIGHTENABLE
        <
        string Object = "Light 0";  // UI Group for lights, auto-closed
        string UIName = "Enable Light 0";
        int UIOrder = 20;
    #ifdef _MAYA_
        > = false;  // maya manages lights itself and defaults to no lights
    #else
        > = true;   // in 3dsMax we should have the default light enabled
    #endif

    // follows LightParameterInfo::ELightType
    // spot = 2, point = 3, directional = 4, ambient = 5,
    int light0Type : LIGHTTYPE
    <
        string Object = "Light 0";
        string UIName = "Light 0 Type";
        string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
        int UIOrder = 21;
    > = 2;  // default to spot so the cone angle etc work when "Use Shader Settings" option is used

    float3 light0Pos : POSITION 
    < 
        string Object = "Light 0";
        string UIName = "Light 0 Position"; 
        string Space = "World"; 
        int UIOrder = 22;
    > = {100.0f, 100.0f, 100.0f}; 

    float3 light0Color : LIGHTCOLOR 
    <
        string Object = "Light 0";
        string UIName = "Light 0 Color"; 
        string UIWidget = "Color"; 
        int UIOrder = 23;
    > = { 1.0f, 1.0f, 1.0f};

    float light0Intensity : LIGHTINTENSITY 
    <
        string Object = "Light 0";
        string UIName = "Light 0 Intensity"; 
        int UIOrder = 24;
    > = { 1.0f };

    float3 light0Dir : DIRECTION 
    < 
        string Object = "Light 0";
        string UIName = "Light 0 Direction"; 
        string Space = "World"; 
        int UIOrder = 25;
    > = {100.0f, 100.0f, 100.0f}; 

    float light0ConeAngle : HOTSPOT // In radians
    <
        string Object = "Light 0";
        string UIName = "Light 0 Cone Angle"; 
        float UIMin = 0;
        float UIMax = PI/2;
        int UIOrder = 26;
    > = { 0.46f };

    float light0FallOff : FALLOFF // In radians. Should be HIGHER then cone angle or lighted area will invert
    <
        string Object = "Light 0";
        string UIName = "Light 0 Penumbra Angle"; 
        float UIMin = 0;
        float UIMax = PI/2;
        int UIOrder = 27;
    > = { 0.7f };

    float light0AttenScale : DECAYRATE
    <
        string Object = "Light 0";
        string UIName = "Light 0 Decay";
        int UIOrder = 28;
    > = {0.0};

    bool light0ShadowOn : SHADOWFLAG
    <
        string Object = "Light 0";
        string UIName = "Light 0 Casts Shadow";
        string UIWidget = "None";
        int UIOrder = 29;
    > = true;

    float4x4 light0Matrix : SHADOWMAPMATRIX     
    < 
        string Object = "Light 0";
        string UIWidget = "None"; 
    >;
} //end lights cbuffer

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
	string UIFieldNames = "none:NdotL:clampNdotL:NdotV:H:NdotH:LdotH:VdotH:vis";
	string UIName = "DEBUG VIEW";
	int UIOrder = 0;
> = 0;

//------------------------------------
// Structs
//------------------------------------
/**
@struct VsInput
@brief Input to the vertex unit from the vertex assembly unit
*/
struct vsInput
{
    float3 m_Position       : POSITION0;
    float4 m_VertColor      : COLOR0;

    float2 m_UV0            : TEXCOORD0;

    float3 m_Normal         : NORMAL;
    float3 m_Binormal       : BINORMAL;
    float3 m_Tangent        : TANGENT;
};

/**
@struct VsOutput
@brief Output from the vertex unit to later stages of GPU execution
*/
struct VsOutput 
{
    float4      m_position       : SV_POSITION;
    float4      m_vertColor      : COLOR;
    
    float2      m_uv0            : TEXCOORD0;

    float3      m_worldNormal      : NORMAL;
    float4      m_worldTangent     : TANGENT; 
    float3      m_worldPosition    : TEXCOORD3_centroid;

    //float3      m_normal         : NORMAL;
    //float3      m_binormal       : BINORMAL;
    //float3      m_tangent        : TANGENT;

    float4      m_view           : TEXCOORD4_centroid;

    float3x3    m_TWMtx          : TEXCOORD5_centroid;

    //float3x3    m_tangentToWorld : TEXCOORD6;

    //float3x3    m_tangentToWorld : TEXCOORD4;

};

//------------------------------------
// vertex shader 
//------------------------------------
VsOutput vsMain(vsInput vIN) 
{
    VsOutput OUT = (VsOutput)0;

    OUT.m_position = mul(float4(vIN.m_Position, 1), WorldViewProj);

    // we pass vertices in world space
    OUT.m_worldPosition = mul(float4(vIN.m_Position, 1), World);

	//Interpolate and ouput vertex color
	OUT.m_vertColor.rgb = vIN.m_VertColor.rgb;
	OUT.m_vertColor.w = vIN.m_VertColor.w;

	// setup Gamma
	float gammaCexp = linearSpaceLighting ? gammaCorrectionValue : 1.0;

	OUT.m_vertColor.rgb = linearVertexColor ? pow(vIN.m_VertColor.rgb, gammaCexp) : OUT.m_vertColor.rgb;

    // Pass through texture coordinates
    // flip Y for Maya
    #ifdef _MAYA_
        OUT.m_uv0 = float2(vIN.m_UV0.x, (1.0 - vIN.m_UV0.y));
    #else
        OUT.m_uv0 = vIN.m_UV0;
    #endif

    // output normals in world space:
    if (!SupportNonUniformScale)
        OUT.m_worldNormal = normalize(mul(vIN.m_Normal, (float3x3)World));
    else
        OUT.m_worldNormal = normalize(mul(vIN.m_Normal, (float3x3)WorldIT));

    // output tangent in world space:
    if (!SupportNonUniformScale)
        OUT.m_worldTangent.xyz = normalize( mul(vIN.m_Tangent, (float3x3)World) );
    else
        OUT.m_worldTangent.xyz = normalize( mul(vIN.m_Tangent, (float3x3)WorldIT) );

    // store direction for normal map:
    OUT.m_worldTangent.w = 1;
    if (dot(cross(vIN.m_Normal.xyz, vIN.m_Tangent.xyz), vIN.m_Binormal.xyz) < 0.0) OUT.m_worldTangent.w = -1;

    // Build the view vector and cache it's length in W
    // pulling the view position in world space from the inverse view matrix 4th row
    OUT.m_view.xyz = viewInv[3].xyz - OUT.m_worldPosition.xyz;
    OUT.m_view.w = length(OUT.m_view.xyz);
    OUT.m_view.xyz *= rcp(OUT.m_view.w);

    //OUT.m_tangent = vIN.m_Tangent;
    //OUT.m_binormal = vIN.m_Binormal;
    //OUT.m_normal = vIN.m_Normal;

    // Compose the tangent space to local space matrix
    float3x3 tLocal;
    tLocal[0] = vIN.m_Tangent;
    tLocal[1] = vIN.m_Binormal;
    tLocal[2] = vIN.m_Normal;

    // Calculate the tangent to world space matrix
    OUT.m_TWMtx = mul(tLocal, (float3x3)World); 

    // Calculate tangent space to world space matrix using the world space tanget, binormal and normal as basis vector.
    //OUT.m_tangentToWorld[0] = vIN.m_Tangent;
    //OUT.m_tangentToWorld[1] = vIN.m_Binormal;
    //OUT.m_tangentToWorld[2] = vIN.m_Normal;

    return OUT;
}

#define SHADOW_FILTER_TAPS_CNT 10
float2 SuperFilterTaps[SHADOW_FILTER_TAPS_CNT]
<
string UIWidget = "None";
> =
{
    { -0.84052f, -0.073954f },
    { -0.326235f, -0.40583f },
    { -0.698464f, 0.457259f },
    { -0.203356f, 0.6205847f },
    { 0.96345f, -0.194353f },
    { 0.473434f, -0.480026f },
    { 0.519454f, 0.767034f },
    { 0.185461f, -0.8945231f },
    { 0.507351f, 0.064963f },
    { -0.321932f, 0.5954349f }
};

float shadowMapTexelSize
<
	string UIWidget = "None";
> = { 0.00195313 }; // (1.0f / 512)

/**
@struct PsOutput
@brief Output that written to the render target
*/
struct PsOutput  // was APPDATA
{
	float4 m_Color			: SV_TARGET;
};

// Calculate a light:
struct lightOutD
{
    float   Specular;
    float3  Color;
};

// Calculate a light:
struct lightOutCT
{
    float   Specular;
    float3  Color;
};

//------------------------------------
// external includes
//------------------------------------
#include "functions_structs.fxh"
//#include "cookTorranceBRDF.fxh"
#include "bigdBRDF.fxh"

float3 RGBMDecode ( float4 rgbm, float hdrExp, float gammaExp ) 
{
    float3 upackRGBhdr = (rgbm.bgr * rgbm.a) * hdrExp;
    float3 rgbLin = pow(upackRGBhdr.rgb, gammaExp);
    return rgbLin;
}


//------------------------------------
// pixel shader
//------------------------------------
float4 pMain(VsOutput pIN, bool FrontFace : SV_IsFrontFace) : SV_Target
{  
	//PsOutput o;
	      
    // setup Gamma
    float gammaCorrectExp = linearSpaceLighting ? gammaCorrectionValue : 1.0;

    // Opacity:
    float opacity = saturate(Opacity);

    // Set up view
    //float3 V = pIN.m_view.xyz;  <-- This gives a BAD view vector!!!
    float3  V = normalize(viewInv[3].xyz - pIN.m_worldPosition.xyz);

    //Base Normals
    float3 N = pIN.m_worldNormal.xyz;

    // set up additional normals, tangent, binormals
    float3 Nw = N;
    // Tangent and BiNormal:
    float3 T = normalize(pIN.m_worldTangent.xyz);
    float3 Bn = cross(N, T); 
    Bn *= pIN.m_worldTangent.w;
    float3x3 toWorld = float3x3(T, Bn, N);

    // Normal setup
    if (flipBackfaceNormals)
    {
        N = lerp(-N, N, FrontFace);
    }

    if (useNormalMap)
    {
        // load the normal map
        float3 n = NormalTexture.Sample(SamplerAnisoWrap, pIN.m_uv0).xyz * 2.0f - 1.0f;

        // DEBUG controls for flipping any normal component in Maya
        // (needed to figure out proper directions for X|Y)
        // PLEASE leave for now
        if (NormalCoordsysX > 0)
            n.x = -n.x;
        if (NormalCoordsysY > 0)
            n.y = -n.y;
        if (NormalCoordsysZ > 0)
            n.z = -n.z;

        // Transform the normal into world space where the light data is
        //N = normalize(mul(n, pIN.m_TWMtx));  // replace the geom normals
        N = normalize(mul(n, toWorld));  // replace the geom normals
    }

    // ambient dome
    float3 ambGroundColor = pow(AmbientGroundColor.rgb, gammaCorrectExp);
    float3 ambSkyColor = pow(AmbientSkyColor.rgb, gammaCorrectExp);
    #ifndef _ZUP_
        float ambientUpAxis = N.y;
    #else
        float ambientUpAxis = N.z;
    #endif
    float3 ambDomeColor = ( lerp(ambGroundColor.rgb, ambSkyColor.rgb, saturate((ambientUpAxis * 0.5) + 0.5)) );

    // make sRGB colors linear
    float3 albedo = pow(baseColor.rgb, gammaCorrectExp);
    if (useAlbedoMap)
    {
        float3 cBaseMap = AlbedoTexture.Sample(SamplerAnisoWrap, pIN.m_uv0).rgb;
        albedo = pow(cBaseMap.rgb, gammaCorrectExp);
    }

    // specular RGB and Mask (alpha)
    float specA = specular;
    if (useSpecularMap)
    {
        float4 specMap = SpecularTexure.Sample(SamplerAnisoWrap, pIN.m_uv0).rgba;
        specA = specMap.x;

        if (useSpecularRGB) float3 sColor = pow(specMap.rgb, gammaCorrectExp).rgb;
        if (useSpecularMask) specA = specMap.a;
    }

    float roughA = roughness;
    if (useRoughnessMap)
    {
		
		roughA = RoughnessTexure.Sample(SamplerAnisoWrap, pIN.m_uv0).g;
		roughA = roughIsGloss ? roughA : 1.0f - roughA;
    }

    float metalA = metalness;
    if (useMetalnessMap)
    {
        metalA = MetalnessTexure.Sample(SamplerAnisoWrap, pIN.m_uv0).g;
    }

    float3 ambOcc = float3(1.0f,1.0f,1.0f);
    if (useAmbOccMap)
    {
        ambOcc = AmbOccTexure.Sample(SamplerAnisoWrap, pIN.m_uv0).rgb;
    }

	if (useVertexColorAO)
	{
		ambOcc *= pIN.m_vertColor.rgb;
	}
    
    // cheap ambient
    //float3 ambientColor = ( lerp(ambGroundColor.rgb, ambSkyColor.rgb, saturate((ambientUpAxis * 0.5) + 0.5)) );
    // physical ambient
    //vec3 dBRDF( vec3 L, vec3 V, vec3 N, vec3 X, vec3 Y, albedo, specAmount, roughnessAmount, metalnessAmount )
    lightOutD ambientDomeLight = dBRDF(N, V, N, T, Bn, albedo, specA, roughA, metalA);

    // START Light 0
    float3 L = light0Pos - pIN.m_worldPosition.xyz;
    float D = length(L);
    float ood = rcp(D);
	L *= ood;

	// calc attenuation
    bool enableAttenuation = light0AttenScale > 0.0001f;
    float attenuation = 1.0f;  // directional lights have no attenuation
    attenuation = lerp(1.0, 1 / pow(D, light0AttenScale), enableAttenuation);

	// Light 0
	float3 light0Clin = pow(light0Color.rgb, gammaCorrectExp);
	lightOutD light0 = dBRDF(L, V, N, T, Bn, albedo, specA, roughA, metalA);
	float3 light0Total = (light0.Color + ( light0.Specular * specA) ) * light0Clin * light0Intensity * attenuation;

	// Smbient Dome
	// physically based ambient has no specular and no attenuation
    float3 ambTotal = ambientDomeLight.Color * ambDomeColor * AmbientLightIntensity;
	
    // Env
	// env maps set up
	const float rMipCount = 8.0f;
	float roughMip = roughA * rMipCount;
	//float roughMip = roughA + rMipCount;

	float3 diffEnv = (0.0f, 0.0f, 0.0f);
	float3 diffEnvLin = (0.0f, 0.0f, 0.0f);
	if (useDiffuseENv)
	{
		//float4 diffEnvMap = DiffuseEnvTextureCube.SampleLevel(CubeMapSampler, reflection, 0.0f).rgba;
		float4 diffEnvMap = DiffuseEnvTextureCube.SampleLevel(CubeMapSampler, N, 0.0f).rgba;
		diffEnvLin = RGBMDecode(diffEnvMap, envLightingExp, gammaCorrectExp).rgb;  // decode to HDR
		//diffEnvLin = pow(diffEnvMap.rgb, gammaCorrectExp) / PI;  // make values linear
		diffEnv = albedo * (1.0 - metalA) * (diffEnvLin);
	}

    float3 specEnvLin = (0.0f, 0.0f, 0.0f);
	float3 specEnv = (0.0f, 0.0f, 0.0f);
    float3 Cspec = (0.0f, 0.0f, 0.0f);

    // Normal dependent terms.
    float  NdotV = - saturate(dot( V, N ));
    float3 reflection = reflect( V, N );

	if (useSpecularEnv)
	{

		//float3 Cdlin = albedo.rgb; // pass in color already converted to linear
		//float Cdlum = 0.3f * Cdlin[0] + 0.6f * Cdlin[1] + 0.1f * Cdlin[2]; // luminance approx.
		//float3 Ctint = Cdlum > 0.0f ? Cdlin/Cdlum : 1.0f.xxx; // normalize lum. to isolate hue+sat
		//float3 Cspec0 = lerp(SpecA * 0.08f * lerp(1.0f.xxx, Ctint, specularTint), Cdlin, metalA);

		const float3 dielectricColor  = float3(0.04f, 0.04f, 0.04f);

		float3 brdfMap = BrdfTexture.Sample(BrdfSampler, float2(NdotV, roughA), 0.0f).xyz;

		float4 specEnvMap = SpecularEnvTextureCube.SampleLevel(CubeMapSampler, -reflection, roughMip).rgba;
		specEnvLin = RGBMDecode(specEnvMap, envLightingExp, gammaCorrectExp);  // decode to HDR
		//specEnvLin = pow(specEnvMap.rgb, gammaCorrectExp);  // make values linear
	
		// Hack version to decrease fresnel the more metal a meterial is.
		//specEnv = lerp(dielectricColor, albedo, metalA) * brdfMap.x + (brdfMap.y*(clamp(1.0-metalA, 0.04f, 1.0f)));
		Cspec = lerp(dielectricColor, albedo, metalA) * brdfMap.x + brdfMap.y;
		specEnv = (specEnvLin.rgb) * Cspec.rgb * specA;
	}
	
    // ----------------------
    // FINAL COLOR AND ALPHA:
    // ----------------------
    //float3 result = ambientColor * AmbientLightIntensity * opacity;

    // final alpha:
    float transperancy = opacity;

    float3 result = light0Total + ( (ambTotal + diffEnv + specEnv) * ambOcc);

	
	//result = diffEnvLin;
	//result = diffEnv;
	//result = specEnvLin;
    //result = Cspec;
    
    //float4 foo = SpecularEnvTextureCube.SampleLevel(CubeMapSampler, -reflection, roughMip).rgba;
    //float4 foo = SpecularEnvTextureCube.SampleLevel(CubeMapSampler, reflection, 0.0f).bgra;
    //float3 fool = foo.rgb * foo.aaa;
    //result = fool;

	//result = specEnv;

    // do gamma correction in shader:
    if (!MayaFullScreenGamma)
        result = pow(result, 1 / gammaCorrectExp);

    // User adjusted tone mapping
    if (UseToneMapping)
        result = lerp(result*pow(2, exposure), filmicTonemap(result*pow(2, exposure)), globalTonemap);

	// Debug views
#ifdef _MAYA_
	if (g_DebugMode > 0)
	{
		// dBRDF(float3 L, float3 V, float3 N, float3 X, float3 Y, float3 Albedo)
		//  dBRDF(L, V, N, IN.tangentToWorld[0], IN.tangentToWorld[1], albedo);

		float NdotL = dot( N, L );
		float clampNdotL = max( NdotL , 0.000000f );

		float NdotV = dot( N, V );
		float3 H = normalize( L + V );
		float NdotH = dot( N, H );
		float LdotH = dot( L, H );
		float VdotH  = dot( V, H );

		// calc visability term
		float a = max(0.001f, roughness * roughness);
		float k = a / 2.0f;
		float vis = G1V(NdotL, k) * G1V(NdotV, k);
		
		// "none:NdotL:clampNdotL:NdotV:H:NdotH:LdotH:VdotH:vis"
		if (g_DebugMode == 1)
		{
			result = NdotL.xxx;
		}
		if (g_DebugMode == 2)
		{
			result = clampNdotL.xxx;
		}
		if (g_DebugMode == 3)
		{
			result = NdotV.xxx;
		}
		if (g_DebugMode == 4)
		{
			result = H.xxx;
		}
		if (g_DebugMode == 5)
		{
			result = NdotH.xxx;
		}
		if (g_DebugMode == 6)
		{
			result = LdotH.xxx;
		}
		if (g_DebugMode == 7)
		{
			result = VdotH.xxx;
		}
		if (g_DebugMode == 8)
		{
			result = vis.xxx;
		}
	
	}
#endif

	// REAL return out...
	//o.m_Color = float4(result.rgb, transperancy);
	//return o;

	return float4(result.rgb, transperancy);
}

#ifdef _MAYA_

    void Peel(VsOutput IN)
    {
        float currZ = abs(mul(IN.m_worldPosition, view).z);
        float4 Pndc = mul(IN.m_worldPosition, viewPrj);
        float2 UV = Pndc.xy / Pndc.w * float2(0.5f, -0.5f) + 0.5f;
        float prevZ = transpDepthTexture.Sample(SamplerShadowDepth, UV).r;
        float opaqZ = opaqueDepthTexture.Sample(SamplerShadowDepth, UV).r;
        float bias = 0.00002f;
        if (currZ < prevZ * (1.0f + bias) || currZ > opaqZ * (1.0f - bias))
        {
            discard;
        }
    }

    float4 LinearDepth(VsOutput IN)
    {
        return abs(mul(IN.m_worldPosition, view).z);
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

    MultiOut2 fTransparentPeel(VsOutput IN, bool FrontFace : SV_IsFrontFace)
    {
        Peel(IN);

        MultiOut2 OUT;
        OUT.target0 = pMain(IN, FrontFace);
        OUT.target1 = LinearDepth(IN);
        return OUT;
    }

    MultiOut2 fTransparentPeelAndAvg(VsOutput IN, bool FrontFace : SV_IsFrontFace)
    {
        Peel(IN);

        MultiOut2 OUT;
        OUT.target0 = pMain(IN, FrontFace);
        OUT.target1 = DepthComplexity(OUT.target0.w);
        return OUT;
    }

    MultiOut2 fTransparentWeightedAvg(VsOutput IN, bool FrontFace : SV_IsFrontFace)
    {
        MultiOut2 OUT;
        OUT.target0 = pMain(IN, FrontFace);
        OUT.target1 = DepthComplexity(OUT.target0.w);
        return OUT;
    }

    //------------------------------------
    // wireframe pixel shader
    //------------------------------------
    float4 fwire(VsOutput IN) : SV_Target
    {
        return float4(0,0,1,1);
    }


    //------------------------------------
    // pixel shader for shadow map generation
    //------------------------------------
    //float4 ShadowMapPS( float3 Pw, float4x4 shadowViewProj ) 
    float4 ShadowMapPS(VsOutput IN) : SV_Target
    { 
        // clip as early as possible
        //float2 opacityMaskUV = pickTexcoord(OpacityMaskTexcoord, IN.texCoord0, IN.texCoord1, IN.texCoord2);
        //OpacityMaskClip(opacityMaskUV);
        //OpacityMaskClip(IN.m_uv0);

        float4 Pndc = mul(IN.m_worldPosition, viewPrj);

        // divide Z and W component from clip space vertex position to get final depth per pixel
        float retZ = Pndc.z / Pndc.w; 

        retZ += fwidth(retZ); 
        return retZ.xxxx; 
    } 
#endif

//-----------------------------------
// Objects without tessellation
//------------------------------------
technique11 brdfShader
<
    bool overridesDrawState = false;
    int isTransparent = 3;
    string transparencyTest = "Opacity < 1.0";

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
    pass p0  // color and lighting
    < 
        string drawContext = "colorPass";   // tell maya during what draw context this shader should be active, in this case 'Color'
    >
    {
        // even though overrideDrawState is false, we still set the pre-multiplied alpha state here in
        // case Maya is using 'Depth Peeling' transparency algorithm
        // This unfortunately won't solve sorting issues, but at least our object can draw transparent.
        // If we don't set this, the object will always be opaque.
        // In the future, hopefully ShaderOverride nodes can participate properly in Maya's Depth Peeling setup
        #ifdef _MAYA_
            SetBlendState(PMAlphaBlending, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        #endif
        SetVertexShader(CompileShader(vs_5_0, vsMain()));
        //SetHullShader(NULL);
        //SetDomainShader(NULL);
        //SetGeometryShader(NULL);
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
        //SetHullShader(NULL);
        //SetDomainShader(NULL);
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, fTransparentPeel()));
    }

    pass pTransparentPeelAndAvg
        <
        // Weighted-average pass for depth-peeling transparency algorithm.
        string drawContext = "transparentPeelAndAvg";
        >
    {
        SetVertexShader(CompileShader(vs_5_0, vsMain()));
        //SetHullShader(NULL);
        //SetDomainShader(NULL);
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, fTransparentPeelAndAvg()));
    }

    pass pTransparentWeightedAvg
        <
        // Weighted-average algorithm. No peeling.
        string drawContext = "transparentWeightedAvg";
        >
    {
        SetVertexShader(CompileShader(vs_5_0, vsMain()));
        //SetHullShader(NULL);
        //SetDomainShader(NULL);
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, fTransparentWeightedAvg()));
    }

    pass pShadow
        < 
            string drawContext = "shadowPass";  // shadow pass
        >
        {
            SetVertexShader(CompileShader(vs_5_0, vsMain()));
            SetHullShader(NULL);
            SetDomainShader(NULL);
            SetGeometryShader(NULL);
            SetPixelShader(CompileShader(ps_5_0, ShadowMapPS()));
        }
    #endif
}