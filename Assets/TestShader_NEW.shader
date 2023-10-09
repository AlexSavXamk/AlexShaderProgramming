Shader"AlexShaders/TestShader"
{
    Properties
    {
        [KeywordEnum(Red, Green, Blue, Black)]
        _ColorKeyword("Color", Float) = 0
        
        [KeywordEnum(Object, World, View)]
        
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }
        
        Pass
        {
            name "Forward Lit"
            Tags { "LightMode" = "UniversalForward" }
            
            HLSLPROGRAM

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #pragma vertex Vertex
            #pragma fragment Fragment

            #pragma shader_feature_local_fragment _COLORKEYWORD_RED _COLORKEYWORD_GREEN _COLORKEYWORD_BLUE
            #pragma shader_feature_local_vertex _SPACE_OBJECT _SPACE_WORLD _SPACE_VIEW

            float4 Vertex(float3 positionOS : POSITION) : SV_POSITION {
                float4 positionHCS;

                #if _SPACE_OBJECT
                // positionHCS = mul(UNITY_MATRIX_MVP, positionOS + float3(0, 1, 0));
                positionHCS = TransformObjectToHClip(positionOS + float3(0, 1, 0));
                #elif _SPACE_WORLD
                // const float3 positionWS = mul(UNITY_MATRIX_M, positionOS);
                // positionHCS = mul(UNITY_MATRIX_VP, positionWS) + float3(0, 1, 0);
                const float3 positionWS = TransformOBjectToWorld(positionOS);
                positionHCS = TransformWorldTOHClip(positionWS) + float3(0, 1, 0);
                #endif

                return positionHCS;
            }

            float4 Fragment() : SV_TARGET {
                
                float4 col = 1;
                
                #if _COLORKEYWORD_RED
                col = float4(1, 0, 0, 1);
                #elif _COLORKEYWORD_GREEN
                col = float4(0, 1, 0, 1);
                #elif _COLORKEYWORD_BLUE
                col = float4(0, 0, 1, 1);
                #elif _COLORKEYWORD_BLACK
                col = float4(0, 0, 0, 1);
                #endif

                return col;
            }

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            CBUFFER_END

            ENDHLSL
        }
    }
}