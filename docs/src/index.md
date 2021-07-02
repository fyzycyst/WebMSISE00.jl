# WebMSISE00.jl Documentation

*Accesses and runs the MSISE00 Earth atmosphere model on NASA's Model Web site.*

```@contents
```

## Description
Accesses the NASA Model Web site to generate and retrieve MSISE00 
atmospheric model profiles.  Also contains routines for storing & retrieving 
results to/from JLD2 files.

For simple examples, see the accompanying Pluto notebook.

**NOTE** *Please do not abuse the NASA ModelWeb site!! If you anticipate 
many runs, consider downloading the model code and running a local copy.*

DEPENDENCIES: the following package versions were used
- AbstractTrees v0.3.4
- CSV v0.8.4
- DataFrames v1.1.1
- DataStructures v0.18.9
- Gumbo v0.8.0
- HTTP v0.9.8
- JLD2 v0.4.7

## Installation
The package can be installed by pointing at the GitHub repo:
[https://github.com/fyzycyst/WebMSISE00.jl](https://github.com/fyzycyst/WebMSISE00.jl)

## Project Status
This project was done purely as an exercise to learn Julia and, secondarily, to
learn web scraping at a level beyond the usual 'there's an HTML table, get it!'

However, if this should be of modest use (I can think of educational uses), 
please let me know.

## Comments & Questions
All helpful comments/suggestions are welcome. Questions too. I can be reached
at... [e.strobel.phd@gmail.com](mailto:e.strobel.phd@gmail.com)

## Functions

```@docs
WebMSISE00
ReadMSISE
WriteMSISEData
ReadMSISEData
```
