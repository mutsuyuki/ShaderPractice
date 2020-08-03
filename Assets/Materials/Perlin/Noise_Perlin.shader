Shader "Custom/Noise_Perlin"
{
    Properties
    {
        _GridSize ("GridSize", float) = 1.0
        _X ("Seed X", float) = 1.0
        _Y ("Seed Y", float) = 1.0
        
        _noiseX("noise X", float) = 0.0
        _noiseY("noise Y", float) = 0.0
        _noiseZ("noise Z", float) = 0.0
        _noiseNormal("noise Normal", float) = 1.0
    }
 
    SubShader
    {
        Tags { "RenderType"="Opaque" }
 
        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "../_ShaderLib/noise.cginc"
 
            float _GridSize;
            float _X;
            float _Y;
            float _noiseX;
            float _noiseY;
            float _noiseZ;
            float _noiseNormal;
            
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
                float2 perlinParam = v.uv * _GridSize + float2(_X + _Time.z, _Y + _Time.z);
                float PerlinNoise = PerlinNoise2D(perlinParam) * 0.5f;
                
                float4 newVertex = v.vertex;
                newVertex += float4(v.normal * PerlinNoise * _noiseNormal, 0.0);
                newVertex += float4(PerlinNoise * _noiseX, 0.0, 0.0, 0.0);
                newVertex += float4(0.0, PerlinNoise * _noiseY, 0.0, 0.0);
                newVertex += float4(0.0, 0.0, PerlinNoise * _noiseZ, 0.0);
                
                o.vertex = UnityObjectToClipPos(newVertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
         
            fixed4 frag (v2f i) : SV_Target
            {
                float2 perlinParam = i.uv * _GridSize + float2(_X + _Time.z, _Y + _Time.z);
                float ns = PerlinNoise2D(perlinParam) / 2 + 0.5f;
                return float4(
                    ns - _CosTime.x / 2 + 0.5f,
                    ns - _CosTime.y / 2 + 0.5f,
                    ns - _CosTime.z / 2 + 0.5f,
                    1.0f
                );
            }
            ENDCG
        }
    }
}
