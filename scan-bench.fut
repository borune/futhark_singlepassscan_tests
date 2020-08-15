import "radixsort"
import "mergesort"



-- ==
-- entry: scanplus_i32
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
entry scanplus_i32 (input:[]i32) =
    scan (+) 0 input

-- ==
-- entry: scanomap_i32
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
entry scanomap_i32 (input:[]i32) =
    let arr = map (*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')

-- =/=
-- entry: mapplus_i32
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
entry mapplus_i32 (input:[]i32) =
    map (+2) input

-- Patition tests
-- =/=
-- entry: par_i32
-- random input { [100000000]i32 } auto output
entry par_i32 [n] (arr: [n]i32) : ([]i32, []i32) =
    partition (\x -> (x % 2) == 0i32) arr


-- =/=
-- entry: radixsort_i32
-- random input { [100000000]i32 } auto output
entry radixsort_i32 = radix_sort_int i32.num_bits i32.get_bit


-- =/=
-- entry: mergesort_i32
-- random input { [100000000]i32 } auto output
entry mergesort_i32 (xs: []i32) = merge_sort (i32.<=) xs



