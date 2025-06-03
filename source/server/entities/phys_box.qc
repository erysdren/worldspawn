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

class phys_box : CPhysicsEntity {
	void() phys_box;
};

void phys_box::phys_box()
{
	this.solid = SOLID_PHYSICS_BOX;
	this.geomtype = GEOMTYPE_BOX;
	this.movetype = MOVETYPE_PHYSICS;

	if (this.model)
	{
		precache_model(this.model);
		setmodel(this, this.model);
	}
	else
	{
		precache_model("models/classic64/box_01.iqm");
		setmodel(this, "models/classic64/box_01.iqm");
	}

	switch (this.model)
	{
		default:
		case "models/classic64/box_01.iqm":
			setsize(this, [-16, -16, -16], [16, 16, 16]);
			break;

		case "models/flatbox.iqm":
			setsize(this, [-16, -16, -4], [16, 16, 4]);
			break;

		case "models/tallbox.iqm":
			setsize(this, [-4, -4, -32], [4, 4, 32]);
			break;
	}
}
