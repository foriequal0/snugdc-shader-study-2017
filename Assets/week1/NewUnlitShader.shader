	Shader "SNUGDC/MyFragmentShader"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
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
			
			fixed4 frag (v2f i) : SV_Target
			{
				float radius = 0.1;
				float x = (_SinTime.w + 1)/2;
				float y = (_CosTime.w + 1)/2;
				if (sqrt(pow(i.uv.x - x, 2) + pow(i.uv.y - y, 2)) < radius) {
					return fixed4(1, 0, 0, 0);
				} 

				float2x2 rot = float2x2(
					_CosTime.w, -_SinTime.w,
					_SinTime.w, _CosTime.w
				);
				float2 k = mul(rot, float2(i.uv.x-0.5, i.uv.y-0.5));
				if (abs(k[0]) < 0.1 && abs(k[1]) < 0.1) {
					return fixed4(0, 1, 0, 0);
				}

				return fixed4(0, 0, 0, 0);
			}
			ENDCG
		}
	}
}