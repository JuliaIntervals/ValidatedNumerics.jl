
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
                        @show op, a, b, r
                        @test op(a, b, r) == op(errorfree, a, b, r)

                    end
                end
            end
        end
    end
end
