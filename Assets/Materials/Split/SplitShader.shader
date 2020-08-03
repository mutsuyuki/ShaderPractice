Shader "Custom/SplitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		splitPosition ("Split Position" , Range(0.0, 1.0)) = 0
		splitAmount ("Split Amount" , Range(-1.0, 1.0)) = 0
		
	}
	SubShader
	{
	    Tags { "RenderType"="Opaque" }
		// No culling or depth
		Cull Back ZWrite On ZTest LEqual

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata // 頂点シェーダの入力
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f  // vertex -> frag への引数
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float splitPosition;
			float splitAmount;

			fixed4 frag (v2f i) : SV_Target
			{
			    fixed4 col;
				// just invert the colors
				if(i.uv.y > splitPosition){
				     // メインテクスチャ（インプットの方）から色を取ってくる関数
				     col = tex2D(_MainTex, float2(i.uv.x + splitAmount, i.uv.y));
				}else{
				     col = tex2D(_MainTex, i.uv);
				}
				return col;
				
			}
			ENDCG
		}
	}
}
