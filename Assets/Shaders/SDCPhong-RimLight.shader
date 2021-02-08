Shader "Custom/Phong-Rimlight"
{
    Properties
    {
        _Albedo("Albedo color", Color) = (1,1,1,1)
        _SpecularColor("Specular color", Color) = (1,1,1,1)
        _SpecularPower("Specular power", Range(1.0, 10.0)) = 5.0
        _SpecularGloss("Specular gloss", Range(1,5)) = 1
        _GlossSteps("Gloss steps", Range(1,8)) = 4
        [HDR] _RimColor("Rim Color", Color) = (1, 0, 0, 1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"

        }

        CGPROGRAM
            #pragma surface surf PhongCustom

            half4 _Albedo;
            half4 _SpecularColor;
            half _SpecularPower;
            half _SpecularGloss; 
            int _GlossSteps;

            half4 _RimColor;
            float _RimPower;


            half4 LightingPhongCustom(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                half NdotL = max(0, dot(s.Normal, lightDir));
                half3 reflectedLight = reflect(-lightDir, s.Normal);
                half RdotV = max(0,dot(reflectedLight, viewDir));
                half3 specularity = pow(RdotV, _SpecularGloss/_GlossSteps) * _SpecularPower * _SpecularColor.rgb;
                half4 c;
                c.rgb = (NdotL * s.Albedo + specularity) * _LightColor0.rgb * atten;
                c.a = s.Alpha;
                return c;
            }

            struct Input
            {
                float3 viewDir;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
                float3 nVwd = normalize(IN.viewDir);
                float3 NdotV = dot(nVwd, o.Normal);
                half rim = 1 - saturate(NdotV);
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            }

        ENDCG
    }
}
