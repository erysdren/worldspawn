
class phys_constraint {
	void() phys_constraint;
	virtual void() think;
};

void phys_constraint::phys_constraint()
{
	this.solid = SOLID_NOT;
	this.movetype = MOVETYPE_NONE;
	this.nextthink = time + 0.1;
}

void phys_constraint::think()
{
	if (this.target1) this.enemy = find(world, ::targetname, this.target1);
	if (this.target2) this.aiment = find(world, ::targetname, this.target2);
}
