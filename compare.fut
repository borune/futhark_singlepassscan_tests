let main [n] (as:[n]i32) (bs:[n]i32):(bool,i32,i32,i32) =
	let sas = scan (+) 0 as
	let tfs =  map2 (\a b -> a == b) sas bs
	in (reduce (&&) true tfs,n,(last sas),(last bs))