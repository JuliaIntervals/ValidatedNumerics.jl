
using PyCall
using PyPlot

using ValidatedNumerics

@pyimport matplotlib.patches as patches
@pyimport matplotlib.collections as collections


function rectangle(X::IntervalBox, color="grey", alpha=0.5, linewidth=0)
    x, y = X
    rectangle(x.lo, y.lo, x.hi, y.hi, color, alpha, linewidth)
end

function rectangle(xlo, ylo, xhi, yhi, color="grey", alpha=0.5, linewidth=0)
    patches.Rectangle(
        (xlo, ylo), xhi - xlo, yhi - ylo,
        facecolor=color, alpha=alpha, linewidth=0, edgecolor="none"
    )
end


import PyPlot.draw

function draw(X::IntervalBox, color="grey", alpha=0.5, linewidth=0)

    ax = gca()
    ax[:add_patch](rectangle(X, color, alpha, linewidth))
end

function draw(box_list::Vector{IntervalBox}, color="grey", alpha=0.5, linewidth=0)

    patch_list = map(rectangle, box_list)

    ax = gca()
    ax[:add_collection](collections.PatchCollection(patch_list, color=color, alpha=alpha,
    edgecolor="black", linewidths=linewidth))
end
