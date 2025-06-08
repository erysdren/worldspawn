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

/**
 * @brief an invisible explosion that only affects physics bodies
 * @field radius 256 search radius for physics bodies
 * @field force 32 force applied to each body (diminishes with distance)
 */
class env_physexplosion {
	void() env_physexplosion;
	virtual void() use;
};

void env_physexplosion::env_physexplosion()
{
	if (this.radius <= 0)
		this.radius = 256;
	if (this.force <= 0)
		this.force = 32;
}

void env_physexplosion::use()
{
	int num_nearby = 0;
	entity *nearby = findradius_list(this.origin, this.radius, num_nearby);
	for (int i = 0; i < num_nearby; i++)
	{
		if (nearby[i].movetype != MOVETYPE_PHYSICS)
			continue;

		vector dir = normalize(nearby[i].origin - this.origin);
		float dist = vlen(nearby[i].origin - this.origin) + 0.01; // present divide by zero

		physics_addforce(nearby[i], dir * this.force * (this.radius - dist), this.origin);
	}
}
