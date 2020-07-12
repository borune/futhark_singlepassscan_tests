-- ==
-- entry: map
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
let map (input:[]i32) =
    map (+2) input

-- ==
-- entry: scanplus
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
let scanplus (input:[]i32) =
    scan (+) 0 input

-- ==
-- entry: scanmul
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
let scanmul (input:[]i32) =
    scan (*) 0 input

-- ==
-- entry: scanomap
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [10000000]i32 } auto output
-- random input { [100000000]i32 } auto output
let scanomap (input:[]i32) =
    let arr = map (\x -> x*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')

-- random input { [1000000000]i32 } auto output
