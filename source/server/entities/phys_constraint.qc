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

class phys_constraint {
	void() phys_constraint;
	virtual void() think;
};

void phys_constraint::phys_constraint()
{
	this.solid = SOLID_NOT;
	this.movetype = MOVETYPE_NONE;
	this.nextthink = time + 0.1;
}

void phys_constraint::think()
{
	if (this.target1) this.enemy = find(world, ::targetname, this.target1);
	if (this.target2) this.aiment = find(world, ::targetname, this.target2);
}
