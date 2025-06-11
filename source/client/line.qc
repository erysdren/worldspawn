
// https://www.gamedev.net/forums/topic/617595-solved-thick-constant-width-lines-using-quads/
void drawline3d(float width, vector start, vector end, vector rgb, float alpha, float drawflags=DRAWFLAG_NORMAL)
{
	vector line_direction = start - end;
	vector quad_normal = getproperty(VF_ORIGIN) - ((start + end) / 2);
	vector extrude_direction = normalize(crossproduct(line_direction, quad_normal));

	makevectors(getproperty(VF_ANGLES));
	vector rstart = v_forward * start.x - v_right * start.y + v_up * start.z;
	vector rend = v_forward * end.x - v_right * end.y + v_up * end.z;

	vector coords[4] = {
		[0, 0],
		[1, 0],
		[1, 1],
		[0, 1]
	};

	vector positions[4] = {
		start + extrude_direction * width / 2,
		end + extrude_direction * width / 2,
		end - extrude_direction * width / 2,
		start - extrude_direction * width / 2
	};

#if 0
	// project then negate z values
	for (int i = 0; i < 4; i++)
	{
		positions[i] = project(positions[i]);
		positions[i].z = -1;
		positions[i] = unproject(positions[i]);
	}
#endif

	// draw the thing
	R_BeginPolygon("gfx/conback", drawflags);
	R_PolygonVertex(positions[0], coords[0], rgb, alpha);
	R_PolygonVertex(positions[1], coords[1], rgb, alpha);
	R_PolygonVertex(positions[2], coords[2], rgb, alpha);
	R_PolygonVertex(positions[3], coords[3], rgb, alpha);
	R_EndPolygon();
}
