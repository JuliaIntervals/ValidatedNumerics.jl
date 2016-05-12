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

facts("minimal_inf_test") do
    @fact infimum(∅) --> Inf
    @fact infimum(BareInterval(-Inf, Inf)) --> -Inf
    @fact infimum(BareInterval(1.0, 2.0)) --> 1.0
    @fact infimum(BareInterval(-3.0, -2.0)) --> -3.0
    @fact infimum(BareInterval(-Inf, 2.0)) --> -Inf
    @fact infimum(BareInterval(-Inf, 0.0)) --> -Inf
    @fact infimum(BareInterval(-Inf, -0.0)) --> -Inf
    @fact infimum(BareInterval(-2.0, Inf)) --> -2.0
    @fact infimum(BareInterval(0.0, Inf)) --> -0.0
    @fact infimum(BareInterval(-0.0, Inf)) --> -0.0
    @fact infimum(BareInterval(-0.0, 0.0)) --> -0.0
    @fact infimum(BareInterval(0.0, -0.0)) --> -0.0
    @fact infimum(BareInterval(0.0, 0.0)) --> -0.0
    @fact infimum(BareInterval(-0.0, -0.0)) --> -0.0
end

facts("minimal_inf_dec_test") do
    @fact infimum(Interval(∅, trv)) --> Inf
    @fact infimum(Interval(BareInterval(-Inf, Inf), def)) --> -Inf
    @fact infimum(Interval(BareInterval(1.0, 2.0), com)) --> 1.0
    @fact infimum(Interval(BareInterval(-3.0, -2.0), trv)) --> -3.0
    @fact infimum(Interval(BareInterval(-Inf, 2.0), dac)) --> -Inf
    @fact infimum(Interval(BareInterval(-Inf, 0.0), def)) --> -Inf
    @fact infimum(Interval(BareInterval(-Inf, -0.0), trv)) --> -Inf
    @fact infimum(Interval(BareInterval(-2.0, Inf), trv)) --> -2.0
    @fact infimum(Interval(BareInterval(0.0, Inf), def)) --> -0.0
    @fact infimum(Interval(BareInterval(-0.0, Inf), trv)) --> -0.0
    @fact infimum(Interval(BareInterval(-0.0, 0.0), dac)) --> -0.0
    @fact infimum(Interval(BareInterval(0.0, -0.0), trv)) --> -0.0
    @fact infimum(Interval(BareInterval(0.0, 0.0), trv)) --> -0.0
    @fact infimum(Interval(BareInterval(-0.0, -0.0), trv)) --> -0.0
end

facts("minimal_sup_test") do
    @fact supremum(∅) --> -Inf
    @fact supremum(BareInterval(-Inf, Inf)) --> Inf
    @fact supremum(BareInterval(1.0, 2.0)) --> 2.0
    @fact supremum(BareInterval(-3.0, -2.0)) --> -2.0
    @fact supremum(BareInterval(-Inf, 2.0)) --> 2.0
    @fact supremum(BareInterval(-Inf, 0.0)) --> 0.0
    @fact supremum(BareInterval(-Inf, -0.0)) --> 0.0
    @fact supremum(BareInterval(-2.0, Inf)) --> Inf
    @fact supremum(BareInterval(0.0, Inf)) --> Inf
    @fact supremum(BareInterval(-0.0, Inf)) --> Inf
    @fact supremum(BareInterval(-0.0, 0.0)) --> 0.0
    @fact supremum(BareInterval(0.0, -0.0)) --> 0.0
    @fact supremum(BareInterval(0.0, 0.0)) --> 0.0
    @fact supremum(BareInterval(-0.0, -0.0)) --> 0.0
end

facts("minimal_sup_dec_test") do
    @fact supremum(Interval(∅, trv)) --> -Inf
    @fact supremum(Interval(BareInterval(-Inf, Inf), def)) --> Inf
    @fact supremum(Interval(BareInterval(1.0, 2.0), com)) --> 2.0
    @fact supremum(Interval(BareInterval(-3.0, -2.0), trv)) --> -2.0
    @fact supremum(Interval(BareInterval(-Inf, 2.0), dac)) --> 2.0
    @fact supremum(Interval(BareInterval(-Inf, 0.0), def)) --> 0.0
    @fact supremum(Interval(BareInterval(-Inf, -0.0), trv)) --> 0.0
    @fact supremum(Interval(BareInterval(-2.0, Inf), trv)) --> Inf
    @fact supremum(Interval(BareInterval(0.0, Inf), def)) --> Inf
    @fact supremum(Interval(BareInterval(-0.0, Inf), trv)) --> Inf
    @fact supremum(Interval(BareInterval(-0.0, 0.0), dac)) --> +0.0
    @fact supremum(Interval(BareInterval(0.0, -0.0), trv)) --> +0.0
    @fact supremum(Interval(BareInterval(0.0, 0.0), trv)) --> +0.0
    @fact supremum(Interval(BareInterval(-0.0, -0.0), trv)) --> +0.0
end

facts("minimal_mid_test") do
    @fact mid(BareInterval(-Inf, Inf)) --> 0.0
    @fact mid(BareInterval(-0x1.fffffffffffffp1023, +0x1.fffffffffffffp1023)) --> 0.0
    @fact mid(BareInterval(0.0, 2.0)) --> 1.0
    @fact mid(BareInterval(2.0, 2.0)) --> 2.0
    @fact mid(BareInterval(-2.0, 2.0)) --> 0.0
    @fact mid(BareInterval(-0x0.0000000000002p-1022, 0x0.0000000000001p-1022)) --> 0.0
    @fact mid(BareInterval(-0x0.0000000000001p-1022, 0x0.0000000000002p-1022)) --> 0.0
end

