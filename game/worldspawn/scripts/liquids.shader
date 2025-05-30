
liquids/water01a
{
	deformVertexes wave 256 sin 0 1 0.1 0.5
	{
		map textures/liquids/water01a_bottom.png
		blendfunc blend
		alphagen const 0.25
		tcMod scale 0.5 0.5
		tcMod turb 1 0.1 0.5 0.04
		tcMod scroll 0.0005 0.0005
	}
	{
		map textures/liquids/water01a_top.png
		blendfunc GL_ONE GL_ONE
		tcMod scale 0.5 0.5
		tcMod turb 0.5 0.075 0.5 0.02
		tcMod scroll 0.005 0.005
	}
	{
		map $lightmap
		blendfunc GL_DST_COLOR GL_ZERO
		rgbgen identity
	}
}
