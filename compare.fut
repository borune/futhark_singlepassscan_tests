let main [n] (as:[n]i32) (bs:[n]i32):(bool,i32,i32,i32) =
	let sas = scan (+) 0 as
	let tfs =  map2 (\a b -> a == b) sas bs
  let falseIndx = map2 (\tf ind -> if tf then ind else -1) tfs (iota n)
  let filt = filter (\a -> a > -1) falseIndx
	in (reduce (&&) true tfs,(first filt),(last sas),(last bs))
