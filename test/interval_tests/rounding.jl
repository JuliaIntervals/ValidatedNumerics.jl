using ValidatedNumerics
using Base.Test

# using Suppressor

setdisplay(:full)

# @suppress begin

# @testset "Interval rounding" begin

# NB: Due to "world age" problems, the following is not a @testset

setrounding(Interval, :correct)
x = Interval(0.5)
@test sin(x) == Interval(0.47942553860420295, 0.479425538604203)

setrounding(Interval, :fast)
@test sin(x) == Interval(0.47942553860420295, 0.47942553860420306)

setrounding(Interval, :none)
@test sin(x) == Interval(0.479425538604203, 0.479425538604203)

setrounding(Interval, :correct)
@test sin(x) == Interval(0.47942553860420295, 0.479425538604203)

setdisplay(:standard)

# end
# end
