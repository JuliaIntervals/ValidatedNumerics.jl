using ValidatedNumerics
include("./draw_boxes.jl")


X = IntervalBox(2..4, 3..5)
Y = IntervalBox(3..5, 4..6)

D = setdiff(X, Y)

draw(X, "green")
draw(Y, "red")
axis("image")


figure()
X = IntervalBox(2..5, 3..6)
Y = IntervalBox(3..4, 4..5)

draw(X, "green")
draw(Y, "red")
axis("image")


figure()
X = IntervalBox(2..5, 3..6)
Y = IntervalBox(4..6, 4..5)

draw(X, "green")
draw(Y, "red")
axis("image")


figure()
X = IntervalBox(2..5, 3..6)
Y = IntervalBox(-10..10, 4..5)

draw(X, "green")
draw(Y, "red")
axis("image")
