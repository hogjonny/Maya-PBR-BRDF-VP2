/**
@file FbxPropertyNames.h
@brief Contains the material variable names that have been made common
to all Maya fbx & include files
@copyright 2015 Bifrost Engine
*/

#ifndef _PROPERTY_NAMES_H_
#define _PROPERTY_NAMES_H_

// FBX material property names are referenced as preprocessor macros in order to unify property naming between the Maya shaders and FBX loading code.
// If a property name needs to be modified, it would be changed here without needing to modify the loading code or Maya shaders directly.
// colors
#define MGDS_MATERIAL_AMBIENT			"Ambient"
#define MGDS_MATERIAL_DIFFUSE			"Diffuse"

// hemispherical ambient sky
#define MGDS_SCENE_AMBSKY				"Ambient Sky Color"
#define MGDS_SCENE_AMBGRND				"Ambient Ground Color"
#define MGDS_SCENE_AMBSKYINT			"Ambient Sky Intensity"
#define MGDS_SCENE_AMBGRNDINT			"Ambient Ground Intensity"

// environment maps
#define MGDS_SCENE_BRDF					"BRDF Map [2D]"
#define MGDS_SCENE_IBLDIFF				"Diffuse IBL [cube]"
#define MGDS_SCENE_IBLSPEC				"Specualar IBL [cube]"
#define	MGDS_SCENE_IBLEXP				"Env IBL Exponent"

// PBR Material Color Names
#define MGDS_MATERIAL_BASECOLOR			"Base Color"
#define MGDS_MATERIAL_ALBEDO			"Albedo Color"

// Material properties
#define MGDS_MATERIAL_ROUGHNESS			"Roughness"
#define MGDS_MATERIAL_METALNESS			"Metalness"
#define MGDS_MATERIAL_BUMPINTENSITY		"Normal Intensity"

#define MGDS_MATERIAL_SPECULAR			"Specular"
#define MGDS_MATERIAL_EMISSIVE			"Emissive"
#define MGDS_MATERIAL_EMISSIVEINT		"Emissive Intensity"

#define MGDS_MATERIAL_IOR				"Index of Refraction (IOR)"
#define MGDS_MATERIAL_SHINE				"Shine"
#define MGDS_MATERIAL_FRESNEL			"Fresnel"

#define MGDS_MATERIAL_DISPLACE			"Displace"
#define MGDS_MATERIAL_SPECTINT			"Specular Tint"
#define MGDS_MATERIAL_RADIANCE_FLUX		"Radiance Flux"
#define MGDS_IS_SHADOW_CASTER			"Is Shadow Caster"
#define MGDS_IS_SHADOW_RECEIVER			"Is Shadow Receiver"

#define MGDS_HAS_VERTEX_ALPHA			"Has Vertex Alpha"
#define MGDS_HAS_ALPHA					"Has Diffuse Map Alpha"
#define MGDS_USE_CUTOUT_ALPHA			"Use Cutout Alpha"
#define MGDS_OPACITY					"Opacity [*]"
#define MGDS_OPACITY_BIAS				"Cutout Bias [*]"

#define MGDS_DIFFUSE_MAP				"Diffuse Map"
#define MGDS_DIFFUSE0_MAP				"Diffuse Map 0"
#define MGDS_DIFFUSE1_MAP				"Diffuse Map 1"

#define MGDS_BASECOLOR_MAP				"Base Color Map"
#define MGDS_BASECOLOR0_MAP				"Base Color Map 0"
#define MGDS_BASECOLOR1_MAP				"Base Color Map 1"

#define MGDS_PBRMASKSMAP_MAP			"PBR Masks Map"
#define MGDS_PBRMASKSMAP0_MAP			"PBR Masks Map 0"
#define MGDS_PBRMASKSMAP1_MAP			"PBR Masks Map 1"

#define MGDS_TRANSMISSION0_MAP			"Transmission Map 0"

#define MGDS_NORMAL_MAP					"Normal Map"
#define MGDS_NORMAL0_MAP				"Normal Map 0"
#define MGDS_NORMAL1_MAP				"Normal Map 1"

#define MGDS_SPECULAR_MAP				"Specular Map"
#define MGDS_EMISSIVE_MAP				"Emissive Map"

#define MGDS_BASE0_UV					"Base0 UV"
#define MGDS_BASE1_UV					"Base1 UV"

#define MGDS_BASENORMAL0_UV				"Base0|Normal0 UV"
#define MGDS_BASENORMAL1_UV				"Base1|Normal1 UV"

#define MGDS_SPECULAR_UV				"Specular UV"
#define MGDS_EMISSIVE_UV				"Emissive UV"

#define MGDS_DIFFUSE_BLEND_RGBA			"Diffuse Blend CPV"
#define MGDS_NORMAL_BLEND_RGBA			"Normal Blend CPV"

#define MGDS_SHADOW_RANGE_AUTO			"Shadow Range Auto"
#define MGDS_SHADOW_RANGE_MAX			"Shadow Range Max"

#define MGDS_VERTEX_ELEMENT_POSITION	"Position Format"
#define MGDS_VERTEX_ELEMENT_COLOR		"Color Format"
#define MGDS_VERTEX_ELEMENT_UV			"UV Format"
#define MGDS_VERTEX_ELEMENT_NORMAL		"Normal Format"
#define MGDS_VERTEX_ELEMENT_BINORMAL	"Binormal Format"
#define MGDS_VERTEX_ELEMENT_TANGENT		"Tangent Format"

#define MGDS_LINEAR_SPACE_LIGHTING		"Linear Lighting [*]"
#define MGDS_LINEAR_VERTEX_COLORS		"Linear Vert Color [*]"
#define MGDS_FLIP_BACKFACE_NORMALS		"Double Sided [*]"

#define MGDS_SHADOW_DEPTH_BIAS			"Shadow Bias [*]"
#define MGDS_SHADOW_MULTIPLIER			"Shadow Strength [*]"
#define MGDS_SHADOW_USE_SHADOWS			"Use Shadows [*]"

#define MGDS_SCENE_AMBIENT_LIGHT						"Scene Ambient [*]"
#define MGDS_GAMMA_BLOOM_EXP							"Bloom Exposure [*]"								
#define MGDS_USE_LIGHT_COLOR_AS_LIGHT_SPECULAR_COLOR	"Use LightColor as lightSpecularColor [*]"
#define MGDS_USE_APPROX_MAXPLAY_TONE_MAPPING			"Use MaxPlay Approx Tone Mapping [*]"
#define MGDS_GAMMA_CORRECT_SHADER						"Use Gamma Correct Shader [*]"

#define MGDS_CUBE_SRC					"Cubemap"
	
#define MGDS_IEM_SRC					"IEM Source"				// Irradiance Environment Map
#define MGDS_IEM_CUBE					"IEM Cubemap"

#define MGDS_PMREM_SRC					"PMREM Source"				// Prefiltered Mip-mapped Radiance Environment Map
#define MGDS_PMREM_CUBE					"PMREM Cubemap"

#define MGDS_ALBEDO_MAP					"Albedo Map"
#define MGDS_PBRMASK_MAP				"PBRmasks Map"
#define MGDS_TRANSMISSION_MAP			"Transmission Map"
#define MGDS_SPECRADIANCE_MAP			"ENV Spec Rad [LatLong]"
#define MGDS_IRRADIANCE_MAP				"Env Irrad [LatLong]"
#define MGDS_BDRFLUT_MAP				"BDRF LUT"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#endif
#ifndef _PROPERTY_NAMES_H_