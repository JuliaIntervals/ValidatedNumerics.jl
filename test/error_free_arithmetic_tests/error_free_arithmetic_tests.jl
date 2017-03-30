
using ValidatedNumerics
using Base.Test

const errorfree = ValidatedNumerics.IntervalRounding{:errorfree}

@testset "Errorfree arithmetic tests" begin

    @testset "+, -, *, /" begin

        for s1 in (+, -)  # sign
            for s2 in (+, -)  # sign

                a, b = s1(0.1), s2(0.7)

                for r in (RoundUp, RoundDown)
                    for op in (+, -, *, /)
                        # @show op, a, b, r
                        @test op(a, b, r) == op(errorfree, a, b, r)

                    end
                end
            end
        end
    end

    @testset "sqrt" begin
        for r in (RoundUp, RoundDown)
            for a in (10.0, 0.3, 1024.5, 49.0)
                @show a, r 
                @test sqrt(errorfree, a, r) == sqrt(a, r)
            end
        end
    end
end
