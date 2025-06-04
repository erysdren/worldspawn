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

void init(float prevprogs)
{
#ifdef ADDON
	addon_init();
#endif
}

#ifndef ADDON

void main()
{

}

void StartFrame()
{

}

void EndFrame()
{

}

#if 0
static void HeldPropCustomPhysics()
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
}
#endif

void PlayerPreThink()
{
	if (self.button2 && (self.flags & FL_ONGROUND || (self.flags & FL_ONGROUND && self.groundentity)))
		self.velocity.z = 270;

	if (time < self.mReadyTime)
		return;

	// physgun hold
	if (self.button0)
	{
		if (!self.mHeldProp)
		{
			makevectors(self.v_angle);
			vector src = self.origin + self.view_ofs;
			vector dst = src + v_forward * 512;

			traceline(src, dst, MOVE_NORMAL, self);

			if (trace_ent && trace_ent.movetype == MOVETYPE_PHYSICS)
			{
				physgun_attach(self, trace_ent, trace_endpos);
			}
		}

		self.mReadyTime = time + 0.1;
	}
	else if (self.mHeldProp)
	{
		physgun_detach(self);
	}

#if 0
	// gravity gun punt
	if (self.button0 && !self.button3)
	{
		makevectors(self.v_angle);
		vector src = self.origin + self.view_ofs;
		vector dst = src + v_forward * 256;

		traceline(src, dst, MOVE_NORMAL, self);

		if (trace_ent && trace_ent.movetype == MOVETYPE_PHYSICS)
		{
			physics_addforce(trace_ent, v_forward * (256 - vlen(self.origin - trace_endpos)), trace_endpos - trace_ent.origin);
		}

		self.mReadyTime = time + 0.4;
	}
#endif
}

void PlayerPostThink()
{

}

void ClientKill()
{

}

void ClientConnect()
{

}

void DecodeChangeParms()
{
	self.health = parm1;
}

void PutClientInServer()
{
	clientstat(STAT_USER, EV_VECTOR, mHeldPropPosition);

	entity spot = find(world, classname, "info_player_start");

	if (spot)
	{
		setorigin(self, spot.origin);
		self.angles = spot.angles;
	}
	else
	{
		setorigin(self, [0, 0, 0]);
		self.angles = [0, 0, 0];
	}

	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_SLIDEBOX;
	self.geomtype = GEOMTYPE_CAPSULE;
	self.movetype = MOVETYPE_WALK;
	self.fixangle = TRUE;
	setsize(self, [-16, -16, -36], [16, 16, 36]);
	self.view_ofs = [0, 0, 28];
	self.flags |= FL_CLIENT;
	self.classname = "player";
	self.mass = 1;
	self.friction = 1;
	self.gravity = 1;
	setmodel(self, "models/tallbox.iqm");

	DecodeChangeParms();
}

void ClientDisconnect()
{

}

void SetNewParms()
{
	parm1 = 100;
}

void SetChangeParms()
{
	parm1 = self.health;
}

void SpectatorConnect()
{

}

void SpectatorDisconnect()
{

}

void SpectatorThink()
{

}

void SV_ParseClientCommand(string cmd)
{
	clientcommand(self, cmd);
}

void SV_PausedTic(float paused_time)
{

}

float SV_ShouldPause(float new_status)
{
	return TRUE;
}

void SV_RunClientCommand()
{
	runstandardplayerphysics(self);
}

#endif // ADDON
