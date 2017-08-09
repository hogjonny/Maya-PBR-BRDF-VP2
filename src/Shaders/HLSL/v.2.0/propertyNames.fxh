/**
@file propertyNames.fxh
@brief Contains the material variable names that have been made common
to all Maya fbx & include files
*/

#ifndef _PROPERTY_NAMES_H_
#define _PROPERTY_NAMES_H_

/**
FBX material property names may be referenced as preprocessor macros in order to unify property naming between the Maya shaders and any FBX loading code.

If a property name needs to be modified, it would be changed here without needing to modify the loading code or Maya shaders directly.
*/

// UI Groups
#define HOG_GRP_MATERIAL_MAPS			"Material Maps"
#define HOG_GRP_ENV_LIGHTING			"Enrironment Lighting"	
#define HOG_GRP_MAT_PROPS				"Material Properties"
#define HOG_GRP_LIGHT_PROPS				"Lighting Properties"
#define HOG_GRP_SHADOW_PROPS			"Shadow Properties"
#define HOG_GRP_ADV_PROPS				"Advanced Properties"
#define HOG_GRP_ENGN_PREV				"Engine | Scene Preview"
#define HOG_GRP_PARA_OCC				"Parallax Occlusion"

// colors
#define HOG_MATERIAL_AMBIENT			"Surface Ambient"
#define HOG_MATERIAL_DIFFUSE			"Surface Diffuse"

// per-vertex color sets
#define HOG_USE_VERTEX_C0_RGBA			"Use Vert color0, Albedo RGBA"
#define HOG_USE_VERTEX_C1_AO			"Use Vert color1, Vertex AO"

// environment maps
#define HOG_SCENE_USE_ENV				"Use Environment Maps"
#define HOG_SCENE_ENV_TYPE				"Env Map Type"
#define HOG_SCENE_BRDF					"BRDF Map [2D]"
#define HOG_SCENE_CUBE_IBLDIFF			"Diffuse IBL [cube]"
#define HOG_SCENE_CUBE_IBLSPEC			"Specualar IBL [cube]"
#define HOG_SCENE_LATLONG_IBLDIFF		"Diffuse IBL [Latlong]"
#define HOG_SCENE_LATLONG_IBLSPEC		"Specualar IBL [Latlong]"
#define	HOG_SCENE_IBLEXP				"Env IBL Exponent"

// hemispherical ambient sky
#define HOG_SCENE_AMBSKY				"Ambient Sky Color"
#define HOG_SCENE_AMBGRND				"Ambient Ground Color"
#define HOG_SCENE_AMBSKYINT				"Ambient Sky Intensity"
#define HOG_SCENE_AMBGRNDINT			"Ambient Ground Intensity"
#define HOG_SCENE_AMBHEMIMODE			"Hemispherical Ambient"

// PBR Material Color Names
#define HOG_MATERIAL_BASECOLOR			"Base Color"
#define HOG_MATERIAL_ALBEDO				"Albedo Color"

// Material properties
#define HOG_MATERIAL_ANISOTROPIC		"Anisotropic"
#define HOG_MATERIAL_ROUGHNESS			"Roughness"
#define HOG_MATERIAL_METALNESS			"Metalness"
#define HOG_MATERIAL_SPECULAR			"Specular"
#define HOG_MATERIAL_SPECTINT			"Specular Tint"
#define HOG_MATERIAL_SHEEN				"Sheen"
#define HOG_MATERIAL_SHEENTINT			"Sheen Tint"
#define HOG_MATERIAL_CLEARCOAT			"Clearcoat"
#define HOG_MATERIAL_CLEARCOATGLOSS		"Clearcoat Gloss"

#define HOG_MATERIAL_EMISSIVE			"Emissive Color"
#define HOG_MATERIAL_EMISSIVEINT		"Emissive Int"

#define HOG_MATERIAL_IOR				"Index of Refraction (IOR)"
#define HOG_MATERIAL_BUMPINTENSITY		"Normal Int"

#define HOG_MATERIAL_USEPOM				"Use POM"
#define HOG_MATERIAL_POMSCALE			"POM Height Scale"
#define HOG_MATERIAL_USEPOMSHDW			"Use POM Shadows"
#define HOG_MATERIAL_POMSHDWTYPE		"POM Shadow Type"
#define HOG_MATERIAL_POMOCCOFFSET		"POM Occ Offset"
#define HOG_MATERIAL_POMOCCSHDWSTR		"POM Occ Shadow Strength"
#define HOG_MATERIAL_POMSHDWMULTI		"POM Shadow Multiplier"
#define HOG_MATERIAL_USEPOMSOFTSHDW		"Use POM SoftShadows"
#define HOG_MATERIAL_POMSOFTSHDWAMT		"POM SoftShadows Amt"

#define HOG_MATERIAL_POMMINSAMPLES		"POM Min Samples"
#define HOG_MATERIAL_POMMAXSAMPLES		"POM Max Samples"

#define HOG_MATERIAL_SHINE				"Shine"
#define HOG_MATERIAL_FRESNEL			"Fresnel"

#define HOG_MATERIAL_DISPLACE			"Displace"
#define HOG_MATERIAL_RADIANCE_FLUX		"Radiance Flux"
#define HOG_IS_SHADOW_CASTER			"Is Shadow Caster"
#define HOG_IS_SHADOW_RECEIVER			"Is Shadow Receiver"

