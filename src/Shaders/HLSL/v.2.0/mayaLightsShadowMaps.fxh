/**
@file mayaLightShadowMaps.fxh
@brief Contains the Maya UI for setting lighting parameters
*/

#ifndef _MAYALIGHTSHADOWMAPS_FXH_
#define _MAYALIGHTSHADOWMAPS_FXH_

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

#endif // #ifndef _MAYALIGHTSHADOWMAPS_FXH_