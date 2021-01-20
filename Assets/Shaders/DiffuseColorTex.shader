Shader "Custom/DiffuseColorTex"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)  // (r, g, b, a)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _MainTex;
            float4 _Albedo;

            struct Input
            {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = texColor * _Albedo;
            }

        ENDCG
    }
}
