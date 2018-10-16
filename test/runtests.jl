using ValidatedNumerics

using Test

@testset "Load and briefly test packages" begin

    @testset "IntervalArithmetic" begin
        @test 1..2 == Interval(1, 2)
    end

    @testset "IntervalRootFinding" begin
        roots = IntervalRootFinding.roots(x->x^2 - 2, -10..10)
        @test length(roots) == 2
    end

    @testset "IntervalConstraintProgramming" begin
        S = @constraint x^2 + y^2 <= 1
        X = (-∞..∞) × (-∞..∞)
        paving = pave(S, X, 1.0)

        @test length(paving.inner) == 3
        @test length(paving.boundary) == 7
    end

    @testset "IntervalContractors" begin
        X = 1..4
        Y = 5..10

        Z = X + Y

        Z = Z ∩ (13..15)

        Z, X, Y = plus_rev(Z, X, Y)

        @test X == 3..4
        @test Y == 9..10
    end

    @testset "IntervalOptimisation" begin
        f(x) = x^4 - 3x^3 + 2x

        globalmin, minimisers = minimise(f, -1e10..1e10, 1e-7)

        @test globalmin ⊆ (-4.15.. -4.14)
    end

end
