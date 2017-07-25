#define SAMPLERMINMAGMIPLINEARCLAMP SamplerState SamplerLinearClamp	\
{																    \
	Filter = MIN_MAG_MIP_LINEAR;								    \
	AddressU = Clamp;											    \
	AddressV = Clamp;											    \
};

#define SAMPLERMINMAGMIPLINEARWRAP SamplerState SamplerLinearWrap	\
{																    \
	Filter = MIN_MAG_MIP_LINEAR;								    \
	AddressU = Wrap;											    \
	AddressV = Wrap;											    \
};

#define SAMPLERSTATESHADOWDEPTH SamplerState SamplerShadowDepth		\
{																	\
	Filter = MIN_MAG_MIP_POINT;										\
	AddressU = Border;												\
	AddressV = Border;												\
	BorderColor = float4(1.0f, 1.0f, 1.0f, 1.0f);					\
};

#define SAMPLERSTATEANISOCLAMP_UV SamplerState SamplerAnisoClampUV	\
{																	\
    Filter = ANISOTROPIC;											\
    AddressU = Clamp;												\
    AddressV = Clamp;												\
};		

#define SAMPLERSTATEANISOWRAP SamplerState SamplerAnisoWrap			\
{																	\
    Filter = ANISOTROPIC;											\
    AddressU = Wrap;												\
    AddressV = Wrap;												\
};	

#define SAMPLERSTATEANISOWRAP_U SamplerState SamplerAnisoWrapU		\
{																	\
    Filter = ANISOTROPIC;											\
    AddressU = Wrap;												\
    AddressV = Clamp;												\
};				

#define SAMPLERSTATEANISOWRAP_V SamplerState SamplerAnisoWrapV		\
{																	\
    Filter = ANISOTROPIC;											\
    AddressU = Clamp;												\
    AddressV = Wrap;												\
};	

#define SAMPLERMINMAGMIP SamplerState SamplerLinearWrapU			\
{																	\
	Filter = MIN_MAG_MIP_LINEAR;									\
	AddressU = Wrap;												\
	AddressV = Clamp;												\
};			

#define SAMPLERCUBEMAP SamplerState SamplerCubeMap                  \
{                                                                   \
    Filter = ANISOTROPIC;                                           \
    AddressU = Clamp;                                               \
    AddressV = Clamp;                                               \
    AddressW = Clamp;                                               \
};

#define SAMPLERBRDFLUT	SamplerState SamplerBrdfLUT	\
{													\
	Filter = ANISOTROPIC;							\
    AddressU  = Wrap;								\
    AddressV  = Wrap;								\
	AddressW  = Wrap;								\
};
								