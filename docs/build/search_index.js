var documenterSearchIndex = {"docs":
[{"location":"#WebMSISE00.jl-Documentation","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"Accesses and runs the MSISE00 Earth atmosphere model on NASA's Model Web site.","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"","category":"page"},{"location":"#Description","page":"WebMSISE00.jl Documentation","title":"Description","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"Accesses the NASA Model Web site to generate and retrieve MSISE00  atmospheric model profiles.  Also contains routines for storing & retrieving  results to/from JLD2 files.","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"For simple examples, see the accompanying Pluto notebook.","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"NOTE Please do not abuse the NASA ModelWeb site!! If you anticipate  many runs, consider downloading the model code and running a local copy.","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"DEPENDENCIES: the following package versions were used","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"AbstractTrees v0.3.4\nCSV v0.8.4\nDataFrames v1.1.1\nDataStructures v0.18.9\nGumbo v0.8.0\nHTTP v0.9.8\nJLD2 v0.4.7","category":"page"},{"location":"#Installation","page":"WebMSISE00.jl Documentation","title":"Installation","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"The package can be installed by pointing at the GitHub repo: https://github.com/fyzycyst/WebMSISE00.jl","category":"page"},{"location":"#Project-Status","page":"WebMSISE00.jl Documentation","title":"Project Status","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"This project was done purely as an exercise to learn Julia and, secondarily, to learn web scraping at a level beyond the usual 'there's an HTML table, get it!'","category":"page"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"However, if this should be of modest use (I can think of educational uses),  please let me know.","category":"page"},{"location":"#Comments-and-Questions","page":"WebMSISE00.jl Documentation","title":"Comments & Questions","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"All helpful comments/suggestions are welcome. Questions too. I can be reached at... e.strobel.phd@gmail.com","category":"page"},{"location":"#Functions","page":"WebMSISE00.jl Documentation","title":"Functions","text":"","category":"section"},{"location":"","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.jl Documentation","text":"WebMSISE00\r\nReadMSISE\r\nWriteMSISEData\r\nReadMSISEData","category":"page"},{"location":"#WebMSISE00","page":"WebMSISE00.jl Documentation","title":"WebMSISE00","text":"WebMSISE00\n\nLoad this module to access the functions below...\n\n\n\n\n\n","category":"module"},{"location":"#WebMSISE00.ReadMSISE","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.ReadMSISE","text":"ReadMSISE(case_inputs::Dict, casename::String = \"\")\n\nExecutes an MSISE00 run on NASA's Model Web site.\n\nUses HTTP.jl and Gumbo.jl to access the appropriate PHP form on the NASA\nModel Web site, submits the form, then scrapes the resulting data. The data\nis returned in a DataFrame.\n\nINPUT:\n    `case_inputs` is a Dict that gets merged with the default settings \n        contained in the payload Dict below.\n    \n    `casename` is used as the basis of the filename for storing output into\n        a JLD2 file (no string means \"don't write a file\")\n\nOUTPUT: casename.jld2 (optional)\n\nRETURNS: DataFrame containing the requested atmospheric data\n\n\n\n\n\n","category":"function"},{"location":"#WebMSISE00.WriteMSISEData","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.WriteMSISEData","text":"WriteMSISEData(casename::String, run_echo::String, rundata::DataFrame)\n\nWrites the MSISE00 results to a JLD2 file.\n\nUsed for storing chunks of the MSISE00 output to a file for later use.\n\nINPUT:      casename = basis for the filename ('.jld2' extension is added)     run_echo = the ModelWeb site echos back the inputs at the top of its         output, this string contains just that portion of the output     rundata = the DataFrame containing the parsed MSISE00 output\n\nOUTPUT: 'casename.jld2' file containing stored data\n\nRETURNS: none\n\n\n\n\n\n","category":"function"},{"location":"#WebMSISE00.ReadMSISEData","page":"WebMSISE00.jl Documentation","title":"WebMSISE00.ReadMSISEData","text":"ReadMSISEData(casename::String)\n\nReads MSISE00 results from a JLD2 file.\n\nINPUT:      casename = basis for the filename ('.jld2' extension is added)\n\nOUTPUT: none\n\nRETURNS:     run_echo = the ModelWeb site echos back the inputs at the top of its         output, this string contains just that portion of the output     rundata = the DataFrame containing the parsed MSISE00 output\n\n\n\n\n\n","category":"function"}]
}
