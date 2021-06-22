using Test
using WebMSISE00

# insert tests using @Test macro

    #Test 1 (tests ReadMSISE)
    testinput = Dict(
        "year" => "2017",
        "month" => "01",
        "day" => "01",
        "step" => "25.",
        "vars" => ["05","11"]
    )
    @test ReadMSISE(testinput)[4,2] == 2.773e-08

    #Test 2 (tests WriteMSISEData, using the call within ReadMSISE)
    ReadMSISE(testinput, "testoutput")
    @test isfile("testoutput.jld2")

    #Test 3 (tests ReadMSISEData)
    frontmatter, output = ReadMSISEData("testoutput")
    @test output[4,2] == 2.773e-08
