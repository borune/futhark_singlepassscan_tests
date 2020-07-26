-- entry: mapplus
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
entry mapplus (input:[]i32) =
    map (+2) input

-- ==
-- entry: scanplus
-- random input { [100000000]i32 } auto output
entry scanplus (input:[]i32) =
    scan (+) 0 input

-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output




-- entry: scanomap
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
entry scanomap (input:[]i32) =
    let arr = map (*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')

-- random input { [100000000]i32 } auto output
-- random input { [1000000000]i32 } auto output
