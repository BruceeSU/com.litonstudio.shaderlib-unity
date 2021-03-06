Shader "LitonStudio/Effects/Rotator"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RotateSpeed("Rotate Speed",float) = 2.0
        [Enum(CullMode)]_Cull("Cull Mode",float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull [_Cull]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _RotateSpeed;
            Texture2D _MainTex;
            SamplerState linear_clamp_sampler;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv - 0.5;
                float c, s;
                sincos(_Time.y * _RotateSpeed, c, s);
                uv = mul(float2x2(c ,s ,-s, c), uv);
                i.uv = uv + 0.5;

                fixed4 col = _MainTex.Sample(linear_clamp_sampler, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
