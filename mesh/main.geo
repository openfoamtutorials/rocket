// Parameters
// Lengths are non-dimensionalized by main body diameter, which is assumed to have unit length 1.

nose_lc = 0.01; // mesh size at the nose.
nose_radius = 0.1;
nose_angle = 30.0 / 180.0 * 3.14159; // rad, half-angle of the nose cone.

fairing_length = 3.5; // from nose tip to chamfer end / start of main body.
fairing_diameter = 1.5; // assumed to be > 1.
fairing_chamfer_length = 0.3; // length of chamfer that joins main body and fairing.
fairing_lc = 2 * nose_lc;

length = 5; // multiple of body diameter.
domain = 100; // multiple of body diameter.

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

Circle(ce++) = {nose_tip, nose_center, nose_end};

fairing_radius = 0.5 * fairing_diameter;
c = Cos(nose_angle);
fillet_start_x = c * fairing_radius;
dx = fillet_start_x - nose_end_x;
t = Tan(nose_angle);
fillet_start_y = nose_end_y - dx / t;
Point(ce++) = {fillet_start_x, fillet_start_y, 0, fairing_lc};
fillet_start = ce - 1;

Line(ce++) = {nose_end, fillet_start};

fillet_end_x = fairing_radius;
s = Sin(nose_angle);
fillet_end_y = fillet_start_y - s * fairing_radius;
Point(ce++) = {fillet_end_x, fillet_end_y, 0, fairing_lc};
fillet_end = ce - 1;
Point(ce++) = {0, fillet_end_y, 0, fairing_lc};
fillet_center = ce - 1;

Circle(ce++) = {fillet_start, fillet_center, fillet_end};

chamfer_end_y = -fairing_length;
chamfer_start_y = chamfer_end_y + fairing_chamfer_length;
Point(ce++) = {fairing_radius, chamfer_start_y, 0, fairing_lc};
chamfer_start = ce - 1;

Line(ce++) = {fillet_end, chamfer_start};

Point(ce++) = {0.5, chamfer_end_y, 0, fairing_lc};
chamfer_end = ce - 1;

Line(ce++) = {chamfer_start, chamfer_end};


/*
blastSourceRadius = 0.1; // m
domainDistance = 10 * blastSourceRadius; // m
wallDistance = 5 * blastSourceRadius; // m
wallThickness = 0.1; // m
wallHeight = 1; // m

blastSourceLc = 0.1 * blastSourceRadius;
wallLc = 2 * blastSourceLc;
farLc = wallLc;

wedgeAngle = 5*Pi/180;

ce = 0;

p = ce;
Point(ce++) = {0, 0, 0};
Point(ce++) = {0, -blastSourceRadius, 0, blastSourceLc};
Point(ce++) = {blastSourceRadius, 0, 0, blastSourceLc};
Point(ce++) = {0, blastSourceRadius, 0, blastSourceLc};

bottomarc = ce;
Circle(ce++) = {p + 1, p, p + 2};
toparc = ce;
Circle(ce++) = {p + 2, p, p + 3};
sourceline = ce;
Line(ce++) = {p + 1, p + 3};

p = ce;
Point(ce++) = {0, -domainDistance, 0, farLc};
Point(ce++) = {wallDistance, -domainDistance, 0, wallLc};
Point(ce++) = {wallDistance, -domainDistance + wallHeight, 0, wallLc};
Point(ce++) = {wallDistance + wallThickness, -domainDistance + wallHeight, 0, wallLc};
Point(ce++) = {wallDistance + wallThickness, -domainDistance, 0, wallLc};

Point(ce++) = {domainDistance, -domainDistance, 0, farLc};

Point(ce++) = {domainDistance, -domainDistance, 0, farLc};
Point(ce++) = {domainDistance, domainDistance, 0, farLc};
Point(ce++) = {0, domainDistance, 0, farLc};

l = ce;
Line(ce++) = {p - 6, p};
For k In {0:7}
    Line(ce++) = {p + k, p + k + 1};
EndFor
Line(ce++) = {p + 8, p - 4};

sourceloop = ce;
Line Loop(ce++) = {sourceline, -toparc, -bottomarc};
sourcesurface = ce;
Plane Surface(ce++) = {sourceloop};
domainloop = ce;
Line Loop(ce++) = {l : l + 9, -toparc, -bottomarc};
domainsurface = ce;
Plane Surface(ce++) = {domainloop};

Rotate {{0,1,0}, {0,0,0}, wedgeAngle/2}
{
  Surface{domainsurface, sourcesurface};
}
domainEntities[] = Extrude {{0,1,0}, {0,0,0}, -wedgeAngle}
{
  Surface{domainsurface, sourcesurface};
  Layers{1};
  Recombine;
};

Physical Surface("wedge0") = {domainsurface, sourcesurface};
Physical Surface("wedge1") = {domainEntities[{0, 12}]};
Physical Surface("walls") = {domainEntities[{2 : 9}]};

Physical Volume("blastSource") = {domainEntities[13]};
Physical Volume(1000) = {domainEntities[1]};
*/

