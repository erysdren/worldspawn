
class func_physbox : CPhysicsEntity {
	void() func_physbox;
};

void func_physbox::func_physbox()
{
	this.solid = SOLID_PHYSICS_TRIMESH;
	this.geomtype = GEOMTYPE_TRIMESH;
	this.movetype = MOVETYPE_PHYSICS;
}
