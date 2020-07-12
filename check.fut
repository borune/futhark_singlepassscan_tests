let main (as:[]i32) : i32 =
	let result = scan (+) 0 as
	in result[64]
