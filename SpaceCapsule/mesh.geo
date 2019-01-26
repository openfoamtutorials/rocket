//Inputs
vehicle_diameter = 0.198;
vehicle_diameter_back = 0.08106;
vehicle_length = 0.130;
tube_diameter = 10*vehicle_diameter;
tube_length = 10*vehicle_diameter;

shield_radius = 0.19;

vehicle_gridsize = 0.01*vehicle_diameter;
far_gridsize = 0.02*tube_diameter;

shock_grid_line_distance = vehicle_diameter/2;
shock_grid_line_length = vehicle_diameter;

// Derived variables.
shield_span = Asin(vehicle_diameter/2 / shield_radius);
shield_end_distance = (1-Cos(shield_span))*shield_radius;

ce = 0;
Point(ce++) = {0,0,0,vehicle_gridsize};e1=ce;
Point(ce++) = {shield_radius,0,0,vehicle_gridsize};c1 = ce;
Point(ce++) = {shield_end_distance,vehicle_diameter/2,0,vehicle_gridsize};
  t1=ce;
Point(ce++) = {vehicle_length,0,0,vehicle_gridsize};e2=ce;
Point(ce++) = {vehicle_length,vehicle_diameter_back/2,0,vehicle_gridsize};
  t2=ce;
Point(ce++) = {-tube_length/2+vehicle_length/2,0,0,far_gridsize};i1=ce;
Point(ce++) = {tube_length/2+vehicle_length/2,0,0,far_gridsize};o1=ce;
Point(ce++) = {-tube_length/2+vehicle_length/2,tube_diameter/2,0,far_gridsize};
  i2=ce;
Point(ce++) = {tube_length/2+vehicle_length/2,tube_diameter/2,0,far_gridsize};
  o2=ce;

lns[]={};
Line(ce++) = {i1,e1};lns[]+=ce;
Circle(ce++) = {e1,c1,t1};lns[]+=ce;front_arc = ce;
Line(ce++) = {t1,t2};lns[]+=ce;
Line(ce++) = {t2,e2};lns[]+=ce;
Line(ce++) = {e2,o1};lns[]+=ce;
Line(ce++) = {o1,o2};lns[]+=ce;
Line(ce++) = {o2,i2};lns[]+=ce;
Line(ce++) = {i2,i1};lns[]+=ce;

// Grid field
Field[1] = Attractor;
Field[1].NNodesByEdge = 100;
Field[1].EdgesList = {front_arc};
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = vehicle_gridsize;
Field[2].LcMax = far_gridsize;
Field[2].DistMin = 0.4*vehicle_diameter;
Field[2].DistMax = 1*vehicle_diameter;
Field[7] = Min;
Field[7].FieldsList = {2};
Background Field = 7;

Line Loop(ce++) = lns[];

Plane Surface(ce++) = ce-1;surf=ce;

Rotate {{1,0,0},{0,0,0},2.5*Pi/180.0}
{
	Surface{surf};
}

new_entities[] = Extrude {{1,0,0},{0,0,0},-5*Pi/180.0}
{
	Surface{surf};
	Layers{1};
	Recombine;
};

Physical Surface("vehicle") = {new_entities[{2:4}]};
Physical Surface("tunnel") = {new_entities[6]};
Physical Surface("outlet") = {new_entities[5]};
Physical Surface("inlet") = {new_entities[7]};
Physical Surface("wedge0") = {surf};
Physical Surface("wedge1") = {new_entities[0]};

Physical Volume("volume") = {new_entities[1]};
