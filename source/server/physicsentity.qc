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

class CPhysicsEntity {
	static const float SPAWNFLAG_START_DISABLED = 1 << 0;
	float bouyency;
	float mCurrentContents;
	vector mWaterEnteredPos;
	bool mIsInWater;
	bool mPhysicsState;
	void() CPhysicsEntity;
	virtual void() EnablePhysics;
	virtual void() DisablePhysics;
	virtual void() TogglePhysics;
	virtual void() use;
	virtual void() touch;
	virtual void() customphysics;

	// used when loaded above a standard Quake progs
	virtual void(entity attacker, float damage) th_pain;
	virtual void() th_die;
};

void CPhysicsEntity::CPhysicsEntity()
{
	// sensible defaults
	if (this.mass <= 0) this.mass = 10;
	if (this.gravity <= 0) this.gravity = 1;
	if (this.friction <= 0) this.friction = 1;
	if (this.damp_angular <= 0) this.damp_angular = 0.3;
	if (this.damp_linear <= 0) this.damp_linear = 0.3;
	if (this.max_angular <= 0) this.max_angular = 0.25 * M_PI * 60;
	if (this.scale <= 0) this.scale = 1;
	if (this.bouyency <= 0) this.bouyency = 12;

	this.takedamage = DAMAGE_YES;
	if (this.health <= 0) this.health = 100;

	setmodel(this, this.model);
	setsize(this, this.mins * this.scale, this.maxs * this.scale);

	if (this.spawnflags & SPAWNFLAG_START_DISABLED)
	{
		this.DisablePhysics();
	}
	else
	{
		this.EnablePhysics();
	}

	this.mCurrentContents = pointcontents(this.origin);
}

void CPhysicsEntity::EnablePhysics()
{
	physics_enable(this, true);
	this.mPhysicsState = true;
}

void CPhysicsEntity::DisablePhysics()
{
	physics_enable(this, false);
	this.mPhysicsState = false;
}

void CPhysicsEntity::TogglePhysics()
{
	physics_enable(this, !this.mPhysicsState);
	this.mPhysicsState = !this.mPhysicsState;
}

void CPhysicsEntity::use()
{
	this.TogglePhysics();
}

void CPhysicsEntity::touch()
{
	printf("%s touched by %s\n", this.classname, other.classname);
}

void CPhysicsEntity::customphysics()
{
	float newcontents = pointcontents(this.origin);

	if (newcontents != this.mCurrentContents)
	{
		if (newcontents == CONTENT_WATER)
		{
			this.mIsInWater = true;
			this.mWaterEnteredPos = this.origin;
		}
		else
		{
			this.mIsInWater = false;
		}
	}

	this.mCurrentContents = newcontents;

	if (this.mIsInWater)
	{
		vector surfacepos = [this.origin.x, this.origin.y, this.mWaterEnteredPos.z];
		float depth = vlen(this.origin - surfacepos);

		physics_addforce(this, [0, 0, this.bouyency] * depth, this.origin);
	}
}

void CPhysicsEntity::th_pain(entity attacker, float damage)
{
	// this is just boldly assuming that trace_endpos is set to where the damage landed, as is largely the case
	this.EnablePhysics();
	physics_addforce(this, (this.origin - attacker.origin) * damage, trace_endpos);
}

void CPhysicsEntity::th_die()
{
	this.DisablePhysics();
	remove(this);
}
