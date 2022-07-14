Shader "Unlit/CrossSectionCreate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StencilMask("Stencil Mask", Range(0, 255)) = 255
        _MinY("Min Y", float) = 0
        _MaxY("Max Y", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend Zero One
        Stencil
		{
			Ref [_StencilMask]
            Comp Always
            Pass Replace
        }

        cull Back
        Pass
        {
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
                bool use_vert: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _MinY;
            float _MaxY;

            v2f vert (appdata v)
            {
                v2f o;
                if (_MinY <= v.vertex.x <= _MaxY) 
                {
                    o.use_vert = true;
                }
                else o.use_vert = false;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                if (!i.use_vert) discard;
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
            cull Front
        }
    }
}
