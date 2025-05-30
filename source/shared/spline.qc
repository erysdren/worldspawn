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

typedef struct spline {
	vector *keys;
	int num_keys;
	float continuity;
	float bias;
	float tension;
} spline_t;

spline_t *spline_alloc(int num_keys, float continuity, float bias, float tension)
{
	spline_t *s = memalloc(sizeof(spline_t));
	s->keys = memalloc(sizeof(vector) * num_keys);
	s->num_keys = num_keys;
	s->continuity = continuity;
	s->bias = bias;
	s->tension = tension;
	return s;
}

void spline_free(spline_t *s)
{
	memfree(s->keys);
	memfree(s);
}

vector spline_interpolate(spline_t *s, float frm)
{
	int i, i_1, i0, i1, i2;
	float time1, time2, time3;
	float t1, t2, t3, t4, u1, u2, u3, u4, v1, v2, v3;
	float a, b, c, d;
	vector out = [0, 0, 0];

	a = (1 - s->tension) * (1 + s->continuity) * (1 + s->bias);
	b = (1 - s->tension) * (1 - s->continuity) * (1 - s->bias);
	c = (1 - s->tension) * (1 - s->continuity) * (1 + s->bias);
	d = (1 - s->tension) * (1 + s->continuity) * (1 - s->bias);
	v1 = t1 = -a / 2.0;
	u1 = a;
	u2 = (-6 - 2 * a + 2 * b + c) / 2.0;
	v2 = (a - b) / 2.0;
	t2 = (4 + a - b - c) / 2.0;
	t3 = (-4 + b + c - d) / 2.0;
	u3 = (6 - 2 * b - c + d) / 2.0;
	v3 = b / 2.0;
	t4 = d / 2.0;
	u4 = -t4;

	i0 = (unsigned int)frm;
	i_1 = i0 - 1;
	while (i_1 < 0) i_1 += s->num_keys;
	i1 = i0 + 1;
	while (i1 >= s->num_keys) i1 -= s->num_keys;
	i2 = i0 + 2;
	while (i2 >= s->num_keys) i2 -= s->num_keys;
	time1 = frm - (unsigned int)frm;
	time2 = time1 * time1;
	time3 = time2 * time1;

	for (i = 0; i < 3; i ++)
	{
		a = t1 * s->keys[i_1][i] + t2 * s->keys[i0][i] + t3 * s->keys[i1][i] + t4 * s->keys[i2][i];
		b = u1 * s->keys[i_1][i] + u2 * s->keys[i0][i] + u3 * s->keys[i1][i] + u4 * s->keys[i2][i];
		c = v1 * s->keys[i_1][i] + v2 * s->keys[i0][i] + v3 * s->keys[i1][i];
		out[i] = a * time3 + b * time2 + c * time1 + s->keys[i0][i];
	}

	return out;
}
