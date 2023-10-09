Shader"AlexShaders/NormalsTest"
{
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _FresnelPower ("Power", Range(0.0,10.0)) = 1.0
        _FresnelIntensity ("Intensity", Range(0.0,10.0)) = 1.0
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100
 
        ZWrite Off
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
 
        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0
                #pragma multi_compile_fog
         
                #include "UnityCG.cginc"
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord : TEXCOORD0;
                    float3 normal : NORMAL;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };
                struct v2f {
                    float4 vertex : SV_POSITION;
                    float2 texcoord : TEXCOORD0;
                    float3 normal : TEXCOORD1;
                    UNITY_FOG_COORDS(1)
                    UNITY_VERTEX_OUTPUT_STEREO
                };
                
                float4 _Color;
                float3 viewDir;
                float _FresnelPower;
                float _FresnelIntensity;
                v2f vert (appdata_t v)
                {
                    v2f o;
                    // SV_POSITION = TransformObjectToHClip(SV_POSITION + float3(0, 1, 0));
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                    o.vertex = UnityObjectToClipPos(v.vertex + float3(0, 1, 0));

                    const float3 positionWS = TransformOBjectToWorld(positionOS);
                    positionHCS = TransformWorldTOHClip(positionWS) + float3(0, 1, 0);
                    
                    o.normal = v.normal;
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                
         
                fixed4 frag (v2f i) : SV_Target
                {
                    half rim = 1 - saturate(dot(normalize(viewDir), i.normal));
                 
                    fixed4 col = _Color;
                    UNITY_APPLY_FOG(i.fogCoord, col);
                 
                    return col;
                }
            ENDCG
        }
    }
}