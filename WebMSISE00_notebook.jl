### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 47b82739-35ba-496c-b5e0-2e73e59cf1c4
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 1b7a3fe9-8716-427f-b796-ca94f7e48a09
begin
	Pkg.add(url="https://github.com/fyzycyst/WebMSISE00.jl.git")
	using WebMSISE00
end

# ╔═╡ d8961618-08aa-4424-9cba-960c5023d1fb
begin
	Pkg.add("Plots")
	Pkg.add("StatPlots")
	Pkg.add("DataFrames")
	using DataFrames
	using Plots
	using StatPlots
end

# ╔═╡ 28dc8709-edc3-4754-a2dd-fc98d0890469
using Plots.PlotMeasures

# ╔═╡ 9ba46bb7-66de-4756-ba4e-613cb1e6f751
md"""
# Example use of _WebMSISE00.jl_

This notebook just has some quick & dirty examples of generating an atmosphere and
plotting the density profile(s) vs. altitude.
"""

# ╔═╡ db0d3958-a55a-4d49-b27e-c586007c8676
md"""

_First, we load all the packages needed._

In addition to `WebMSISE00`, we load in `Plots`, `StatPlots`, and `DataFrames`, since
we're going to plot from the returned dataframe.
"""

# ╔═╡ dabf432d-434a-4526-a61e-e4d2d61d77d3
plotly()

# ╔═╡ 0d766211-5fd1-4810-b799-5c0f28e088e8
md"""


_Next, we set up and run an atmosphere profile._

"""

# ╔═╡ 177978c2-935d-432e-b5e3-c623d5f6b492
md"""
In order to do a run, we need to first discuss the inputs to the model.
"""

# ╔═╡ 234718cf-381a-4d06-8403-67d993922b50
md"""
The inputs are all entered as strings, even numerical inputs. The important inputs (entered as a Dict) are:\
_[NOTE: valid dates are 1960/02/14 - 2020/09/16, with the end date updated monthly]_\
_[NOTE 2: If none of the solar activity indices (F10.7 or Ap) are entered, the real value for the date specified is automatically used.]_
- `"year" => "2020"`,              (4 digits)
- `"month" => "01"`,               (2 digits)
- `"day" => "01"`,                 (2 digits)
- `"time_flag" => "0"`,            ('0' for Universal Time; '1' for local time)
- `"hour" => "1.5"`,               (hours after midnight)
- `"latitude" => "55."`,           (from -90. to 90.)
- `"longitude" => "45."`,          (from 0. to 360.)
- `"profile" => "1"`,              (defines the parameter sweep performed)
    * '1' = Height (from 0. to 1000.)
    * '2' = Latitude (from -90. to 90.)
    * '3' = Longitude (from 0. to 360.)
    * '4' = Year (from 1961. to 2007.)
    * '5' = Month (from 1. to 12.)
    * '6' = Day of Month (from 1. to 31.)
    * '7' = Day of Year (from 1. to 366.)
    * '8' = Hour of Day (from 1. to 24.)
- `"start" => "0."`,                (start of the parameter sweep)
- `"stop" => "1000."`,              (end of the parameter sweep)
- `"step" => "50."`,                (step size for the parameter sweep)
- `"f10_7" => ""`,                  (F10.7 daily value)
- `"f10_7_3" => ""`,                (F10.7 three month average)
- `"ap" => ""`,                     (Ap daily value)
- `"vars" => ["05", "08", "09"]`    (lists the independent & dependent variables)

"vars" determines the columns written to the output datafile which ends up loaded into the DataFrame output.\
 \
The `vars` Array values that are exposed in `WebMSISE00` are:\
_Independent variables:_ \
00 = Year; 01 = Month; 02 = Day of Month; 03 = Day of Year;\
04 = Hour of Day; 05 = Height (km); 06 = Latitude; 07 = Longitude\
_Calculated Parameters:_ \
08 = Atomic Oxygen number density (cm^-3); 09 = N2 number density;\
10 = O2 number density; 11 = total mass density (g/cm^3);\
12 = Neutral Temp (K); 13 = Exospheric Temp (K); 14 = He number density;\
15 = Ar number density; 16 = H number density; 17 = N number density;\
18 = Anomalous Oxygen number density\
_Indices taken from user input vs. data base_ \
19 = F10.7 (daily); 20 = F10.7 (3 month avg); 21 = ap (daily)\
 \
Finally, the values listed in the above example Dict entries are the defaults used by `WebMSISE00` for any not explicitly set by the user in the input Dict.
"""

# ╔═╡ d56a1b81-1d17-463b-b5d1-751cf531da76
md"""
As an initial example, let's choose a time of low solar activity... 1 Jan 2020, near dawn (hour 5, local time), for a mid latitude of $40^{o}$, and an F10.3 three month average value of 70. In addition, let's get a profile for the total density *and* all the individual constituents, from ground to 1000 km (this range is a default setting), at a step size of 25 km.
"""

