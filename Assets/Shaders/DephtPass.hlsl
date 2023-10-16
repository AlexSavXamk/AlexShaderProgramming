#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
float4 DepthVert(float3 positionOS : POSITION) : SV_POSITION
{
    return TransformObjectToHClip(positionOS);
}
float DepthFrag(float4 positionHCS : SV_POSITION) : SV_TARGET
{
    return positionHCS.z;
}