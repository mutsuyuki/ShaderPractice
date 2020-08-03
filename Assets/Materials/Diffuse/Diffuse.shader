Shader "Custom/Diffuse"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 lightDir : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				o.lightDir = ObjSpaceLightDir(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			
				fixed4 col = tex2D(_MainTex, i.uv);
				float3 normalizedNormal = normalize(i.normal);
				float3 normalizedLightDir = normalize(i.lightDir);
				float dotted = dot(normalizedNormal, normalizedLightDir);
				float saturated = saturate(dotted);
				float4 result = float4(saturated * col.rgb, 1);
				
				return result;
			}
			ENDCG
		}
	}
}
