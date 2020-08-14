import "radixsort"
import "mergesort"

-- ==
-- entry: scanplus_i8
-- random input { [100000000]i8 } auto output
entry scanplus_i8 (input:[]i8) =
    scan (+) 0 input
-- random input { [1000]i8 } auto output
-- random input { [10000]i8 } auto output
-- random input { [100000]i8 } auto output
-- random input { [10000000]i8 } auto output
-- random input { [100000000]i8 } auto output
-- random input { [1000000000]i8 } auto output

-- ==
-- entry: scanomap_i8
-- random input { [100000000]i8 } auto output
entry scanomap_i8 (input:[]i8) =
    let arr = map (*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')

-- ==
-- entry: mapplus_i8
-- random input { [100000000]i8 } auto output
entry mapplus_i8 (input:[]i8) =
    map (+2) input

-- Patition tests
-- ==
-- entry: par_i8
-- random input { [100000000]i8 } auto output
entry par_i8 [n] (arr: [n]i8) : ([]i8, []i8) =
    partition (\x -> (x % 2) == 0i8) arr


-- ==
-- entry: radixsort_i8
-- random input { [100000000]i8 } auto output
entry radixsort_i8 = radix_sort_int i8.num_bits i8.get_bit


-- ==
-- entry: mergesort_i8
-- random input { [100000000]i8 } auto output
entry mergesort_i8 (xs: []i8) = merge_sort (i8.<=) xs
