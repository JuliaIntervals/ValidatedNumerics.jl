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
    @fact Interval(BareInterval(1.0, 3.0), com) ∩ Interval(BareInterval(2.1, 4.0), com) --> Interval(BareInterval(2.1, 3.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), com) ∩ Interval(BareInterval(2.1, 4.0), com)) --> decoration(Interval(BareInterval(2.1, 3.0), trv))
    @fact intersect(Interval(BareInterval(1.0, 3.0), com), Interval(BareInterval(2.1, 4.0), com)) --> Interval(BareInterval(2.1, 3.0), trv)
    @fact decoration(intersect(Interval(BareInterval(1.0, 3.0), com), Interval(BareInterval(2.1, 4.0), com))) --> decoration(Interval(BareInterval(2.1, 3.0), trv))
    @fact Interval(BareInterval(1.0, 3.0), dac) ∩ Interval(BareInterval(3.0, 4.0), def) --> Interval(BareInterval(3.0, 3.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), dac) ∩ Interval(BareInterval(3.0, 4.0), def)) --> decoration(Interval(BareInterval(3.0, 3.0), trv))
    @fact intersect(Interval(BareInterval(1.0, 3.0), dac), Interval(BareInterval(3.0, 4.0), def)) --> Interval(BareInterval(3.0, 3.0), trv)
    @fact decoration(intersect(Interval(BareInterval(1.0, 3.0), dac), Interval(BareInterval(3.0, 4.0), def))) --> decoration(Interval(BareInterval(3.0, 3.0), trv))
    @fact Interval(BareInterval(1.0, 3.0), def) ∩ Interval(∅, trv) --> Interval(∅, trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), def) ∩ Interval(∅, trv)) --> decoration(Interval(∅, trv))
    @fact intersect(Interval(BareInterval(1.0, 3.0), def), Interval(∅, trv)) --> Interval(∅, trv)
    @fact decoration(intersect(Interval(BareInterval(1.0, 3.0), def), Interval(∅, trv))) --> decoration(Interval(∅, trv))
    @fact Interval(entireinterval(Float64), def) ∩ Interval(∅, trv) --> Interval(∅, trv)
    @fact decoration(Interval(entireinterval(Float64), def) ∩ Interval(∅, trv)) --> decoration(Interval(∅, trv))
    @fact intersect(Interval(entireinterval(Float64), def), Interval(∅, trv)) --> Interval(∅, trv)
    @fact decoration(intersect(Interval(entireinterval(Float64), def), Interval(∅, trv))) --> decoration(Interval(∅, trv))
    @fact Interval(BareInterval(1.0, 3.0), dac) ∩ Interval(entireinterval(Float64), def) --> Interval(BareInterval(1.0, 3.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), dac) ∩ Interval(entireinterval(Float64), def)) --> decoration(Interval(BareInterval(1.0, 3.0), trv))
    @fact intersect(Interval(BareInterval(1.0, 3.0), dac), Interval(entireinterval(Float64), def)) --> Interval(BareInterval(1.0, 3.0), trv)
    @fact decoration(intersect(Interval(BareInterval(1.0, 3.0), dac), Interval(entireinterval(Float64), def))) --> decoration(Interval(BareInterval(1.0, 3.0), trv))
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
    @fact Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(BareInterval(2.1, 4.0), trv) --> Interval(BareInterval(1.0, 4.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(BareInterval(2.1, 4.0), trv)) --> decoration(Interval(BareInterval(1.0, 4.0), trv))
    @fact hull(Interval(BareInterval(1.0, 3.0), trv), Interval(BareInterval(2.1, 4.0), trv)) --> Interval(BareInterval(1.0, 4.0), trv)
    @fact decoration(hull(Interval(BareInterval(1.0, 3.0), trv), Interval(BareInterval(2.1, 4.0), trv))) --> decoration(Interval(BareInterval(1.0, 4.0), trv))
    @fact Interval(BareInterval(1.0, 1.0), trv) ∪ Interval(BareInterval(2.1, 4.0), trv) --> Interval(BareInterval(1.0, 4.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 1.0), trv) ∪ Interval(BareInterval(2.1, 4.0), trv)) --> decoration(Interval(BareInterval(1.0, 4.0), trv))
    @fact hull(Interval(BareInterval(1.0, 1.0), trv), Interval(BareInterval(2.1, 4.0), trv)) --> Interval(BareInterval(1.0, 4.0), trv)
    @fact decoration(hull(Interval(BareInterval(1.0, 1.0), trv), Interval(BareInterval(2.1, 4.0), trv))) --> decoration(Interval(BareInterval(1.0, 4.0), trv))
    @fact Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(∅, trv) --> Interval(BareInterval(1.0, 3.0), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(∅, trv)) --> decoration(Interval(BareInterval(1.0, 3.0), trv))
    @fact hull(Interval(BareInterval(1.0, 3.0), trv), Interval(∅, trv)) --> Interval(BareInterval(1.0, 3.0), trv)
    @fact decoration(hull(Interval(BareInterval(1.0, 3.0), trv), Interval(∅, trv))) --> decoration(Interval(BareInterval(1.0, 3.0), trv))
    @fact Interval(∅, trv) ∪ Interval(∅, trv) --> Interval(∅, trv)
    @fact decoration(Interval(∅, trv) ∪ Interval(∅, trv)) --> decoration(Interval(∅, trv))
    @fact hull(Interval(∅, trv), Interval(∅, trv)) --> Interval(∅, trv)
    @fact decoration(hull(Interval(∅, trv), Interval(∅, trv))) --> decoration(Interval(∅, trv))
    @fact Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(entireinterval(Float64), def) --> Interval(entireinterval(Float64), trv)
    @fact decoration(Interval(BareInterval(1.0, 3.0), trv) ∪ Interval(entireinterval(Float64), def)) --> decoration(Interval(entireinterval(Float64), trv))
    @fact hull(Interval(BareInterval(1.0, 3.0), trv), Interval(entireinterval(Float64), def)) --> Interval(entireinterval(Float64), trv)
    @fact decoration(hull(Interval(BareInterval(1.0, 3.0), trv), Interval(entireinterval(Float64), def))) --> decoration(Interval(entireinterval(Float64), trv))
end
# FactCheck.exitstatus()
