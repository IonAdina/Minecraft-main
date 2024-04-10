Shader "Minecraft/Blocks"{

    Properties{
        _MainTex ("Block Texture Atlas", 2D) = "white" {}
    }

    SubShader{
        Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
        LOD 100
        Lighting Off

        Pass{

            CGPROGRAM
                #pragma vertex vertFunction
                #pragma fragment fragFunction
                #pragma target 2.0

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                    float color: COLOR;
                };

                struct v2f
                {
                    float4 vertex : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float color: COLOR;
                };

                sampler2D _MainTex;
                float GlobalLightLevel;

                v2f vertFunction (appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    o.color = v.color;
                    
                    return o;
                }

                fixed4 fragFunction (v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.uv);
                    float localLightLevel = clamp(GlobalLightLevel + i.color, 0, 1);
                    
                    // Aplicarea nivelului local de lumină la culoare
                    col.rgb *= localLightLevel;
                    
                    // Clipim în funcție de transparența finală a culorii
                    col.a = max(col.a - 0.5, 0); // Asigurăm că valoarea alfa este întotdeauna pozitivă
                    clip(col.a);
                    
                    return col;
                }

                ENDCG
        }
    }
}
