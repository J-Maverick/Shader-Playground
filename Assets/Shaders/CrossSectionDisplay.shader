Shader "Unlit/CrossSection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StencilMask("Stencil Mask", Range(0, 255)) = 255
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100



        Pass
        {
            
            Stencil
            {
                Ref [_StencilMask]
                Comp Equal
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                float3 worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
                // o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex = mul(UNITY_MATRIX_VP, float4(worldPos, 1));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
