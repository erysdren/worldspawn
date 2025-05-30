
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
