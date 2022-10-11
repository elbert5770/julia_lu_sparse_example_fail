import Pkg
Pkg.activate(".")
Pkg.add(["SparseArrays","MAT","LinearAlgebra"])

using SparseArrays
using MAT
using LinearAlgebra




# Open sparse matrix generated in matlab
filename = string(@__DIR__,"/NuNv.mat")
matfile = matopen(filename)
NuNv_sparse_matlab = read(matfile,"NuNv")
println("Sparse matrix")
@show size(NuNv_sparse_matlab)
@show typeof(NuNv_sparse_matlab)
println()

# Open full matrix generated in matlab
filename = string(@__DIR__,"/NuNv_full.mat")
matfile = matopen(filename)
NuNv_full_matlab = read(matfile,"NuNv_full")
println("Full matrix")
@show size(NuNv_full_matlab)
@show typeof(NuNv_full_matlab)
println()

# LU factorization of full matrix followed by sparsifying results
F = LinearAlgebra.lu(NuNv_full_matlab; check = true)
L_NuNv_full = sparse(F.L)
U_NuNv_full = sparse(F.U)
println("L matrix from lu(full_matrix) -> spares(result)")
@show size(L_NuNv_full)
@show typeof(L_NuNv_full)
println()

# LU factorization of sparse matrix
Fs = LinearAlgebra.lu(NuNv_sparse_matlab; check = true)
L_NuNv_sparse = Fs.L
U_NuNv_sparse = Fs.U
println("L matrix from lu(sparse_matrix)")
@show size(L_NuNv_sparse)
@show typeof(L_NuNv_sparse)
println()


#Compare L matrix between lu(full_matrix) and lu(sparse_matrix)
count = 0
for i = 1:size(L_NuNv_full,1)
    for j = 1:size(L_NuNv_full,2)
        if L_NuNv_full[i,j] .- L_NuNv_sparse[i,j]  > 1e-6 || L_NuNv_full[i,j] .- L_NuNv_sparse[i,j] < -1e-6
            
            global count += 1
           # @show i,j,L_NuNv_full[i,j],L_NuNv_sparse[i,j]
        end
    end
end
println("Number of elements differening between L_NuNv calculated by: (in julia, lu(full matrix) -> sparse(result)), versus: (in julia, lu(sparse matrix)) : ", count)
println()

#Open L matrix calculated in matlab from sparse matrix
filename = string(@__DIR__,"/L_NuNv.mat")
matfile = matopen(filename)
L_NuNv_sparse_matlab = read(matfile,"L_NuNv")
println("L matrix from MATLAB)")
@show size(L_NuNv_sparse_matlab)
@show typeof(L_NuNv_sparse_matlab)
println()

#Compare L matrix calculated in MATLAB versus calculated in Julia from MATLAB-generated sparse matrix
count = 0
for i = 1:size(L_NuNv_sparse_matlab,1)
    for j = 1:size(L_NuNv_full,2)
        if L_NuNv_sparse_matlab[i,j] .- L_NuNv_sparse[i,j]  > 1e-6 || L_NuNv_sparse_matlab[i,j] .- L_NuNv_sparse[i,j] < -1e-6
            
            global count += 1
           # @show i,j,L_NuNv_sparse_matlab[i,j],L_NuNv_sparse[i,j]
        end
    end
end
println("Number of elements differening between L_NuNv calculated by MATLAB versus: (in julia, lu(sparse matrix): ", count)
println()


#Compare L matrix calculated in MATLAB versus calculated in Julia from full matrix
count = 0
for i = 1:size(L_NuNv_sparse_matlab,1)
    for j = 1:size(L_NuNv_sparse_matlab,2)
        if L_NuNv_sparse_matlab[i,j] .- L_NuNv_full[i,j]  > 1e-6 || L_NuNv_sparse_matlab[i,j] .- L_NuNv_full[i,j] < -1e-6
            
            global count += 1
           # @show i,j,L_NuNv_sparse_matlab[i,j],L_NuNv_full[i,j]
        end
    end
end
println("Number of elements differening between L_NuNv calculated by MATLAB versus: (in julia, lu(full matrix) -> sparse(result)): ", count)
println("^^^^ No difference from MATLAB result when lu() is performed on full matrix ^^^^^")
println()


# LU factorization of sparse matrix, where sparse matrix was calculated in Julia from full matrix
NuNv_full_sparse = sparse(NuNv_full_matlab)
Ffs = LinearAlgebra.lu(NuNv_full_sparse; check = true)
L_NuNv_full_sparse = Ffs.L
U_NuNv_full_sparse = Ffs.U
println("L matrix from sparse(full_matrix) -> lu(result))")
@show size(L_NuNv_full)
@show typeof(L_NuNv_full)
println()

#Compare L matrix calculated in MATLAB versus calculated in Julia from sparse matrix generated from full matrix
count = 0
for i = 1:size(L_NuNv_sparse_matlab,1)
    for j = 1:size(L_NuNv_sparse_matlab,2)
        if L_NuNv_sparse_matlab[i,j] .- L_NuNv_full_sparse[i,j]  > 1e-6 || L_NuNv_sparse_matlab[i,j] .- L_NuNv_full_sparse[i,j] < -1e-6
            
            global count += 1
           # @show i,j,L_NuNv_sparse_matlab[i,j],L_NuNv_sparse[i,j]
        end
    end
end
println("Number of elements differening between L_NuNv calculated by MATLAB versus: (in julia, sparse(full matrix) -> lu(result)): ", count)
println("^^^^ Problem really seems to be with lu() on a sparse matrix in Julia ^^^^^")
println()
println("Summary, lu(sparse matrix) in Julia is giving results that differ from MATLAB and from lu(full matrix) ")

