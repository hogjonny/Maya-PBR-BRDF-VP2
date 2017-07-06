/**
@file approxToneMapping.fxh
@brief Contains the Maya approximation for ToneMapping Implementation
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

	hdrColor.xyz *= bloomExp;
	half3 x = (half3)max(0, hdrColor.xyz - 0.004);

	o.xyz = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
	return o;
}