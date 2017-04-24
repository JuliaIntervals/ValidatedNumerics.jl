using IntervalArithmetic
using IntervalRootFinding
using IntervalConstraintProgramming

using Base.Test

@testset "Load and briefly test packages" begin
    @testset "IntervalArithmetic" begin
        @test @interval(1, 2) == Interval(1, 2)
    end

    @testset "IntervalRootFinding" begin
        roots = newton(x->x^2 - 2, -10..10)
        @test length(roots) == 2
    end

    @testset "IntervalConstraintProgramming" begin
        S = @constraint x^2 + y^2 <= 1
        X = (-∞..∞) × (-∞..∞)
        paving = pave(S, X, 1.0)

        @test length(paving.inner) == 4
        @test length(paving.boundary) == 8
    end
end
