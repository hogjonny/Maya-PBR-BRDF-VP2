/**
@file mayaLights.fxh
@brief Contains the Maya UI for setting lighting parameters
*/

#ifndef _MAYALIGHTS_FXH_
#define _MAYALIGHTS_FXH_

//static const float cg_PI = 3.141592f;

//------------------------------------
// Light Constants Buffer  :  UI 900+
//------------------------------------
cbuffer UpdateLights : register(b2)
{
	// ---------------------------------------------
	// Light 0 GROUP
	// ---------------------------------------------
	// This value is controlled by Maya to tell us if a Light should be calculated
	// For example the artist may disable a Light in the scene, or choose to see only the selected Light
	// This flag allows Maya to tell our shader not to contribute this Light into the lighting
	bool light0Enable : LIGHTENABLE
	<
		string Object = "Light 0";	// UI Group for lights, auto-closed
		string UIName = "Enable Light 0";
		int UIOrder = 20;
	#ifdef _MAYA_
		> = false;	// maya manages lights itself and defaults to no lights
	#else
		> = true;	// in 3dsMax we should have the default Light enabled
	#endif

	// follows LightParameterInfo::ELightType
	// spot = 2, point = 3, directional = 4, ambient = 5,
	int light0Type : LIGHTTYPE
	<
		string Object = "Light 0";
		string UIName = "Light 0 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		int UIOrder = 21;
		float UIMin = 0;
		float UIMax = 5;
		float UIStep = 1;
	> = 2;	// default to spot so the cone angle etc work when "Use Shader Settings" option is used

	float3 light0Pos : POSITION 
	< 
		string Object = "Light 0";
		string UIName = "Light 0 Position"; 
		string Space = "World"; 
		int UIOrder = 22;
		int RefID = 0; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	float3 light0Color : LIGHTCOLOR 
	<
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 23;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light0Intensity : LIGHTINTENSITY 
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 0";
			string UIName = "Light 0 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 24;
		#endif
	> = { 1.0f };

	float3 light0Dir : DIRECTION 
	< 
		string Object = "Light 0";
		string UIName = "Light 0 Direction"; 
		string Space = "World"; 
		int UIOrder = 25;
		int RefID = 0; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light0ConeAngle : HOTSPOT // In radians
	#else
		float light0ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Cone Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 26;
		#endif
	> = { 0.46f };

	#ifdef _MAYA_
		float light0FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light0FallOff : LIGHTFALLOFF
	#endif
	<
		string Object = "Light 0";
		#ifdef _3DSMAX_
			int LightRef = 0;
			string UIWidget = "None";
		#else
			string UIName = "Light 0 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 27;
		#endif
	> = { 0.7f };

	float light0AttenScale : DECAYRATE
	<
		string Object = "Light 0";
		string UIName = "Light 0 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 28;
	> = {0.0};

	bool light0ShadowOn : SHADOWFLAG
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 0";
			string UIName = "Light 0 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 29;
		#endif
	> = true;

	float4x4 light0Matrix : SHADOWMAPMATRIX		
	< 
		string Object = "Light 0";
		string UIWidget = "None"; 
	>;



	// ---------------------------------------------
	// Light 1 GROUP
	// ---------------------------------------------
	bool light1Enable : LIGHTENABLE
	<
		string Object = "Light 1";
		string UIName = "Enable Light 1";
		int UIOrder = 30;
	> = false;

	int light1Type : LIGHTTYPE
	<
		string Object = "Light 1";
		string UIName = "Light 1 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 31;
	> = 2;

	float3 light1Pos : POSITION 
	< 
		string Object = "Light 1";
		string UIName = "Light 1 Position"; 
		string Space = "World"; 
		int UIOrder = 32;
		int RefID = 1; // 3DSMAX
	> = {-100.0f, 100.0f, 100.0f}; 

	float3 light1Color : LIGHTCOLOR 
	<
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 33;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light1Intensity : LIGHTINTENSITY 
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 1";
			string UIName = "Light 1 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 34;
		#endif
	> = { 1.0f };

	float3 light1Dir : DIRECTION 
	< 
		string Object = "Light 1";
		string UIName = "Light 1 Direction"; 
		string Space = "World"; 
		int UIOrder = 35;
		int RefID = 1; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light1ConeAngle : HOTSPOT // In radians
	#else
		float light1ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Cone Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 36;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light1FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light1FallOff : LIGHTFALLOFF
	#endif
	<
		string Object = "Light 1";
		#ifdef _3DSMAX_
			int LightRef = 1;
			string UIWidget = "None";
		#else
			string UIName = "Light 1 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 37;
		#endif
	> = { 0.0f };

	float light1AttenScale : DECAYRATE
	<
		string Object = "Light 1";
		string UIName = "Light 1 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 38;
	> = {0.0};

	bool light1ShadowOn : SHADOWFLAG
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 1";
			string UIName = "Light 1 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 39;
		#endif
	> = true;

	float4x4 light1Matrix : SHADOWMAPMATRIX		
	< 
		string Object = "Light 1";
		string UIWidget = "None"; 
	>;



	// ---------------------------------------------
	// Light 2 GROUP
	// ---------------------------------------------
	bool light2Enable : LIGHTENABLE
	<
		string Object = "Light 2";
		string UIName = "Enable Light 2";
		int UIOrder = 40;
	> = false;

	int light2Type : LIGHTTYPE
	<
		string Object = "Light 2";
		string UIName = "Light 2 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 41;
	> = 2;

	float3 light2Pos : POSITION 
	< 
		string Object = "Light 2";
		string UIName = "Light 2 Position"; 
		string Space = "World"; 
		int UIOrder = 42;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, -100.0f}; 

	float3 light2Color : LIGHTCOLOR 
	<
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 43;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light2Intensity : LIGHTINTENSITY 
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 2";
			string UIName = "Light 2 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 44;
		#endif
	> = { 1.0f };

	float3 light2Dir : DIRECTION 
	< 
		string Object = "Light 2";
		string UIName = "Light 2 Direction"; 
		string Space = "World"; 
		int UIOrder = 45;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light2ConeAngle : HOTSPOT // In radians
	#else
		float light2ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Cone Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 46;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light2FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light2FallOff : LIGHTFALLOFF
	#endif
	<
		string Object = "Light 2";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 2 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 47;
		#endif
	> = { 0.0f };

	float light2AttenScale : DECAYRATE
	<
		string Object = "Light 2";
		string UIName = "Light 2 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 48;
	> = {0.0};

	bool light2ShadowOn : SHADOWFLAG
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 2";
			string UIName = "Light 2 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 49;
		#endif
	> = true;

	float4x4 light2Matrix : SHADOWMAPMATRIX		
	< 
		string Object = "Light 2";
		string UIWidget = "None"; 
	>;

