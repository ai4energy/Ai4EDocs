using Documenter

format = Documenter.HTML(assets=["assets/css/ai4e.css"])

CSBase = map(file -> joinpath("CSBase", file), readdir(joinpath(@__DIR__, "src", "CSBase")))
JuliaIntro = map(file -> joinpath("JuliaIntro", file), readdir(joinpath(@__DIR__, "src", "JuliaIntro")))
CSAdv = map(file -> joinpath("CSAdv", file), readdir(joinpath(@__DIR__, "src", "CSAdv")))
Modeling = map(file -> joinpath("Modeling", file), readdir(joinpath(@__DIR__, "src", "Modeling")))
Simulation = map(file -> joinpath("Simulation", file), readdir(joinpath(@__DIR__, "src", "Simulation")))
Optimization = map(file -> joinpath("Optimization", file), readdir(joinpath(@__DIR__, "src", "Optimization")))
Control = map(file -> joinpath("Control", file), readdir(joinpath(@__DIR__, "src", "Control")))
AIandML = map(file -> joinpath("AIandML", file), readdir(joinpath(@__DIR__, "src", "AIandML")))
IotBigdataCloud = map(file -> joinpath("IotBigdataCloud", file), readdir(joinpath(@__DIR__, "src", "IotBigdataCloud")))
Frameworks = map(file -> joinpath("Frameworks", file), readdir(joinpath(@__DIR__, "src", "Frameworks")))
Tools = map(file -> joinpath("Tools", file), readdir(joinpath(@__DIR__, "src", "Tools")))
WorkFlow = map(file -> joinpath("WorkFlow", file), readdir(joinpath(@__DIR__, "src", "WorkFlow")))
GolangIntro = map(file -> joinpath("GolangIntro", file), readdir(joinpath(@__DIR__, "src", "GolangIntro")))
StepByStep = map(file -> joinpath("StepByStep", file), readdir(joinpath(@__DIR__, "src", "StepByStep")))

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
        "CSAdv" => CSAdv,       
        "Modeling" => Modeling,
        "Simulation" => Simulation,
        "Optimization" => Optimization,
        "Control" => Control,
        "AIandML" => AIandML,
        "IotBigdataCloud" => IotBigdataCloud, 
        "Frameworks" => Frameworks,
        "Tools" => Tools,
        "WorkFlow" => WorkFlow,
        "GolangIntro" => GolangIntro,
        "StepByStep" => StepByStep,
    ],
    format=format,
)


deploydocs(
    repo="https://github.com/ai4energy/Ai4EDocs.git";
    push_preview=true
    #    target = "../build",
)
