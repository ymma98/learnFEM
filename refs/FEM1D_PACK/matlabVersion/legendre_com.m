function [ xtab, weight ] = legendre_com ( n )

%*****************************************************************************80
%
%% legendre_com() computes abscissas and weights for Gauss-Legendre quadrature.
%
%  Integration interval:
%
%    [ -1, 1 ]
%
%  Weight function:
%
%    1.
%
%  Integral to approximate:
%
%    Integral ( -1 <= X <= 1 ) F(X) dX.
%
%  Approximate integral:
%
%    sum ( 1 <= I <= N ) WEIGHT(I) * F ( XTAB(I) ).
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    14 February 2003
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    integer N, the order of the rule.
%    N must be greater than 0.
%
%  Output:
%
%    real XTAB(N), the abscissas of the rule.
%
%    real WEIGHT(N), the weights of the rule.
%    The weights are positive, symmetric, and should sum to 2.
%
  if ( n < 1 )
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'LEGENDRE_COM - Fatal error!'
    write ( *, '(a,i6)' ) '  Illegal value of N = ', n
    error ( 'LEGENDRE_COM - Fatal error!' );
  end

  e1 = n * ( n + 1 );

  m = floor ( ( n + 1 ) / 2 );

  for i = 1 : m

    mp1mi = m + 1 - i;
    t = pi * ( 4 * i - 1 ) / ( 4 * n + 2 );
    x0 = cos ( t ) * ( 1.0 - ( 1.0 - 1.0 / n ) / ( 8 * n * n ) );

    pkm1 = 1.0;
    pk = x0;

    for k = 2 : n
      pkp1 = 2.0 * x0 * pk - pkm1 - ( x0 * pk - pkm1 ) / k;
      pkm1 = pk;
      pk = pkp1;
    end

    d1 = n * ( pkm1 - x0 * pk );

    dpn = d1 / ( 1.0E+00 - x0 * x0 );

    d2pn = ( 2.0 * x0 * dpn - e1 * pk ) / ( 1.0 - x0 * x0 );

    d3pn = ( 4.0 * x0 * d2pn + ( 2.0 - e1 ) * dpn ) / ( 1.0 - x0 * x0 );

    d4pn = ( 6.0 * x0 * d3pn + ( 6.0 - e1 ) * d2pn )  / ( 1.0 - x0 * x0 );

    u = pk / dpn;
    v = d2pn / dpn;
%
%  Initial approximation H:
%
    h = - u * ( 1.0 + 0.5 * u * ( v + u * ( v * v - d3pn / ( 3.0 * dpn ) ) ) );
%
%  Refine H using one step of Newton's method:
%
    p = pk + h * ( dpn + 0.5 * h * ( d2pn + h / 3.0 * ( d3pn + 0.25 * h * d4pn ) ) );

    dp = dpn + h * ( d2pn + 0.5 * h * ( d3pn + h * d4pn / 3.0 ) );

    h = h - p / dp;

    xtemp = x0 + h;

    xtab(mp1mi) = xtemp;

    fx = d1 - h * e1 * ( pk + 0.5 * h * ( dpn + h / 3.0 ...
      * ( d2pn + 0.25 * h * ( d3pn + 0.2 * h * d4pn ) ) ) );

    weight(mp1mi) = 2.0 * ( 1.0 - xtemp * xtemp ) / ( fx * fx );

  end

  if ( mod ( n, 2 ) == 1 )
    xtab(1) = 0.0;
  end
%
%  Shift the data up.
%
  nmove = floor ( ( n + 1 ) / 2 );
  ncopy = n - nmove;

  for i = 1 : nmove
    iback = n+ 1 - i;
    xtab(iback) = xtab(iback-ncopy);
    weight(iback) = weight(iback-ncopy);
  end
%
%  Reflect values for the negative abscissas.
%
  for i = 1 : n - nmove
    xtab(i) = - xtab(n+1-i);
    weight(i) = weight(n+1-i);
  end

  return
end
