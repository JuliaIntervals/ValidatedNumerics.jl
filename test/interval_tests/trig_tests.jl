using ValidatedNumerics
using Base.Test

@test sin(@interval(0.5)) == Interval(0.47942553860420295, 0.47942553860420301)
@test sin(@interval(0.5, 1.67)) == Interval(4.7942553860420295e-01, 1.0)
@test sin(@interval(1.67,3.2)) == Interval(-5.8374143427580093e-02, 9.9508334981018021e-01)
@test sin(@interval(2.1, 5.6)) == Interval(-1.0, 8.6320936664887404e-01)
@test sin(@interval(0.5,8.5)) == Interval(-1.0, 1.0)

@test cos(@interval(0.5)) == Interval(0.87758256189037265, 0.87758256189037276)
@test cos(@interval(0.5,1.67)) == Interval(-0.099041036598728246, 0.87758256189037276)
@test cos(@interval(2.1, 5.6)) == Interval(-1.0, 0.77556587851025016)
@test cos(@interval(0.5,8.5)) == Interval(-1.0, 1.0)
@test cos(@interval(1.67,3.2)) == Interval(-1.0, -0.099041036598728011)

@test tan(@interval(0.5)) == Interval(0.54630248984379048, 0.5463024898437906)
@test tan(@interval(0.5,1.67)) == Interval(-Inf, Inf)
@test tan(@interval(1.67, 3.2)) == Interval(-10.047182299210307, 0.058473854459578652)
