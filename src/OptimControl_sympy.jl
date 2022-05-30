using SymPy
@syms t A B λ() x()
diffeq = Eq(λ(t).diff(t, 2), A * λ(t))
λt = dsolve(diffeq, λ(t)).__pyobject__.rhs
ut = -1 // 2 * B * λt
diffeq2 = Eq(x(t).diff(t, t), A * x(t) + B * ut)
dsolve(diffeq2, x(t))
dsolve(diffeq2, x(t)).__pyobject__.rhs.diff(t)


@syms t A B λ1() x1() λ2() x2()
eqs = [
    Eq(λ1(t).diff(t), -A * λ2(t)),
    Eq(λ2(t).diff(t), -λ1(t)),
    Eq(x1(t).diff(t), x2(t)),
    Eq(x2(t).diff(t), A * x1(t) - B^2 / 2 * λ2(t))
]
dsolve(eqs)