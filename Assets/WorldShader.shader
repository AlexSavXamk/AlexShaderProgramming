Shader "AlexShaders/WorldShader"
{
   SubShader {
      Pass {
         CGPROGRAM

         #pragma vertex vert  
         #pragma fragment frag 
 
         // uniform float4x4 unity_ObjectToWorld; 
            // automatic definition of a Unity-specific uniform parameter

         struct vertexInput {
            float4 vertex : POSITION;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 position_in_world_space : TEXCOORD0;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output; 
 
            output.pos =  UnityObjectToClipPos(input.vertex);
            output.position_in_world_space = 
               mul(unity_ObjectToWorld + float3(0,1,0), input.vertex);
               // transformation of input.vertex from object 
               // coordinates to world coordinates;
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR 
         {
             float dist = distance(input.position_in_world_space, 
               float4(0.0, 0.0, 0.0, 1.0));
               // computes the distance between the fragment position 
               // and the origin (the 4th coordinate should always be 
               // 1 for points).
            
            if (dist < 5.0)
            {
               return float4(0.0, 1.0, 0.0, 1.0); 
                  // color near origin
            }
            else
            {
               return float4(0.1, 0.1, 0.1, 1.0); 
                  // color far from origin
            }
         }
 
         ENDCG  
      }
   }
}