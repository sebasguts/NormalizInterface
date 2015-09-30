#
# Test a Hilbert series with negative shift
#

gap> M := [
> [0,  2,  1],
> [0, -2,  3],
> [2, -2,  3]
> ];
[ [ 0, 2, 1 ], [ 0, -2, 3 ], [ 2, -2, 3 ] ]
gap> InhomIneq := NmzCone(["inhom_inequalities", M, "grading", [[1,0]] ]);
<a Normaliz cone with long int coefficients>
gap> NmzHilbertSeries(InhomIneq);
[ 1+t^-1, [ [ 1, 1 ] ] ]
gap> NmzHilbertQuasiPolynomial(InhomIneq);
[ 2 ]
