// Parameters
// Lengths are non-dimensionalized by main body diameter, which is assumed to have unit length 1.

nose_lc = 0.01; // mesh size at the nose.
nose_radius = 0.1;
nose_angle = 30.0 / 180.0 * 3.14159; // rad, half-angle of the nose cone.

fairing_length = 3.5; // from nose tip to chamfer end / start of main body.
fairing_diameter = 1.5; // assumed to be > 1.
fairing_chamfer_length = 0.3; // length of chamfer that joins main body and fairing.
fairing_lc = 2 * nose_lc;

length = 20; // distance from nose tip to tail; multiple of body diameter.
tail_lc = 0.1; // mesh size at body tail.
domain = 100; // multiple of body diameter.
boundary_lc = 2;

ce = 0; // id for all geometric entities (points, lines, etc.).

p = ce;
Point(ce++) = {0, 0, 0, nose_lc};
nose_tip = ce - 1;
Point(ce++) = {0, -nose_radius, 0};
nose_center = ce - 1;
s = Sin(Pi / 2 - nose_angle);
c = Cos(Pi / 2 - nose_angle);
nose_end_x = s * nose_radius;
nose_end_y = (c - 1) * nose_radius;
Point(ce++) = {nose_end_x, nose_end_y, 0, nose_lc};
nose_end = ce - 1;

loop_lines[] = {};
Circle(ce++) = {nose_tip, nose_center, nose_end};
loop_lines[] += ce - 1;

fairing_radius = 0.5 * fairing_diameter;
c = Cos(nose_angle);
fillet_start_x = c * fairing_radius;
dx = fillet_start_x - nose_end_x;
t = Tan(nose_angle);
fillet_start_y = nose_end_y - dx / t;
Point(ce++) = {fillet_start_x, fillet_start_y, 0, fairing_lc};
fillet_start = ce - 1;

Line(ce++) = {nose_end, fillet_start};
loop_lines[] += ce - 1;

fillet_end_x = fairing_radius;
s = Sin(nose_angle);
fillet_end_y = fillet_start_y - s * fairing_radius;
Point(ce++) = {fillet_end_x, fillet_end_y, 0, fairing_lc};
fillet_end = ce - 1;
Point(ce++) = {0, fillet_end_y, 0, fairing_lc};
fillet_center = ce - 1;

Circle(ce++) = {fillet_start, fillet_center, fillet_end};
loop_lines[] += ce - 1;

chamfer_end_y = -fairing_length;
chamfer_start_y = chamfer_end_y + fairing_chamfer_length;
Point(ce++) = {fairing_radius, chamfer_start_y, 0, fairing_lc};
chamfer_start = ce - 1;

Line(ce++) = {fillet_end, chamfer_start};
loop_lines[] += ce - 1;

Point(ce++) = {0.5, chamfer_end_y, 0, fairing_lc};
chamfer_end = ce - 1;

Line(ce++) = {chamfer_start, chamfer_end};
loop_lines[] += ce - 1;

Point(ce++) = {0.5, -length, 0, tail_lc};
tail_outer = ce - 1;

Line(ce++) = {chamfer_end, tail_outer};
loop_lines[] += ce - 1;

Point(ce++) = {0, -length, 0, tail_lc};
tail_inner = ce - 1;

Line(ce++) = {tail_outer, tail_inner};
loop_lines[] += ce - 1;

Point(ce++) = {0, -domain, 0, boundary_lc};
boundary_bottom_inner = ce - 1;

Line(ce++) = {tail_inner, boundary_bottom_inner};
loop_lines[] += ce - 1;

Point(ce++) = {domain, -domain, 0, boundary_lc};
boundary_bottom_outer = ce - 1;

Line(ce++) = {boundary_bottom_inner, boundary_bottom_outer};
loop_lines[] += ce - 1;

Point(ce++) = {domain, domain, 0, boundary_lc};
boundary_top_outer = ce - 1;

Line(ce++) = {boundary_bottom_outer, boundary_top_outer};
loop_lines[] += ce - 1;

Point(ce++) = {0, domain, 0, boundary_lc};
boundary_top_inner = ce - 1;

Line(ce++) = {boundary_top_outer, boundary_top_inner};
loop_lines[] += ce - 1;

Line(ce++) = {boundary_top_inner, nose_tip};
loop_lines[] += ce - 1;

Line Loop(ce++) = loop_lines[];
line_loop = ce - 1;
Plane Surface(ce++) = {line_loop};
mesh_surface = ce - 1;

wedge_angle = 5.0 * Pi / 180.0;
Rotate {{0, 1, 0}, {0, 0, 0}, 0.5 * wedge_angle}
{
  Surface{mesh_surface};
}
generated_entities[] = Extrude {{0, 1, 0}, {0, 0, 0}, -wedge_angle}
{
  Surface{mesh_surface};
  Layers{1};
  Recombine;
};

Physical Surface("wedge0") = {mesh_surface};
Physical Surface("wedge1") = {generated_entities[0]};
Physical Surface("rocket") = {generated_entities[{2 : 8}]};
Physical Surface("outlet") = generated_entities[9];
Physical Surface("side") = generated_entities[10];
Physical Surface("inlet") = generated_entities[11];

Physical Volume("volume") = generated_entities[1];
