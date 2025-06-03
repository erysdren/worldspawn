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

class func_breakable {
	void() func_breakable;
	virtual void(entity attacker, float damage) th_pain;
	virtual void() th_die;
};

void func_breakable::func_breakable()
{
	this.takedamage = DAMAGE_YES;
	if (this.health <= 0) this.health = 100;

	this.solid = SOLID_BSP;
	this.movetype = MOVETYPE_NONE;
	setmodel(this, this.model);
}

void func_breakable::th_pain(entity attacker, float damage)
{

}

void func_breakable::th_die()
{
	remove(this);
}
