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

facts("minimal_intersection_test") do
    @fact BareInterval(1.0, 3.0) ∩ BareInterval(2.1, 4.0) --> BareInterval(2.1, 3.0)
    @fact intersect(BareInterval(1.0, 3.0), BareInterval(2.1, 4.0)) --> BareInterval(2.1, 3.0)
    @fact BareInterval(1.0, 3.0) ∩ BareInterval(3.0, 4.0) --> BareInterval(3.0, 3.0)
    @fact intersect(BareInterval(1.0, 3.0), BareInterval(3.0, 4.0)) --> BareInterval(3.0, 3.0)
    @fact BareInterval(1.0, 3.0) ∩ ∅ --> ∅
    @fact intersect(BareInterval(1.0, 3.0), ∅) --> ∅
    @fact entireinterval(Float64) ∩ ∅ --> ∅
    @fact intersect(entireinterval(Float64), ∅) --> ∅
    @fact BareInterval(1.0, 3.0) ∩ entireinterval(Float64) --> BareInterval(1.0, 3.0)
    @fact intersect(BareInterval(1.0, 3.0), entireinterval(Float64)) --> BareInterval(1.0, 3.0)
end

facts("minimal_intersection_dec_test") do
    @fact Decorated(BareInterval(1.0, 3.0), com) ∩ Decorated(BareInterval(2.1, 4.0), com) --> Decorated(BareInterval(2.1, 3.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), com) ∩ Decorated(BareInterval(2.1, 4.0), com)) --> decoration(Decorated(BareInterval(2.1, 3.0), trv))
    @fact intersect(Decorated(BareInterval(1.0, 3.0), com), Decorated(BareInterval(2.1, 4.0), com)) --> Decorated(BareInterval(2.1, 3.0), trv)
    @fact decoration(intersect(Decorated(BareInterval(1.0, 3.0), com), Decorated(BareInterval(2.1, 4.0), com))) --> decoration(Decorated(BareInterval(2.1, 3.0), trv))
    @fact Decorated(BareInterval(1.0, 3.0), dac) ∩ Decorated(BareInterval(3.0, 4.0), def) --> Decorated(BareInterval(3.0, 3.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), dac) ∩ Decorated(BareInterval(3.0, 4.0), def)) --> decoration(Decorated(BareInterval(3.0, 3.0), trv))
    @fact intersect(Decorated(BareInterval(1.0, 3.0), dac), Decorated(BareInterval(3.0, 4.0), def)) --> Decorated(BareInterval(3.0, 3.0), trv)
    @fact decoration(intersect(Decorated(BareInterval(1.0, 3.0), dac), Decorated(BareInterval(3.0, 4.0), def))) --> decoration(Decorated(BareInterval(3.0, 3.0), trv))
    @fact Decorated(BareInterval(1.0, 3.0), def) ∩ Decorated(∅, trv) --> Decorated(∅, trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), def) ∩ Decorated(∅, trv)) --> decoration(Decorated(∅, trv))
    @fact intersect(Decorated(BareInterval(1.0, 3.0), def), Decorated(∅, trv)) --> Decorated(∅, trv)
    @fact decoration(intersect(Decorated(BareInterval(1.0, 3.0), def), Decorated(∅, trv))) --> decoration(Decorated(∅, trv))
    @fact Decorated(entireinterval(Float64), def) ∩ Decorated(∅, trv) --> Decorated(∅, trv)
    @fact decoration(Decorated(entireinterval(Float64), def) ∩ Decorated(∅, trv)) --> decoration(Decorated(∅, trv))
    @fact intersect(Decorated(entireinterval(Float64), def), Decorated(∅, trv)) --> Decorated(∅, trv)
    @fact decoration(intersect(Decorated(entireinterval(Float64), def), Decorated(∅, trv))) --> decoration(Decorated(∅, trv))
    @fact Decorated(BareInterval(1.0, 3.0), dac) ∩ Decorated(entireinterval(Float64), def) --> Decorated(BareInterval(1.0, 3.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), dac) ∩ Decorated(entireinterval(Float64), def)) --> decoration(Decorated(BareInterval(1.0, 3.0), trv))
    @fact intersect(Decorated(BareInterval(1.0, 3.0), dac), Decorated(entireinterval(Float64), def)) --> Decorated(BareInterval(1.0, 3.0), trv)
    @fact decoration(intersect(Decorated(BareInterval(1.0, 3.0), dac), Decorated(entireinterval(Float64), def))) --> decoration(Decorated(BareInterval(1.0, 3.0), trv))
