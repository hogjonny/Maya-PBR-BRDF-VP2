// shadertype=hlsl

//------------------------------------
// Structs
//------------------------------------
struct MayaLight
{
	bool m_enabled;
	int m_type;
	float4 m_Diffuse;
	float4 m_Direction;
	float4 m_Specular;
	float4 m_Position;
	float m_Attenuation;
};

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

	// For Maya, flip the lightDir:
	#ifdef _MAYA_
		lightDirections[0] = -light0Dir;
		lightDirections[1] = -light1Dir;
		lightDirections[2] = -light2Dir;
		lightDirections[3] = -light3Dir;
	#endif

	for (int i = 0; i<4; ++i)
	{
		lights[i].m_enabled = lightsEnabled[i];
		lights[i].m_type = lightTypes[i];
		lights[i].m_Diffuse = float4(lightDiffuseColors[i].rgb * matDiffuse, 1.0f);
		lights[i].m_Specular = float4(lightDiffuseColors[i].rgb * matSpecular, 1.0f);
		lights[i].m_Position = float4(lightPositions[i], 1.0f);
		lights[i].m_Direction = float4(lightDirections[i], 1.0f);
		lights[i].m_Attenuation = lightAttenuation[i];
	}
}