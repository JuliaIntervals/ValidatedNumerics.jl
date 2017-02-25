using ValidatedNumerics


@test ValidatedNumerics.round_expr(:(a + b), RoundDown) ==
    :( +( $(Expr(:escape, :a)), $(Expr(:escape, :b)), RoundingMode{:Down}()) )

@test ValidatedNumerics.round_expr(:(sin(a)), RoundDown) ==
    :( sin( $(Expr(:escape, :a)), RoundingMode{:Down}() ) )
