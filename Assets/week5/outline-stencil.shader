Shader "Week5/OutlineStencil"
{
	
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", float) = 0
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Stencil {
			Ref 4
			ReadMask 255
			WriteMask 255
			Comp equal
			Pass keep
			Fail keep
			ZFail keep
		}

		Pass
		{
			ZTest always
			ZWrite off
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float _Scale;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + float4(v.normal*_Scale, 0));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0,0,0,1);
				return col;
			}
			ENDCG
		}
	}
}
