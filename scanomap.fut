-- ==
-- random input { [1]i32 } auto output
-- random input { [7]i32 } auto output
-- random input { [13]i32 } auto output
-- random input { [42]i32 } auto output
-- random input { [8704]i32 } auto output
-- random input { [32768]i32 } auto output
-- random input { [524288]i32 } auto output
-- random input { [1000000]i32 } auto output

let main (input:[]i32) =
    let arr = map (*2) input
    let arr' = scan (+) 0 arr
    in (arr, arr')