#define HOG_HAS_VERTEX_ALPHA			"Use Vert color0 Alpha"
#define HOG_HAS_ALPHA					"Has Albedo Map Alpha"
#define HOG_USE_CUTOUT_ALPHA			"Use Cutout Alpha"
#define HOG_OPACITY						"Opacity [*]"
#define HOG_OPACITY_BIAS				"Cutout Bias [*]"

#define HOG_DIFFUSE_MAP					"Diffuse Map"
#define HOG_DIFFUSE0_MAP				"Diffuse Map 0"
#define HOG_DIFFUSE1_MAP				"Diffuse Map 1"

#define HOG_BASECOLOR_MAP				"Base Color Map"
#define HOG_BASECOLOR0_MAP				"Base Color Map 0"
#define HOG_BASECOLOR1_MAP				"Base Color Map 1"

#define HOG_PBRMASKSMAP_MAP				"PBR Masks Map"
#define HOG_PBRMASKSMAP0_MAP			"PBR Masks Map 0"
#define HOG_PBRMASKSMAP1_MAP			"PBR Masks Map 1"

#define HOG_TRANSMISSION0_MAP			"Transmission Map 0"

#define HOG_NORMAL_MAP					"Normal Map"
#define HOG_NORMAL0_MAP					"Normal Map 0"
#define HOG_NORMAL1_MAP					"Normal Map 1"

#define HOG_ROUGHNESS_MAP				"Roughness Map"
#define HOG_METALNESS_MAP				"Metalness Map"
#define HOG_SPECF0_MAP					"Specular F0 Map"
#define HOG_SPECULAR_MAP				"Specular A Map"

#define HOG_HEIGHT_MAP					"Height Map"
#define HOG_AMBOCC_MAP					"Amb Occ Map"
#define HOG_CAVITY_MAP					"Cavity Map"

#define HOG_EMISSIVE_MAP				"Emissive Map"
#define HOG_ANISOTROPIC_MAP				"Anisotropic Map"

#define HOG_BASE0_UV					"Base0 UV"
#define HOG_BASE1_UV					"Base1 UV"

#define HOG_BASENORMAL0_UV				"Base0|Normal0 UV"
#define HOG_BASENORMAL1_UV				"Base1|Normal1 UV"

#define HOG_SPECULAR_UV					"Specular UV"
#define HOG_EMISSIVE_UV					"Emissive UV"

#define HOG_DIFFUSE_BLEND_RGBA			"Diffuse Blend CPV"
#define HOG_NORMAL_BLEND_RGBA			"Normal Blend CPV"

#define HOG_SHADOW_RANGE_AUTO			"Shadow Range Auto"
#define HOG_SHADOW_RANGE_MAX			"Shadow Range Max"

#define HOG_VERTEX_ELEMENT_POSITION		"Position Format"
#define HOG_VERTEX_ELEMENT_COLOR		"Color Format"
#define HOG_VERTEX_ELEMENT_UV			"UV Format"
#define HOG_VERTEX_ELEMENT_NORMAL		"Normal Format"
#define HOG_VERTEX_ELEMENT_BINORMAL		"Binormal Format"
#define HOG_VERTEX_ELEMENT_TANGENT		"Tangent Format"

#define HOG_LINEAR_SPACE_LIGHTING		"Linear Lighting [*]"
#define HOG_LINEAR_VERTEX_COLORS		"Linear Vert Color [*]"
#define HOG_FLIP_BACKFACE_NORMALS		"Double Sided [*]"

#define HOG_SHADOW_DEPTH_BIAS			"Shadow Bias [*]"
#define HOG_SHADOW_MULTIPLIER			"Shadow Strength [*]"
#define HOG_SHADOW_USE_SHADOWS			"Use Shadows [*]"

#define HOG_SCENE_AMBIENT_LIGHT			"Scene Ambient [*]"
#define HOG_GAMMA_BLOOM_EXP				"Bloom Exposure [*]"								
#define HOG_USE_LIGHT_COLOR_AS_LIGHT_SPECULAR_COLOR	"Use LightColor as lightSpecularColor [*]"
#define HOG_USE_APPROX_TONE_MAPPING		"Use Approx Tone Mapping [*]"
#define HOG_GAMMA_CORRECT_SHADER		"Use Gamma Correct Shader [*]"
#define HOG_FILMLUT						"Film LUT"

#define HOG_CUBE_SRC					"Cubemap"

// Irradiance Environment Map
#define HOG_IEM_SRC						"IEM Source"				
#define HOG_IEM_CUBE					"IEM Cubemap"

// Prefiltered Mip-mapped Radiance Environment Map
#define HOG_PMREM_SRC					"PMREM Source"				
#define HOG_PMREM_CUBE					"PMREM Cubemap"

#define HOG_ALBEDO_MAP					"Albedo Map"
#define HOG_PBRMASK_MAP					"PBRmasks Map"
#define HOG_TRANSMISSION_MAP			"Transmission Map"
#define HOG_SPECRADIANCE_MAP			"ENV Spec Rad [LatLong]"
#define HOG_IRRADIANCE_MAP				"Env Irrad [LatLong]"
#define HOG_BDRFLUT_MAP					"BDRF LUT"

#define HOG_TONEMAPPING_TYPE			"Tonemapping Type"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#endif // #ifndef _PROPERTY_NAMES_