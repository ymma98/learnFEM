"""
FEM basis functions and Gaussian quadrature
ymma98
"""

import cython
from cython.parallel import prange
import numpy as np
cimport numpy as np
np.import_array()
from libc.math cimport sqrt
from libc.stdio cimport printf



@cython.boundscheck(False)
@cython.wraparound(False)
cdef void local_basis_1d():
    """
    Gauss-Lobatto points: https://mathworld.wolfram.com/LobattoQuadrature.html
    """
    pass



@cython.boundscheck(False)
@cython.wraparound(False)
cdef void gauss_legendre_quadrature_set1d(int n, \
                                          double x[:], \
                                          double w[:]):
    """
    get abscissas and weights for Gauss-Legendre quadrature
    The quadrature interval is [-1, 1]
    Integrate (-1 <= X <= 1) F(x) dX = Sum (1 <= I <= N) W(I) * F(X(I))
    
    The quadrature rule will integrate exactly all polynomials up to x**(2*N-1)

    :param n: (int) number of node points
    :param x: (1d np.ndarray) abscissas
    :param w: (1d np.ndarray) weights for Gauss-Legendre quadrature

    author: ymma98

    this function is modified from
        void legendre_set ( int n, double x[], double w[] )
        which is created by John Burkardt, the licence of the legendre_set()
        are copied as follows:

        Licensing:
          This code is distributed under the GNU LGPL license. 
        Modified:
          19 October 2009
        Author:
          John Burkardt
        Reference:
          Milton Abramowitz, Irene Stegun,
          Handbook of Mathematical Functions,
          National Bureau of Standards, 1964,
          ISBN: 0-486-61272-4,
          LC: QA47.A34.

          Vladimir Krylov,
          Approximate Calculation of Integrals,
          Dover, 2006,
          ISBN: 0486445798.

          Arthur Stroud, Don Secrest,
          Gaussian Quadrature Formulas,
          Prentice Hall, 1966,
          LC: QA299.4G3S7.

          Daniel Zwillinger, editor,
          CRC Standard Mathematical Tables and Formulae,
          30th Edition,
          CRC Press, 1996,
          ISBN: 0-8493-2479-3.
    """
    if ( n == 1 ):
        x[0] = 0.0
        w[0] = 2.0

    elif ( n == 2 ):
        x[0] = - 0.577350269189625764509148780502
        x[1] =   0.577350269189625764509148780502

        w[0] = 1.0
        w[1] = 1.0

    elif ( n == 3 ):
        x[0] = - 0.774596669241483377035853079956
        x[1] =   0.0
        x[2] =   0.774596669241483377035853079956

        w[0] = 5.0 / 9.0
        w[1] = 8.0 / 9.0
        w[2] = 5.0 / 9.0

    elif ( n == 4 ):
        x[0] = - 0.861136311594052575223946488893
        x[1] = - 0.339981043584856264802665759103
        x[2] =   0.339981043584856264802665759103
        x[3] =   0.861136311594052575223946488893

        w[0] = 0.347854845137453857373063949222
        w[1] = 0.652145154862546142626936050778
        w[2] = 0.652145154862546142626936050778
        w[3] = 0.347854845137453857373063949222

    elif ( n == 5 ):
        x[0] = - 0.906179845938663992797626878299
        x[1] = - 0.538469310105683091036314420700
        x[2] =   0.0
        x[3] =   0.538469310105683091036314420700
        x[4] =   0.906179845938663992797626878299

        w[0] = 0.236926885056189087514264040720
        w[1] = 0.478628670499366468041291514836
        w[2] = 0.568888888888888888888888888889
        w[3] = 0.478628670499366468041291514836
        w[4] = 0.236926885056189087514264040720

    elif ( n == 6 ):
        x[0] = - 0.932469514203152027812301554494
        x[1] = - 0.661209386466264513661399595020
        x[2] = - 0.238619186083196908630501721681
        x[3] =   0.238619186083196908630501721681
        x[4] =   0.661209386466264513661399595020
        x[5] =   0.932469514203152027812301554494

        w[0] = 0.171324492379170345040296142173
        w[1] = 0.360761573048138607569833513838
        w[2] = 0.467913934572691047389870343990
        w[3] = 0.467913934572691047389870343990
        w[4] = 0.360761573048138607569833513838
        w[5] = 0.171324492379170345040296142173
    elif ( n == 7 ):
        x[0] = - 0.949107912342758524526189684048
        x[1] = - 0.741531185599394439863864773281
        x[2] = - 0.405845151377397166906606412077
        x[3] =   0.0
        x[4] =   0.405845151377397166906606412077
        x[5] =   0.741531185599394439863864773281
        x[6] =   0.949107912342758524526189684048

        w[0] = 0.129484966168869693270611432679
        w[1] = 0.279705391489276667901467771424
        w[2] = 0.381830050505118944950369775489
        w[3] = 0.417959183673469387755102040816
        w[4] = 0.381830050505118944950369775489
        w[5] = 0.279705391489276667901467771424
        w[6] = 0.129484966168869693270611432679

    else:
        printf("******************************");
        printf("Illegal value of n = %d \n", n);
        printf("Legal values are 1 through 10");
        printf("******************************");