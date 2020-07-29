let main [n] (as:[n]i32) (bs:[n]i32):(bool,i32,i32,i32,i32,i32,i32,i32) =
	let sas = scan (+) 0 as
	let tfs =  map2 (\a b -> a == b) sas bs
  let falseIndx = map2 (\tf ind -> if tf then -1 else ind) tfs (iota n)
  let filt = filter (\a -> a > -1) falseIndx
  let theLength = length filt
  let first = if theLength > 0 then head filt else -1
  let original = if theLength > 0 then as[head filt] else -1
  let expected = if theLength > 0 then sas[head filt] else -1
  let actually = if theLength > 0 then bs[head filt] else -1
	in (reduce (&&) true tfs,first,theLength,original,expected,actually,(last sas),(last bs))
