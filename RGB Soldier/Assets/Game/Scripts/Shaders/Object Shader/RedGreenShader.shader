﻿Shader "RedGreenShader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        _EffectAmount ("Effect Amount", Range (0, 1)) = 1.0
    }
 
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
 
        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
 
        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile DUMMY PIXELSNAP_ON
            #include "UnityCG.cginc"
           
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
            };
           
            fixed4 _Color;
 
            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color;
                #ifdef PIXELSNAP_ON
                OUT.vertex = UnityPixelSnap (OUT.vertex);
                #endif
 
                return OUT;
            }
 
            sampler2D _MainTex;
            uniform float _EffectAmount;
 
            fixed4 frag(v2f IN) : COLOR
            {
                half4 orig = tex2D (_MainTex, IN.texcoord);   
				
				fixed4 color;
				v2f OUT;

				if(orig.r >= orig.b && orig.r >= orig.g){
					OUT.color = fixed4(orig.r*1.5, orig.g*0.75, orig.b*1.2, orig.a);
				}else if (orig.g > orig.b && orig.g > orig.b) {
					OUT.color = fixed4(orig.r, orig.g*1.2, orig.b, orig.a);
				}else if(orig.b > orig.g && orig.b > orig.r){
					OUT.color = fixed4(orig.r*1.5, orig.g*0.5, orig.b*1.2, orig.a);
				}else{
					OUT.color = fixed4(orig.r*1.5, orig.g*0.75, orig.b*1.2, orig.a);
				}

				color = OUT.color * _Color;
                return color;
            }
        ENDCG
        }
    }
}