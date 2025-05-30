
class phys_springbox {
	void() phys_springbox;
};

void phys_springbox::phys_springbox()
{
	this.solid = SOLID_NOT;
	this.movetype = MOVETYPE_NONE;
	this.aiment = spawn(phys_box, model:"models/tallbox.iqm", origin:this.origin);
	this.friction = 2;
	this.jointtype = JOINTTYPE_SLIDER;
	this.movedir = [1, 1, 1];
	this.angles = [90, 0, 0];
}
