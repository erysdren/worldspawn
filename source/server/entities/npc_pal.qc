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

class npc_pal {
	void() npc_pal;
	virtual void() use;
};

void npc_pal::npc_pal()
{
	this.solid = SOLID_BBOX;
	this.movetype = MOVETYPE_NONE;

	precache_model("models/sprites/pal.iqm");
	setmodel(this, "models/sprites/pal.iqm");
	setsize(this, [-32, -32, -32], [32, 32, 32]);
}

void npc_pal::use()
{
	printf("meow!\n");
}
