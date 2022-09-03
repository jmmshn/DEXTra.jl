using Documenter
using DEXTra
using DEXTra.ExchangeFunctions

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

# make docs
makedocs(
    sitename = "DEXTra",
    format = format,
    modules = [DEXTra],
    pages = pages_files,
    clean = true,
)

# deploy docs
deploydocs(
    repo = "github.com/jmmshn/DEXTra.jl.git",
    target = "build",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#", ],
    deps = nothing,
    make = nothing,
    push_preview = true,
)