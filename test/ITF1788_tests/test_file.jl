#

# Copyright 2013 - 2015 Marco Nehmeier (nehmeier@informatik.uni-wuerzburg.de)

# Copyright 2015 Oliver Heimlich (oheim@posteo.de)

#

# Original author: Marco Nehmeier (unit tests in libieeep1788)

# Converted into portable ITL format by Oliver Heimlich with minor corrections.

#

# Licensed under the Apache License, Version 2.0 (the "License");

# you may not use this file except in compliance with the License.

# You may obtain a copy of the License at

#

#     http://www.apache.org/licenses/LICENSE-2.0

#

# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,

# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

# See the License for the specific language governing permissions and

# limitations under the License.

#

#Language imports



#Test library imports

using FactCheck



#Arithmetic library imports

using ValidatedNumerics



#Preamble

setprecision(53)

setprecision(Interval, Float64)

setrounding(Interval, :narrow)



facts("minimal_pos_test") do

    @fact +Interval(1.0, 2.0) --> Interval(1.0, 2.0)

    @fact +∅ --> ∅

    @fact +entireinterval(Float64) --> entireinterval(Float64)

    @fact +Interval(1.0, Inf) --> Interval(1.0, Inf)

    @fact +Interval(-Inf, -1.0) --> Interval(-Inf, -1.0)

    @fact +Interval(0.0, 2.0) --> Interval(0.0, 2.0)

    @fact +Interval(-0.0, 2.0) --> Interval(0.0, 2.0)

    @fact +Interval(-2.5, -0.0) --> Interval(-2.5, 0.0)

    @fact +Interval(-2.5, 0.0) --> Interval(-2.5, 0.0)

    @fact +Interval(-0.0, -0.0) --> Interval(0.0, 0.0)

    @fact +Interval(0.0, 0.0) --> Interval(0.0, 0.0)

end



facts("minimal_pos_dec_test") do

    @fact +DecoratedInterval(∅, trv) --> DecoratedInterval(∅, trv)

    @fact decoration(+DecoratedInterval(∅, trv)) --> decoration(DecoratedInterval(∅, trv))

    @fact +DecoratedInterval(entireinterval(Float64), def) --> DecoratedInterval(entireinterval(Float64), def)

    @fact decoration(+DecoratedInterval(entireinterval(Float64), def)) --> decoration(DecoratedInterval(entireinterval(Float64), def))

    @fact +DecoratedInterval(Interval(1.0, 2.0), com) --> DecoratedInterval(Interval(1.0, 2.0), com)

    @fact decoration(+DecoratedInterval(Interval(1.0, 2.0), com)) --> decoration(DecoratedInterval(Interval(1.0, 2.0), com))

end



facts("minimal_neg_test") do

    @fact -(Interval(1.0, 2.0)) --> Interval(-2.0, -1.0)

    @fact -(∅) --> ∅

    @fact -(entireinterval(Float64)) --> entireinterval(Float64)

    @fact -(Interval(1.0, Inf)) --> Interval(-Inf, -1.0)

    @fact -(Interval(-Inf, 1.0)) --> Interval(-1.0, Inf)

    @fact -(Interval(0.0, 2.0)) --> Interval(-2.0, 0.0)

    @fact -(Interval(-0.0, 2.0)) --> Interval(-2.0, 0.0)

    @fact -(Interval(-2.0, 0.0)) --> Interval(0.0, 2.0)

    @fact -(Interval(-2.0, -0.0)) --> Interval(0.0, 2.0)

    @fact -(Interval(0.0, -0.0)) --> Interval(0.0, 0.0)

    @fact -(Interval(-0.0, -0.0)) --> Interval(0.0, 0.0)

end



facts("minimal_neg_dec_test") do

    @fact -(DecoratedInterval(∅, trv)) --> DecoratedInterval(∅, trv)

    @fact decoration(-(DecoratedInterval(∅, trv))) --> decoration(DecoratedInterval(∅, trv))

    @fact -(DecoratedInterval(entireinterval(Float64), def)) --> DecoratedInterval(entireinterval(Float64), def)

    @fact decoration(-(DecoratedInterval(entireinterval(Float64), def))) --> decoration(DecoratedInterval(entireinterval(Float64), def))

    @fact -(DecoratedInterval(Interval(1.0, 2.0), com)) --> DecoratedInterval(Interval(-2.0, -1.0), com)

    @fact decoration(-(DecoratedInterval(Interval(1.0, 2.0), com))) --> decoration(DecoratedInterval(Interval(-2.0, -1.0), com))

end



