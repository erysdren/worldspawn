
class func_breakable {
	void() func_breakable;
	virtual void(entity attacker, float damage) th_pain;
	virtual void() th_die;
};

void func_breakable::func_breakable()
{
	this.takedamage = DAMAGE_YES;
	if (this.health <= 0) this.health = 100;

	this.solid = SOLID_BSP;
	this.movetype = MOVETYPE_NONE;
	setmodel(this, this.model);
}

void func_breakable::th_pain(entity attacker, float damage)
{

}

void func_breakable::th_die()
{
	remove(this);
}