// ---------------------------------------------
	// Light 3 GROUP
	// ---------------------------------------------
	bool light3Enable : LIGHTENABLE
	<
		string Object = "Light 3";
		string UIName = "Enable Light 3";
		int UIOrder = 50;
	> = false;

	int light3Type : LIGHTTYPE
	<
		string Object = "Light 3";
		string UIName = "Light 3 Type";
		string UIFieldNames ="None:Default:Spot:Point:Directional:Ambient";
		float UIMin = 0;
		float UIMax = 5;
		int UIOrder = 51;
	> = 2;

	float3 light3Pos : POSITION 
	< 
		string Object = "Light 3";
		string UIName = "Light 3 Position"; 
		string Space = "World"; 
		int UIOrder = 52;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, -100.0f}; 

	float3 light3Color : LIGHTCOLOR 
	<
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Color"; 
			string UIWidget = "Color"; 
			int UIOrder = 53;
		#endif
	> = { 1.0f, 1.0f, 1.0f};

	float light3Intensity : LIGHTINTENSITY 
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 3";
			string UIName = "Light 3 Intensity"; 
			float UIMin = 0.0;
			float UIMax = _3DSMAX_SPIN_MAX;
			float UIStep = 0.01;
			int UIOrder = 54;
		#endif
	> = { 1.0f };

	float3 light3Dir : DIRECTION 
	< 
		string Object = "Light 3";
		string UIName = "Light 3 Direction"; 
		string Space = "World"; 
		int UIOrder = 55;
		int RefID = 2; // 3DSMAX
	> = {100.0f, 100.0f, 100.0f}; 

	#ifdef _MAYA_
		float light3ConeAngle : HOTSPOT // In radians
	#else
		float light3ConeAngle : LIGHTHOTSPOT
	#endif
	<
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Cone Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 56;
		#endif
	> = { 45.0f };

	#ifdef _MAYA_
		float light3FallOff : FALLOFF // In radians. Sould be HIGHER then cone angle or lighted area will invert
	#else
		float light3FallOff : LIGHTFALLOFF
	#endif
	<
		string Object = "Light 3";
		#ifdef _3DSMAX_
			int LightRef = 2;
			string UIWidget = "None";
		#else
			string UIName = "Light 3 Penumbra Angle"; 
			float UIMin = 0;
			float UIMax = cg_PI/2;
			int UIOrder = 57;
		#endif
	> = { 0.0f };

	float light3AttenScale : DECAYRATE
	<
		string Object = "Light 3";
		string UIName = "Light 3 Decay";
		float UIMin = 0.0;
		float UIMax = _3DSMAX_SPIN_MAX;
		float UIStep = 0.01;
		int UIOrder = 58;
	> = {0.0};

	bool light3ShadowOn : SHADOWFLAG
	<
		#ifdef _3DSMAX_
			string UIWidget = "None";
		#else
			string Object = "Light 3";
			string UIName = "Light 3 Casts Shadow";
			string UIWidget = "None";
			int UIOrder = 59;
		#endif
	> = true;

	float4x4 light3Matrix : SHADOWMAPMATRIX		
	< 
		string Object = "Light 3";
		string UIWidget = "None"; 
	>;

} //end lights cbuffer

#endif // #ifndef _MAYALIGHTS_FXH_
