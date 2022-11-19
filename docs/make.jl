using Documenter

format = Documenter.HTML(assets=["assets/css/ai4e.css"])

Modeling = map(file -> joinpath("Modeling", file), readdir(joinpath(@__DIR__, "src", "Modeling")))
Simulation = map(file -> joinpath("Simulation", file), readdir(joinpath(@__DIR__, "src", "Simulation")))
Optimization = map(file -> joinpath("Optimization", file), readdir(joinpath(@__DIR__, "src", "Optimization")))
Control = map(file -> joinpath("Control", file), readdir(joinpath(@__DIR__, "src", "Control")))
Frameworks = map(file -> joinpath("Frameworks", file), readdir(joinpath(@__DIR__, "src", "Frameworks")))
CS_Base = map(file -> joinpath("CS Base", file), readdir(joinpath(@__DIR__, "src", "CS Base")))
Tools = map(file -> joinpath("Tools", file), readdir(joinpath(@__DIR__, "src", "Tools")))
WorkFlow = map(file -> joinpath("WorkFlow", file), readdir(joinpath(@__DIR__, "src", "WorkFlow")))

makedocs(
    sitename="Ai4EDocs",
    pages=[
        "Home" => "index.md",
        "Frameworks" => Frameworks,
        "Modeling" => Modeling,
        "Simulation" => Simulation,
        "Optimization" => Optimization,
        "Control" => Control,
        "CS Base" => CS_Base,
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
