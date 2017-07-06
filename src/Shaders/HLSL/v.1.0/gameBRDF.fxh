// shadertype=hlsl

lightOut game_BRDF(float3 L, float3 V, float3 N, float3 Albedo, float specA, float roughA, float metalA)
{
    lightOut OUT = (lightOut)0;

    OUT.Color = float3(0.0f, 0.0f, 0.0f);
    OUT.Specular = 0.0f;

	float alpha = roughA * roughA;

	float3 H = normalize( L + V );

    float NdotL = saturate( dot( N, L ) );
	float NdotV = saturate( dot( N, V ) );
	float NdotH = saturate( dot( N, H ) );
	float LdotH = saturate( dot( L, H ) );

	float F, D, vis;

	// V ... calc visability term
	float k = alpha / 2.0f;
	vis = G1V(NdotL, k) * G1V(NdotV, k);

	float3 Cdlin = Albedo.rgb; // pass in color already converted to linear
    float Cdlum = 0.3f * Cdlin[0] + 0.6f * Cdlin[1] + 0.1f * Cdlin[2]; // luminance approx.

    float3 Ctint = Cdlum > 0.0f ? Cdlin/Cdlum : 1.0f.xxx; // normalize lum. to isolate hue+sat
    float3 Cspec0 = lerp(specA * 0.08f * lerp(1.0f.xxx, Ctint, specularTint), Cdlin, metalA);

	// D
	float alphaSqr = alpha*alpha;
	float denom = NdotH * NdotH * (alphaSqr-1.0f) + 1.0f;
	D = alphaSqr / (PI * denom * denom);

	// F
	float LdotH5 = pow(1.0f-LdotH, 5.0f);
	//float F0 = FresnelOptimized( specA, LdotH );
	float F0 = SchlickFresnel(LdotH);
	F = F0 + (1.0f-F0) * (LdotH5);
	float3 Fs = lerp(Cspec0, 1.0f.xxx, F);

    //float geom = geomSchlickGGX( alpha, NdotV );
	//float geom = smithG_GGX( alpha, NdotV );
	//float G = saturate( 2 * NdotH * min( NdotV, NdotL ) / LdotH );
	//float specular_brdf = ( 0.25 * ndf * G ) / ( NdotL * NdotV );
    
	float specularBRDF = D * Fs * vis * NdotL;
	
	OUT.Specular = specularBRDF * Cspec0;

    OUT.Color = INV_PI * ( 1.0 - metalA ) * Cdlin;
    OUT.Color *= NdotL;

    return OUT;
}