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

#define NULL __NULL__

#define DEG2RAD(x) ((x) * M_PI/180.0f)
#define RAD2DEG(x) ((x) * 180.0f/M_PI)

#define printf(...) print(sprintf(__VA_ARGS__))

typedef enum { false, true } bool;

// multicast events
enum {
	EVENT_PHYSGUN_STATE = 1
};

// shared entity types
enum {
	SHAREDENT_SKY_CAMERA
};

// shared entity sendflags
enumflags {
	SENDFLAG_ORIGIN, // 1
	SENDFLAG_ANGLES, // 2
	SENDFLAG_UNUSED3, // 4
	SENDFLAG_UNUSED4, // 8
	SENDFLAG_UNUSED5, // 16
	SENDFLAG_UNUSED6, // 32
	SENDFLAG_UNUSED7, // 64
	SENDFLAG_MODELINDEX // 128
};

float vlen2d(vector v)
{
	v.z = 0;
	return vlen(v);
}

#ifdef ADDON

vector *ptr_trace_endpos;
#define trace_endpos (*ptr_trace_endpos)

vector *ptr_trace_plane_normal;
#define trace_plane_normal (*ptr_trace_plane_normal)

entity *ptr_trace_ent;
#define trace_ent (*ptr_trace_ent)

entity *ptr_self;
#define self (*ptr_self)

void addon_init()
{
	ptr_trace_endpos = (vector *)externvalue(0, "&trace_endpos");
	ptr_trace_plane_normal = (vector *)externvalue(0, "&trace_plane_normal");
	ptr_trace_ent = (entity *)externvalue(0, "&trace_ent");
	ptr_self = (entity *)externvalue(0, "&self");
}

#endif
