
class prop_static {
	static const float SPAWNFLAG_NONSOLID = 1;
	void() prop_static;
};

void prop_static::prop_static()
{
	if (this.spawnflags & SPAWNFLAG_NONSOLID)
	{
		this.solid = SOLID_NOT;
		this.geomtype = GEOMTYPE_NONE;
	}
	else
	{
		this.solid = SOLID_PHYSICS_TRIMESH;
		this.geomtype = GEOMTYPE_TRIMESH;
	}

	this.movetype = MOVETYPE_NONE;
	this.mass = 0;

	precache_model(this.model);
	setmodel(this, this.model);
}
