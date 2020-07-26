-- ==
-- random input { [100]i32 } auto output
-- random input { [1000]i32 } auto output
-- random input { [10000]i32 } auto output
-- random input { [100000]i32 } auto output
-- random input { [1000000]i32 } auto output
-- random input { [100000000]i32 } auto output

let main n (x:[n]i32): [n]i32 =
    scan (+) 0 x


-- random input { [1]i32 } auto output
-- random input { [7]i32 } auto output
-- random input { [13]i32 } auto output
-- random input { [42]i32 } auto output
-- random input { [8704]i32 } auto output
-- random input { [32768]i32 } auto output
-- random input { [524288]i32 } auto output
-- random input { [1000000]i32 } auto output
