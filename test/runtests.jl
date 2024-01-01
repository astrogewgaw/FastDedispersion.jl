using Test
using FastDedispersion

@testset "FastDedispersion.jl" begin
    open("./data/frb.fil") do s
        seek(s, 360)
        data = Array{UInt8}(read(s))
        data = reshape(data, 128, :)

        Δf = 200.0
        dm = 1000.0
        f₀ = 499.21875
        δt = 1.31072e-3

        dmt = FastDedispersion.transform(
            data,
            f₀,
            f₀ - Δf + 0.5 * (Δf / 128),
            δt,
            900.0,
            1100.0,
        )

        nt = size(dmt, 2)
        t = range(0.0, nt * δt, nt)
        dms = range(900.0, 1100.0, size(dmt, 1))
        dmmax, tmax = Tuple(argmax(dmt[1000:end, 2000:6000]))

        @test tmax == 2031
        @test dmmax == 1852
        @test maximum(dmt) ≈ 4605.0
        @test t[2000+tmax] ≈ 5.0 atol = 0.5
        @test dms[1000+dmmax] ≈ 1000.0 atol = 50.0
    end
end
