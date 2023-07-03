using Documenter

format = Documenter.HTML(assets=["assets/css/ai4e.css"])

Modeling = map(file -> joinpath("Modeling", file), readdir(joinpath(@__DIR__, "src", "Modeling")))
Simulation = map(file -> joinpath("Simulation", file), readdir(joinpath(@__DIR__, "src", "Simulation")))
Optimization = map(file -> joinpath("Optimization", file), readdir(joinpath(@__DIR__, "src", "Optimization")))
Control = map(file -> joinpath("Control", file), readdir(joinpath(@__DIR__, "src", "Control")))
Frameworks = map(file -> joinpath("Frameworks", file), readdir(joinpath(@__DIR__, "src", "Frameworks")))
CSBase = map(file -> joinpath("CSBase", file), readdir(joinpath(@__DIR__, "src", "CSBase")))
JuliaIntro = map(file -> joinpath("JuliaIntro", file), readdir(joinpath(@__DIR__, "src", "JuliaIntro")))
IotBigdataCloud = map(file -> joinpath("IotBigdataCloud", file), readdir(joinpath(@__DIR__, "src", "IotBigdataCloud")))
Tools = map(file -> joinpath("Tools", file), readdir(joinpath(@__DIR__, "src", "Tools")))
WorkFlow = map(file -> joinpath("WorkFlow", file), readdir(joinpath(@__DIR__, "src", "WorkFlow")))

makedocs(
    sitename="Ai4EDocs",
    strict=[
             :doctest,
             :linkcheck,
             :parse_error,
             :example_block,
             # Other available options are
             # :autodocs_block, :cross_references, :docs_block, :eval_block, :example_block, :footnote, :meta_block, :missing_docs, :setup_block
    ],
    pages=[
        "Home" => "index.md",
        "CSBase" => CSBase,
        "JuliaIntro" => JuliaIntro,
        "IotBigdataCloud" => IotBigdataCloud,        
        "Modeling" => Modeling,
        "Simulation" => Simulation,
        "Optimization" => Optimization,
        "Control" => Control,
        "Frameworks" => Frameworks,
        "Tools" => Tools,
        "WorkFlow" => WorkFlow,
    ],
    format=format,
)


deploydocs(
    repo="https://github.com/ai4energy/Ai4EDocs.git";
    push_preview=true
    #    target = "../build",
)
