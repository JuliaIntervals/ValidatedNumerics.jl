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

facts("minimal_empty_test") do
    @fact isempty(∅) --> true
    @fact isempty(Interval(-Inf, Inf)) --> false
    @fact isempty(Interval(1.0, 2.0)) --> false
    @fact isempty(Interval(-1.0, 2.0)) --> false
    @fact isempty(Interval(-3.0, -2.0)) --> false
    @fact isempty(Interval(-Inf, 2.0)) --> false
    @fact isempty(Interval(-Inf, 0.0)) --> false
    @fact isempty(Interval(-Inf, -0.0)) --> false
    @fact isempty(Interval(0.0, Inf)) --> false
    @fact isempty(Interval(-0.0, Inf)) --> false
    @fact isempty(Interval(-0.0, 0.0)) --> false
    @fact isempty(Interval(0.0, -0.0)) --> false
    @fact isempty(Interval(0.0, 0.0)) --> false
    @fact isempty(Interval(-0.0, -0.0)) --> false
end

facts("minimal_empty_dec_test") do
    @fact isempty(Decorated(∅, trv)) --> true
    @fact isempty(Decorated(Interval(-Inf, Inf), def)) --> false
    @fact isempty(Decorated(Interval(1.0, 2.0), com)) --> false
    @fact isempty(Decorated(Interval(-1.0, 2.0), trv)) --> false
    @fact isempty(Decorated(Interval(-3.0, -2.0), dac)) --> false
    @fact isempty(Decorated(Interval(-Inf, 2.0), trv)) --> false
    @fact isempty(Decorated(Interval(-Inf, 0.0), trv)) --> false
    @fact isempty(Decorated(Interval(-Inf, -0.0), trv)) --> false
    @fact isempty(Decorated(Interval(0.0, Inf), def)) --> false
    @fact isempty(Decorated(Interval(-0.0, Inf), trv)) --> false
    @fact isempty(Decorated(Interval(-0.0, 0.0), com)) --> false
    @fact isempty(Decorated(Interval(0.0, -0.0), trv)) --> false
    @fact isempty(Decorated(Interval(0.0, 0.0), trv)) --> false
    @fact isempty(Decorated(Interval(-0.0, -0.0), trv)) --> false
end

facts("minimal_entire_test") do
    @fact isentire(∅) --> false
    @fact isentire(Interval(-Inf, Inf)) --> true
    @fact isentire(Interval(1.0, 2.0)) --> false
    @fact isentire(Interval(-1.0, 2.0)) --> false
    @fact isentire(Interval(-3.0, -2.0)) --> false
    @fact isentire(Interval(-Inf, 2.0)) --> false
    @fact isentire(Interval(-Inf, 0.0)) --> false
    @fact isentire(Interval(-Inf, -0.0)) --> false
    @fact isentire(Interval(0.0, Inf)) --> false
    @fact isentire(Interval(-0.0, Inf)) --> false
    @fact isentire(Interval(-0.0, 0.0)) --> false
    @fact isentire(Interval(0.0, -0.0)) --> false
    @fact isentire(Interval(0.0, 0.0)) --> false
    @fact isentire(Interval(-0.0, -0.0)) --> false
end

facts("minimal_entire_dec_test") do
    @fact isentire(Decorated(∅, trv)) --> false
    @fact isentire(Decorated(Interval(-Inf, Inf), trv)) --> true
    @fact isentire(Decorated(Interval(-Inf, Inf), def)) --> true
    @fact isentire(Decorated(Interval(-Inf, Inf), dac)) --> true
    @fact isentire(Decorated(Interval(1.0, 2.0), com)) --> false
    @fact isentire(Decorated(Interval(-1.0, 2.0), trv)) --> false
    @fact isentire(Decorated(Interval(-3.0, -2.0), dac)) --> false
    @fact isentire(Decorated(Interval(-Inf, 2.0), trv)) --> false
    @fact isentire(Decorated(Interval(-Inf, 0.0), trv)) --> false
    @fact isentire(Decorated(Interval(-Inf, -0.0), trv)) --> false
    @fact isentire(Decorated(Interval(0.0, Inf), def)) --> false
    @fact isentire(Decorated(Interval(-0.0, Inf), trv)) --> false
    @fact isentire(Decorated(Interval(-0.0, 0.0), com)) --> false
    @fact isentire(Decorated(Interval(0.0, -0.0), trv)) --> false
    @fact isentire(Decorated(Interval(0.0, 0.0), trv)) --> false
    @fact isentire(Decorated(Interval(-0.0, -0.0), trv)) --> false
end

