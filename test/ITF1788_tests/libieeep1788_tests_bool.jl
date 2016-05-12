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
setprecision(BareInterval, Float64)
setrounding(BareInterval, :narrow)

facts("minimal_empty_test") do
    @fact isempty(∅) --> true
    @fact isempty(BareInterval(-Inf, Inf)) --> false
    @fact isempty(BareInterval(1.0, 2.0)) --> false
    @fact isempty(BareInterval(-1.0, 2.0)) --> false
    @fact isempty(BareInterval(-3.0, -2.0)) --> false
    @fact isempty(BareInterval(-Inf, 2.0)) --> false
    @fact isempty(BareInterval(-Inf, 0.0)) --> false
    @fact isempty(BareInterval(-Inf, -0.0)) --> false
    @fact isempty(BareInterval(0.0, Inf)) --> false
    @fact isempty(BareInterval(-0.0, Inf)) --> false
    @fact isempty(BareInterval(-0.0, 0.0)) --> false
    @fact isempty(BareInterval(0.0, -0.0)) --> false
    @fact isempty(BareInterval(0.0, 0.0)) --> false
    @fact isempty(BareInterval(-0.0, -0.0)) --> false
end

facts("minimal_empty_dec_test") do
    @fact isempty(Decorated(∅, trv)) --> true
    @fact isempty(Decorated(BareInterval(-Inf, Inf), def)) --> false
    @fact isempty(Decorated(BareInterval(1.0, 2.0), com)) --> false
    @fact isempty(Decorated(BareInterval(-1.0, 2.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(-3.0, -2.0), dac)) --> false
    @fact isempty(Decorated(BareInterval(-Inf, 2.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(-Inf, 0.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(-Inf, -0.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(0.0, Inf), def)) --> false
    @fact isempty(Decorated(BareInterval(-0.0, Inf), trv)) --> false
    @fact isempty(Decorated(BareInterval(-0.0, 0.0), com)) --> false
    @fact isempty(Decorated(BareInterval(0.0, -0.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(0.0, 0.0), trv)) --> false
    @fact isempty(Decorated(BareInterval(-0.0, -0.0), trv)) --> false
end

facts("minimal_entire_test") do
    @fact isentire(∅) --> false
    @fact isentire(BareInterval(-Inf, Inf)) --> true
    @fact isentire(BareInterval(1.0, 2.0)) --> false
    @fact isentire(BareInterval(-1.0, 2.0)) --> false
    @fact isentire(BareInterval(-3.0, -2.0)) --> false
    @fact isentire(BareInterval(-Inf, 2.0)) --> false
    @fact isentire(BareInterval(-Inf, 0.0)) --> false
    @fact isentire(BareInterval(-Inf, -0.0)) --> false
    @fact isentire(BareInterval(0.0, Inf)) --> false
    @fact isentire(BareInterval(-0.0, Inf)) --> false
    @fact isentire(BareInterval(-0.0, 0.0)) --> false
    @fact isentire(BareInterval(0.0, -0.0)) --> false
    @fact isentire(BareInterval(0.0, 0.0)) --> false
    @fact isentire(BareInterval(-0.0, -0.0)) --> false
end

facts("minimal_entire_dec_test") do
    @fact isentire(Decorated(∅, trv)) --> false
    @fact isentire(Decorated(BareInterval(-Inf, Inf), trv)) --> true
    @fact isentire(Decorated(BareInterval(-Inf, Inf), def)) --> true
    @fact isentire(Decorated(BareInterval(-Inf, Inf), dac)) --> true
    @fact isentire(Decorated(BareInterval(1.0, 2.0), com)) --> false
    @fact isentire(Decorated(BareInterval(-1.0, 2.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(-3.0, -2.0), dac)) --> false
    @fact isentire(Decorated(BareInterval(-Inf, 2.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(-Inf, 0.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(-Inf, -0.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(0.0, Inf), def)) --> false
    @fact isentire(Decorated(BareInterval(-0.0, Inf), trv)) --> false
    @fact isentire(Decorated(BareInterval(-0.0, 0.0), com)) --> false
    @fact isentire(Decorated(BareInterval(0.0, -0.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(0.0, 0.0), trv)) --> false
    @fact isentire(Decorated(BareInterval(-0.0, -0.0), trv)) --> false
end

facts("minimal_nai_dec_test") do
    @fact isnai(Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact isnai(Decorated(BareInterval(-Inf, Inf), def)) --> false
    @fact isnai(Decorated(BareInterval(-Inf, Inf), dac)) --> false
    @fact isnai(Decorated(BareInterval(1.0, 2.0), com)) --> false
    @fact isnai(Decorated(BareInterval(-1.0, 2.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(-3.0, -2.0), dac)) --> false
    @fact isnai(Decorated(BareInterval(-Inf, 2.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(-Inf, 0.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(-Inf, -0.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(0.0, Inf), def)) --> false
    @fact isnai(Decorated(BareInterval(-0.0, Inf), trv)) --> false
    @fact isnai(Decorated(BareInterval(-0.0, 0.0), com)) --> false
    @fact isnai(Decorated(BareInterval(0.0, -0.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(0.0, 0.0), trv)) --> false
    @fact isnai(Decorated(BareInterval(-0.0, -0.0), trv)) --> false
end

facts("minimal_equal_test") do
    @fact BareInterval(1.0, 2.0) == BareInterval(1.0, 2.0) --> true
    @fact BareInterval(1.0, 2.1) == BareInterval(1.0, 2.0) --> false
    @fact ∅ == ∅ --> true
    @fact ∅ == BareInterval(1.0, 2.0) --> false
    @fact BareInterval(-Inf, Inf) == BareInterval(-Inf, Inf) --> true
    @fact BareInterval(1.0, 2.4) == BareInterval(-Inf, Inf) --> false
    @fact BareInterval(1.0, Inf) == BareInterval(1.0, Inf) --> true
    @fact BareInterval(1.0, 2.4) == BareInterval(1.0, Inf) --> false
    @fact BareInterval(-Inf, 2.0) == BareInterval(-Inf, 2.0) --> true
    @fact BareInterval(-Inf, 2.4) == BareInterval(-Inf, 2.0) --> false
    @fact BareInterval(-2.0, 0.0) == BareInterval(-2.0, 0.0) --> true
    @fact BareInterval(-0.0, 2.0) == BareInterval(0.0, 2.0) --> true
    @fact BareInterval(-0.0, -0.0) == BareInterval(0.0, 0.0) --> true
    @fact BareInterval(-0.0, 0.0) == BareInterval(0.0, 0.0) --> true
    @fact BareInterval(0.0, -0.0) == BareInterval(0.0, 0.0) --> true
end

facts("minimal_equal_dec_test") do
    @fact Decorated(BareInterval(1.0, 2.0), def) == Decorated(BareInterval(1.0, 2.0), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.1), trv) == Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact Decorated(∅, trv) == Decorated(∅, trv) --> true
    @fact Decorated(∅, trv) == Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact Decorated(∅, trv) == Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact Decorated(BareInterval(-Inf, Inf), def) == Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.4), trv) == Decorated(BareInterval(-Inf, Inf), trv) --> false
    @fact Decorated(BareInterval(1.0, Inf), trv) == Decorated(BareInterval(1.0, Inf), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.4), def) == Decorated(BareInterval(1.0, Inf), trv) --> false
    @fact Decorated(BareInterval(-Inf, 2.0), trv) == Decorated(BareInterval(-Inf, 2.0), trv) --> true
    @fact Decorated(BareInterval(-Inf, 2.4), def) == Decorated(BareInterval(-Inf, 2.0), trv) --> false
    @fact Decorated(BareInterval(-2.0, 0.0), trv) == Decorated(BareInterval(-2.0, 0.0), trv) --> true
    @fact Decorated(BareInterval(-0.0, 2.0), def) == Decorated(BareInterval(0.0, 2.0), trv) --> true
    @fact Decorated(BareInterval(-0.0, -0.0), trv) == Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact Decorated(BareInterval(-0.0, 0.0), def) == Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact Decorated(BareInterval(0.0, -0.0), trv) == Decorated(BareInterval(0.0, 0.0), trv) --> true
end

facts("minimal_subset_test") do
    @fact ∅ ⊆ ∅ --> true
    @fact ∅ ⊆ BareInterval(0.0, 4.0) --> true
    @fact ∅ ⊆ BareInterval(-0.0, 4.0) --> true
    @fact ∅ ⊆ BareInterval(-0.1, 1.0) --> true
    @fact ∅ ⊆ BareInterval(-0.1, 0.0) --> true
    @fact ∅ ⊆ BareInterval(-0.1, -0.0) --> true
    @fact ∅ ⊆ BareInterval(-Inf, Inf) --> true
    @fact BareInterval(0.0, 4.0) ⊆ ∅ --> false
    @fact BareInterval(-0.0, 4.0) ⊆ ∅ --> false
    @fact BareInterval(-0.1, 1.0) ⊆ ∅ --> false
    @fact BareInterval(-Inf, Inf) ⊆ ∅ --> false
    @fact BareInterval(0.0, 4.0) ⊆ BareInterval(-Inf, Inf) --> true
    @fact BareInterval(-0.0, 4.0) ⊆ BareInterval(-Inf, Inf) --> true
    @fact BareInterval(-0.1, 1.0) ⊆ BareInterval(-Inf, Inf) --> true
    @fact BareInterval(-Inf, Inf) ⊆ BareInterval(-Inf, Inf) --> true
    @fact BareInterval(1.0, 2.0) ⊆ BareInterval(1.0, 2.0) --> true
    @fact BareInterval(1.0, 2.0) ⊆ BareInterval(0.0, 4.0) --> true
    @fact BareInterval(1.0, 2.0) ⊆ BareInterval(-0.0, 4.0) --> true
    @fact BareInterval(0.1, 0.2) ⊆ BareInterval(0.0, 4.0) --> true
    @fact BareInterval(0.1, 0.2) ⊆ BareInterval(-0.0, 4.0) --> true
    @fact BareInterval(-0.1, -0.1) ⊆ BareInterval(-4.0, 3.4) --> true
    @fact BareInterval(0.0, 0.0) ⊆ BareInterval(-0.0, -0.0) --> true
    @fact BareInterval(-0.0, -0.0) ⊆ BareInterval(0.0, 0.0) --> true
    @fact BareInterval(-0.0, 0.0) ⊆ BareInterval(0.0, 0.0) --> true
    @fact BareInterval(-0.0, 0.0) ⊆ BareInterval(0.0, -0.0) --> true
    @fact BareInterval(0.0, -0.0) ⊆ BareInterval(0.0, 0.0) --> true
    @fact BareInterval(0.0, -0.0) ⊆ BareInterval(-0.0, 0.0) --> true
end

facts("minimal_subset_dec_test") do
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(0.0, 4.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(-0.0, 4.0), def) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(-0.1, 1.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(-0.1, 0.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(-0.1, -0.0), trv) --> true
    @fact Decorated(∅, trv) ⊆ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(0.0, 4.0), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(BareInterval(-0.0, 4.0), def) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(BareInterval(-0.1, 1.0), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) ⊆ Decorated(∅, trv) --> false
    @fact Decorated(BareInterval(0.0, 4.0), trv) ⊆ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(-0.0, 4.0), trv) ⊆ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(-0.1, 1.0), trv) ⊆ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(-Inf, Inf), trv) ⊆ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.0), trv) ⊆ Decorated(BareInterval(1.0, 2.0), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.0), trv) ⊆ Decorated(BareInterval(0.0, 4.0), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.0), def) ⊆ Decorated(BareInterval(-0.0, 4.0), def) --> true
    @fact Decorated(BareInterval(0.1, 0.2), trv) ⊆ Decorated(BareInterval(0.0, 4.0), trv) --> true
    @fact Decorated(BareInterval(0.1, 0.2), trv) ⊆ Decorated(BareInterval(-0.0, 4.0), def) --> true
    @fact Decorated(BareInterval(-0.1, -0.1), trv) ⊆ Decorated(BareInterval(-4.0, 3.4), trv) --> true
    @fact Decorated(BareInterval(0.0, 0.0), trv) ⊆ Decorated(BareInterval(-0.0, -0.0), trv) --> true
    @fact Decorated(BareInterval(-0.0, -0.0), trv) ⊆ Decorated(BareInterval(0.0, 0.0), def) --> true
    @fact Decorated(BareInterval(-0.0, 0.0), trv) ⊆ Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact Decorated(BareInterval(-0.0, 0.0), trv) ⊆ Decorated(BareInterval(0.0, -0.0), trv) --> true
    @fact Decorated(BareInterval(0.0, -0.0), def) ⊆ Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact Decorated(BareInterval(0.0, -0.0), trv) ⊆ Decorated(BareInterval(-0.0, 0.0), trv) --> true
end

facts("minimal_less_test") do
    @fact <=(∅, ∅) --> true
    @fact ∅ ≤ ∅ --> true
    @fact <=(BareInterval(1.0, 2.0), ∅) --> false
    @fact BareInterval(1.0, 2.0) ≤ ∅ --> false
    @fact <=(∅, BareInterval(1.0, 2.0)) --> false
    @fact ∅ ≤ BareInterval(1.0, 2.0) --> false
    @fact <=(BareInterval(-Inf, Inf), BareInterval(-Inf, Inf)) --> true
    @fact BareInterval(-Inf, Inf) ≤ BareInterval(-Inf, Inf) --> true
    @fact <=(BareInterval(1.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact BareInterval(1.0, 2.0) ≤ BareInterval(-Inf, Inf) --> false
    @fact <=(BareInterval(0.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact BareInterval(0.0, 2.0) ≤ BareInterval(-Inf, Inf) --> false
    @fact <=(BareInterval(-0.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact BareInterval(-0.0, 2.0) ≤ BareInterval(-Inf, Inf) --> false
    @fact <=(BareInterval(-Inf, Inf), BareInterval(1.0, 2.0)) --> false
    @fact BareInterval(-Inf, Inf) ≤ BareInterval(1.0, 2.0) --> false
    @fact <=(BareInterval(-Inf, Inf), BareInterval(0.0, 2.0)) --> false
    @fact BareInterval(-Inf, Inf) ≤ BareInterval(0.0, 2.0) --> false
    @fact <=(BareInterval(-Inf, Inf), BareInterval(-0.0, 2.0)) --> false
    @fact BareInterval(-Inf, Inf) ≤ BareInterval(-0.0, 2.0) --> false
    @fact <=(BareInterval(0.0, 2.0), BareInterval(0.0, 2.0)) --> true
    @fact BareInterval(0.0, 2.0) ≤ BareInterval(0.0, 2.0) --> true
    @fact <=(BareInterval(0.0, 2.0), BareInterval(-0.0, 2.0)) --> true
    @fact BareInterval(0.0, 2.0) ≤ BareInterval(-0.0, 2.0) --> true
    @fact <=(BareInterval(0.0, 2.0), BareInterval(1.0, 2.0)) --> true
    @fact BareInterval(0.0, 2.0) ≤ BareInterval(1.0, 2.0) --> true
    @fact <=(BareInterval(-0.0, 2.0), BareInterval(1.0, 2.0)) --> true
    @fact BareInterval(-0.0, 2.0) ≤ BareInterval(1.0, 2.0) --> true
    @fact <=(BareInterval(1.0, 2.0), BareInterval(1.0, 2.0)) --> true
    @fact BareInterval(1.0, 2.0) ≤ BareInterval(1.0, 2.0) --> true
    @fact <=(BareInterval(1.0, 2.0), BareInterval(3.0, 4.0)) --> true
    @fact BareInterval(1.0, 2.0) ≤ BareInterval(3.0, 4.0) --> true
    @fact <=(BareInterval(1.0, 3.5), BareInterval(3.0, 4.0)) --> true
    @fact BareInterval(1.0, 3.5) ≤ BareInterval(3.0, 4.0) --> true
    @fact <=(BareInterval(1.0, 4.0), BareInterval(3.0, 4.0)) --> true
    @fact BareInterval(1.0, 4.0) ≤ BareInterval(3.0, 4.0) --> true
    @fact <=(BareInterval(-2.0, -1.0), BareInterval(-2.0, -1.0)) --> true
    @fact BareInterval(-2.0, -1.0) ≤ BareInterval(-2.0, -1.0) --> true
    @fact <=(BareInterval(-3.0, -1.5), BareInterval(-2.0, -1.0)) --> true
    @fact BareInterval(-3.0, -1.5) ≤ BareInterval(-2.0, -1.0) --> true
    @fact <=(BareInterval(0.0, 0.0), BareInterval(-0.0, -0.0)) --> true
    @fact BareInterval(0.0, 0.0) ≤ BareInterval(-0.0, -0.0) --> true
    @fact <=(BareInterval(-0.0, -0.0), BareInterval(0.0, 0.0)) --> true
    @fact BareInterval(-0.0, -0.0) ≤ BareInterval(0.0, 0.0) --> true
    @fact <=(BareInterval(-0.0, 0.0), BareInterval(0.0, 0.0)) --> true
    @fact BareInterval(-0.0, 0.0) ≤ BareInterval(0.0, 0.0) --> true
    @fact <=(BareInterval(-0.0, 0.0), BareInterval(0.0, -0.0)) --> true
    @fact BareInterval(-0.0, 0.0) ≤ BareInterval(0.0, -0.0) --> true
    @fact <=(BareInterval(0.0, -0.0), BareInterval(0.0, 0.0)) --> true
    @fact BareInterval(0.0, -0.0) ≤ BareInterval(0.0, 0.0) --> true
    @fact <=(BareInterval(0.0, -0.0), BareInterval(-0.0, 0.0)) --> true
    @fact BareInterval(0.0, -0.0) ≤ BareInterval(-0.0, 0.0) --> true
end

facts("minimal_less_dec_test") do
    @fact <=(Decorated(BareInterval(1.0, 2.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(BareInterval(1.0, 2.0), trv) ≤ Decorated(∅, trv) --> false
    @fact <=(Decorated(∅, trv), Decorated(BareInterval(1.0, 2.0), def)) --> false
    @fact Decorated(∅, trv) ≤ Decorated(BareInterval(1.0, 2.0), def) --> false
    @fact <=(Decorated(BareInterval(1.0, 2.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(BareInterval(1.0, 2.0), trv) ≤ Decorated(∅, trv) --> false
    @fact <=(Decorated(∅, trv), Decorated(BareInterval(1.0, 2.0), trv)) --> false
    @fact Decorated(∅, trv) ≤ Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact <=(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> true
    @fact Decorated(BareInterval(-Inf, Inf), trv) ≤ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact <=(Decorated(BareInterval(1.0, 2.0), def), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact Decorated(BareInterval(1.0, 2.0), def) ≤ Decorated(BareInterval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(BareInterval(0.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact Decorated(BareInterval(0.0, 2.0), trv) ≤ Decorated(BareInterval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(BareInterval(-0.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact Decorated(BareInterval(-0.0, 2.0), trv) ≤ Decorated(BareInterval(-Inf, Inf), trv) --> false
    @fact <=(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(1.0, 2.0), trv)) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) ≤ Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact <=(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(0.0, 2.0), def)) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) ≤ Decorated(BareInterval(0.0, 2.0), def) --> false
    @fact <=(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-0.0, 2.0), trv)) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) ≤ Decorated(BareInterval(-0.0, 2.0), trv) --> false
    @fact <=(Decorated(BareInterval(0.0, 2.0), trv), Decorated(BareInterval(0.0, 2.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 2.0), trv) ≤ Decorated(BareInterval(0.0, 2.0), trv) --> true
    @fact <=(Decorated(BareInterval(0.0, 2.0), trv), Decorated(BareInterval(-0.0, 2.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 2.0), trv) ≤ Decorated(BareInterval(-0.0, 2.0), trv) --> true
    @fact <=(Decorated(BareInterval(0.0, 2.0), def), Decorated(BareInterval(1.0, 2.0), def)) --> true
    @fact Decorated(BareInterval(0.0, 2.0), def) ≤ Decorated(BareInterval(1.0, 2.0), def) --> true
    @fact <=(Decorated(BareInterval(-0.0, 2.0), trv), Decorated(BareInterval(1.0, 2.0), trv)) --> true
    @fact Decorated(BareInterval(-0.0, 2.0), trv) ≤ Decorated(BareInterval(1.0, 2.0), trv) --> true
    @fact <=(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(1.0, 2.0), trv)) --> true
    @fact Decorated(BareInterval(1.0, 2.0), trv) ≤ Decorated(BareInterval(1.0, 2.0), trv) --> true
    @fact <=(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(3.0, 4.0), def)) --> true
    @fact Decorated(BareInterval(1.0, 2.0), trv) ≤ Decorated(BareInterval(3.0, 4.0), def) --> true
    @fact <=(Decorated(BareInterval(1.0, 3.5), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(1.0, 3.5), trv) ≤ Decorated(BareInterval(3.0, 4.0), trv) --> true
    @fact <=(Decorated(BareInterval(1.0, 4.0), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(1.0, 4.0), trv) ≤ Decorated(BareInterval(3.0, 4.0), trv) --> true
    @fact <=(Decorated(BareInterval(-2.0, -1.0), trv), Decorated(BareInterval(-2.0, -1.0), trv)) --> true
    @fact Decorated(BareInterval(-2.0, -1.0), trv) ≤ Decorated(BareInterval(-2.0, -1.0), trv) --> true
    @fact <=(Decorated(BareInterval(-3.0, -1.5), trv), Decorated(BareInterval(-2.0, -1.0), trv)) --> true
    @fact Decorated(BareInterval(-3.0, -1.5), trv) ≤ Decorated(BareInterval(-2.0, -1.0), trv) --> true
    @fact <=(Decorated(BareInterval(0.0, 0.0), trv), Decorated(BareInterval(-0.0, -0.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 0.0), trv) ≤ Decorated(BareInterval(-0.0, -0.0), trv) --> true
    @fact <=(Decorated(BareInterval(-0.0, -0.0), trv), Decorated(BareInterval(0.0, 0.0), def)) --> true
    @fact Decorated(BareInterval(-0.0, -0.0), trv) ≤ Decorated(BareInterval(0.0, 0.0), def) --> true
    @fact <=(Decorated(BareInterval(-0.0, 0.0), trv), Decorated(BareInterval(0.0, 0.0), trv)) --> true
    @fact Decorated(BareInterval(-0.0, 0.0), trv) ≤ Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact <=(Decorated(BareInterval(-0.0, 0.0), trv), Decorated(BareInterval(0.0, -0.0), trv)) --> true
    @fact Decorated(BareInterval(-0.0, 0.0), trv) ≤ Decorated(BareInterval(0.0, -0.0), trv) --> true
    @fact <=(Decorated(BareInterval(0.0, -0.0), def), Decorated(BareInterval(0.0, 0.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, -0.0), def) ≤ Decorated(BareInterval(0.0, 0.0), trv) --> true
    @fact <=(Decorated(BareInterval(0.0, -0.0), trv), Decorated(BareInterval(-0.0, 0.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, -0.0), trv) ≤ Decorated(BareInterval(-0.0, 0.0), trv) --> true
end

facts("minimal_precedes_test") do
    @fact precedes(∅, BareInterval(3.0, 4.0)) --> true
    @fact precedes(BareInterval(3.0, 4.0), ∅) --> true
    @fact precedes(∅, ∅) --> true
    @fact precedes(BareInterval(1.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact precedes(BareInterval(0.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact precedes(BareInterval(-0.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact precedes(BareInterval(-Inf, Inf), BareInterval(1.0, 2.0)) --> false
    @fact precedes(BareInterval(-Inf, Inf), BareInterval(-Inf, Inf)) --> false
    @fact precedes(BareInterval(1.0, 2.0), BareInterval(3.0, 4.0)) --> true
    @fact precedes(BareInterval(1.0, 3.0), BareInterval(3.0, 4.0)) --> true
    @fact precedes(BareInterval(-3.0, -1.0), BareInterval(-1.0, 0.0)) --> true
    @fact precedes(BareInterval(-3.0, -1.0), BareInterval(-1.0, -0.0)) --> true
    @fact precedes(BareInterval(1.0, 3.5), BareInterval(3.0, 4.0)) --> false
    @fact precedes(BareInterval(1.0, 4.0), BareInterval(3.0, 4.0)) --> false
    @fact precedes(BareInterval(-3.0, -0.1), BareInterval(-1.0, 0.0)) --> false
    @fact precedes(BareInterval(0.0, 0.0), BareInterval(-0.0, -0.0)) --> true
    @fact precedes(BareInterval(-0.0, -0.0), BareInterval(0.0, 0.0)) --> true
    @fact precedes(BareInterval(-0.0, 0.0), BareInterval(0.0, 0.0)) --> true
    @fact precedes(BareInterval(-0.0, 0.0), BareInterval(0.0, -0.0)) --> true
    @fact precedes(BareInterval(0.0, -0.0), BareInterval(0.0, 0.0)) --> true
    @fact precedes(BareInterval(0.0, -0.0), BareInterval(-0.0, 0.0)) --> true
end

facts("minimal_precedes_dec_test") do
    @fact precedes(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), def)) --> true
    @fact precedes(Decorated(BareInterval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact precedes(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact precedes(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(BareInterval(0.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(BareInterval(-0.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(1.0, 2.0), trv)) --> false
    @fact precedes(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact precedes(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(1.0, 3.0), trv), Decorated(BareInterval(3.0, 4.0), def)) --> true
    @fact precedes(Decorated(BareInterval(-3.0, -1.0), def), Decorated(BareInterval(-1.0, 0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(-3.0, -1.0), trv), Decorated(BareInterval(-1.0, -0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(1.0, 3.5), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> false
    @fact precedes(Decorated(BareInterval(1.0, 4.0), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> false
    @fact precedes(Decorated(BareInterval(-3.0, -0.1), trv), Decorated(BareInterval(-1.0, 0.0), trv)) --> false
    @fact precedes(Decorated(BareInterval(0.0, 0.0), trv), Decorated(BareInterval(-0.0, -0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(-0.0, -0.0), trv), Decorated(BareInterval(0.0, 0.0), def)) --> true
    @fact precedes(Decorated(BareInterval(-0.0, 0.0), trv), Decorated(BareInterval(0.0, 0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(-0.0, 0.0), def), Decorated(BareInterval(0.0, -0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(0.0, -0.0), trv), Decorated(BareInterval(0.0, 0.0), trv)) --> true
    @fact precedes(Decorated(BareInterval(0.0, -0.0), trv), Decorated(BareInterval(-0.0, 0.0), trv)) --> true
end

facts("minimal_interior_test") do
    @fact ∅ ⪽ ∅ --> true
    @fact interior(∅, ∅) --> true
    @fact ∅ ⪽ BareInterval(0.0, 4.0) --> true
    @fact interior(∅, BareInterval(0.0, 4.0)) --> true
    @fact BareInterval(0.0, 4.0) ⪽ ∅ --> false
    @fact interior(BareInterval(0.0, 4.0), ∅) --> false
    @fact BareInterval(-Inf, Inf) ⪽ BareInterval(-Inf, Inf) --> true
    @fact interior(BareInterval(-Inf, Inf), BareInterval(-Inf, Inf)) --> true
    @fact BareInterval(0.0, 4.0) ⪽ BareInterval(-Inf, Inf) --> true
    @fact interior(BareInterval(0.0, 4.0), BareInterval(-Inf, Inf)) --> true
    @fact ∅ ⪽ BareInterval(-Inf, Inf) --> true
    @fact interior(∅, BareInterval(-Inf, Inf)) --> true
    @fact BareInterval(-Inf, Inf) ⪽ BareInterval(0.0, 4.0) --> false
    @fact interior(BareInterval(-Inf, Inf), BareInterval(0.0, 4.0)) --> false
    @fact BareInterval(0.0, 4.0) ⪽ BareInterval(0.0, 4.0) --> false
    @fact interior(BareInterval(0.0, 4.0), BareInterval(0.0, 4.0)) --> false
    @fact BareInterval(1.0, 2.0) ⪽ BareInterval(0.0, 4.0) --> true
    @fact interior(BareInterval(1.0, 2.0), BareInterval(0.0, 4.0)) --> true
    @fact BareInterval(-2.0, 2.0) ⪽ BareInterval(-2.0, 4.0) --> false
    @fact interior(BareInterval(-2.0, 2.0), BareInterval(-2.0, 4.0)) --> false
    @fact BareInterval(-0.0, -0.0) ⪽ BareInterval(-2.0, 4.0) --> true
    @fact interior(BareInterval(-0.0, -0.0), BareInterval(-2.0, 4.0)) --> true
    @fact BareInterval(0.0, 0.0) ⪽ BareInterval(-2.0, 4.0) --> true
    @fact interior(BareInterval(0.0, 0.0), BareInterval(-2.0, 4.0)) --> true
    @fact BareInterval(0.0, 0.0) ⪽ BareInterval(-0.0, -0.0) --> false
    @fact interior(BareInterval(0.0, 0.0), BareInterval(-0.0, -0.0)) --> false
    @fact BareInterval(0.0, 4.4) ⪽ BareInterval(0.0, 4.0) --> false
    @fact interior(BareInterval(0.0, 4.4), BareInterval(0.0, 4.0)) --> false
    @fact BareInterval(-1.0, -1.0) ⪽ BareInterval(0.0, 4.0) --> false
    @fact interior(BareInterval(-1.0, -1.0), BareInterval(0.0, 4.0)) --> false
    @fact BareInterval(2.0, 2.0) ⪽ BareInterval(-2.0, -1.0) --> false
    @fact interior(BareInterval(2.0, 2.0), BareInterval(-2.0, -1.0)) --> false
end

facts("minimal_interior_dec_test") do
    @fact Decorated(∅, trv) ⪽ Decorated(BareInterval(0.0, 4.0), trv) --> true
    @fact interior(Decorated(∅, trv), Decorated(BareInterval(0.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 4.0), def) ⪽ Decorated(∅, trv) --> false
    @fact interior(Decorated(BareInterval(0.0, 4.0), def), Decorated(∅, trv)) --> false
    @fact Decorated(BareInterval(0.0, 4.0), trv) ⪽ Decorated(∅, trv) --> false
    @fact interior(Decorated(BareInterval(0.0, 4.0), trv), Decorated(∅, trv)) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) ⪽ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> true
    @fact Decorated(BareInterval(0.0, 4.0), trv) ⪽ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(BareInterval(0.0, 4.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> true
    @fact Decorated(∅, trv) ⪽ Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact interior(Decorated(∅, trv), Decorated(BareInterval(-Inf, Inf), trv)) --> true
    @fact Decorated(BareInterval(-Inf, Inf), trv) ⪽ Decorated(BareInterval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(0.0, 4.0), trv)) --> false
    @fact Decorated(BareInterval(0.0, 4.0), trv) ⪽ Decorated(BareInterval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(BareInterval(0.0, 4.0), trv), Decorated(BareInterval(0.0, 4.0), trv)) --> false
    @fact Decorated(BareInterval(1.0, 2.0), def) ⪽ Decorated(BareInterval(0.0, 4.0), trv) --> true
    @fact interior(Decorated(BareInterval(1.0, 2.0), def), Decorated(BareInterval(0.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(-2.0, 2.0), trv) ⪽ Decorated(BareInterval(-2.0, 4.0), def) --> false
    @fact interior(Decorated(BareInterval(-2.0, 2.0), trv), Decorated(BareInterval(-2.0, 4.0), def)) --> false
    @fact Decorated(BareInterval(-0.0, -0.0), trv) ⪽ Decorated(BareInterval(-2.0, 4.0), trv) --> true
    @fact interior(Decorated(BareInterval(-0.0, -0.0), trv), Decorated(BareInterval(-2.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 0.0), def) ⪽ Decorated(BareInterval(-2.0, 4.0), trv) --> true
    @fact interior(Decorated(BareInterval(0.0, 0.0), def), Decorated(BareInterval(-2.0, 4.0), trv)) --> true
    @fact Decorated(BareInterval(0.0, 0.0), trv) ⪽ Decorated(BareInterval(-0.0, -0.0), trv) --> false
    @fact interior(Decorated(BareInterval(0.0, 0.0), trv), Decorated(BareInterval(-0.0, -0.0), trv)) --> false
    @fact Decorated(BareInterval(0.0, 4.4), trv) ⪽ Decorated(BareInterval(0.0, 4.0), trv) --> false
    @fact interior(Decorated(BareInterval(0.0, 4.4), trv), Decorated(BareInterval(0.0, 4.0), trv)) --> false
    @fact Decorated(BareInterval(-1.0, -1.0), trv) ⪽ Decorated(BareInterval(0.0, 4.0), def) --> false
    @fact interior(Decorated(BareInterval(-1.0, -1.0), trv), Decorated(BareInterval(0.0, 4.0), def)) --> false
    @fact Decorated(BareInterval(2.0, 2.0), def) ⪽ Decorated(BareInterval(-2.0, -1.0), trv) --> false
    @fact interior(Decorated(BareInterval(2.0, 2.0), def), Decorated(BareInterval(-2.0, -1.0), trv)) --> false
end

facts("minimal_strictLess_test") do
    @fact ∅ < ∅ --> true
    @fact BareInterval(1.0, 2.0) < ∅ --> false
    @fact ∅ < BareInterval(1.0, 2.0) --> false
    @fact BareInterval(-Inf, Inf) < BareInterval(-Inf, Inf) --> true
    @fact BareInterval(1.0, 2.0) < BareInterval(-Inf, Inf) --> false
    @fact BareInterval(-Inf, Inf) < BareInterval(1.0, 2.0) --> false
    @fact BareInterval(1.0, 2.0) < BareInterval(1.0, 2.0) --> false
    @fact BareInterval(1.0, 2.0) < BareInterval(3.0, 4.0) --> true
    @fact BareInterval(1.0, 3.5) < BareInterval(3.0, 4.0) --> true
    @fact BareInterval(1.0, 4.0) < BareInterval(3.0, 4.0) --> false
    @fact BareInterval(0.0, 4.0) < BareInterval(0.0, 4.0) --> false
    @fact BareInterval(-0.0, 4.0) < BareInterval(0.0, 4.0) --> false
    @fact BareInterval(-2.0, -1.0) < BareInterval(-2.0, -1.0) --> false
    @fact BareInterval(-3.0, -1.5) < BareInterval(-2.0, -1.0) --> true
end

facts("minimal_strictLess_dec_test") do
    @fact Decorated(BareInterval(1.0, 2.0), trv) < Decorated(∅, trv) --> false
    @fact Decorated(∅, trv) < Decorated(BareInterval(1.0, 2.0), def) --> false
    @fact Decorated(BareInterval(1.0, 2.0), def) < Decorated(∅, trv) --> false
    @fact Decorated(∅, trv) < Decorated(BareInterval(1.0, 2.0), def) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) < Decorated(BareInterval(-Inf, Inf), trv) --> true
    @fact Decorated(BareInterval(1.0, 2.0), trv) < Decorated(BareInterval(-Inf, Inf), trv) --> false
    @fact Decorated(BareInterval(-Inf, Inf), trv) < Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact Decorated(BareInterval(1.0, 2.0), trv) < Decorated(BareInterval(1.0, 2.0), trv) --> false
    @fact Decorated(BareInterval(1.0, 2.0), trv) < Decorated(BareInterval(3.0, 4.0), trv) --> true
    @fact Decorated(BareInterval(1.0, 3.5), def) < Decorated(BareInterval(3.0, 4.0), trv) --> true
    @fact Decorated(BareInterval(1.0, 4.0), trv) < Decorated(BareInterval(3.0, 4.0), def) --> false
    @fact Decorated(BareInterval(0.0, 4.0), trv) < Decorated(BareInterval(0.0, 4.0), def) --> false
    @fact Decorated(BareInterval(-0.0, 4.0), def) < Decorated(BareInterval(0.0, 4.0), trv) --> false
    @fact Decorated(BareInterval(-2.0, -1.0), def) < Decorated(BareInterval(-2.0, -1.0), def) --> false
    @fact Decorated(BareInterval(-3.0, -1.5), trv) < Decorated(BareInterval(-2.0, -1.0), trv) --> true
end

facts("minimal_strictPrecedes_test") do
    @fact strictprecedes(∅, BareInterval(3.0, 4.0)) --> true
    @fact strictprecedes(BareInterval(3.0, 4.0), ∅) --> true
    @fact strictprecedes(∅, ∅) --> true
    @fact strictprecedes(BareInterval(1.0, 2.0), BareInterval(-Inf, Inf)) --> false
    @fact strictprecedes(BareInterval(-Inf, Inf), BareInterval(1.0, 2.0)) --> false
    @fact strictprecedes(BareInterval(-Inf, Inf), BareInterval(-Inf, Inf)) --> false
    @fact strictprecedes(BareInterval(1.0, 2.0), BareInterval(3.0, 4.0)) --> true
    @fact strictprecedes(BareInterval(1.0, 3.0), BareInterval(3.0, 4.0)) --> false
    @fact strictprecedes(BareInterval(-3.0, -1.0), BareInterval(-1.0, 0.0)) --> false
    @fact strictprecedes(BareInterval(-3.0, -0.0), BareInterval(0.0, 1.0)) --> false
    @fact strictprecedes(BareInterval(-3.0, 0.0), BareInterval(-0.0, 1.0)) --> false
    @fact strictprecedes(BareInterval(1.0, 3.5), BareInterval(3.0, 4.0)) --> false
    @fact strictprecedes(BareInterval(1.0, 4.0), BareInterval(3.0, 4.0)) --> false
    @fact strictprecedes(BareInterval(-3.0, -0.1), BareInterval(-1.0, 0.0)) --> false
end

facts("minimal_strictPrecedes_dec_test") do
    @fact strictprecedes(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(BareInterval(3.0, 4.0), def), Decorated(∅, trv)) --> true
    @fact strictprecedes(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(BareInterval(3.0, 4.0), def), Decorated(∅, trv)) --> true
    @fact strictprecedes(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(1.0, 2.0), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(1.0, 2.0), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact strictprecedes(Decorated(BareInterval(1.0, 3.0), def), Decorated(BareInterval(3.0, 4.0), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(-3.0, -1.0), trv), Decorated(BareInterval(-1.0, 0.0), def)) --> false
    @fact strictprecedes(Decorated(BareInterval(-3.0, -0.0), def), Decorated(BareInterval(0.0, 1.0), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(-3.0, 0.0), trv), Decorated(BareInterval(-0.0, 1.0), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(1.0, 3.5), trv), Decorated(BareInterval(3.0, 4.0), trv)) --> false
    @fact strictprecedes(Decorated(BareInterval(1.0, 4.0), trv), Decorated(BareInterval(3.0, 4.0), def)) --> false
    @fact strictprecedes(Decorated(BareInterval(-3.0, -0.1), trv), Decorated(BareInterval(-1.0, 0.0), trv)) --> false
end

facts("minimal_disjoint_test") do
    @fact isdisjoint(∅, BareInterval(3.0, 4.0)) --> true
    @fact isdisjoint(BareInterval(3.0, 4.0), ∅) --> true
    @fact isdisjoint(∅, ∅) --> true
    @fact isdisjoint(BareInterval(3.0, 4.0), BareInterval(1.0, 2.0)) --> true
    @fact isdisjoint(BareInterval(0.0, 0.0), BareInterval(-0.0, -0.0)) --> false
    @fact isdisjoint(BareInterval(0.0, -0.0), BareInterval(-0.0, 0.0)) --> false
    @fact isdisjoint(BareInterval(3.0, 4.0), BareInterval(1.0, 7.0)) --> false
    @fact isdisjoint(BareInterval(3.0, 4.0), BareInterval(-Inf, Inf)) --> false
    @fact isdisjoint(BareInterval(-Inf, Inf), BareInterval(1.0, 7.0)) --> false
    @fact isdisjoint(BareInterval(-Inf, Inf), BareInterval(-Inf, Inf)) --> false
end

facts("minimal_disjoint_dec_test") do
    @fact isdisjoint(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), def)) --> true
    @fact isdisjoint(Decorated(BareInterval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact isdisjoint(Decorated(∅, trv), Decorated(BareInterval(3.0, 4.0), trv)) --> true
    @fact isdisjoint(Decorated(BareInterval(3.0, 4.0), trv), Decorated(∅, trv)) --> true
    @fact isdisjoint(Decorated(BareInterval(3.0, 4.0), trv), Decorated(BareInterval(1.0, 2.0), def)) --> true
    @fact isdisjoint(Decorated(BareInterval(0.0, 0.0), trv), Decorated(BareInterval(-0.0, -0.0), trv)) --> false
    @fact isdisjoint(Decorated(BareInterval(0.0, -0.0), trv), Decorated(BareInterval(-0.0, 0.0), trv)) --> false
    @fact isdisjoint(Decorated(BareInterval(3.0, 4.0), def), Decorated(BareInterval(1.0, 7.0), def)) --> false
    @fact isdisjoint(Decorated(BareInterval(3.0, 4.0), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
    @fact isdisjoint(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(1.0, 7.0), trv)) --> false
    @fact isdisjoint(Decorated(BareInterval(-Inf, Inf), trv), Decorated(BareInterval(-Inf, Inf), trv)) --> false
end
# FactCheck.exitstatus()
