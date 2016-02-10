# What's new in ValidatedNumerics.jl

# v0.2

- Significant progress has been made towards conformance with the [IEEE 1788-2015 - IEEE Standard for Interval Arithmetic] (https://standards.ieee.org/findstds/standard/1788-2015.html), with many functions added, including hyperbolic functions (`cosh`, etc.)

- The [CRlibm.jl](https://github.com/dpsanders/CRlibm.jl) (Correctly-Rounded mathematics library) is now used to obtain correctly-rounded elementary functions (`sin`, `exp`, etc.) for `Float64` arguments. Functions that are not available in `CRlibm.jl` are taken from MPFR, and are hence slower; note that this includes the `^` function.

- Julia versions of files from the comprehensive [ITF1788 test suite](https://github.com/oheim/ITF1788) by Marco Nehmeier and Maximilian Kiesner have been included in our own test suite, thanks to the efforts of Oliver Heimlich. All relevant tests pass.

- Documentation has been enhanced.

- `Interval`s can now only contain floating-point numbers. Non-floats will be automatically converted.

- v0.2 **supports only Julia v0.4 and later**.

- Changes are detailed in [issue #31](https://github.com/dpsanders/ValidatedNumerics.jl/issues/31)


## 0.1.3

- Improvements towards conformance with the [IEEE-1788](https://standards.ieee.org/findstds/standard/1788-2015.html) standard for Interval Arithmetic:

 - New `special_intervals.jl` file, with definitions of `emptyinterval`, `entireinterval`, `nai` and related functions. Add new interval functions (`<=`, `radius`, `precedes`, `strictprecedes`, `≺`, etc).

 - Control rounding tighter for arithmetic operations; `*`, `inv` and `/` have been rewritten; this includes changes in `make_interval` and `convert` to get consistent behavior. These functions pass the corresponding tests in the [ITF1788](https://github.com/oheim/ITF1788) test suite.
- Deprecate the use of `⊊` in favor of `interior` (`⪽`).

**Important notice:** This is the **last version** of the package that
supports Julia v0.3.

## 0.1.2

- Increase test coverage and corresponding bug fixes
- Enable pre-compilation for Julia v0.4

## 0.1.1

- Re-enable tests for `Interval{Float64}` (`e0f3c1506f`)

# v0.1

v0.1 is the first public release of the package.

### Interval arithmetic
- Two methods for interval rounding are available:
 (i) narrow/slow (which uses hardward rounding mode changes for `Float64` intervals, and (ii) wide/fast (which does not change the rounding mode)
- The current interval precision and rounding mode are stored in the `parameters` object
- The macro `@interval` generates intervals based on the current interval precision
- Trigonometric functions are "nearly" rigorous (for `Float64` intervals, correct rounding is not currently guaranteed)
- Inverse trigonometric functions are available
- Intervals of `BigFloat`s are displayed with the precision as a subscript numeral

### Root finding
- Newton and Krawczyk methods are implemented for rigorously finding simple roots of 1D real functions
- Stringent tests are performed, with various precision settings ( Float64` and `BigFloat )