facts("minimal_nai_dec_test") do
    @fact isnai(Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact isnai(Decorated(Interval(-Inf, Inf), def)) --> false
    @fact isnai(Decorated(Interval(-Inf, Inf), dac)) --> false
    @fact isnai(Decorated(Interval(1.0, 2.0), com)) --> false
    @fact isnai(Decorated(Interval(-1.0, 2.0), trv)) --> false
    @fact isnai(Decorated(Interval(-3.0, -2.0), dac)) --> false
    @fact isnai(Decorated(Interval(-Inf, 2.0), trv)) --> false
    @fact isnai(Decorated(Interval(-Inf, 0.0), trv)) --> false
    @fact isnai(Decorated(Interval(-Inf, -0.0), trv)) --> false
    @fact isnai(Decorated(Interval(0.0, Inf), def)) --> false
    @fact isnai(Decorated(Interval(-0.0, Inf), trv)) --> false
    @fact isnai(Decorated(Interval(-0.0, 0.0), com)) --> false
    @fact isnai(Decorated(Interval(0.0, -0.0), trv)) --> false
    @fact isnai(Decorated(Interval(0.0, 0.0), trv)) --> false
    @fact isnai(Decorated(Interval(-0.0, -0.0), trv)) --> false
end

facts("minimal_equal_test") do
    @fact Interval(1.0, 2.0) == Interval(1.0, 2.0) --> true
    @fact Interval(1.0, 2.1) == Interval(1.0, 2.0) --> false
    @fact ∅ == ∅ --> true
    @fact ∅ == Interval(1.0, 2.0) --> false
    @fact Interval(-Inf, Inf) == Interval(-Inf, Inf) --> true
    @fact Interval(1.0, 2.4) == Interval(-Inf, Inf) --> false
    @fact Interval(1.0, Inf) == Interval(1.0, Inf) --> true
    @fact Interval(1.0, 2.4) == Interval(1.0, Inf) --> false
    @fact Interval(-Inf, 2.0) == Interval(-Inf, 2.0) --> true
    @fact Interval(-Inf, 2.4) == Interval(-Inf, 2.0) --> false
    @fact Interval(-2.0, 0.0) == Interval(-2.0, 0.0) --> true
    @fact Interval(-0.0, 2.0) == Interval(0.0, 2.0) --> true
    @fact Interval(-0.0, -0.0) == Interval(0.0, 0.0) --> true
    @fact Interval(-0.0, 0.0) == Interval(0.0, 0.0) --> true
    @fact Interval(0.0, -0.0) == Interval(0.0, 0.0) --> true
end

facts("minimal_equal_dec_test") do
    @fact Decorated(Interval(1.0, 2.0), def) == Decorated(Interval(1.0, 2.0), trv) --> true
    @fact Decorated(Interval(1.0, 2.1), trv) == Decorated(Interval(1.0, 2.0), trv) --> false
    @fact Decorated(∅, trv) == Decorated(∅, trv) --> true
    @fact Decorated(∅, trv) == Decorated(Interval(1.0, 2.0), trv) --> false
    @fact Decorated(∅, trv) == Decorated(Interval(1.0, 2.0), trv) --> false
    @fact Decorated(Interval(-Inf, Inf), def) == Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(1.0, 2.4), trv) == Decorated(Interval(-Inf, Inf), trv) --> false
    @fact Decorated(Interval(1.0, Inf), trv) == Decorated(Interval(1.0, Inf), trv) --> true
    @fact Decorated(Interval(1.0, 2.4), def) == Decorated(Interval(1.0, Inf), trv) --> false
    @fact Decorated(Interval(-Inf, 2.0), trv) == Decorated(Interval(-Inf, 2.0), trv) --> true
    @fact Decorated(Interval(-Inf, 2.4), def) == Decorated(Interval(-Inf, 2.0), trv) --> false
    @fact Decorated(Interval(-2.0, 0.0), trv) == Decorated(Interval(-2.0, 0.0), trv) --> true
    @fact Decorated(Interval(-0.0, 2.0), def) == Decorated(Interval(0.0, 2.0), trv) --> true
    @fact Decorated(Interval(-0.0, -0.0), trv) == Decorated(Interval(0.0, 0.0), trv) --> true
    @fact Decorated(Interval(-0.0, 0.0), def) == Decorated(Interval(0.0, 0.0), trv) --> true
    @fact Decorated(Interval(0.0, -0.0), trv) == Decorated(Interval(0.0, 0.0), trv) --> true
end

facts("minimal_subset_test") do
    @fact ∅ ⊆ ∅ --> true
    @fact ∅ ⊆ Interval(0.0, 4.0) --> true
    @fact ∅ ⊆ Interval(-0.0, 4.0) --> true
    @fact ∅ ⊆ Interval(-0.1, 1.0) --> true
    @fact ∅ ⊆ Interval(-0.1, 0.0) --> true
    @fact ∅ ⊆ Interval(-0.1, -0.0) --> true
    @fact ∅ ⊆ Interval(-Inf, Inf) --> true
    @fact Interval(0.0, 4.0) ⊆ ∅ --> false
    @fact Interval(-0.0, 4.0) ⊆ ∅ --> false
    @fact Interval(-0.1, 1.0) ⊆ ∅ --> false
    @fact Interval(-Inf, Inf) ⊆ ∅ --> false
    @fact Interval(0.0, 4.0) ⊆ Interval(-Inf, Inf) --> true
    @fact Interval(-0.0, 4.0) ⊆ Interval(-Inf, Inf) --> true
    @fact Interval(-0.1, 1.0) ⊆ Interval(-Inf, Inf) --> true
    @fact Interval(-Inf, Inf) ⊆ Interval(-Inf, Inf) --> true
    @fact Interval(1.0, 2.0) ⊆ Interval(1.0, 2.0) --> true
    @fact Interval(1.0, 2.0) ⊆ Interval(0.0, 4.0) --> true
    @fact Interval(1.0, 2.0) ⊆ Interval(-0.0, 4.0) --> true
    @fact Interval(0.1, 0.2) ⊆ Interval(0.0, 4.0) --> true
    @fact Interval(0.1, 0.2) ⊆ Interval(-0.0, 4.0) --> true
    @fact Interval(-0.1, -0.1) ⊆ Interval(-4.0, 3.4) --> true
    @fact Interval(0.0, 0.0) ⊆ Interval(-0.0, -0.0) --> true
    @fact Interval(-0.0, -0.0) ⊆ Interval(0.0, 0.0) --> true
    @fact Interval(-0.0, 0.0) ⊆ Interval(0.0, 0.0) --> true
    @fact Interval(-0.0, 0.0) ⊆ Interval(0.0, -0.0) --> true
    @fact Interval(0.0, -0.0) ⊆ Interval(0.0, 0.0) --> true
    @fact Interval(0.0, -0.0) ⊆ Interval(-0.0, 0.0) --> true
