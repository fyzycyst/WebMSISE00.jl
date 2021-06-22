"""
    WebMSISE00

Load this module to access the functions below...

"""
module WebMSISE00

export ReadMSISE
export WriteMSISEData
export ReadMSISEData

using HTTP, Gumbo, DataStructures
using DataFrames
using CSV
using JLD2
using AbstractTrees

"""
    ReadMSISE(case_inputs::Dict, casename::String = "")

    Executes an MSISE00 run on NASA's Model Web site.

    Uses HTTP.jl and Gumbo.jl to access the appropriate PHP form on the NASA
    Model Web site, submits the form, then scrapes the resulting data. The data
    is returned in a DataFrame.

    INPUT:
        `case_inputs` is a Dict that gets merged with the default settings 
            contained in the payload Dict below.
        
        `casename` is used as the basis of the filename for storing output into
            a JLD2 file (no string means "don't write a file")

    OUTPUT: casename.jld2 (optional)

    RETURNS: DataFrame containing the requested atmospheric data
"""
function ReadMSISE(case_inputs::Dict, casename::String = "")
    
    url = "https://ccmc.gsfc.nasa.gov/modelweb/models/nrlmsise00.php"

    resp = HTTP.get(url) # grab the entire page

# The hierarchical structure of the HTML body is broken into a many
#   dimensional array. The trick is to page thru until you find what you want.

# The following commented code would be needed in case we wish to autodetect
#   the form data and do something with it

# parsed = parsehtml(String(resp.body))  # parse it into a ginormous array
# body = parsed.root[2] # the body (as opposed to the header)
# form = body[4][1][6]

# TIP: Chrome developer mode is useful for looking at the form to determine
#   the variables and values to POST.
#
# the form items to POST start with a dict of the responses of the format:
#   key(name) => value

    url2 = "https://ccmc.gsfc.nasa.gov/cgi-bin/modelweb/models/vitmo_model.cgi"

# NOTE: everything is submitted to the form as a string
# NOTE2: using OrderedDict in case order actually matters
# NOTE3: multiple selected checkboxes in the form result in needing to
#   use multiple values with a single key... obviously a problem when using
#   anything related to a Dict. **SOLVED** by storing checkbox items in an
#   array, then parsing that array using an inner loop

# vars Array values
#   Independent variables:
#   00 = Year; 01 = Month; 02 = Day of Month; 03 = Day of Year;
#   04 = Hour of Day; 05 = Height (km); 06 = Latitude; 07 = Longitude
#   Calculated Parameters:
#   08 = Atomic Oxygen number density (cm^-3); 09 = N2 number density;
#   10 = O2 number density; 11 = total mass density (g/cm^3);
#   12 = Neutral Temp (K); 13 = Exospheric Temp (K); 14 = He number density;
#   15 = Ar number density; 16 = H number density; 17 = N number density;
#   18 = Anomalous Oxygen number density
#   Indices taken from user input vs. data base
#   19 = F10.7 (daily); 20 = F10.7 (3 month avg); 21 = ap (daily);
#       (remainder won't generally be used)

    payload = OrderedDict{String, Any}(
        "model" => "nrlmsise",
        "year" => "2020",
        "month" => "01",
        "day" => "01",
        "time_flag" => "0",
        "hour" => "1.5",
        "geo_flag" => "0.",
        "latitude" => "55.",
        "longitude" => "45.",
        "height" => "100.",
        "profile" => "1",
        "start" => "0.",
        "stop" => "1000.",
        "step" => "50.",
        "f10_7" => "",
        "f10_7_3" => "",
        "ap" => "",
        "format" => "2",
        "vars" => ["05", "08", "09"],
        "linestyle" => "solid",
        "charsize" => "1.0",
        "symbol" => "2",
        "symsize" => "1.0",
        "yscale" => "Lin",
        "xscale" => "Lin",
        "imagex" => "640",
        "imagey" => "480"
    )

# Merge the input with the payload Dict

    merge!(payload, case_inputs)

