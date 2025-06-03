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

class prop_static {
	static const float SPAWNFLAG_NONSOLID = 1;
	void() prop_static;
};

void prop_static::prop_static()
{
	if (this.spawnflags & SPAWNFLAG_NONSOLID)
	{
		this.solid = SOLID_NOT;
		this.geomtype = GEOMTYPE_NONE;
	}
	else
	{
		this.solid = SOLID_PHYSICS_TRIMESH;
		this.geomtype = GEOMTYPE_TRIMESH;
	}

	this.movetype = MOVETYPE_NONE;
	this.mass = 0;

	precache_model(this.model);
	setmodel(this, this.model);
}
