
using ValidatedNumerics
using Base.Test

const errorfree = ValidatedNumerics.IntervalRounding{:errorfree}

srand(17)  # for reproducible random numbers

@testset "Errorfree arithmetic tests" begin

    @testset "+, -, *, /" begin

        for s1 in (+, -)  # sign
            for s2 in (+, -)  # sign

                for i in 1:1000
                    a, b = rand(0.0:0.1:100000, 2)
                    a, b = s1(a), s2(b)  # signs

                    for r in (RoundUp, RoundDown)
                        for op in (+, -, *, /)
                            # @show op, a, b, r
                            @test op(a, b, r) == op(errorfree, a, b, r)
                        end

                    end
                end
            end
        end
    end

    @testset "sqrt" begin
        for r in (RoundUp, RoundDown)
            for a in [10.0, 0.3, 1024.5, 49.0] ∪ rand(0.0:0.001:1, 1000) ∪  rand(1.:0.01:1000, 1000)
                # @show a, r
                @test sqrt(errorfree, a, r) == sqrt(a, r)
            end
        end
    end
end
