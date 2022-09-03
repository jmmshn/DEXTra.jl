using Documenter
using DEXTra

# Copy Over the README.md
cp(
    normpath(@__FILE__, "../../README.md"),
    normpath(@__FILE__, "../src/index.md");
    force=true,
)

format = Documenter.HTML(
    collapselevel = 2,
    prettyurls = get(ENV, "CI", nothing) == "true",
    canonical = "https://jmmshn.github.io/DEXTra.jl",
)

pages_files = ["Home" => "index.md", "API Documentation" => "api.md"]

makedocs(
    sitename = "DEXTra",
    format = format,
    modules = [DEXTra],
    pages = pages_files,
    clean = true,
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
