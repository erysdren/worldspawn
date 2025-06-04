/*
Copyright (C) 1996-1997 Id Software, Inc.
Copyright (C) 2002-2025 Forethought Entertainment
Copyright (C) 2019-2025 LibreQuake Project Contributors
Copyright (C) 2025 erysdren (it/its)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see https://www.gnu.org/licenses/
*/

#if 0
static var bool physgun_active = false;
static var spline_t *physgun_spline = NULL;

static var entity viewmodel = NULL;
#endif

static var bool skyroom_set = false;
static var vector skyroom_pos = [0, 0, 0];

void init(float prevprogs)
{
#ifdef ADDON
	addon_init();
#endif
}

void CSQC_RendererRestarted(string rendererdescription)
{

}

void CSQC_Init(float apilevel, string enginename, float engineversion)
{
#if 0
	// setup spline
	physgun_spline = spline_alloc(4, 0, 0, 0);

	// setup beam shader
	shaderforname("physgun_beam", "{\n{\nmap gfx/slappyhandarm.png\nblendfunc blend\n}\n}\n");
	shaderforname("physgun_hand", "{\n{\nmap gfx/slappyhand.png\nblendfunc blend\n}\n}\n");

	// precache
	precache_pic("gfx/phys.png");

	// setup viewmodel
	viewmodel = spawn();
	viewmodel.drawmask = MASK_VIEWMODEL;
	viewmodel.renderflags |= RF_VIEWMODEL;
	viewmodel.effects |= EF_NOSHADOW;
	precache_model("progs/v_light.mdl");
	setmodel(viewmodel, "progs/v_light.mdl");
#endif
}

void CSQC_Shutdown()
{
#if 0
	spline_free(physgun_spline);

	remove(viewmodel);
#endif
}

void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	vector vsize = [vwidth, vheight];

	clearscene();

	setproperty(VF_DRAWENGINESBAR, TRUE);
	setproperty(VF_DRAWCROSSHAIR, TRUE);
	setproperty(VF_DRAWWORLD, TRUE);

	if (skyroom_set)
	{
		float scale = 16; // FIXME: user-settable from sky_camera entity
		vector pos = getproperty(VF_ORIGIN);
		vector offset = [pos.x / scale, pos.y / scale, pos.z / scale];
		setproperty(VF_SKYROOM_CAMERA, skyroom_pos + offset);
	}

	addentities(MASK_ENGINE | MASK_VIEWMODEL);

#if 0
	// draw physgun beam
	if (physgun_active)
	{
		makevectors(getproperty(VF_ANGLES));

		vector src = getproperty(VF_ORIGIN) + v_forward * 32/* + v_right * 16 */- v_up * 16;
		vector dst = [getstatf(STAT_USER), getstatf(STAT_USER + 1), getstatf(STAT_USER + 2)];

		// setup spline
		physgun_spline->keys[0] = src;
		physgun_spline->keys[1] = src + v_forward * 32;
		physgun_spline->keys[2] = dst - v_forward * 8 - v_up * 32;
		physgun_spline->keys[3] = dst - v_forward * 8 - v_up * 8;

#if 0
#define STEP 0.125
		R_BeginPolygon("physgun_beam");
		for (float i = 0; i < physgun_spline->num_keys - 1; i += STEP * 2)
		{
			vector a = spline_interpolate(physgun_spline, i);
			vector b = a + v_right * 8;
			vector c = spline_interpolate(physgun_spline, i + STEP);
			vector d = c + v_right * 8;
			R_PolygonVertex(a, [1, 1], [1, 1, 1], 1);
			R_PolygonVertex(b, [1, 0], [1, 1, 1], 1);
			R_PolygonVertex(c, [0, 0], [1, 1, 1], 1);
			R_PolygonVertex(d, [0, 1], [1, 1, 1], 1);
		}
		R_EndPolygon();
#undef STEP
#endif

		// draw spline
#define STEP 0.25
#define SIZE 8
		R_BeginPolygon("physgun_beam");
		R_PolygonVertex(physgun_spline->keys[0], [0, 0], [1, 1, 1], 1);
		for (float i = STEP; i < physgun_spline->num_keys - 1; i += STEP)
		{
			R_PolygonVertex(spline_interpolate(physgun_spline, i), [0, 0], [1, 1, 1], 1);
		}
		R_PolygonVertex(physgun_spline->keys[physgun_spline->num_keys - 1], [0, 0], [1, 1, 1], 1);
		R_EndPolygonRibbon(SIZE, [1, 1]);
#undef SIZE
#undef STEP

		// draw hand
		float sz = 8;
		R_BeginPolygon("physgun_hand");
		R_PolygonVertex(dst - v_forward * sz - v_right * sz - v_up * sz, [1, 1], [1, 1, 1], 1);
		R_PolygonVertex(dst - v_forward * sz - v_right * sz + v_up * sz, [1, 0], [1, 1, 1], 1);
		R_PolygonVertex(dst - v_forward * sz + v_right * sz + v_up * sz, [0, 0], [1, 1, 1], 1);
		R_PolygonVertex(dst - v_forward * sz + v_right * sz - v_up * sz, [0, 1], [1, 1, 1], 1);
		R_EndPolygon();
	}
#endif

	renderscene();

#if 0
	vector sz = drawgetimagesize("gfx/phys.png");
	drawpic(vsize - sz + [0, 32], "gfx/phys.png", sz);
#endif

	chat_draw(vsize);
}

float CSQC_ConsoleCommand(string cmd)
{
	int argc = tokenize(cmd);

	switch (argv(0))
	{
		default:
		{
			return FALSE;
		}
	}
}

void CSQC_Input_Frame()
{

}

void CSQC_Parse_Event()
{
	switch (readbyte())
	{
#if 0
		case EVENT_PHYSGUN_STATE:
		{
			physgun_active = readbyte();
			break;
		}
#endif

		default:
		{
			break;
		}
	}
}

float CSQC_InputEvent(float evtype, float scanx, float chary, float devid)
{
	return FALSE;
}

void CSQC_Parse_Print(string printmsg, float printlvl)
{
	float lvl = cvar("msg");

	if (printlvl == PRINT_CHAT)
	{
		chat_add(printmsg);
		print(printmsg);
	}
	else if (printlvl >= lvl)
	{
		print(printmsg);
	}
}

void CSQC_Ent_Update(float isnew)
{
	float type = readbyte();
	float sendflags = readbyte();
	switch (type)
	{
		case SHAREDENT_SKY_CAMERA:
		{
			if (sendflags & SENDFLAG_ORIGIN)
			{
				self.origin.x = readcoord();
				self.origin.y = readcoord();
				self.origin.z = readcoord();
				setorigin(self, self.origin);

				skyroom_pos = self.origin;
				skyroom_set = true;
			}

			break;
		}
	}
}

void CSQC_Ent_Remove()
{
	remove(self);
}
