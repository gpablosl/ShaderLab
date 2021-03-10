Shader "Custom/v2fSolidColor"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque" 
            "Queue" = "Geometry"
        }

        Pass //Capas
        {
            //codigo
            CGPROGRAM

             #pragma vertex vertexShader
             #pragma fragment fragmentShader

             uniform fixed4 _Albedo;

             //funciones basicas de CG para Vertex 
             #include "UnityCG.cginc"

             struct vertexInput
             {
                 fixed4 vertex : POSITION;
             };

             struct vertexOutput
             {
                 fixed4 position : SV_POSITION;
                 fixed4 color : COLOR;
             };

             vertexOutput vertexShader(vertexInput i)
             {
                 vertexOutput o;

                 float x = i.vertex.x;
                 float y = i.vertex.y;
                 float z = i.vertex.z;
                 float w = 1;

                 i.vertex = float4(x, y, z, w); //Para no modificar la posicion original

                 o.position = mul(unity_ObjectToWorld, i.vertex);
                 o.position = mul(UNITY_MATRIX_V, o.position);
                 o.position = mul(UNITY_MATRIX_P, o.position);

                 o.color = _Albedo;

                 return o;
             }
             
             struct pixelOutput
             {
                 fixed4 pixel : SV_TARGET;
             };

             pixelOutput fragmentShader(vertexOutput o)
             {
                pixelOutput p;

                p.pixel = o.color;

                return p;
             }

            ENDCG
        }
    }
}

//Vertex - Fragment Shaders