# julia_lu_sparse_example_fail
Code that performs lu factorization correctly on full matrix in julia but not sparse matrix

In both Julia and MATLAB, lu() takes arrays or sparse arrays.  Using MATLAB to generate a 3969x3969 matrix useful for isogeometric analysis, the matrix is saved in .mat files in full or sparse format.

After LU factorization in MATLAB (on the sparse matrix), the L matrix is saved in a .mat file.

In Julia, the full matrix is factored with LinearAlgebra.lu() and the L matrix is sparsified.

Also in Julia, the sparse matrix from MATLAB is factored with LinearAlgebra.lu().

The resulting sparse L matrices are compared to each other and to the MATLAB-derived matrix.

While the L matrix calculated in Julia with the full matrix agrees with the MATLAB-derived L matrix, the L matrix calculated in Julia with the sparse matrix agrees with neither.
