

#Ultraspherical Spaces

type UltrasphericalSpace{T<:Union(IntervalDomain,DataType)} <: OperatorSpace
    order::Int
    domain::T     
end

UltrasphericalSpace(o::Integer)=UltrasphericalSpace(o,Any)




##Check domain compatibility

domainscompatible(a::OperatorSpace,b::OperatorSpace) = a.domain == Any || b.domain == Any || a.domain == b.domain


#TODO: bad override?
==(a::UltrasphericalSpace,b::UltrasphericalSpace)=a.order==b.order && domainscompatible(a,b)

##max space



function Base.max(a::UltrasphericalSpace,b::UltrasphericalSpace)
    @assert domainscompatible(a,b)
    
    a.order > b.order?a:b
end

function Base.min(a::UltrasphericalSpace,b::UltrasphericalSpace)
    @assert domainscompatible(a,b)
    
    a.order < b.order?a:b
end



## Operator space manipulation



# DirichletSpaces


type ChebyshevDirichletSpace{T<:Union(IntervalDomain,DataType)} <: OperatorSpace
    domain::T 
    left::Int
    right::Int    
end

==(a::ChebyshevDirichletSpace,b::ChebyshevDirichletSpace)= a.domain==b.domain && a.left==b.left && a.right==b.right

function Base.max(a::UltrasphericalSpace,b::ChebyshevDirichletSpace)
    @assert domainscompatible(a,b)
    
    a
end
Base.max(b::ChebyshevDirichletSpace,a::UltrasphericalSpace)=max(a,b)

function Base.min(a::UltrasphericalSpace,b::ChebyshevDirichletSpace)
    @assert domainscompatible(a,b)
    
    b
end
Base.min(b::ChebyshevDirichletSpace,a::UltrasphericalSpace)=min(a,b)



##Check domain compatibility

# domainscompatible(a::UltrasphericalDirchletSpace,b::UltrasphericalDirchletSpace) = a.domain == Any || b.domain == Any || a.domain == b.domain
# 
# 
# spacescompatible(a::UltrasphericalDirchletSpace,b::UltrasphericalSpace) = domainscompatible(a,b) && a.order >= b.order