end

facts("minimal_convexHull_test") do
    @fact BareInterval(1.0, 3.0) ∪ BareInterval(2.1, 4.0) --> BareInterval(1.0, 4.0)
    @fact hull(BareInterval(1.0, 3.0), BareInterval(2.1, 4.0)) --> BareInterval(1.0, 4.0)
    @fact BareInterval(1.0, 1.0) ∪ BareInterval(2.1, 4.0) --> BareInterval(1.0, 4.0)
    @fact hull(BareInterval(1.0, 1.0), BareInterval(2.1, 4.0)) --> BareInterval(1.0, 4.0)
    @fact BareInterval(1.0, 3.0) ∪ ∅ --> BareInterval(1.0, 3.0)
    @fact hull(BareInterval(1.0, 3.0), ∅) --> BareInterval(1.0, 3.0)
    @fact ∅ ∪ ∅ --> ∅
    @fact hull(∅, ∅) --> ∅
    @fact BareInterval(1.0, 3.0) ∪ entireinterval(Float64) --> entireinterval(Float64)
    @fact hull(BareInterval(1.0, 3.0), entireinterval(Float64)) --> entireinterval(Float64)
end

facts("minimal_convexHull_dec_test") do
    @fact Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(BareInterval(2.1, 4.0), trv) --> Decorated(BareInterval(1.0, 4.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(BareInterval(2.1, 4.0), trv)) --> decoration(Decorated(BareInterval(1.0, 4.0), trv))
    @fact hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(BareInterval(2.1, 4.0), trv)) --> Decorated(BareInterval(1.0, 4.0), trv)
    @fact decoration(hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(BareInterval(2.1, 4.0), trv))) --> decoration(Decorated(BareInterval(1.0, 4.0), trv))
    @fact Decorated(BareInterval(1.0, 1.0), trv) ∪ Decorated(BareInterval(2.1, 4.0), trv) --> Decorated(BareInterval(1.0, 4.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 1.0), trv) ∪ Decorated(BareInterval(2.1, 4.0), trv)) --> decoration(Decorated(BareInterval(1.0, 4.0), trv))
    @fact hull(Decorated(BareInterval(1.0, 1.0), trv), Decorated(BareInterval(2.1, 4.0), trv)) --> Decorated(BareInterval(1.0, 4.0), trv)
    @fact decoration(hull(Decorated(BareInterval(1.0, 1.0), trv), Decorated(BareInterval(2.1, 4.0), trv))) --> decoration(Decorated(BareInterval(1.0, 4.0), trv))
    @fact Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(∅, trv) --> Decorated(BareInterval(1.0, 3.0), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(∅, trv)) --> decoration(Decorated(BareInterval(1.0, 3.0), trv))
    @fact hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(∅, trv)) --> Decorated(BareInterval(1.0, 3.0), trv)
    @fact decoration(hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(∅, trv))) --> decoration(Decorated(BareInterval(1.0, 3.0), trv))
    @fact Decorated(∅, trv) ∪ Decorated(∅, trv) --> Decorated(∅, trv)
    @fact decoration(Decorated(∅, trv) ∪ Decorated(∅, trv)) --> decoration(Decorated(∅, trv))
    @fact hull(Decorated(∅, trv), Decorated(∅, trv)) --> Decorated(∅, trv)
    @fact decoration(hull(Decorated(∅, trv), Decorated(∅, trv))) --> decoration(Decorated(∅, trv))
    @fact Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(entireinterval(Float64), def) --> Decorated(entireinterval(Float64), trv)
    @fact decoration(Decorated(BareInterval(1.0, 3.0), trv) ∪ Decorated(entireinterval(Float64), def)) --> decoration(Decorated(entireinterval(Float64), trv))
    @fact hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(entireinterval(Float64), def)) --> Decorated(entireinterval(Float64), trv)
    @fact decoration(hull(Decorated(BareInterval(1.0, 3.0), trv), Decorated(entireinterval(Float64), def))) --> decoration(Decorated(entireinterval(Float64), trv))
end
# FactCheck.exitstatus()
