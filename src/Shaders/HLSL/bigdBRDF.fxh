// shadertype=hlsl

lightOutD dBRDF(float3 L, float3 V, float3 N, float3 X, float3 Y, float3 Albedo, float SpecA, float roughA, float metalA)
{
    lightOutD OUT    = (lightOutD)0;

    OUT.Color = float3(0, 0, 0);
    OUT.Specular = 0.0;

	float alpha = roughA * roughA;

	float3 H = normalize( L + V );

    float NdotL = saturate( dot( N, L ) );
	float NdotV = saturate( dot( N, V ) );
	float NdotH = saturate( dot( N, H ) );
	float LdotH = saturate( dot( L, H ) );

	// V ... calc visability term
	//float k = alpha / 2.0f;
	//float vis = G1V(NdotL, k) * G1V(NdotV, k);

    if (NdotL < 0 || NdotV < 0)  //this will negate the backside
    {
        ////return float3(0.0f, 0.0f, 0.0f);
        return OUT;
    }

    float3 Cdlin = Albedo.rgb; // pass in color already converted to linear
    float Cdlum = 0.3f * Cdlin[0] + 0.6f * Cdlin[1] + 0.1f * Cdlin[2]; // luminance approx.

    float3 Ctint = Cdlum > 0.0f ? Cdlin/Cdlum : 1.0f.xxx; // normalize lum. to isolate hue+sat
    float3 Cspec0 = lerp(SpecA * 0.08f * lerp(1.0f.xxx, Ctint, specularTint), Cdlin, metalA);
    float3 Csheen  = lerp(1.0f.xxx, Ctint, sheenTint);

    // Diffuse fresnel - go from 1 at normal incidence to .5 at grazing
    // and mix in diffuse retro-reflection based on roughness
    float FL = SchlickFresnel(NdotL);
    float FV = SchlickFresnel(NdotV);
    float Fd90 = 0.5f + 2.0f * LdotH * LdotH * alpha;
	// Fd looks odd if not * NdotL?
    float Fd = lerp(1.0f, Fd90, FL) * lerp(1.0f, Fd90, FV);

    // Based on Hanrahan-Krueger brdf approximation of isotropic bssrdf
    // 1.25 scale is used to (roughly) preserve albedo
    // Fss90 used to "flatten" retroreflection based on roughness
    float Fss90 = LdotH * LdotH * alpha;
    float Fss = lerp(0.999f, Fss90, FL) * lerp(0.999f, Fss90, FV);
	// appears to have bright rim anomalies!!
    float ss = 1.25f * (Fss * (1.0f / (NdotL + NdotV + 0.0001f) - 0.5f) + 0.5f);

    // specular
    float aspect = sqrt(1.0f - anisotropic * 0.9f);
    float ax = max(0.001f, sqr(alpha) / aspect);
    float ay = max(0.001f, sqr(alpha) * aspect);
    float Ds = GTR2_aniso(NdotH, dot(H, X), dot(H, Y), ax, ay);
    float FH = SchlickFresnel(LdotH);
    float3 Fs = lerp(Cspec0, 1.0f.xxx, FH);
    float roughg = sqr(alpha * 0.5f + 0.5f);
    float Gs = smithG_GGX(NdotL, roughg) * smithG_GGX(NdotV, roughg);

    // sheen looks weird/wrong with out view based fresnel?
    float3 Fsheen = FH * sheen * Csheen;

    float Dr = GTR1(NdotH, lerp(0.1f, 0.001f, clearcoatGloss));
    float Fr = lerp(0.04f, 1.0f, FH);
    float Gr = smithG_GGX(NdotL, 0.25f) * smithG_GGX(NdotV, 0.25f);

    OUT.Color += ((1.0f / PI) * lerp(Fd, ss, subsurface) * Cdlin + Fsheen);
    OUT.Color *= (1.0f - metalA) * NdotL;
    //OUT.Color *= vis;

	// next line looks weird/wrong without *NdotL?
    OUT.Specular = (Gs * Fs * Ds);
    OUT.Specular += (0.25f * clearcoat * Gr * Fr * Dr);
    OUT.Specular *= NdotL;
    //OUT.Specular *= vis;

    return OUT;
}