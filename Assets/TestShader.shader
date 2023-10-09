Shader"AlexShaders/TestShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
			


			float3 positionOS : POSITION;
			float3 normalOS : NORMAL;
		};
		
		struct Varyings
		{
			float4 positionHCS : SV_POSITION;
			float3 positionWS : TEXCOORD0;
		};

		CBUFFER_START(UnityPerMaterial)
		float4 _Color
		CBUFFER_END		

		Varyings Vert(const Attributes input)
		{
			Varyings output;
	
			output.positionHCS = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_V, mul(UNITY_MATRIX_M, input.positionoS)));
	
			ouput.positionHCS = TransformObjectToHClip(input.positionOS);
			ouput.positionws = TransformObjectToWorld(input.positionOS);
			
			
			return output;
		}

		half4 Frag(const Varyings input) : SV_TARGET
		{
			return _Color * clamp(input.positionWS.x, 0, 1);
		}

		ENDHLSL
    }
}
