
points(S::Jacobi,n)=fromcanonical(S,gaussjacobi(n,S.a,S.b)[1])

immutable JacobiTransformPlan{DD,T,TT}
    space::Jacobi{TT,DD}
    points::Vector{T}
    weights::Vector{T}
end

plan_transform(S::Jacobi,v::Vector) = JacobiTransformPlan(S,gaussjacobi(length(v),S.a,S.b)...)
function transform(S::Jacobi,vals,plan::JacobiTransformPlan)
#    @assert S==plan.space
    x,w = plan.points, plan.weights
    V=jacobip(0:length(vals)-1,S.a,S.b,x)'
    w2=w.*(1-x).^(S.a-plan.space.a).*(1+x).^(S.b-plan.space.b)   # need to weight if plan is different
    nrm=(V.^2)*w2

    V*(w2.*vals)./nrm
end




immutable JacobiITransformPlan{DD,T}
    space::Jacobi{Float64,DD}
    points::Vector{T}
end


plan_itransform(S::Jacobi,cfs::Vector) = JacobiITransformPlan(S,points(S,length(cfs)))
function itransform(S::Jacobi,cfs,plan::JacobiITransformPlan)
#    @assert S==plan.space
    jacobip(0:length(cfs)-1,S.a,S.b,tocanonical(S,plan.points))*cfs
end

coefficients{T<:AbstractFloat}(f::Vector{T},a::Jacobi,b::Chebyshev) = domain(a) == domain(b) ? cjt(f,a.a,a.b) : defaultcoefficients(f,a,b)
coefficients{T<:AbstractFloat}(f::Vector{T},a::Chebyshev,b::Jacobi) = domain(a) == domain(b) ? icjt(f,b.a,b.b) : defaultcoefficients(f,a,b)
coefficients{T<:AbstractFloat}(f::Vector{T},a::Jacobi,b::Jacobi) = domain(a) == domain(b) ? jjt(f,a.a,a.b,b.a,b.b) : defaultcoefficients(f,a,b)
coefficients{T<:AbstractFloat}(f::Vector{Complex{T}},a::Jacobi,b::Chebyshev) = domain(a) == domain(b) ? (p=plan_cjt(real(f),a.a,a.b);complex(p*real(f),p*imag(f))) : defaultcoefficients(f,a,b)
coefficients{T<:AbstractFloat}(f::Vector{Complex{T}},a::Chebyshev,b::Jacobi) = domain(a) == domain(b) ? (p=plan_icjt(real(f),b.a,b.b);complex(p*real(f),p*imag(f))) : defaultcoefficients(f,a,b)
coefficients{T<:AbstractFloat}(f::Vector{Complex{T}},a::Jacobi,b::Jacobi) = domain(a) == domain(b) ? complex(jjt(real(f),a.a,a.b,b.a,b.b),jjt(imag(f),a.a,a.b,b.a,b.b)) : defaultcoefficients(f,a,b)
