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

class sky_camera {
	void() sky_camera;
	virtual float(entity to, float sendflags) SendEntity;
};

void sky_camera::sky_camera()
{
	this.pvsflags |= PVSF_IGNOREPVS;
	this.SendFlags |= SENDFLAG_ORIGIN;
}

float sky_camera::SendEntity(entity to, float sendflags)
{
	// mask sendflags for 1 byte
	sendflags &= 0xFF;

	// write entity header
	WriteByte(MSG_ENTITY, SHAREDENT_SKY_CAMERA);
	WriteByte(MSG_ENTITY, sendflags);

	// write origin
	if (sendflags & SENDFLAG_ORIGIN)
	{
		WriteCoord(MSG_ENTITY, self.origin.x);
		WriteCoord(MSG_ENTITY, self.origin.y);
		WriteCoord(MSG_ENTITY, self.origin.z);
	}

	return TRUE;
}
