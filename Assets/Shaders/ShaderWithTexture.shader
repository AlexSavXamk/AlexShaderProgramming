Shader "AlexShaders/ShaderWithTexture"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _ScrollSpeed("Scroll Speed", float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes{
                float4 positionOS   : POSITION;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings{
                float2 uv           : TEXCOORD0;
                float4 positionHCS  : SV_POSITION;
            };

            //FLOAT(_ScrollSpeed);
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            
            float4 _MainTex_ST;

            Varyings vert(Attributes IN){
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.uv.x -= _Time.y * 2;
                OUT.uv.y -= _Time.y * 1;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
            }
            ENDHLSL
        }

        Pass
        {
            Name "Depth"
            Tags { "LightMode" = "DepthOnly" }
            
            Cull Back
            ZTest LEqual
            ZWrite On
            ColorMask R
            
            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment DepthFrag
            float DepthFrag(Varyings input) : SV_TARGET {
                return input.positionHCS.z;
            }
            
            ENDHLSL
        }
        Pass
        {
            Name "Normals"
            Tags { "LightMode" = "DepthNormalsOnly" }
            
            Cull Back
            ZTest LEqual
            ZWrite On
            
            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment DepthNormalsFrag
            float4 DepthNormalsFrag(Varyings input) : SV_TARGET {
                return float4(input.normalWS, 0);
            }
            
            ENDHLSL
        }
    }
}