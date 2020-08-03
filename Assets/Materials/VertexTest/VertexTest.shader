Shader "Custom/VertexTestShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//変数名 (インスペクタの表示, 型)
		value ("Value" , Float) = 0
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
			    float3 normal : NORMAL;
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float value;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + float4(v.normal * (_CosTime.w * value), 0));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return float4(
				   col.r - ((_SinTime.z / 2 + 0.5f) * 0.5f) + 0.2f,
                   col.g - ((_SinTime.x / 2 + 0.5f) * 0.5f) + 0.2f,
                   col.b - ((_SinTime.y / 2 + 0.5f) * 0.5f) + 0.2f,
                   col.a - ((_SinTime.w / 2 + 0.5f) * 0.5f) + 0.2f 
				);
			}
			ENDCG
		}
	}
}
