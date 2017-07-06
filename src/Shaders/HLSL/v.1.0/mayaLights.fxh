// shadertype=hlsl

#ifndef _MAYALIGHTS_FXH_
#define _MAYALIGHTS_FXH_

static const float PI = 3.14159265358979323846f;
static const float INV_PI = ( 1.0 / PI );
static const float halfPI = PI/2;

//------------------------------------
// Shadow Maps; UI 5000+
//------------------------------------
Texture2D light0ShadowMap : SHADOWMAP
<
	string Object = "Light 0";	// UI Group for lights, auto-closed
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

Texture2D light3ShadowMap : SHADOWMAP
<
string Object = "Light 3";
string UIWidget = "None";
int UIOrder = 5040;
>;


//------------------------------------
// Light Constants Buffer  :  UI 900+
//------------------------------------
cbuffer UpdateLights : register(b2)
{
	// ---------------------------------------------
	// Light 0 GROUP : UI 900+
	// ---------------------------------------------
	// This value is controlled by Maya to tell us if a light should be calculated
	// For example the artist may disable a light in the scene, or choose to see only the selected light
	// This flag allows Maya to tell our shader not to contribute this light into the lighting
	bool light0Enable : LIGHTENABLE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";	// UI Group for lights, auto-closed
		string UIName = "Enable Light 0";
		int UIOrder = 900;
	#ifdef _MAYA_
		> = false;	// maya manages lights itself and defaults to no lights
	#else
		> = true;	// in 3dsMax we should have the default light enabled
	#endif

	// follows LightParameterInfo::ELightType
	// spot = 2, point = 3, directional = 4, ambient = 5,
	int light0Type : LIGHTTYPE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";
		string UIName = "Light 0 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		int UIOrder = 901;
		float UIMin = 0;
		float UIMax = 5;
		float UIStep = 1;
	> = 2;	// default to spot so the cone angle etc work when "Use Shader Settings" option is used

	float3 light0Pos : POSITION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 0";
		string UIName = "Light 0 Position"; 
		string Space = "World"; 
		int UIOrder = 902;
		int RefID = 0; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	float3 light0Color : LIGHTCOLOR 
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 903;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light0Intensity : LIGHTINTENSITY 
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 0";
			string UIName = "Light 0 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 904;
		#endif
	> = { 1.0f };

	float3 light0Dir : DIRECTION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 0";
		string UIName = "Light 0 Direction"; 
		string Space = "World"; 
		int UIOrder = 905;
		int RefID = 0; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light0ConeAngle : HOTSPOT // In radians
	#else
		float light0ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Cone Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 906;
		#endif
	> = { 0.46f };

	#ifdef _MAYA_
		float light0FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light0FallOff : LIGHTFALLOFF
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 907;
		#endif
	> = { 0.7f };

	float light0AttenScale : DECAYRATE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 0";
		string UIName = "Light 0 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 908;
	> = {0.0};

	bool light0ShadowOn : SHADOWFLAG
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 0";
			string UIName = "Light 0 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 909;
		#endif
	> = true;

	float4x4 light0Matrix : SHADOWMAPMATRIX		
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 0";
		string UIWidget = "None"; 
	>;


	// ---------------------------------------------
	// Light 1 GROUP  : UI 920+
	// ---------------------------------------------
	bool light1Enable : LIGHTENABLE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		string UIName = "Enable Light 1";
		int UIOrder = 920;
	> = false;

	int light1Type : LIGHTTYPE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		string UIName = "Light 1 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 921;
	> = 2;

	float3 light1Pos : POSITION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 1";
		string UIName = "Light 1 Position"; 
		string Space = "World"; 
		int UIOrder = 922;
		int RefID = 1; // 3DSMAX
	> = {-100.0f, 100.0f, 100.0f}; 

	float3 light1Color : LIGHTCOLOR 
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 923;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light1Intensity : LIGHTINTENSITY 
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 1";
			string UIName = "Light 1 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 924;
		#endif
	> = { 1.0f };

	float3 light1Dir : DIRECTION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 1";
		string UIName = "Light 1 Direction"; 
		string Space = "World"; 
		int UIOrder = 925;
		int RefID = 1; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light1ConeAngle : HOTSPOT // In radians
	#else
		float light1ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Cone Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 926;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light1FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light1FallOff : LIGHTFALLOFF
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 927;
		#endif
	> = { 0.0f };

	float light1AttenScale : DECAYRATE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 1";
		string UIName = "Light 1 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 928;
	> = {0.0};

	bool light1ShadowOn : SHADOWFLAG
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 1";
			string UIName = "Light 1 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 929;
		#endif
	> = true;

	float4x4 light1Matrix : SHADOWMAPMATRIX		
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 1";
		string UIWidget = "None"; 
	>;


	// ---------------------------------------------
	// Light 2 GROUP  : 940+
	// ---------------------------------------------
	bool light2Enable : LIGHTENABLE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		string UIName = "Enable Light 2";
		int UIOrder = 940;
	> = false;

	int light2Type : LIGHTTYPE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		string UIName = "Light 2 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 941;
	> = 2;

	float3 light2Pos : POSITION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 2";
		string UIName = "Light 2 Position"; 
		string Space = "World"; 
		int UIOrder = 942;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, -100.0f}; 

	float3 light2Color : LIGHTCOLOR 
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 943;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light2Intensity : LIGHTINTENSITY 
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 2";
			string UIName = "Light 2 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 944;
		#endif
	> = { 1.0f };

	float3 light2Dir : DIRECTION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 2";
		string UIName = "Light 2 Direction"; 
		string Space = "World"; 
		int UIOrder = 945;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light2ConeAngle : HOTSPOT // In radians
	#else
		float light2ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Cone Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 946;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light2FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light2FallOff : LIGHTFALLOFF
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 947;
		#endif
	> = { 0.0f };

	float light2AttenScale : DECAYRATE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 2";
		string UIName = "Light 2 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 948;
	> = {0.0};

	bool light2ShadowOn : SHADOWFLAG
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 2";
			string UIName = "Light 2 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 949;
		#endif
	> = true;

	float4x4 light2Matrix : SHADOWMAPMATRIX		
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 2";
		string UIWidget = "None"; 
	>;


	// ---------------------------------------------
	// Light 3 GROUP  : 960+
	// ---------------------------------------------
	bool light3Enable : LIGHTENABLE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		string UIName = "Enable Light 3";
		int UIOrder = 960;
	> = false;

	int light3Type : LIGHTTYPE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		string UIName = "Light 3 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 961;
	> = 2;

	float3 light3Pos : POSITION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 3";
		string UIName = "Light 3 Position"; 
		string Space = "World"; 
		int UIOrder = 962;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, -100.0f}; 

	float3 light3Color : LIGHTCOLOR 
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 963;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light3Intensity : LIGHTINTENSITY 
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 3";
			string UIName = "Light 3 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 964;
		#endif
	> = { 1.0f };

	float3 light3Dir : DIRECTION 
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 3";
		string UIName = "Light 3 Direction"; 
		string Space = "World"; 
		int UIOrder = 965;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light3ConeAngle : HOTSPOT // In radians
	#else
		float light3ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Cone Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 966;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light3FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light3FallOff : LIGHTFALLOFF
	#endif
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = halfPI;
			int UIOrder = 967;
		#endif
	> = { 0.0f };

	float light3AttenScale : DECAYRATE
	<
		string UIGroup = "Maya Lights [Preview]";
		string Object = "Light 3";
		string UIName = "Light 3 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 968;
	> = {0.0};

	bool light3ShadowOn : SHADOWFLAG
	<
		string UIGroup = "Maya Lights [Preview]";
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 3";
			string UIName = "Light 3 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 969;
		#endif
	> = true;

	float4x4 light3Matrix : SHADOWMAPMATRIX		
	<
		string UIGroup = "Maya Lights [Preview]"; 
		string Object = "Light 3";
		string UIWidget = "None"; 
	>;

} //end lights cbuffer

#endif // #ifndef _MAYALIGHTS_FXH_
