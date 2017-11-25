Shader "week4/blinnphong"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members diff)
#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc" // _WorldSpaceLightPos0, _LightColor0

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal: NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normal: TEXCOORD1;
				float3 v : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.v = normalize(WorldSpaceViewDir(v.vertex));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 light = _WorldSpaceLightPos0.xyz;
				float3 worldNormal = UnityObjectToWorldNormal(i.normal);
				float nl = saturate(dot(worldNormal, light));
				float diff = nl * _LightColor0;

				float spec = pow(dot(worldNormal, normalize(light + i.v)), 100);

				fixed4 col = fixed4(1, 0, 0, 1) * (diff)+ spec;
				return fixed4(pow(col.r, 1/2.2), pow(col.g, 1/2.2), pow(col.b, 1/2.2), 1);
			}
			ENDCG
		}
	}
}