end

facts("minimal_subset_dec_test") do
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(0.0, 4.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(-0.0, 4.0), def) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(-0.1, 1.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(-0.1, 0.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(-0.1, -0.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(0.0, 4.0), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(Interval(-0.0, 4.0), def) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(Interval(-0.1, 1.0), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(Interval(0.0, 4.0), trv) ⊆ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(-0.0, 4.0), trv) ⊆ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(-0.1, 1.0), trv) ⊆ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(-Inf, Inf), trv) ⊆ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(1.0, 2.0), trv) ⊆ Decorated(Interval(1.0, 2.0), trv) --> true
    @fact Decorated(Interval(1.0, 2.0), trv) ⊆ Decorated(Interval(0.0, 4.0), trv) --> true
    @fact Decorated(Interval(1.0, 2.0), def) ⊆ Decorated(Interval(-0.0, 4.0), def) --> true
    @fact Decorated(Interval(0.1, 0.2), trv) ⊆ Decorated(Interval(0.0, 4.0), trv) --> true
    @fact Decorated(Interval(0.1, 0.2), trv) ⊆ Decorated(Interval(-0.0, 4.0), def) --> true
    @fact Decorated(Interval(-0.1, -0.1), trv) ⊆ Decorated(Interval(-4.0, 3.4), trv) --> true
    @fact Decorated(Interval(0.0, 0.0), trv) ⊆ Decorated(Interval(-0.0, -0.0), trv) --> true
    @fact Decorated(Interval(-0.0, -0.0), trv) ⊆ Decorated(Interval(0.0, 0.0), def) --> true
    @fact Decorated(Interval(-0.0, 0.0), trv) ⊆ Decorated(Interval(0.0, 0.0), trv) --> true
    @fact Decorated(Interval(-0.0, 0.0), trv) ⊆ Decorated(Interval(0.0, -0.0), trv) --> true
    @fact Decorated(Interval(0.0, -0.0), def) ⊆ Decorated(Interval(0.0, 0.0), trv) --> true
    @fact Decorated(Interval(0.0, -0.0), trv) ⊆ Decorated(Interval(-0.0, 0.0), trv) --> true
end

