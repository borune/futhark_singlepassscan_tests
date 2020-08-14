import "partition2"

-----------------------
--- Flat Quicksort
-----------------------
let randomInd ( (lb,ub) : (i32,i32) ) (count : i32) : i32 =
  if lb > ub then 0 else
  ( (count+lb+ub) % (ub - lb + 1) ) + lb

let isSorted [n] (arr: [n]f32) : bool =
    map (\i-> unsafe (arr[i] <= arr[i+1])) (iota (n-1))
    |> reduce (&&) true

let quicksortL [n][m] (shp: [m]i32, arr: [n]f32) : ([]i32, []f32) =
  let stop  = isSorted arr
  let count = 0

  let (shp,arr,_,_) =
    loop(shp,arr,stop,count) while (!stop) do
      let begs   = scan (+) 0 shp
      let flags  = mkFlagArray shp 0i32 <| map (+1) <| iota (length shp)

      let outinds= sgmSumInt flags <| map (\f -> if f==0 then 0 else f-1) flags

      let rL   = map (\u -> randomInd(0,u-1) count) shp
      let pivL = map3(\r l i -> if l <= 0 then 0.0
                                else let off = if i > 0 then unsafe begs[i-1] else 0
                                     in  unsafe arr[off + r]
                     ) rL shp (iota (length shp))

      let condsL = map2(\a sgmind -> unsafe pivL[sgmind] > a ) arr outinds

      let (ps, (_,arr')) = partition2L condsL 0.0f32 (shp, arr)

      -- shp' = [p, n-p]
      let shp' = filter (!=0) <| flatten <| map2 (\p s -> if s==0 then [0,0] else [p,s-p]) ps shp

      let stop' = isSorted arr'
      in (shp', arr', stop', count+1)
  in (shp,arr)




