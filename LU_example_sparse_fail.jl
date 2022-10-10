using CSV
using Tables
using DataFrames
using JLD2
using SparseArrays
using MAT
using LinearAlgebra





filename = string(@__DIR__,"/NuNv.mat")
matfile = matopen(filename)
NuNv_sparse_matlab = read(matfile,"NuNv")
@show size(NuNv_sparse_matlab)
@show typeof(NuNv_sparse_matlab)

filename = string(@__DIR__,"/NuNv_full.mat")
matfile = matopen(filename)
NuNv_full_matlab = read(matfile,"NuNv_full")
@show size(NuNv_full_matlab)
@show typeof(NuNv_full_matlab)

F = LinearAlgebra.lu(NuNv_full_matlab; check = true)
L_NuNv_full = sparse(F.L)
U_NuNv_full = sparse(F.U)

@show size(L_NuNv_full)
@show typeof(L_NuNv_full)

F = LinearAlgebra.lu(NuNv_sparse_matlab; check = true)
L_NuNv_sparse = sparse(F.L)
U_NuNv_sparse = sparse(F.U)

@show size(L_NuNv_sparse)
@show typeof(L_NuNv_sparse)
count = 0
for i = 1:size(L_NuNv_full,1)
    for j = 1:size(L_NuNv_full,2)
        if L_NuNv_full[i,j] .- L_NuNv_sparse[i,j]  > 1e-6 || L_NuNv_full[i,j] .- L_NuNv_sparse[i,j] < -1e-6
            
            global count += 1
           # @show i,j,var_matlab[i,j],var_julia[i,j]
        end
    end
end
@show "Number of elements differening between L_NuNv calculated with full matrix versus sparse matrix, both with lu in julia", count

filename = string(@__DIR__,"/L_NuNv.mat")
matfile = matopen(filename)
L_NuNv_sparse_matlab = read(matfile,"L_NuNv")
@show size(L_NuNv_sparse_matlab)
@show typeof(L_NuNv_sparse_matlab)
count = 0
for i = 1:size(L_NuNv_sparse_matlab,1)
    for j = 1:size(L_NuNv_sparse_matlab,2)
        if L_NuNv_sparse_matlab[i,j] .- L_NuNv_sparse[i,j]  > 1e-6 || L_NuNv_sparse_matlab[i,j] .- L_NuNv_sparse[i,j] < -1e-6
            
            global count += 1
           # @show i,j,var_matlab[i,j],var_julia[i,j]
        end
    end
end
@show "Number of elements differening between L_NuNv calculated by MATLAB versus sparse matrix in julia", count



count = 0
for i = 1:size(L_NuNv_sparse_matlab,1)
    for j = 1:size(L_NuNv_sparse_matlab,2)
        if L_NuNv_sparse_matlab[i,j] .- L_NuNv_full[i,j]  > 1e-6 || L_NuNv_sparse_matlab[i,j] .- L_NuNv_full[i,j] < -1e-6
            
            global count += 1
           # @show i,j,var_matlab[i,j],var_julia[i,j]
        end
    end
end
@show "Number of elements differening between L_NuNv calculated by MATLAB versus full matrix in julia", count
println("Summary: lu in Julia on the full matrix agrees with lu in MATLAB (calculated on the sparse matrix).  lu in Julia with the sparse matrix does not agree with the others.")


            
