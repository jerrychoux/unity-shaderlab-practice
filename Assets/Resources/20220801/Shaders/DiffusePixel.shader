Shader "Jerry/20220801/DiffusePixel"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _DiffuseColor;

            struct c2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
            };

            v2f vert(c2v data)
            {
                v2f ret;

                ret.pos = UnityObjectToClipPos(data.vertex);
                ret.normal = UnityObjectToWorldNormal(data.normal);

                return ret;
            }

            fixed4 frag(v2f data) : SV_TARGET
            {
                fixed3 worldNormal = normalize(data.normal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 color = UNITY_LIGHTMODEL_AMBIENT.xyz + _DiffuseColor * _LightColor0.rgb * max(0, dot(worldNormal, worldLightDir));
                
                return fixed4(color, 1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}
