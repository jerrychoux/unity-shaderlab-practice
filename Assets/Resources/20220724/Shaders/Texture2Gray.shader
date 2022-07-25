Shader "Jerry/20220724/Texture2Gray"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 tex : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.tex = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.tex);
                float grey = dot(color.rgb, fixed3(0.299, 0.587, 0.114));
                color.rgb = float3(grey, grey, grey);
                return color;
            }
            ENDCG
        }
    }
}
