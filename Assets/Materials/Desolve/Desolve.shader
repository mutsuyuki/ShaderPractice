Shader "Custom/Desolve"
{
	Properties
	{
        _GridSize ("GridSize", float) = 1.0
        _X ("Seed X", float) = 1.0
        _Y ("Seed Y", float) = 1.0
        _threshoed ("Threashold", Range(0.0, 1.0)) = 0.5
    }
	SubShader
	{
//		Tags { "RenderType"="Opaque" }
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
            #include "../_ShaderLib/noise.cginc"


            float _GridSize;
            float _X;
            float _Y;
            float _threshoed;
            
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
			
			v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			fixed4 frag (v2f i) : SV_Target
			{
			    float2 perlinParam = i.uv * _GridSize + float2(_X + _Time.x, _Y + _Time.x);
//			    float2 perlinParam = i.uv * _GridSize + float2(_X, _Y);
                float ns = PerlinNoise2D(perlinParam) / 2 + 0.5f;

                fixed4 col = float4( ns, ns, ns, (ns < _threshoed) ? 0 : 1 );
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
	
			}
			ENDCG
		}
	}
}
