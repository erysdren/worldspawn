
class func_brush {
	void() func_brush;
};

void func_brush::func_brush()
{
	this.solid = SOLID_BSP;
	this.movetype = MOVETYPE_NONE;
	setmodel(this, this.model);
}
