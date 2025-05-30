
class prop_physics : CPhysicsEntity {
	void() prop_physics;
};

void prop_physics::prop_physics()
{
	this.solid = SOLID_PHYSICS_TRIMESH;
	this.geomtype = GEOMTYPE_TRIMESH;
	this.movetype = MOVETYPE_PHYSICS;

	precache_model(this.model);
	setmodel(this, this.model);
}
