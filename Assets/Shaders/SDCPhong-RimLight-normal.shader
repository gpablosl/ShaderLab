Shader "Custom/PhongRimlightNormal"
{
    Properties
    {
        _Albedo("Albedo color", Color) = (1,1,1,1)
        _SpecularColor("Specular color", Color) = (1,1,1,1)
        _SpecularPower("Specular power", Range(1.0, 10.0)) = 5.0
        _SpecularGloss("Specular gloss", Range(1,15)) = 1
        _GlossSteps("Gloss steps", Range(1,8)) = 4
        [HDR] _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0
        _NormalTex("Normal Texture", 2D) = "bump" {}
        _NormalStrength("Normal stregth", Range(-5,5)) = 1.0
        [MainColor] _Color("Color layer", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf PhongRimLightNormalCustom

            half4 _Albedo;
            half4 _SpecularColor;
            half _SpecularPower;
            half _SpecularGloss; 
            half _GlossSteps;

            half4 _Color;
            half4 _RimColor;
            float _RimPower;

            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _NormalStrength;


            half4 LightingPhongRimLightNormalCustom(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                half NdotL = max(0, dot(s.Normal, lightDir));
                half3 reflectedLight = reflect(-lightDir, s.Normal);
                half RdotV = max(0,dot(reflectedLight, viewDir));
                half3 specularity = pow(RdotV, _SpecularGloss/_GlossSteps) * _SpecularPower * _SpecularColor.rgb;
                half4 c;
                c.rgb = (NdotL * s.Albedo + specularity) * _LightColor0.rgb * atten;
                c.a = s.Alpha;
                b.rgb = 
                return c;
            }

            struct Input
            {
                float3 viewDir;
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalColor);
                normal.z = normal.z / _NormalStrength;
                o.Normal = normal;
                o.Albedo = _Albedo.rgb;
                float3 nVwd = normalize(IN.viewDir);
                float3 NdotV = dot(nVwd, o.Normal);
                fixed rim = 1- saturate(NdotV);
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);

            }

        ENDCG
    }
}
