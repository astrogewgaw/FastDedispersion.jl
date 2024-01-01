module FastDedispersion

const 𝓓 = 4.1488064239e3

struct InputSegment{T}
    nf::Int64
    nt::Int64
    fₕ::Float64
    fₗ::Float64
    δt::Float64
    data::AbstractMatrix{T}
end

function InputSegment(fₕ, fₗ, δt, data)
    fₕ < fₗ && throw("fₕ ≯ fₗ.")
    nf, nt = size(data)
    InputSegment(nf, nt, fₕ, fₗ, δt, data)
end

mutable struct OutputSegment
    y₀::Int64
    yₙ::Int64
    data::Array{Float64}
end

function OutputSegment(y₀, yₙ, nt::Int64)
    data = zeros(Float32, yₙ - y₀ + 1, nt)
    OutputSegment(y₀, yₙ, data)
end

δdm(inseg::InputSegment) = inseg.δt / Δξperdm(inseg)
Δξperdm(inseg::InputSegment) = 𝓓 * (inseg.fₗ^-2 - inseg.fₕ^-2)

function split(inseg::InputSegment)
    Δf = inseg.fₕ - inseg.fₗ
    δf = Δf / inseg.nf
    fᵢ = (0.5 * (inseg.fₗ^-2 + inseg.fₕ^-2))^-0.5
    i = round(Int, (inseg.fₕ - fᵢ) / δf)
    head = InputSegment(inseg.fₕ, inseg.fₕ - (i - 1) * δf, inseg.δt, view(inseg.data, 1:i, :))
    tail = InputSegment(inseg.fₕ - i * δf, inseg.fₗ, inseg.δt, view(inseg.data, (i+1):inseg.nf, :))
    head, tail
end


function recursive_loop(y₀, yₙ, inseg::InputSegment)
    oseg = OutputSegment(y₀, yₙ, inseg.nt)

    if inseg.nf == 1
        oseg.data[1, :] = inseg.data[1, :]
        return oseg
    end

    head, tail = split(inseg)
    y₀ₕ = round(Int, y₀ * Δξperdm(head) / Δξperdm(inseg) + 0.5)
    yₙₕ = round(Int, yₙ * Δξperdm(head) / Δξperdm(inseg) + 0.5)
    Tₕ = recursive_loop(y₀ₕ, yₙₕ, head)

    y₀ₜ = round(Int, y₀ * Δξperdm(tail) / Δξperdm(inseg) + 0.5)
    yₙₜ = round(Int, yₙ * Δξperdm(tail) / Δξperdm(inseg) + 0.5)
    Tₜ = recursive_loop(y₀ₜ, yₙₜ, tail)

    for y ∈ y₀:yₙ
        yₕ = round(Int, y * Δξperdm(head) / Δξperdm(inseg) + 0.5)
        yₜ = round(Int, y * Δξperdm(tail) / Δξperdm(inseg) + 0.5)
        yᵢ = y - yₕ - yₜ

        iₕ = yₕ - Tₕ.y₀ + 1
        iₜ = yₜ - Tₜ.y₀ + 1
        i = y - y₀ + 1
        oseg.data[i, :] = Tₕ.data[iₕ, :] + circshift(Tₜ.data[iₜ, :], -(yₕ + yᵢ))
    end
    return oseg
end

function transform(I, fₕ, fₗ, δt, dm₀, dmₙ)
    inseg = InputSegment(fₕ, fₗ, δt, I)
    y₀ = round(Int, dm₀ / δdm(inseg))
    yₙ = round(Int, ceil(dmₙ / δdm(inseg)))
    oseg = recursive_loop(y₀, yₙ, inseg)
    return oseg.data
end

end