# Convert the Dict into the format expected...
#   That format was discovered using Chrome developer tool, looking at the outgoing
#   form submission

    form_data = ""

    for (k, v) in payload
        if isa(v, Array) || isa(v, Tuple)
            for w in v
                form_data = form_data * k * "=" * w * "&"
            end
        else
            form_data = form_data * k * "=" * v * "&"
        end
    end
    form_data = rstrip(form_data, ['&']) # get rid of extraneous trailing '&'

    resp2 = HTTP.request("POST", url2, 
        ["Content-Type" => "application/x-www-form-urlencoded"], form_data)

    body2 = parsehtml(String(resp2.body)).root[2]

# find all HREFs in body2 (there are many)
# body2 is a Tree, which is why we needed AbstractTrees

    links = String[]
    for element in PreOrderDFS(body2)
        if element isa HTMLElement
           if "href" in keys(attrs(element))
               push!(links, attrs(element)["href"])
           end
        end
    end
    
# extract the one that matches what we need
    link = ""
    url3 = ""
    for link in links
        if startswith(link, "http") && endswith(link,".lst")
            url3 = link
            break
        end
    end

    resp3 = HTTP.get(url3)

    result = parsehtml(String(resp3.body)).root[2][1].text

# Next step: parse the actual data from 'result'
# result is pure ASCII. It contains an echo of the important inputs,
#   a 'decoder ring' for the columns, and then the actual data (in columns
#   labeled 1, 2, ..., hence the need for the 'decoder ring')
# Optional step: Write result out to a file for safe keeping?

    model_input_echo = String[]
    cols_key = String[]
    data = String[]
    i = 0
    df1 = DataFrame()

# parse line by line, breaking result into 3 pieces

    for line in eachline(IOBuffer(result))
        if !occursin("Selected output parameters", line) && i==0
            push!(model_input_echo, line)
        elseif occursin("Selected output parameters", line)
            i = i + 1
            continue
        elseif i == 1 && occursin(",", line)
            push!(cols_key, line)
        else
            push!(data, line)
        end
    end

# Parse column key to a DataFrame so we can pull out the column names
    
    for l in cols_key
        thisline = CSV.read(IOBuffer(l), DataFrame; header = 0, delim = "  ")
        df1 = vcat(df1, thisline)
    end

    cols_names = df1.Column2

# need to reassemble data into a long string so we can read into DataFrame
#   without trying to parse line by line (as in the above loop)
#   NOTE: start on line 3

    data2 = ""
    for l in data[3:length(data)]
        data2 = data2 * l * "\n"
    end

# Seems inefficient to read the data twice (probably can replace last 
#   push! in the line-by-line parsing with what's immediately above)

    df2 = CSV.read(IOBuffer(data2), DataFrame; header = 0, delim = " ",
        ignorerepeated = true)

# Now we need to insert the column names...

    rename!(df2,cols_names)

    if length(casename) > 0
# Convert model_input_echo from a vector of one line strings
        input_echo = ""
        for l in model_input_echo
            input_echo = input_echo * l * "\n"
        end

        WriteMSISEData(casename, input_echo, df2)
    end

# the DataFrame is now ready for use... so return it
    return df2

end # ReadMSISE

# RunMSISEUI: a simple user interface to set up a case to grab from ModelWeb

"""
    WriteMSISEData(casename::String, run_echo::String, rundata::DataFrame)

Writes the MSISE00 results to a JLD2 file.

Used for storing chunks of the MSISE00 output to a file for later use.

INPUT: 
    `casename` = basis for the filename ('.jld2' extension is added)
    `run_echo` = the ModelWeb site echos back the inputs at the top of its
        output, this string contains just that portion of the output
    `rundata` = the DataFrame containing the parsed MSISE00 output

OUTPUT: 'casename.jld2' file containing stored data

RETURNS: none
"""
function WriteMSISEData(casename::String, run_echo::String, rundata::DataFrame)
    filename = casename * ".jld2"

    @save filename run_echo rundata
end

"""
    ReadMSISEData(casename::String)

Reads MSISE00 results from a JLD2 file.

INPUT: 
    `casename` = basis for the filename ('.jld2' extension is added)
    
OUTPUT: none

RETURNS:
    `run_echo` = the ModelWeb site echos back the inputs at the top of its
        output, this string contains just that portion of the output
    `rundata` = the DataFrame containing the parsed MSISE00 output
"""
function ReadMSISEData(casename::String)
    filename = casename * ".jld2"

    @load filename run_echo rundata

    return run_echo, rundata
end

end # module