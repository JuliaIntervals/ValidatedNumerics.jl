
using PyCall
using PyPlot

using ValidatedNumerics

@pyimport matplotlib.patches as patches
@pyimport matplotlib.collections as collections


function rectangle(xlo, ylo, xhi, yhi, color="grey", alpha=0.5, linewidth=0)
    patches.Rectangle(
        (xlo, ylo), xhi - xlo, yhi - ylo,
        facecolor=color, alpha=alpha, linewidth=0, edgecolor="none"
    )
end

import PyPlot.draw
function draw_boxes{T<:IntervalBox}(box_list::Vector{T}, color="grey", alpha=0.5, linewidth=0)
    patch_list = []

    for box in box_list
        x, y = box
        push!(patch_list, rectangle(x.lo, y.lo, x.hi, y.hi, color, alpha))
    end

    ax = gca()
    ax[:add_collection](collections.PatchCollection(patch_list, color=color, alpha=alpha,
    edgecolor="black", linewidths=linewidth))
end
