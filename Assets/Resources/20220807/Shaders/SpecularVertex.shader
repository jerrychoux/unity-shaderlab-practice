Shader "Jerry/20220807/SpecularVertex"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8, 256)) = 10
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
            fixed4 _SpecularColor;
            fixed _Gloss;

            struct c2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(c2v data)
            {
                v2f ret;

                fixed3 worldNormal = normalize(UnityObjectToWorldNormal(data.vertex));
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, data.vertex).xyz);
                fixed3 reflectDir = normalize(reflect(-_WorldSpaceLightPos0.xyz, worldNormal));
                float3 diffuse = _DiffuseColor * _LightColor0.rgb * max(0, dot(worldNormal, worldLightDir));
                float3 specular = _SpecularColor * _LightColor0.rgb * pow(max(0, dot(viewDir, reflectDir)), _Gloss);
                
                ret.color = diffuse + specular;
                ret.pos = UnityObjectToClipPos(data.vertex);

                return ret;
            }

            fixed4 frag(v2f data) : SV_TARGET
            {
                return fixed4(data.color, 1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}
