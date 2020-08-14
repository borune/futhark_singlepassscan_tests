import "radixsort"
import "mergesort"
-- ==
-- entry: scanplus
-- random input { [1000]i64 } auto output
entry scanplus (input:[]i64) =
    scan (+) 0 input
-- random input { [10000]i64 } auto output
-- random input { [100000]i64 } auto output
-- random input { [1000000]i64 } auto output
-- random input { [10000000]i64 } auto output
-- random input { [100000000]i64 } auto output
-- random input { [1000000000]i64 } auto output

-- ==
-- entry: scanomap
-- random input { [1000]i64 } auto output
entry scanomap (input:[]i64) =
    let arr = map (*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')
-- random input { [10000]i64 } auto output
-- random input { [100000]i64 } auto output
-- random input { [1000000]i64 } auto output
-- random input { [10000000]i64 } auto output
-- random input { [100000000]i64 } auto output
-- random input { [1000000000]i64 } auto output

-- ==
-- entry: mapplus
-- random input { [1000]i64 } auto output
entry mapplus (input:[]i64) =
    map (+2) input
-- random input { [10000]i64 } auto output
-- random input { [100000]i64 } auto output
-- random input { [1000000]i64 } auto output
-- random input { [10000000]i64 } auto output
-- random input { [100000000]i64 } auto output
-- random input { [1000000000]i64 } auto output

-- Patition tests
-- ==
-- entry: par_i64
-- random input { [1000]i64 } auto output
entry par_i64 [n] (arr: [n]i64) : ([]i64, []i64) =
    partition (\x -> (x % 2) == 0i64) arr


-- ==
-- entry: radixsort_i64
-- random input { [1000]i64 } auto output
entry radixsort_i64 = radix_sort_int i64.num_bits i64.get_bit


-- ==
-- entry: mergesort_i64
-- random input { [1000]i64 } auto output
entry mergesort_i64 (xs: []i64) = merge_sort (i64.<=) xs
