/**
@file toneMapping.fxh
@brief Contains various tone mapping operators
@reference, modified from: http://filmicworlds.com/blog/filmic-tonemapping-operators/
*/

/**
@brief Function for approximating Tonemapping Implementation in Maya
@param[in] hdrColor - the output color prior to tone mapping
@param[in] bloomExp - the bloom exponential value
@return float3 - the tone mapped output color
*/
float3 approxToneMapping(float3 hdrColor, float bloomExp)
{
	float3 o;

	hdrColor.rgb *= bloomExp;
	half3 x = (half3)max(0, hdrColor.xyz - 0.004);

	hdrColor = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
	return hdrColor;
}

/**
@ brief TO Do: document
*/
float3 linearTonemapping(float3 hdrColor, float gammaExp)
{
   hdrColor.rgb *= 16;  // Hardcoded Exposure Adjustment
   float3 retColor = pow( hdrColor.rgb, 1.0f / gammaExp);
   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 linearExpTonemapping(float3 hdrColor, float bloomExp, float gammaExp)
{
   hdrColor.rgb *= bloomExp;
   float3 retColor = pow( hdrColor.rgb, 1.0f / gammaExp);
   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 reinhard(float3 hdrColor, float gammaExp)
{
   hdrColor.rgb *= 16;  // Hardcoded Exposure Adjustment
   hdrColor.rgb = hdrColor.rgb / ( 1.0f + hdrColor.rgb );
   float3 retColor = pow( hdrColor.rgb, 1.0f / gammaExp);
   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 reinhardExp(float3 hdrColor, float bloomExp, float gammaExp)
{
   hdrColor.rgb *= bloomExp;
   hdrColor.rgb = hdrColor.rgb / ( 1.0f + hdrColor.rgb );
   float3 retColor = pow( hdrColor.rgb, 1.0f / gammaExp);
   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 HaarmPeterCurve(float3 hdrColor, float3 filmLut)
{
   hdrColor *= 16.0f;  // Hardcoded Exposure Adjustment

   float filmLutWidth = 256;
   float padding = 0.5 / filmLutWidth;

   float3 ld = 0.002f;
   float linReference = 0.18f;
   float logReference = 444.0f;
   float logGamma = 0.45f;
      
   float3 logColor;
   logColor.rgb = ( log10 (0.4f * hdrColor.rgb / linReference ) / ld * logGamma + logReference) / 1023.f;
   logColor.rgb = saturate( logColor.rgb );
      
   //  apply response lookup and color grading for target display
   float3 retColor;
   retColor.r = tex2D( filmLut, float2( lerp( padding, 1.0f - padding, logColor.r), 0.5f) ).r;
   retColor.g = tex2D( filmLut, float2( lerp( padding, 1.0f - padding, logColor.g), 0.5f) ).r;
   retColor.b = tex2D( filmLut, float2( lerp( padding, 1.0f - padding, logColor.b), 0.5f) ).r;

   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 HaarmPeterCurveExp(float3 hdrColor, float3 filmLut, float bloomExp)
{
   texColor *= bloomExp;  // Hardcoded Exposure Adjustment

   float filmLutWidth = 256;
   float padding = 0.5 / filmLutWidth;

   float3 ld = 0.002f;
   float linReference = 0.18f;
   float logReference = 444.0f;
   float logGamma = 0.45f;
      
   float3 logColor;
   logColor.rgb = ( log10 (0.4f * texColor.rgb / linReference ) / ld * logGamma + logReference) / 1023.f;
   logColor.rgb = saturate(LogColor.rgb);
      
   //  apply response lookup and color grading for target display
   float3 retColor;
   retColor.r = tex2D( filmLut, float2( lerp( Padding, 1.0f - padding, logColor.r), 0.5f) ).r;
   retColor.g = tex2D( filmLut, float2( lerp( Padding, 1.0f - padding, logColor.g), 0.5f) ).r;
   retColor.b = tex2D( filmLut, float2( lerp( Padding, 1.0f - padding, logColor.b), 0.5f) ).r;

   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 JimHejlRichardBurgessDawson(float3 hdrColor)
{
   hdrColor *= 16;  // Hardcoded Exposure Adjustment
   float3 x = max( 0.0f, hdrColor.rgb - 0.004f );
   float3 retColor = ( x * (6.2f * x + 0.5f ) ) / ( x * ( 6.2f * x + 1.7f ) + 0.06f );
   return retColor.rgb;
}

/**
@ brief TO Do: document
*/
float3 JimHejlRichardBurgessDawsonExp(float3 hdrColor, float bloomExp)
{
   hdrColor *= bloomExp;
   float3 x = max( 0.0f, hdrColor.rgb - 0.004f );
   float3 retColor = ( x * (6.2f * x + 0.5f ) ) / ( x * ( 6.2f * x + 1.7f ) + 0.06f );
   return retColor.rgb;
}