# ╔═╡ 50fc3dd4-fc7b-4283-804f-053c29edbe72
input_low = Dict(
	"year" => "2020",
	"month" => "01",
	"day" => "01",
	"time_flag" => "1",
	"hour" => "5",
	"latitude" => "40.",
	"step" => "25.",
	"f10_7_3" => "70.",
	"vars" => ["05", "08", "09","10","11","14","15","16","17","18"]
	)

# ╔═╡ a9c5f4df-6c71-449b-8ae9-8195c5b62357
output_low = ReadMSISE(input_low)

# ╔═╡ 150bacf2-b05e-42cf-957a-46df242d4d3a
begin
	@df output_low plot(cols(1), cols(2:4), 
		yaxis=:log10, 
		size=(650,600),
		ylims=(1e-19,1e20),
		label=["O" "N2" "O2"],
		legend=(0.8,0.95),
		title="Density of atmospheric constituents with altitude",
		xlabel="Altitude in km",
		ylabel="Number density in cm-3"
	)
	@df output_low plot!(cols(1), cols(6:10),
		label=["He" "Ar" "H" "N" "Anom. O"]
	)
end	

# ╔═╡ 189a1664-bc02-40f0-8347-c5725426faa4
md"""

_Now, compare two days at different parts of the solar cycle to exhibit how the
atmosphere gets 'puffy' when the Sun is particularly active._

"""

# ╔═╡ b4e055c8-cedc-4aef-b170-f51f5afe17d3
md"""
We already have the total atmosphere density (for the low activity portion of the solar cycle) in the `output_low` dataframe, so now we generate the density for high solar activity. We'll just generate the total density without the number densities of all the constituents.
"""

# ╔═╡ 1d49508e-9a41-4835-9499-ba0f08082d87
md"""
For this case, we choose: 1 Jul 1989, afternoot (hour 15, local time), for a mid latitude of $40^{o}$, and an F10.3 three month average value of 250. All other settings remain the same, except for the calculated parameters to be output.
"""

# ╔═╡ a4a3407d-080c-4ac2-b9c6-0a96e24cc78c
input_high = Dict(
	"year" => "1989",
	"month" => "07",
	"day" => "01",
	"time_flag" => "1",
	"hour" => "15",
	"latitude" => "40.",
	"step" => "25.",
	"f10_7_3" => "250.",
	"vars" => ["05", "11"]
	)

# ╔═╡ d15dc97c-f349-4dfe-be7e-489acca266df
output_high = ReadMSISE(input_high)

# ╔═╡ 11b1301f-92fc-4425-af9e-557036377384
begin
	@df output_low plot(cols(1), cols(5), 
		yaxis=:log10, 
		size=(625,600),
		ylims=(1e-18,1e-3),
		legend=(0.75,0.9),
		label="Low Activity",
		title="Atmospheric Density Changes with Solar Activity",
		xlabel="Altitude in km",
		ylabel="Mass density in g/cm-3"
	)
	@df output_high plot!(cols(1), cols(2),
		label="High Activity")
end

# ╔═╡ 603f9f54-a9f0-4320-8223-d23617b61224
md"""
The immediate idea I had for application of this in an instructional environment would be to illustrate the effects of high solar activity making the atmosphere 'puffy' by feeding these density profiles into some sort of orbit decay model. That, however, is the proverbial exercise-left-to-reader.
"""

# ╔═╡ Cell order:
# ╟─9ba46bb7-66de-4756-ba4e-613cb1e6f751
# ╟─db0d3958-a55a-4d49-b27e-c586007c8676
# ╠═47b82739-35ba-496c-b5e0-2e73e59cf1c4
# ╠═1b7a3fe9-8716-427f-b796-ca94f7e48a09
# ╠═d8961618-08aa-4424-9cba-960c5023d1fb
# ╠═28dc8709-edc3-4754-a2dd-fc98d0890469
# ╠═dabf432d-434a-4526-a61e-e4d2d61d77d3
# ╟─0d766211-5fd1-4810-b799-5c0f28e088e8
# ╟─177978c2-935d-432e-b5e3-c623d5f6b492
# ╟─234718cf-381a-4d06-8403-67d993922b50
# ╟─d56a1b81-1d17-463b-b5d1-751cf531da76
# ╠═50fc3dd4-fc7b-4283-804f-053c29edbe72
# ╠═a9c5f4df-6c71-449b-8ae9-8195c5b62357
# ╠═150bacf2-b05e-42cf-957a-46df242d4d3a
# ╟─189a1664-bc02-40f0-8347-c5725426faa4
# ╟─b4e055c8-cedc-4aef-b170-f51f5afe17d3
# ╟─1d49508e-9a41-4835-9499-ba0f08082d87
# ╠═a4a3407d-080c-4ac2-b9c6-0a96e24cc78c
# ╠═d15dc97c-f349-4dfe-be7e-489acca266df
# ╠═11b1301f-92fc-4425-af9e-557036377384
# ╟─603f9f54-a9f0-4320-8223-d23617b61224
