# Decorations:

Decorations are flags, or labels, attached to intervals to indicate the status of a given interval as the product of a function evaluation on a given initial interval. The combination of an interval $X$ and a decoration $d$ is called a decorated interval.

The allowed decorations and their ordering are as follows:
`com` > `dac` > `def` > `trv` > `ill`.

Suppose that a decorated interval $(X, d)$ is the result of evaluating a function $f$ on an initial decorated interval $(X_0, d_0)$. The meaning of the resulting decoration $d$ is as follows:

- `com` ("common"): $X$ is a closed, bounded, nonempty subset of the domain of $f$; $f$ is continuous on the interval $X$; and the resulting interval $f(X)$ is bounded.

- `dac` ("defined & continuous"): $X$ is a nonempty subset of $\mathrm{Dom}(f)$, and $f$ is continuous on $X$.

- `def` ("defined"): $X$ is a nonempty subset of $\mathrm{Dom}(f)$, i.e. $f$ is defined at each point of $X$.

- `trv` ("trivial"): always true; gives no information

- `ill` ("ill-formed"): Not an Interval (an error occurred), e.g. $\mathrm{Dom}(f) = \emptyset$.

## Initialisation
If no decoration is explicitly specified when a `DecoratedInterval` is created, then it is initialised with a decoration according to the status of its interval `X`:

- `com`: if `X` is nonempty and bounded;
- `dac` if `X` is unbounded;
- `trv` if `X` is empty.


## Action of functions

A decoration is the combination of an interval together with the sequence of functions that it has passed through. Here are some examples:

```julia
julia> using ValidatedNumerics

julia> displaymode(decorations=true)

julia> X1 = @decorated(0.5, 3)
[0.5, 3]_com

julia> sqrt(X1)
[0.707106, 1.73206]_com
```
In this case, both input and output are "common" intervals, meaning that they are closed and bounded, and that the resulting function is continuous over the input interval, so that fixed-point theorems may be applied. Since `sqrt(X1) ⊆ X1`, we know that there must be a fixed point of the function inside the interval `X1` (in this case, `sqrt(1) == 1`).

```julia
julia> X2 = DecoratedInterval(3, ∞)
[3, ∞]_dac

julia> sqrt(X2)
[1.73205, ∞]_dac
```
Since the intervals are unbounded here, the maximum decoration possible is `dac`.

```julia
julia> X3 = @decorated(-3, 4)
[-3, 4]_com

julia> sign(X3)
[-1, 1]_def
```
The `sign` function is discontinuous at 0, but is defined everywhere on the input interval, so the decoration is `def`.

```julia
julia> X4 = @decorated(-3.5, 4.1)
[-3.5, 4.10001]_com

julia> sqrt(X4)
[0, 2.02485]_trv
```
The negative part of `X` is discarded by the `sqrt` function, since its domain is `[0,∞]`. (This process of discarding parts of the input interval that are not in the domain is called "loose evaluation".) The fact that this occurred is, however, recorded by the resulting decoration, `trv`, indicating a loss of information: "nothing is known" about the relationship between the output interval and the input.


In this case, we know why the decoration was reduced to `trv`. But if this were just a single step in a longer calculation, a resulting `trv` decoration shows only that something like this happened *at some step*. For example:

```julia
julia> X5 = @decorated(-3, 3)
[-3, 3]_com

julia> asin(sqrt(X5))
[0, 1.5708]_trv

julia> X6 = @decorated(0, 3)
[0, 3]_com

julia> asin(sqrt(X6))
[0, 1.5708]_trv
```
In both cases, `asin(sqrt(X))` gives a result with a `trv` decoration, but
we do not know at which step this happened, unless we break down the function into its constituent parts:
```julia
julia> sqrt(X5)
[0, 1.73206]_trv

julia> sqrt(X6)
[0, 1.73206]_com
```
This shows that loose evaluation occurred in different parts of the expression in the two different cases.

In general, the `trv` decoration is thus used only to signal that "something unexpected" happened during the calculation. Often this is later used to split up the original interval into pieces and reevaluate the function on each piece to refine the information that is obtained about the function.
