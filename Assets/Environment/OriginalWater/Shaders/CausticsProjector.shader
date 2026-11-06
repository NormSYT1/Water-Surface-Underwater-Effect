Shader "Original Water/Caustics Projector"
{
    Properties
    {
        _CausticsColor ("Caustics Color", Color) = (0.28, 0.72, 0.88, 1.0)
        _Intensity ("Intensity", Range(0, 5)) = 1.4
        _Scale ("Scale", Float) = 0.35
        _Speed ("Speed", Float) = 0.9
        _WaterHeight ("Water Height", Float) = 68.0
        _FadeDepth ("Fade Depth", Float) = 35.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent+100" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Pass
        {
            ZWrite Off
            ColorMask RGB
            Blend One One // Additive
            Offset -1, -1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 uvDecal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 pos : SV_POSITION;
            };

            float4x4 unity_Projector;
            fixed4 _CausticsColor;
            float _Intensity;
            float _Scale;
            float _Speed;
            float _WaterHeight;
            float _FadeDepth;

            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uvDecal = mul(unity_Projector, vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                return o;
            }

            float Caustics(float2 uv, float t)
            {
                float2 p = uv * _Scale;
                float2 p1 = p + float2(t * 0.35, t * 0.22);
                float2 p2 = p - float2(t * 0.28, -t * 0.31);
                
                float c1 = sin(p1.x * 2.8 + sin(p1.y * 1.8 + t)) * 0.5 + 0.5;
                float c2 = cos(p2.x * 2.2 + cos(p2.y * 3.1 - t)) * 0.5 + 0.5;
                float c3 = sin((p1.y + p2.x) * 2.0 + t * 0.8) * 0.5 + 0.5;
                
                float caustic = pow(min(min(c1, c2), c3), 1.8) * 3.5;
                return caustic;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                if (i.uvDecal.w <= 0.0) discard;

                float2 uv = i.uvDecal.xy / i.uvDecal.w;
                if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) discard;

                // Do not project above water surface
                if (i.worldPos.y > _WaterHeight - 0.1) discard;

                float c = Caustics(i.worldPos.xz, _Time.y * _Speed);
                
                // Depth attenuation: bright in shallows, fading in deep water
                float depthBelowWater = _WaterHeight - i.worldPos.y;
                float depthAtten = saturate(1.0 - (depthBelowWater / _FadeDepth));
                
                fixed4 col = _CausticsColor * (c * _Intensity * (0.35 + 0.65 * depthAtten));
                return col;
            }
            ENDCG
        }
    }
    FallBack Off
}