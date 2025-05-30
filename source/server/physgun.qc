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

static void physgun_dummy_customphysics()
{
	makevectors(self.owner.v_angle);
	vector idealpos = self.owner.origin + self.owner.view_ofs + (v_forward * self.mHeldDistance);
	vector diff = idealpos - self.origin;
	vector vel = normalize(diff) * 256;

	tracebox(self.origin, self.mins, self.maxs, self.origin + vel * frametime, MOVE_NOMONSTERS, self);

	if (vlen(diff) < self.mHeldDistance && !trace_startsolid)
	{
		setorigin(self, idealpos);
		self.velocity = self.owner.velocity;
	}
	else
	{
		self.velocity = vel;
	}

	makevectors(self.owner.mHeldProp.angles);
	vector ofs = self.owner.mHeldProp.mHeldFrom;
	vector tofs = v_forward * ofs.x - v_right * ofs.y + v_up * ofs.z;
	self.owner.mHeldPropPosition = self.owner.mHeldProp.origin + tofs;
}

void physgun_attach(entity own, entity held, vector pos)
{
	entity dummy;

	// enable physics on held prop
	// and set owner
	physics_enable(held, TRUE);
	held.owner = own;

	makevectors(held.angles);
	held.mHeldFrom = [
		dotproduct(pos - held.origin, v_forward),
		dotproduct(pos - held.origin, -v_right),
		dotproduct(pos - held.origin, v_up)
	];

	// setup owner
	own.mHeldProp = held;

	// setup dummy
	dummy = spawn();
	dummy.classname = "_physgun_dummy";
	dummy.solid = SOLID_NOT;
	dummy.geomtype = GEOMTYPE_BOX;
	dummy.movetype = MOVETYPE_PHYSICS;
	dummy.owner = own;
	dummy.mass = 10;
	dummy.gravity = 1;
	dummy.friction = 1;
	dummy.damp_angular = 0.3;
	dummy.damp_linear = 0.3;
	dummy.max_angular = 0.25 * M_PI * 60;
	dummy.mHeldDistance = 128;
	dummy.customphysics = physgun_dummy_customphysics;
	setsize(dummy, [-4, -4, -4], [4, 4, 4]);
	setorigin(dummy, pos);

	// setup constraint
	own.mHeldPropConstraint = spawn();
	own.mHeldPropConstraint.classname = "_physgun_constraint";
	own.mHeldPropConstraint.solid = SOLID_NOT;
	own.mHeldPropConstraint.movetype = MOVETYPE_NONE;
	own.mHeldPropConstraint.jointtype = JOINTTYPE_FIXED;
	own.mHeldPropConstraint.aiment = held;
	own.mHeldPropConstraint.enemy = dummy;
	own.mHeldPropConstraint.owner = own;
	setorigin(own.mHeldPropConstraint, pos);

	// send multicast to enable client beam
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, EVENT_PHYSGUN_STATE);
	WriteByte(MSG_MULTICAST, true);
	msg_entity = own;
	multicast(own.origin, MULTICAST_ONE_R);
}

void physgun_detach(entity own)
{
	if (own.mHeldPropConstraint)
	{
		if (own.mHeldPropConstraint.enemy)
			remove(own.mHeldPropConstraint.enemy);
		remove(own.mHeldPropConstraint);
		own.mHeldPropConstraint = NULL;
	}

	if (own.mHeldProp)
	{
		physics_enable(own.mHeldProp, TRUE);
		own.mHeldProp.owner = NULL;
		own.mHeldProp = NULL;
	}

	// send multicast to enable client beam
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, EVENT_PHYSGUN_STATE);
	WriteByte(MSG_MULTICAST, false);
	msg_entity = own;
	multicast(own.origin, MULTICAST_ONE_R);
}