facts("minimal_add_test_1") do
    @fact ∅ + ∅ --> ∅

    @fact Interval(-1.0, 1.0) + ∅ --> ∅

    @fact ∅ + Interval(-1.0, 1.0) --> ∅

    @fact ∅ + entireinterval(Float64) --> ∅

    @fact entireinterval(Float64) + ∅ --> ∅

    @fact entireinterval(Float64) + Interval(-Inf, 1.0) --> entireinterval(Float64)

    @fact entireinterval(Float64) + Interval(-1.0, 1.0) --> entireinterval(Float64)

    @fact entireinterval(Float64) + Interval(-1.0, Inf) --> entireinterval(Float64)

    @fact entireinterval(Float64) + entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-Inf, 1.0) + entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-1.0, 1.0) + entireinterval(Float64) --> entireinterval(Float64)


end
facts("minimal_add_test_2") do
    @fact Interval(-1.0, 1.0) + entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-1.0, Inf) + entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-Inf, 2.0) + Interval(-Inf, 4.0) --> Interval(-Inf, 6.0)

    @fact Interval(-Inf, 2.0) + Interval(3.0, 4.0) --> Interval(-Inf, 6.0)

    @fact Interval(-Inf, 2.0) + Interval(3.0, Inf) --> entireinterval(Float64)

    @fact Interval(1.0, 2.0) + Interval(-Inf, 4.0) --> Interval(-Inf, 6.0)

    @fact Interval(1.0, 2.0) + Interval(3.0, 4.0) --> Interval(4.0, 6.0)

    @fact Interval(1.0, 2.0) + Interval(3.0, Inf) --> Interval(4.0, Inf)

    @fact Interval(1.0, Inf) + Interval(-Inf, 4.0) --> entireinterval(Float64)

    @fact Interval(1.0, Inf) + Interval(3.0, 4.0) --> Interval(4.0, Inf)

    @fact Interval(1.0, Inf) + Interval(3.0, Inf) --> Interval(4.0, Inf)


end
facts("minimal_add_test_3") do
    @fact Interval(1.0, Inf) + Interval(3.0, Inf) --> Interval(4.0, Inf)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) + Interval(3.0, 4.0) --> Interval(4.0, Inf)

    @fact Interval(-0x1.fffffffffffffp1023, 2.0) + Interval(-3.0, 4.0) --> Interval(-Inf, 6.0)

    @fact Interval(-0x1.fffffffffffffp1023, 2.0) + Interval(-3.0, 0x1.fffffffffffffp1023) --> entireinterval(Float64)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) + Interval(0.0, 0.0) --> Interval(1.0, 0x1.fffffffffffffp1023)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) + Interval(-0.0, -0.0) --> Interval(1.0, 0x1.fffffffffffffp1023)

    @fact Interval(0.0, 0.0) + Interval(-3.0, 4.0) --> Interval(-3.0, 4.0)

    @fact Interval(-0.0, -0.0) + Interval(-3.0, 0x1.fffffffffffffp1023) --> Interval(-3.0, 0x1.fffffffffffffp1023)

    @fact Interval(0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) + Interval(0x1.999999999999ap-4, 0x1.999999999999ap-4) --> Interval(0x1.0ccccccccccc4p+1, 0x1.0ccccccccccc5p+1)

    @fact Interval(0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) + Interval(-0x1.999999999999ap-4, -0x1.999999999999ap-4) --> Interval(0x1.e666666666656p+0, 0x1.e666666666657p+0)

    @fact Interval(-0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) + Interval(0x1.999999999999ap-4, 0x1.999999999999ap-4) --> Interval(-0x1.e666666666657p+0, 0x1.0ccccccccccc5p+1)


end


facts("minimal_add_dec_test") do

    @fact DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 7.0), com) --> DecoratedInterval(Interval(6.0, 9.0), com)

    @fact decoration(DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 7.0), com)) --> decoration(DecoratedInterval(Interval(6.0, 9.0), com))

    @fact DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 7.0), def) --> DecoratedInterval(Interval(6.0, 9.0), def)

    @fact decoration(DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 7.0), def)) --> decoration(DecoratedInterval(Interval(6.0, 9.0), def))

    @fact DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 0x1.fffffffffffffp1023), com) --> DecoratedInterval(Interval(6.0, Inf), dac)

    @fact decoration(DecoratedInterval(Interval(1.0, 2.0), com) + DecoratedInterval(Interval(5.0, 0x1.fffffffffffffp1023), com)) --> decoration(DecoratedInterval(Interval(6.0, Inf), dac))

    @fact DecoratedInterval(Interval(-0x1.fffffffffffffp1023, 2.0), com) + DecoratedInterval(Interval(-0.1, 5.0), com) --> DecoratedInterval(Interval(-Inf, 7.0), dac)

    @fact decoration(DecoratedInterval(Interval(-0x1.fffffffffffffp1023, 2.0), com) + DecoratedInterval(Interval(-0.1, 5.0), com)) --> decoration(DecoratedInterval(Interval(-Inf, 7.0), dac))

    @fact DecoratedInterval(Interval(1.0, 2.0), trv) + DecoratedInterval(∅, trv) --> DecoratedInterval(∅, trv)

    @fact decoration(DecoratedInterval(Interval(1.0, 2.0), trv) + DecoratedInterval(∅, trv)) --> decoration(DecoratedInterval(∅, trv))

