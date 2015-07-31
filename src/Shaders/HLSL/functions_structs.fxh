// shadertype=hlsl

//------------------------------------
// Functions
//------------------------------------

float2 pickTexcoord(int index, float2 t0, float2 t1, float2 t2)
{
    float2 tcoord = t0;

        if (index == 1)
            tcoord = t1;
        else if (index == 2)
            tcoord = t2;

    return tcoord;
}

// Shadows:
// Percentage-Closer Filtering
float lightShadow(float4x4 LightViewPrj, uniform Texture2D ShadowMapTexture, float3 VertexWorldPosition)
{
    float shadow = 1.0f;

    float4 Pndc = mul(float4(VertexWorldPosition.xyz, 1.0), LightViewPrj);
        Pndc.xyz /= Pndc.w;
    if (Pndc.x > -1.0f && Pndc.x < 1.0f && Pndc.y  > -1.0f
        && Pndc.y <  1.0f && Pndc.z >  0.0f && Pndc.z <  1.0f)
    {
        float2 uv = 0.5f * Pndc.xy + 0.5f;
            uv = float2(uv.x, (1.0 - uv.y));    // maya flip Y
        float z = Pndc.z - shadowDepthBias / Pndc.w;

        // we'll sample a bunch of times to smooth our shadow a little bit around the edges:
        shadow = 0.0f;
        for (int i = 0; i<SHADOW_FILTER_TAPS_CNT; ++i)
        {
            float2 suv = uv + (SuperFilterTaps[i] * shadowMapTexelSize);
                float val = z - ShadowMapTexture.SampleLevel(SamplerShadowDepth, suv, 0).x;
            shadow += (val >= 0.0f) ? 0.0f : (1.0f / SHADOW_FILTER_TAPS_CNT);
        }

        // a single sample would be:
        // shadow = 1.0f;
        // float val = z - ShadowMapTexture.SampleLevel(SamplerShadowDepth, uv, 0 ).x;
        // shadow = (val >= 0.0f)? 0.0f : 1.0f;

        shadow = lerp(1.0f, shadow, shadowMultiplier);
    }

    return shadow;
}

/**
// Clip pixel away when opacity mask is used
void OpacityMaskClip(float2 uv)
{
    if (UseOpacityMaskTexture)
    {
       float OpacityMaskMap = OpacityMaskTexture.Sample(SamplerAnisoWrap, uv).x;

        // clip value when less then 0 for punch-through alpha.
        clip( OpacityMaskMap < OpacityMaskBias ? -1:1 );
   }
}
*/

float3 filmicTonemap(float3 input) //John Hable's filmic tonemap function with fixed values
{
    float A = 0.22;
    float B = 0.3;
    float C = 0.1;
    float D = 0.2;
    float E = 0.01;
    float F = 0.3;
    float linearWhite = 11.2;
    float3 Fcolor = ((input*(A*input + C*B) + D*E) / (input*(A*input + B) + D*F)) - E / F;
        float  Fwhite = ((linearWhite*(A*linearWhite + C*B) + D*E) / (linearWhite*(A*linearWhite + B) + D*F)) - E / F;
    return Fcolor / Fwhite;
}


float sqr(float x)
{
    return x*x;
}

float G1V(float NdotV, float k)
{
    return 1.0f / (NdotV * (1.0f - k) + k);
}

float GTR1(float NdotH, float a)
{
    if (a >= 1.0f)
    {
        return 1.0f / PI;
    }

    float a2 = a*a;
    float t = 1.0f + (a2 - 1.0f) * NdotH * NdotH;
    return (a2 - 1.0f) / (PI*log(a2)*t);
}

float GTR2(float NdotH, float a)
{
    float a2 = a*a;
    float t = 1 + (a2-1)*NdotH*NdotH;
    return a2 / (PI * t*t);
}

float GTR2_aniso(float NdotH, float HdX, float HdY, float ax, float ay)
{
    return 1.0f / (PI * ax*ay * sqr(sqr(HdX / ax) + sqr(HdY / ay) + NdotH*NdotH));
}

float smithG_GGX(float Ndotv, float alphaG)
{
    float a = alphaG*alphaG;
    float b = Ndotv*Ndotv;
    return 1.0f / (Ndotv + sqrt(a + b - a*b));
}

// NEW ////
float fresnelSchlick( float f0, float VdotH )
{
    return f0 + ( 1 - f0 ) * pow( 1 - VdotH, 5 );
}

float fresnelSchlick( float VdotH )
{
    float value  = clamp( 1 - VdotH, 0.0, 1.0 );
    float value2 = value * value;
    return ( value2 * value2 * value );
}

float SchlickFresnel(float u)
{
    float m = clamp(1 - u, 0, 1);
    float m2 = m*m;
    return m2*m2*m; // pow(m,5)
}

float3 FresnelOptimized( float3 R, float c )
{
    float3 F = lerp( R, saturate( 60 * R ), pow(1-c,4) ); 
    return F;
}

float geomSchlickGGX( float alpha, float NdotV )
{
    float k    = 0.5 * alpha;
    float geom = NdotV / ( NdotV * ( 1 - k ) + k );

    return geom;
}

float ndfGGX(float alpha, float NdotH )
{
    float alpha2 = alpha * alpha;
    float t      = 1 + ( alpha2 - 1 ) * NdotH * NdotH;
    return INV_PI * alpha2 / ( t * t );
}

//float3 Gsub(float3 v) // Sub Function of G
//{
    //float k = ((roughness + 1) * (roughness + 1)) / 8;
    //float fdotv = dot(fNormal, v);
    //return vec3((fdotv) / ((fdotv) * (1.0 - k) + k));
//}

//float3 G(float3 L, float3 V, float3 H) // Geometric Attenuation Term - Schlick Modified (k = a/2)
//{
    //return Gsub(L) * Gsub(V);
//}

//float3 mon2lin(float3 value)
//{
    //return float3(pow(value[0], 2.233333333f), pow(value[1], 2.233333333f), pow(value[2], 2.233333333f));
//}

// This function is a modified version of Colin Barre-Brisebois GDC talk
//float3 translucency(float3 thickness, float3 V, float3 L, float3 N, float lightAttenuation, float3 albedoColor)
//{
//    float3 LightVec = L + (N * translucentDistortion);
//    float fLTDot = pow(saturate(dot(V, -LightVec)), translucentPower) * translucentScale;
//    float3 translucence = lightAttenuation * (fLTDot + translucentMin) * thickness;
//    return float3(albedoColor * translucence);
//}
