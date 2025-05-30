
class phys_sphere : CPhysicsEntity {
	void() phys_sphere;
};

void phys_sphere::phys_sphere()
{
	this.solid = SOLID_PHYSICS_SPHERE;
	this.geomtype = GEOMTYPE_SPHERE;
	this.movetype = MOVETYPE_PHYSICS;

	if (this.model)
	{
		precache_model(this.model);
		setmodel(this, this.model);
	}
	else
	{
		precache_model("models/sphere.iqm");
		setmodel(this, "models/sphere.iqm");
	}

	switch (this.model)
	{
		default:
		case "models/sphere.iqm":
			setsize(this, [-16, -16, -16], [16, 16, 16]);
			break;
	}
}