end



facts("minimal_sub_test_1") do
    @fact ∅ - ∅ --> ∅

    @fact Interval(-1.0, 1.0) - ∅ --> ∅

    @fact ∅ - Interval(-1.0, 1.0) --> ∅

    @fact ∅ - entireinterval(Float64) --> ∅

    @fact entireinterval(Float64) - ∅ --> ∅

    @fact entireinterval(Float64) - Interval(-Inf, 1.0) --> entireinterval(Float64)

    @fact entireinterval(Float64) - Interval(-1.0, 1.0) --> entireinterval(Float64)

    @fact entireinterval(Float64) - Interval(-1.0, Inf) --> entireinterval(Float64)

    @fact entireinterval(Float64) - entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-Inf, 1.0) - entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-1.0, 1.0) - entireinterval(Float64) --> entireinterval(Float64)


end
facts("minimal_sub_test_2") do
    @fact Interval(-1.0, 1.0) - entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-1.0, Inf) - entireinterval(Float64) --> entireinterval(Float64)

    @fact Interval(-Inf, 2.0) - Interval(-Inf, 4.0) --> entireinterval(Float64)

    @fact Interval(-Inf, 2.0) - Interval(3.0, 4.0) --> Interval(-Inf, -1.0)

    @fact Interval(-Inf, 2.0) - Interval(3.0, Inf) --> Interval(-Inf, -1.0)

    @fact Interval(1.0, 2.0) - Interval(-Inf, 4.0) --> Interval(-3.0, Inf)

    @fact Interval(1.0, 2.0) - Interval(3.0, 4.0) --> Interval(-3.0, -1.0)

    @fact Interval(1.0, 2.0) - Interval(3.0, Inf) --> Interval(-Inf, -1.0)

    @fact Interval(1.0, Inf) - Interval(-Inf, 4.0) --> Interval(-3.0, Inf)

    @fact Interval(1.0, Inf) - Interval(3.0, 4.0) --> Interval(-3.0, Inf)

    @fact Interval(1.0, Inf) - Interval(3.0, Inf) --> entireinterval(Float64)


end
facts("minimal_sub_test_3") do
    @fact Interval(1.0, Inf) - Interval(3.0, Inf) --> entireinterval(Float64)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) - Interval(-3.0, 4.0) --> Interval(-3.0, Inf)

    @fact Interval(-0x1.fffffffffffffp1023, 2.0) - Interval(3.0, 4.0) --> Interval(-Inf, -1.0)

    @fact Interval(-0x1.fffffffffffffp1023, 2.0) - Interval(-0x1.fffffffffffffp1023, 4.0) --> entireinterval(Float64)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) - Interval(0.0, 0.0) --> Interval(1.0, 0x1.fffffffffffffp1023)

    @fact Interval(1.0, 0x1.fffffffffffffp1023) - Interval(-0.0, -0.0) --> Interval(1.0, 0x1.fffffffffffffp1023)

    @fact Interval(0.0, 0.0) - Interval(-3.0, 4.0) --> Interval(-4.0, 3.0)

    @fact Interval(-0.0, -0.0) - Interval(-3.0, 0x1.fffffffffffffp1023) --> Interval(-0x1.fffffffffffffp1023, 3.0)

    @fact Interval(0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) - Interval(0x1.999999999999ap-4, 0x1.999999999999ap-4) --> Interval(0x1.e666666666656p+0, 0x1.e666666666657p+0)

    @fact Interval(0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) - Interval(-0x1.999999999999ap-4, -0x1.999999999999ap-4) --> Interval(0x1.0ccccccccccc4p+1, 0x1.0ccccccccccc5p+1)

    @fact Interval(-0x1.ffffffffffffp+0, 0x1.ffffffffffffp+0) - Interval(0x1.999999999999ap-4, 0x1.999999999999ap-4) --> Interval(-0x1.0ccccccccccc5p+1, 0x1.e666666666657p+0)


end
