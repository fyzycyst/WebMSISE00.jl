using Documenter
using WebMSISE00

makedocs(
    sitename = "WebMSISE00",
    format = Documenter.HTML(),
    modules = [WebMSISE00]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#