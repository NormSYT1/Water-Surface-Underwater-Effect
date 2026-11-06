Shader "Original Water/Surface FX"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.05, 0.35, 0.45, 0.85)
        _DeepColor ("Deep Color", Color) = (0.01, 0.12, 0.20, 1.0)
        _PrimaryNormal ("Primary Normal Map", 2D) = "bump" {}
        _SecondaryNormal ("Secondary Normal Map", 2D) = "bump" {}
        _NormalStrength ("Normal Strength", Range(0,2)) = 0.6
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 3.0
        _Smoothness ("Smoothness", Range(0,1)) = 0.85
        _PrimaryFlowOffset ("Primary Flow Offset", Vector) = (0,0,0,0)
        _SecondaryFlowOffset ("Secondary Flow Offset", Vector) = (0,0,0,0)
        
        [Header(Shore Foam)]
        _FoamColor ("Foam Color", Color) = (0.90, 0.97, 1.0, 0.95)
        _FoamDistance ("Foam Distance", Range(0.05, 5.0)) = 1.5
        _FoamNoiseCutoff ("Foam Noise Factor", Range(0.0, 2.0)) = 0.5
        _FoamSpeed ("Foam Speed", Float) = 0.8
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard alpha:fade vertex:vert
        #pragma target 3.0
        #include "UnityCG.cginc"

        UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

        sampler2D _PrimaryNormal;
        sampler2D _SecondaryNormal;

        struct Input
        {
            float2 uv_PrimaryNormal;
            float2 uv_SecondaryNormal;
            float3 viewDir;
            float4 screenPos;
        };

        fixed4 _BaseColor;
        fixed4 _DeepColor;
        half _NormalStrength;
        half _FresnelPower;
        half _Smoothness;
        float4 _PrimaryFlowOffset;
        float4 _SecondaryFlowOffset;

        fixed4 _FoamColor;
        half _FoamDistance;
        half _FoamNoiseCutoff;
        half _FoamSpeed;

        void vert(inout appdata_full v)
        {
            // Reserved for future vertex-driven swell/displacement.
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uvA = IN.uv_PrimaryNormal + _PrimaryFlowOffset.xy;
            float2 uvB = IN.uv_SecondaryNormal + _SecondaryFlowOffset.xy;

            half3 nA = UnpackNormal(tex2D(_PrimaryNormal, uvA));
            half3 nB = UnpackNormal(tex2D(_SecondaryNormal, uvB));
            half3 blendedNormal = normalize(half3(nA.xy + nB.xy, nA.z * nB.z));
            blendedNormal = lerp(half3(0,0,1), blendedNormal, _NormalStrength);

            half fresnel = pow(1.0 - saturate(dot(normalize(IN.viewDir), blendedNormal)), _FresnelPower);
            fixed4 col = lerp(_DeepColor, _BaseColor, fresnel);

            // Shoreline Foam calculation using CameraDepthTexture
            float sceneDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos)));
            float surfaceDepth = IN.screenPos.w;
            float depthDiff = sceneDepth - surfaceDepth;

            if (depthDiff > 0.0 && depthDiff < _FoamDistance)
            {
                float foamFactor = 1.0 - (depthDiff / _FoamDistance);
                float waveOffset = sin(_Time.y * _FoamSpeed * 3.14159 + (uvA.x + uvA.y) * 20.0) * 0.15;
                float foamNoise = (nA.x * nB.y) * 1.5 + waveOffset;
                float foamAmount = saturate(foamFactor + foamNoise * _FoamNoiseCutoff);
                foamAmount = smoothstep(0.15, 0.65, foamAmount) * _FoamColor.a;

                col.rgb = lerp(col.rgb, _FoamColor.rgb, foamAmount);
                col.a = saturate(col.a + foamAmount * 0.35);
                _Smoothness = lerp(_Smoothness, 0.25, foamAmount);
            }

            o.Albedo = col.rgb;
            o.Normal = blendedNormal;
            o.Smoothness = _Smoothness;
            o.Metallic = 0.0;
            o.Alpha = col.a;
        }
        ENDCG
    }

    FallBack "Transparent/Diffuse"
}
