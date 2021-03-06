﻿Shader "Hidden/QuadWarp"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Prop1 ("prop(bottom Left-Right)", Vector) = (0,0,1,0)
		_Prop2 ("prop(upper Left-Right)", Vector) = (0,1,1,1)
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200 ZTest Always Cull Off

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
				float2 uv1: TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _Prop1,_Prop2;
			
			v2f vert (appdata v)
			{
				float2 xy1 = lerp(_Prop1.xy, _Prop1.zw, v.vertex.x*0.5 + 0.5);
				float2 xy2 = lerp(_Prop2.xy, _Prop2.zw, v.vertex.x*0.5 + 0.5);
				float2 xy = lerp(xy1, xy2, v.vertex.y*0.5+0.5);

				v2f o;
				o.vertex = float4(xy - 0.5, 0, 0.5);
				o.uv = v.uv;
				o.uv1 = v.uv1;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
