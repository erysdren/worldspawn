
class phys_box : CPhysicsEntity {
	void() phys_box;
};

void phys_box::phys_box()
{
	this.solid = SOLID_PHYSICS_BOX;
	this.geomtype = GEOMTYPE_BOX;
	this.movetype = MOVETYPE_PHYSICS;

	if (this.model)
	{
		precache_model(this.model);
		setmodel(this, this.model);
	}
	else
	{
		precache_model("models/classic64/box_01.iqm");
		setmodel(this, "models/classic64/box_01.iqm");
	}

	switch (this.model)
	{
		default:
		case "models/classic64/box_01.iqm":
			setsize(this, [-16, -16, -16], [16, 16, 16]);
			break;

		case "models/flatbox.iqm":
			setsize(this, [-16, -16, -4], [16, 16, 4]);
			break;

		case "models/tallbox.iqm":
			setsize(this, [-4, -4, -32], [4, 4, 32]);
			break;
	}
}
