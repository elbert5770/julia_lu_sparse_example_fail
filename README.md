# julia_lu_sparse_example_fail
Code that performs lu factorization correctly on full matrix in julia but not sparse matrix

In both Julia and MATLAB, lu() takes arrays or sparse arrays.  Using MATLAB to generate a 3969x3969 matrix useful for isogeometric analysis, the matrix is saved in .mat files in full or sparse format.

After LU factorization in MATLAB (on the sparse matrix), the L matrix is saved in a .mat file.

In Julia, the full matrix is factored with LinearAlgebra.lu() and the L matrix is sparsified.

Also in Julia, the sparse matrix from MATLAB is factored with LinearAlgebra.lu().

The resulting sparse L matrices are compared to each other and to the MATLAB-derived matrix.

While the L matrix calculated in Julia with the full matrix agrees with the MATLAB-derived L matrix, the L matrix calculated in Julia with the sparse matrix agrees with neither.

Status `~/.julia/environments/v1.8/Project.toml`
  [336ed68f] CSV v0.10.4
  [a93c6f00] DataFrames v1.4.1
  [033835bb] JLD2 v0.4.25
  [23992714] MAT v0.10.3
  [bd369af6] Tables v1.9.0
  [37e2e46d] LinearAlgebra
  [9a3f8284] Random
  [2f01184e] SparseArrays