facts("minimal_less_test") do
    @fact <=(∅, ∅) --> true
    @fact ∅ ≤ ∅ --> true
    @fact <=(Interval(1.0, 2.0), ∅) --> false
    @fact Interval(1.0, 2.0) ≤ ∅ --> false
    @fact <=(∅, Interval(1.0, 2.0)) --> false
    @fact ∅ ≤ Interval(1.0, 2.0) --> false
    @fact <=(Interval(-Inf, Inf), Interval(-Inf, Inf)) --> true
    @fact Interval(-Inf, Inf) ≤ Interval(-Inf, Inf) --> true
    @fact <=(Interval(1.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact Interval(1.0, 2.0) ≤ Interval(-Inf, Inf) --> false
    @fact <=(Interval(0.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact Interval(0.0, 2.0) ≤ Interval(-Inf, Inf) --> false
    @fact <=(Interval(-0.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact Interval(-0.0, 2.0) ≤ Interval(-Inf, Inf) --> false
    @fact <=(Interval(-Inf, Inf), Interval(1.0, 2.0)) --> false
    @fact Interval(-Inf, Inf) ≤ Interval(1.0, 2.0) --> false
    @fact <=(Interval(-Inf, Inf), Interval(0.0, 2.0)) --> false
    @fact Interval(-Inf, Inf) ≤ Interval(0.0, 2.0) --> false
    @fact <=(Interval(-Inf, Inf), Interval(-0.0, 2.0)) --> false
    @fact Interval(-Inf, Inf) ≤ Interval(-0.0, 2.0) --> false
    @fact <=(Interval(0.0, 2.0), Interval(0.0, 2.0)) --> true
    @fact Interval(0.0, 2.0) ≤ Interval(0.0, 2.0) --> true
    @fact <=(Interval(0.0, 2.0), Interval(-0.0, 2.0)) --> true
    @fact Interval(0.0, 2.0) ≤ Interval(-0.0, 2.0) --> true
    @fact <=(Interval(0.0, 2.0), Interval(1.0, 2.0)) --> true
    @fact Interval(0.0, 2.0) ≤ Interval(1.0, 2.0) --> true
    @fact <=(Interval(-0.0, 2.0), Interval(1.0, 2.0)) --> true
    @fact Interval(-0.0, 2.0) ≤ Interval(1.0, 2.0) --> true
    @fact <=(Interval(1.0, 2.0), Interval(1.0, 2.0)) --> true
    @fact Interval(1.0, 2.0) ≤ Interval(1.0, 2.0) --> true
    @fact <=(Interval(1.0, 2.0), Interval(3.0, 4.0)) --> true
    @fact Interval(1.0, 2.0) ≤ Interval(3.0, 4.0) --> true
    @fact <=(Interval(1.0, 3.5), Interval(3.0, 4.0)) --> true
    @fact Interval(1.0, 3.5) ≤ Interval(3.0, 4.0) --> true
    @fact <=(Interval(1.0, 4.0), Interval(3.0, 4.0)) --> true
    @fact Interval(1.0, 4.0) ≤ Interval(3.0, 4.0) --> true
    @fact <=(Interval(-2.0, -1.0), Interval(-2.0, -1.0)) --> true
    @fact Interval(-2.0, -1.0) ≤ Interval(-2.0, -1.0) --> true
    @fact <=(Interval(-3.0, -1.5), Interval(-2.0, -1.0)) --> true
    @fact Interval(-3.0, -1.5) ≤ Interval(-2.0, -1.0) --> true
    @fact <=(Interval(0.0, 0.0), Interval(-0.0, -0.0)) --> true
    @fact Interval(0.0, 0.0) ≤ Interval(-0.0, -0.0) --> true
    @fact <=(Interval(-0.0, -0.0), Interval(0.0, 0.0)) --> true
    @fact Interval(-0.0, -0.0) ≤ Interval(0.0, 0.0) --> true
    @fact <=(Interval(-0.0, 0.0), Interval(0.0, 0.0)) --> true
    @fact Interval(-0.0, 0.0) ≤ Interval(0.0, 0.0) --> true
    @fact <=(Interval(-0.0, 0.0), Interval(0.0, -0.0)) --> true
    @fact Interval(-0.0, 0.0) ≤ Interval(0.0, -0.0) --> true
    @fact <=(Interval(0.0, -0.0), Interval(0.0, 0.0)) --> true
    @fact Interval(0.0, -0.0) ≤ Interval(0.0, 0.0) --> true
    @fact <=(Interval(0.0, -0.0), Interval(-0.0, 0.0)) --> true
    @fact Interval(0.0, -0.0) ≤ Interval(-0.0, 0.0) --> true
end

facts("minimal_less_dec_test") do
    @fact <=(Decorated(Interval(1.0, 2.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(Interval(1.0, 2.0), trv) ≤ Decorated(∅, trv) --> false
    @fact <=(Decorated(∅, trv), Decorated(Interval(1.0, 2.0), def)) --> false
    @fact Decorated(∅, trv) ≤ Decorated(Interval(1.0, 2.0), def) --> false
    @fact <=(Decorated(Interval(1.0, 2.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(Interval(1.0, 2.0), trv) ≤ Decorated(∅, trv) --> false
    @fact <=(Decorated(∅, trv), Decorated(Interval(1.0, 2.0), trv)) --> false
    @fact Decorated(∅, trv) ≤ Decorated(Interval(1.0, 2.0), trv) --> false
    @fact <=(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-Inf, Inf), trv)) --> true
    @fact Decorated(Interval(-Inf, Inf), trv) ≤ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact <=(Decorated(Interval(1.0, 2.0), def), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact Decorated(Interval(1.0, 2.0), def) ≤ Decorated(Interval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(Interval(0.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact Decorated(Interval(0.0, 2.0), trv) ≤ Decorated(Interval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(Interval(-0.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact Decorated(Interval(-0.0, 2.0), trv) ≤ Decorated(Interval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(1.0, 2.0), trv)) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) ≤ Decorated(Interval(1.0, 2.0), trv) --> false
    @fact <=(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(0.0, 2.0), def)) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) ≤ Decorated(Interval(0.0, 2.0), def) --> false
    @fact <=(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-0.0, 2.0), trv)) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) ≤ Decorated(Interval(-0.0, 2.0), trv) --> false
    @fact <=(Decorated(Interval(0.0, 2.0), trv), Decorated(Interval(0.0, 2.0), trv)) --> true
    @fact Decorated(Interval(0.0, 2.0), trv) ≤ Decorated(Interval(0.0, 2.0), trv) --> true
    @fact <=(Decorated(Interval(0.0, 2.0), trv), Decorated(Interval(-0.0, 2.0), trv)) --> true
    @fact Decorated(Interval(0.0, 2.0), trv) ≤ Decorated(Interval(-0.0, 2.0), trv) --> true
    @fact <=(Decorated(Interval(0.0, 2.0), def), Decorated(Interval(1.0, 2.0), def)) --> true
    @fact Decorated(Interval(0.0, 2.0), def) ≤ Decorated(Interval(1.0, 2.0), def) --> true
    @fact <=(Decorated(Interval(-0.0, 2.0), trv), Decorated(Interval(1.0, 2.0), trv)) --> true
    @fact Decorated(Interval(-0.0, 2.0), trv) ≤ Decorated(Interval(1.0, 2.0), trv) --> true
    @fact <=(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(1.0, 2.0), trv)) --> true
    @fact Decorated(Interval(1.0, 2.0), trv) ≤ Decorated(Interval(1.0, 2.0), trv) --> true
    @fact <=(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(3.0, 4.0), def)) --> true
    @fact Decorated(Interval(1.0, 2.0), trv) ≤ Decorated(Interval(3.0, 4.0), def) --> true
    @fact <=(Decorated(Interval(1.0, 3.5), trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact Decorated(Interval(1.0, 3.5), trv) ≤ Decorated(Interval(3.0, 4.0), trv) --> true
    @fact <=(Decorated(Interval(1.0, 4.0), trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact Decorated(Interval(1.0, 4.0), trv) ≤ Decorated(Interval(3.0, 4.0), trv) --> true
    @fact <=(Decorated(Interval(-2.0, -1.0), trv), Decorated(Interval(-2.0, -1.0), trv)) --> true
    @fact Decorated(Interval(-2.0, -1.0), trv) ≤ Decorated(Interval(-2.0, -1.0), trv) --> true
    @fact <=(Decorated(Interval(-3.0, -1.5), trv), Decorated(Interval(-2.0, -1.0), trv)) --> true
    @fact Decorated(Interval(-3.0, -1.5), trv) ≤ Decorated(Interval(-2.0, -1.0), trv) --> true
    @fact <=(Decorated(Interval(0.0, 0.0), trv), Decorated(Interval(-0.0, -0.0), trv)) --> true
    @fact Decorated(Interval(0.0, 0.0), trv) ≤ Decorated(Interval(-0.0, -0.0), trv) --> true
    @fact <=(Decorated(Interval(-0.0, -0.0), trv), Decorated(Interval(0.0, 0.0), def)) --> true
    @fact Decorated(Interval(-0.0, -0.0), trv) ≤ Decorated(Interval(0.0, 0.0), def) --> true
    @fact <=(Decorated(Interval(-0.0, 0.0), trv), Decorated(Interval(0.0, 0.0), trv)) --> true
    @fact Decorated(Interval(-0.0, 0.0), trv) ≤ Decorated(Interval(0.0, 0.0), trv) --> true
    @fact <=(Decorated(Interval(-0.0, 0.0), trv), Decorated(Interval(0.0, -0.0), trv)) --> true
    @fact Decorated(Interval(-0.0, 0.0), trv) ≤ Decorated(Interval(0.0, -0.0), trv) --> true
    @fact <=(Decorated(Interval(0.0, -0.0), def), Decorated(Interval(0.0, 0.0), trv)) --> true
    @fact Decorated(Interval(0.0, -0.0), def) ≤ Decorated(Interval(0.0, 0.0), trv) --> true
    @fact <=(Decorated(Interval(0.0, -0.0), trv), Decorated(Interval(-0.0, 0.0), trv)) --> true
    @fact Decorated(Interval(0.0, -0.0), trv) ≤ Decorated(Interval(-0.0, 0.0), trv) --> true
end

facts("minimal_precedes_test") do
    @fact precedes(∅, Interval(3.0, 4.0)) --> true
    @fact precedes(Interval(3.0, 4.0), ∅) --> true
    @fact precedes(∅, ∅) --> true
    @fact precedes(Interval(1.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact precedes(Interval(0.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact precedes(Interval(-0.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact precedes(Interval(-Inf, Inf), Interval(1.0, 2.0)) --> false
    @fact precedes(Interval(-Inf, Inf), Interval(-Inf, Inf)) --> false
    @fact precedes(Interval(1.0, 2.0), Interval(3.0, 4.0)) --> true
    @fact precedes(Interval(1.0, 3.0), Interval(3.0, 4.0)) --> true
    @fact precedes(Interval(-3.0, -1.0), Interval(-1.0, 0.0)) --> true
    @fact precedes(Interval(-3.0, -1.0), Interval(-1.0, -0.0)) --> true
    @fact precedes(Interval(1.0, 3.5), Interval(3.0, 4.0)) --> false
    @fact precedes(Interval(1.0, 4.0), Interval(3.0, 4.0)) --> false
    @fact precedes(Interval(-3.0, -0.1), Interval(-1.0, 0.0)) --> false
    @fact precedes(Interval(0.0, 0.0), Interval(-0.0, -0.0)) --> true
    @fact precedes(Interval(-0.0, -0.0), Interval(0.0, 0.0)) --> true
    @fact precedes(Interval(-0.0, 0.0), Interval(0.0, 0.0)) --> true
    @fact precedes(Interval(-0.0, 0.0), Interval(0.0, -0.0)) --> true
    @fact precedes(Interval(0.0, -0.0), Interval(0.0, 0.0)) --> true
    @fact precedes(Interval(0.0, -0.0), Interval(-0.0, 0.0)) --> true
end

facts("minimal_precedes_dec_test") do
    @fact precedes(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), def)) --> true
    @fact precedes(Decorated(Interval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact precedes(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact precedes(Decorated(Interval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact precedes(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(Interval(0.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(Interval(-0.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(1.0, 2.0), trv)) --> false
    @fact precedes(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact precedes(Decorated(Interval(1.0, 3.0), trv), Decorated(Interval(3.0, 4.0), def)) --> true
    @fact precedes(Decorated(Interval(-3.0, -1.0), def), Decorated(Interval(-1.0, 0.0), trv)) --> true
    @fact precedes(Decorated(Interval(-3.0, -1.0), trv), Decorated(Interval(-1.0, -0.0), trv)) --> true
    @fact precedes(Decorated(Interval(1.0, 3.5), trv), Decorated(Interval(3.0, 4.0), trv)) --> false
    @fact precedes(Decorated(Interval(1.0, 4.0), trv), Decorated(Interval(3.0, 4.0), trv)) --> false
    @fact precedes(Decorated(Interval(-3.0, -0.1), trv), Decorated(Interval(-1.0, 0.0), trv)) --> false
    @fact precedes(Decorated(Interval(0.0, 0.0), trv), Decorated(Interval(-0.0, -0.0), trv)) --> true
    @fact precedes(Decorated(Interval(-0.0, -0.0), trv), Decorated(Interval(0.0, 0.0), def)) --> true
    @fact precedes(Decorated(Interval(-0.0, 0.0), trv), Decorated(Interval(0.0, 0.0), trv)) --> true
    @fact precedes(Decorated(Interval(-0.0, 0.0), def), Decorated(Interval(0.0, -0.0), trv)) --> true
    @fact precedes(Decorated(Interval(0.0, -0.0), trv), Decorated(Interval(0.0, 0.0), trv)) --> true
    @fact precedes(Decorated(Interval(0.0, -0.0), trv), Decorated(Interval(-0.0, 0.0), trv)) --> true
end

facts("minimal_interior_test") do
    @fact ∅ ⪽ ∅ --> true
    @fact interior(∅, ∅) --> true
    @fact ∅ ⪽ Interval(0.0, 4.0) --> true
    @fact interior(∅, Interval(0.0, 4.0)) --> true
    @fact Interval(0.0, 4.0) ⪽ ∅ --> false
    @fact interior(Interval(0.0, 4.0), ∅) --> false
    @fact Interval(-Inf, Inf) ⪽ Interval(-Inf, Inf) --> true
    @fact interior(Interval(-Inf, Inf), Interval(-Inf, Inf)) --> true
    @fact Interval(0.0, 4.0) ⪽ Interval(-Inf, Inf) --> true
    @fact interior(Interval(0.0, 4.0), Interval(-Inf, Inf)) --> true
    @fact ∅ ⪽ Interval(-Inf, Inf) --> true
    @fact interior(∅, Interval(-Inf, Inf)) --> true
    @fact Interval(-Inf, Inf) ⪽ Interval(0.0, 4.0) --> false
    @fact interior(Interval(-Inf, Inf), Interval(0.0, 4.0)) --> false
    @fact Interval(0.0, 4.0) ⪽ Interval(0.0, 4.0) --> false
    @fact interior(Interval(0.0, 4.0), Interval(0.0, 4.0)) --> false
    @fact Interval(1.0, 2.0) ⪽ Interval(0.0, 4.0) --> true
    @fact interior(Interval(1.0, 2.0), Interval(0.0, 4.0)) --> true
    @fact Interval(-2.0, 2.0) ⪽ Interval(-2.0, 4.0) --> false
    @fact interior(Interval(-2.0, 2.0), Interval(-2.0, 4.0)) --> false
    @fact Interval(-0.0, -0.0) ⪽ Interval(-2.0, 4.0) --> true
    @fact interior(Interval(-0.0, -0.0), Interval(-2.0, 4.0)) --> true
    @fact Interval(0.0, 0.0) ⪽ Interval(-2.0, 4.0) --> true
    @fact interior(Interval(0.0, 0.0), Interval(-2.0, 4.0)) --> true
    @fact Interval(0.0, 0.0) ⪽ Interval(-0.0, -0.0) --> false
    @fact interior(Interval(0.0, 0.0), Interval(-0.0, -0.0)) --> false
    @fact Interval(0.0, 4.4) ⪽ Interval(0.0, 4.0) --> false
    @fact interior(Interval(0.0, 4.4), Interval(0.0, 4.0)) --> false
    @fact Interval(-1.0, -1.0) ⪽ Interval(0.0, 4.0) --> false
    @fact interior(Interval(-1.0, -1.0), Interval(0.0, 4.0)) --> false
    @fact Interval(2.0, 2.0) ⪽ Interval(-2.0, -1.0) --> false
    @fact interior(Interval(2.0, 2.0), Interval(-2.0, -1.0)) --> false
end

facts("minimal_interior_dec_test") do
    @fact Decorated(∅, trv) ⪽ Decorated(Interval(0.0, 4.0), trv) --> true
    @fact interior(Decorated(∅, trv), Decorated(Interval(0.0, 4.0), trv)) --> true
    @fact Decorated(Interval(0.0, 4.0), def) ⪽ Decorated(∅, trv) --> false
    @fact interior(Decorated(Interval(0.0, 4.0), def), Decorated(∅, trv)) --> false
    @fact Decorated(Interval(0.0, 4.0), trv) ⪽ Decorated(∅, trv) --> false
    @fact interior(Decorated(Interval(0.0, 4.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) ⪽ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-Inf, Inf), trv)) --> true
    @fact Decorated(Interval(0.0, 4.0), trv) ⪽ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(Interval(0.0, 4.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> true
    @fact Decorated(∅, trv) ⪽ Decorated(Interval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(∅, trv), Decorated(Interval(-Inf, Inf), trv)) --> true
    @fact Decorated(Interval(-Inf, Inf), trv) ⪽ Decorated(Interval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(0.0, 4.0), trv)) --> false
    @fact Decorated(Interval(0.0, 4.0), trv) ⪽ Decorated(Interval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(Interval(0.0, 4.0), trv), Decorated(Interval(0.0, 4.0), trv)) --> false
    @fact Decorated(Interval(1.0, 2.0), def) ⪽ Decorated(Interval(0.0, 4.0), trv) --> true
    @fact interior(Decorated(Interval(1.0, 2.0), def), Decorated(Interval(0.0, 4.0), trv)) --> true
    @fact Decorated(Interval(-2.0, 2.0), trv) ⪽ Decorated(Interval(-2.0, 4.0), def) --> false
    @fact interior(Decorated(Interval(-2.0, 2.0), trv), Decorated(Interval(-2.0, 4.0), def)) --> false
    @fact Decorated(Interval(-0.0, -0.0), trv) ⪽ Decorated(Interval(-2.0, 4.0), trv) --> true
    @fact interior(Decorated(Interval(-0.0, -0.0), trv), Decorated(Interval(-2.0, 4.0), trv)) --> true
    @fact Decorated(Interval(0.0, 0.0), def) ⪽ Decorated(Interval(-2.0, 4.0), trv) --> true
    @fact interior(Decorated(Interval(0.0, 0.0), def), Decorated(Interval(-2.0, 4.0), trv)) --> true
    @fact Decorated(Interval(0.0, 0.0), trv) ⪽ Decorated(Interval(-0.0, -0.0), trv) --> false
    @fact interior(Decorated(Interval(0.0, 0.0), trv), Decorated(Interval(-0.0, -0.0), trv)) --> false
    @fact Decorated(Interval(0.0, 4.4), trv) ⪽ Decorated(Interval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(Interval(0.0, 4.4), trv), Decorated(Interval(0.0, 4.0), trv)) --> false
    @fact Decorated(Interval(-1.0, -1.0), trv) ⪽ Decorated(Interval(0.0, 4.0), def) --> false
    @fact interior(Decorated(Interval(-1.0, -1.0), trv), Decorated(Interval(0.0, 4.0), def)) --> false
    @fact Decorated(Interval(2.0, 2.0), def) ⪽ Decorated(Interval(-2.0, -1.0), trv) --> false
    @fact interior(Decorated(Interval(2.0, 2.0), def), Decorated(Interval(-2.0, -1.0), trv)) --> false
end

facts("minimal_strictLess_test") do
    @fact ∅ < ∅ --> true
    @fact Interval(1.0, 2.0) < ∅ --> false
    @fact ∅ < Interval(1.0, 2.0) --> false
    @fact Interval(-Inf, Inf) < Interval(-Inf, Inf) --> true
    @fact Interval(1.0, 2.0) < Interval(-Inf, Inf) --> false
    @fact Interval(-Inf, Inf) < Interval(1.0, 2.0) --> false
    @fact Interval(1.0, 2.0) < Interval(1.0, 2.0) --> false
    @fact Interval(1.0, 2.0) < Interval(3.0, 4.0) --> true
    @fact Interval(1.0, 3.5) < Interval(3.0, 4.0) --> true
    @fact Interval(1.0, 4.0) < Interval(3.0, 4.0) --> false
    @fact Interval(0.0, 4.0) < Interval(0.0, 4.0) --> false
    @fact Interval(-0.0, 4.0) < Interval(0.0, 4.0) --> false
    @fact Interval(-2.0, -1.0) < Interval(-2.0, -1.0) --> false
    @fact Interval(-3.0, -1.5) < Interval(-2.0, -1.0) --> true
end

facts("minimal_strictLess_dec_test") do
    @fact Decorated(Interval(1.0, 2.0), trv) < Decorated(∅, trv) --> false
    @fact Decorated(∅, trv) < Decorated(Interval(1.0, 2.0), def) --> false
    @fact Decorated(Interval(1.0, 2.0), def) < Decorated(∅, trv) --> false
    @fact Decorated(∅, trv) < Decorated(Interval(1.0, 2.0), def) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) < Decorated(Interval(-Inf, Inf), trv) --> true
    @fact Decorated(Interval(1.0, 2.0), trv) < Decorated(Interval(-Inf, Inf), trv) --> false
    @fact Decorated(Interval(-Inf, Inf), trv) < Decorated(Interval(1.0, 2.0), trv) --> false
    @fact Decorated(Interval(1.0, 2.0), trv) < Decorated(Interval(1.0, 2.0), trv) --> false
    @fact Decorated(Interval(1.0, 2.0), trv) < Decorated(Interval(3.0, 4.0), trv) --> true
    @fact Decorated(Interval(1.0, 3.5), def) < Decorated(Interval(3.0, 4.0), trv) --> true
    @fact Decorated(Interval(1.0, 4.0), trv) < Decorated(Interval(3.0, 4.0), def) --> false
    @fact Decorated(Interval(0.0, 4.0), trv) < Decorated(Interval(0.0, 4.0), def) --> false
    @fact Decorated(Interval(-0.0, 4.0), def) < Decorated(Interval(0.0, 4.0), trv) --> false
    @fact Decorated(Interval(-2.0, -1.0), def) < Decorated(Interval(-2.0, -1.0), def) --> false
    @fact Decorated(Interval(-3.0, -1.5), trv) < Decorated(Interval(-2.0, -1.0), trv) --> true
end

facts("minimal_strictPrecedes_test") do
    @fact strictprecedes(∅, Interval(3.0, 4.0)) --> true
    @fact strictprecedes(Interval(3.0, 4.0), ∅) --> true
    @fact strictprecedes(∅, ∅) --> true
    @fact strictprecedes(Interval(1.0, 2.0), Interval(-Inf, Inf)) --> false
    @fact strictprecedes(Interval(-Inf, Inf), Interval(1.0, 2.0)) --> false
    @fact strictprecedes(Interval(-Inf, Inf), Interval(-Inf, Inf)) --> false
    @fact strictprecedes(Interval(1.0, 2.0), Interval(3.0, 4.0)) --> true
    @fact strictprecedes(Interval(1.0, 3.0), Interval(3.0, 4.0)) --> false
    @fact strictprecedes(Interval(-3.0, -1.0), Interval(-1.0, 0.0)) --> false
    @fact strictprecedes(Interval(-3.0, -0.0), Interval(0.0, 1.0)) --> false
    @fact strictprecedes(Interval(-3.0, 0.0), Interval(-0.0, 1.0)) --> false
    @fact strictprecedes(Interval(1.0, 3.5), Interval(3.0, 4.0)) --> false
    @fact strictprecedes(Interval(1.0, 4.0), Interval(3.0, 4.0)) --> false
    @fact strictprecedes(Interval(-3.0, -0.1), Interval(-1.0, 0.0)) --> false
end

facts("minimal_strictPrecedes_dec_test") do
    @fact strictprecedes(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(Interval(3.0, 4.0), def), Decorated(∅, trv)) --> true
    @fact strictprecedes(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(Interval(3.0, 4.0), def), Decorated(∅, trv)) --> true
    @fact strictprecedes(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact strictprecedes(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(1.0, 2.0), trv)) --> false
    @fact strictprecedes(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact strictprecedes(Decorated(Interval(1.0, 2.0), trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(Interval(1.0, 3.0), def), Decorated(Interval(3.0, 4.0), trv)) --> false
    @fact strictprecedes(Decorated(Interval(-3.0, -1.0), trv), Decorated(Interval(-1.0, 0.0), def)) --> false
    @fact strictprecedes(Decorated(Interval(-3.0, -0.0), def), Decorated(Interval(0.0, 1.0), trv)) --> false
    @fact strictprecedes(Decorated(Interval(-3.0, 0.0), trv), Decorated(Interval(-0.0, 1.0), trv)) --> false
    @fact strictprecedes(Decorated(Interval(1.0, 3.5), trv), Decorated(Interval(3.0, 4.0), trv)) --> false
    @fact strictprecedes(Decorated(Interval(1.0, 4.0), trv), Decorated(Interval(3.0, 4.0), def)) --> false
    @fact strictprecedes(Decorated(Interval(-3.0, -0.1), trv), Decorated(Interval(-1.0, 0.0), trv)) --> false
end

facts("minimal_disjoint_test") do
    @fact isdisjoint(∅, Interval(3.0, 4.0)) --> true
    @fact isdisjoint(Interval(3.0, 4.0), ∅) --> true
    @fact isdisjoint(∅, ∅) --> true
    @fact isdisjoint(Interval(3.0, 4.0), Interval(1.0, 2.0)) --> true
    @fact isdisjoint(Interval(0.0, 0.0), Interval(-0.0, -0.0)) --> false
    @fact isdisjoint(Interval(0.0, -0.0), Interval(-0.0, 0.0)) --> false
    @fact isdisjoint(Interval(3.0, 4.0), Interval(1.0, 7.0)) --> false
    @fact isdisjoint(Interval(3.0, 4.0), Interval(-Inf, Inf)) --> false
    @fact isdisjoint(Interval(-Inf, Inf), Interval(1.0, 7.0)) --> false
    @fact isdisjoint(Interval(-Inf, Inf), Interval(-Inf, Inf)) --> false
end

facts("minimal_disjoint_dec_test") do
    @fact isdisjoint(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), def)) --> true
    @fact isdisjoint(Decorated(Interval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact isdisjoint(Decorated(∅, trv), Decorated(Interval(3.0, 4.0), trv)) --> true
    @fact isdisjoint(Decorated(Interval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact isdisjoint(Decorated(Interval(3.0, 4.0), trv), Decorated(Interval(1.0, 2.0), def)) --> true
    @fact isdisjoint(Decorated(Interval(0.0, 0.0), trv), Decorated(Interval(-0.0, -0.0), trv)) --> false
    @fact isdisjoint(Decorated(Interval(0.0, -0.0), trv), Decorated(Interval(-0.0, 0.0), trv)) --> false
    @fact isdisjoint(Decorated(Interval(3.0, 4.0), def), Decorated(Interval(1.0, 7.0), def)) --> false
    @fact isdisjoint(Decorated(Interval(3.0, 4.0), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
    @fact isdisjoint(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(1.0, 7.0), trv)) --> false
    @fact isdisjoint(Decorated(Interval(-Inf, Inf), trv), Decorated(Interval(-Inf, Inf), trv)) --> false
end
# FactCheck.exitstatus()
