// shadertype=hlsl

lightOutCT simple_ct_BRDF(float3 L, float3 V, float3 L, float3 Albedo, float specA float roughA, float metalA)
{
    lightOutCT OUT = (lightOutCT)0;

    OUT.Color = float3(0.0f, 0.0f, 0.0f);
    OUT.Specular = 0.0f;

    // half vector
    float3 H = normalize( L + V );

    float NdotL = saturate( dot( N, L ) );
	float NdotV = saturate( dot( N, V ) );
	float NdotH = saturate( dot( N, H ) );
	float LdotH = saturate( dot( L, H ) );

	float alphaR = roughA * roughA;

	float3 Cdlin = Albedo.rgb; // pass in color already converted to linear
	float Cdlum = 0.3f * Cdlin[0] + 0.6f * Cdlin[1] + 0.1f * Cdlin[2]; // luminance approx.
	float3 Ctint = Cdlum > 0.0f ? Cdlin/Cdlum : 1.0f.xxx; // normalize lum. to isolate hue+sat
    float3 Cspec0 = lerp(specA * 0.08f * lerp(1.0f.xxx, Ctint, specularTint), Cdlin, metalA);

    // Geometric Term
    //          2 * ( N dot H )( N dot L )    2 * ( N dot H )( N dot V )
    // min( 1, ----------------------------, ---------------------------- )
    //                 ( H dot V )                   ( H dot V )

	// geometric attenuation
    float NH2 = 2.0 * NdotH;
    float g1 = (NH2 * NdotV) / VdotH;
    float g2 = (NH2 * NdotL) / VdotH;
    float G = min(1.0, min(g1, g2));

    // Normal Distribution Function ( cancel 1 / pi )
    //         ( N dot H )^2 - 1
    //  exp( ----------------------- )
    //         ( N dot H )^2 * m^2
    // --------------------------------
    //         ( N dot H )^4 * m^2
     
    // roughness (or: microfacet distribution function)
    // beckmann distribution function
	float sqrNH   = NdotH * NdotH;
    float r1 = 1.0 / ( 4.0 * alphaR * pow(NdotH, 4.0));
    float r2 = ( sqrNH - 1.0 ) / (alphaR * sqrNH);
    float D = r1 * exp(r2);

    // Frensnel Equation
    // F0 + ( 1 - F0 ) * ( 1 - ( H dot V ) )^5
	float LdotH5 = pow(1.0f-LdotH, 5.0f);
	float F0 = SchlickFresnel(LdotH);
    float F = (LdotH5) * ( 1.0  - F0 ) + F0;

	float3 Fs = lerp(Cspec0, 1.0f.xxx, F);

    // CookTorrance dBRDF
    OUT.Specular = D * Fs * G / ( NdotV * NdotL * 4.0 );

    OUT.Color = INV_PI * ( 1.0 - metalA ) * Cdlin;
    OUT.Color *= NdotL;

    return OUT;
}