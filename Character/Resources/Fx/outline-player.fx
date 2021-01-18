#include "mta-helper.fx"

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = MTACalcScreenPosition ( VS.Position );
    PS.TexCoord = VS.TexCoord;
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );

	float3 WorldNormal = MTACalcWorldNormal( VS.Normal );
    PS.Diffuse *= gMaterialDiffuse;

    return PS;
}

float4 ps_main( float2 tex : TEXCOORD0 ) : COLOR0 {  
   float4 color = tex2D( Sampler0, tex.xy );
   color.a = 0.1f;
   color.rgb -= 0.4;
   return color;
}


technique tec0
{
    pass P0
    {
        PixelShader = compile ps_2_0 ps_main();
        ZWriteEnable = TRUE;
        DepthBias = -0.4f;
    }
    pass P1 {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        ZWriteEnable = TRUE;
        DepthBias = -0.3f;
    }
}

technique fallback
{
    pass P0
    {

    }
}