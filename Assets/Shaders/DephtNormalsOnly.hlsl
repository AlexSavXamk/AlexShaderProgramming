// Nimi on eri, jotta ei sekoitu mahdollisen päätiedoston structin kanssa
struct DNAttributes
{
    float3 positionOS : POSITION;
    float3 normalOS : NORMAL;
};

struct DNVaryings
{
    float4 positionHCS : SV_POSITION;
    float3 normalWS : TEXCOORD0;
};

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
DNVaryings DepthNormalsVert(DNAttributes input)
{
    DNVaryings output;
    output.positionHCS = TransformObjectToHClip(input.positionOS);
    output.normalWS = TransformObjectToWorldNormal(input.normalOS);
    return output;
}

float4 DepthNormalsFrag(DNVaryings input) : SV_TARGET
{
    return float4(input.normalWS, 0);
}