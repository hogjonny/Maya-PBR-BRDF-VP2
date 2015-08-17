// shadertype=hlsl

//------------------------------------
// Samplers
//------------------------------------
SamplerState CubeMapSampler
{
    Filter = ANISOTROPIC;
    AddressU = Clamp;
    AddressV = Clamp;
    AddressW = Clamp;    
};

SamplerState SamplerAnisoWrap
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState SamplerAnisoClamp
{
    Filter = ANISOTROPIC;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState SamplerShadowDepth
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Border;
    AddressV = Border;
    BorderColor = float4(1.0f, 1.0f, 1.0f, 1.0f);
};

SamplerState SamplerGradientWrap
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState SamplerRamp
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState PointSampler
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

SamplerState LinearSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

SamplerState BrdfSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    //Filter = ANISOTROPIC;
    AddressU  = Wrap;
    AddressV  = Wrap;
	AddressW  = Wrap;
};