facts("minimal_mid_dec_test") do
    @fact mid(Interval(BareInterval(-Inf, Inf), def)) --> 0.0
    @fact mid(Interval(BareInterval(-0x1.fffffffffffffp1023, +0x1.fffffffffffffp1023), trv)) --> 0.0
    @fact mid(Interval(BareInterval(0.0, 2.0), com)) --> 1.0
    @fact mid(Interval(BareInterval(2.0, 2.0), dac)) --> 2.0
    @fact mid(Interval(BareInterval(-2.0, 2.0), trv)) --> 0.0
    @fact mid(Interval(BareInterval(-0x0.0000000000002p-1022, 0x0.0000000000001p-1022), trv)) --> 0.0
    @fact mid(Interval(BareInterval(-0x0.0000000000001p-1022, 0x0.0000000000002p-1022), trv)) --> 0.0
end

facts("minimal_rad_test") do
    @fact radius(BareInterval(0.0, 2.0)) --> 1.0
    @fact radius(BareInterval(2.0, 2.0)) --> 0.0
    @fact radius(BareInterval(-Inf, Inf)) --> Inf
    @fact radius(BareInterval(0.0, Inf)) --> Inf
    @fact radius(BareInterval(-Inf, 1.2)) --> Inf
end

facts("minimal_rad_dec_test") do
    @fact radius(Interval(BareInterval(0.0, 2.0), trv)) --> 1.0
    @fact radius(Interval(BareInterval(2.0, 2.0), com)) --> 0.0
    @fact radius(Interval(BareInterval(-Inf, Inf), trv)) --> Inf
    @fact radius(Interval(BareInterval(0.0, Inf), def)) --> Inf
    @fact radius(Interval(BareInterval(-Inf, 1.2), trv)) --> Inf
end

facts("minimal_wid_test") do
    @fact diam(BareInterval(2.0, 2.0)) --> 0.0
    @fact diam(BareInterval(1.0, 2.0)) --> 1.0
    @fact diam(BareInterval(1.0, Inf)) --> Inf
    @fact diam(BareInterval(-Inf, 2.0)) --> Inf
    @fact diam(BareInterval(-Inf, Inf)) --> Inf
end

facts("minimal_wid_dec_test") do
    @fact diam(Interval(BareInterval(2.0, 2.0), com)) --> 0.0
    @fact diam(Interval(BareInterval(1.0, 2.0), trv)) --> 1.0
    @fact diam(Interval(BareInterval(1.0, Inf), trv)) --> Inf
    @fact diam(Interval(BareInterval(-Inf, 2.0), def)) --> Inf
    @fact diam(Interval(BareInterval(-Inf, Inf), trv)) --> Inf
end

facts("minimal_mag_test") do
    @fact mag(BareInterval(1.0, 2.0)) --> 2.0
    @fact mag(BareInterval(-4.0, 2.0)) --> 4.0
    @fact mag(BareInterval(-Inf, 2.0)) --> Inf
    @fact mag(BareInterval(1.0, Inf)) --> Inf
    @fact mag(BareInterval(-Inf, Inf)) --> Inf
    @fact mag(BareInterval(-0.0, 0.0)) --> 0.0
    @fact mag(BareInterval(-0.0, -0.0)) --> 0.0
end

facts("minimal_mag_dec_test") do
    @fact mag(Interval(BareInterval(1.0, 2.0), com)) --> 2.0
    @fact mag(Interval(BareInterval(-4.0, 2.0), trv)) --> 4.0
    @fact mag(Interval(BareInterval(-Inf, 2.0), trv)) --> Inf
    @fact mag(Interval(BareInterval(1.0, Inf), def)) --> Inf
    @fact mag(Interval(BareInterval(-Inf, Inf), trv)) --> Inf
    @fact mag(Interval(BareInterval(-0.0, 0.0), trv)) --> 0.0
    @fact mag(Interval(BareInterval(-0.0, -0.0), trv)) --> 0.0
end

facts("minimal_mig_test") do
    @fact mig(BareInterval(1.0, 2.0)) --> 1.0
    @fact mig(BareInterval(-4.0, 2.0)) --> 0.0
    @fact mig(BareInterval(-4.0, -2.0)) --> 2.0
    @fact mig(BareInterval(-Inf, 2.0)) --> 0.0
    @fact mig(BareInterval(-Inf, -2.0)) --> 2.0
    @fact mig(BareInterval(-1.0, Inf)) --> 0.0
    @fact mig(BareInterval(1.0, Inf)) --> 1.0
    @fact mig(BareInterval(-Inf, Inf)) --> 0.0
    @fact mig(BareInterval(-0.0, 0.0)) --> 0.0
    @fact mig(BareInterval(-0.0, -0.0)) --> 0.0
end

facts("minimal_mig_dec_test") do
    @fact mig(Interval(BareInterval(1.0, 2.0), com)) --> 1.0
    @fact mig(Interval(BareInterval(-4.0, 2.0), trv)) --> 0.0
    @fact mig(Interval(BareInterval(-4.0, -2.0), trv)) --> 2.0
    @fact mig(Interval(BareInterval(-Inf, 2.0), def)) --> 0.0
    @fact mig(Interval(BareInterval(-Inf, -2.0), trv)) --> 2.0
    @fact mig(Interval(BareInterval(-1.0, Inf), trv)) --> 0.0
    @fact mig(Interval(BareInterval(1.0, Inf), trv)) --> 1.0
    @fact mig(Interval(BareInterval(-Inf, Inf), trv)) --> 0.0
    @fact mig(Interval(BareInterval(-0.0, 0.0), trv)) --> 0.0
    @fact mig(Interval(BareInterval(-0.0, -0.0), trv)) --> 0.0
end
# FactCheck.exitstatus()
