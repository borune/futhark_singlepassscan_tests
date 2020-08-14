-- Flat implementation of:
-- 1. partition2: reorders the elements of an array such that the ones
--                that succeed under a predicate comes before the ones
--                that fail (the predicate), but the relative order inside
--                the two classes is preserved
-- 2.partition2L: is the segmented/lifted version of `partition2`, i.e., it
--                semantically operates on an array of arrays and applies
--                `partition2` on each subarray (segment).
-- 3. quicksort:  is the flat-parallel version of quicksort algorithm.
--                quicksort implementation uses `partition2L`.

---------------------
--- SgmSumInt     ---
---------------------
-- 2. sgmSumInt on integers, i.e., sgmIncScan (+) 0
let sgmSumInt [n] (flg : [n]i32) (arr : [n]i32) : [n]i32 =
  let flgs_vals =
    scan ( \ (f1, x1) (f2,x2) ->
            let f = f1 | f2 in
            if f2 > 0 then (f, x2)
            else (f, x1 + x2) )
         (0,0) (zip flg arr)
  let (_, vals) = unzip flgs_vals
  in vals

---------------------
--- MkFlags Array ---
---------------------

let mkFlagArray 't [m]
            (aoa_shp: [m]i32) (zero: t)       --aoa_shp=[0,3,1,0,4,2,0]
            (aoa_val: [m]t  ) : []t = unsafe  --aoa_val=[1,1,1,1,1,1,1]
  let shp_rot = map (\i->if i==0 then 0       --shp_rot=[0,0,3,1,0,4,2]
                         else aoa_shp[i-1]
                    ) (iota m)
  let shp_scn = scan (+) 0 shp_rot            --shp_scn=[0,0,3,4,4,8,10]
  let aoa_len = shp_scn[m-1]+aoa_shp[m-1]     --aoa_len= 10
  let shp_ind = map2 (\shp ind ->             --shp_ind=
                       if shp==0 then -1      --  [-1,0,3,-1,4,8,-1]
                       else ind               --scatter
                     ) aoa_shp shp_scn        --   [0,0,0,0,0,0,0,0,0,0]
  in scatter (replicate aoa_len zero)         --   [-1,0,3,-1,4,8,-1]
             shp_ind aoa_val                  --   [1,1,1,1,1,1,1]
                                              -- res = [1,0,0,1,1,0,0,0,1,0]

let scanExc 't [n] (op: t->t->t) (ne: t) (arr : [n]t) : [n]t =
    scan op ne <| map (\i -> if i>0 then unsafe arr[i-1] else ne) (iota n)

let seg_scatter [n] 't (shp:[]i32) (D_xss:[]t) (I_xss:[n]i32) (V_xss:[n]t)
    : []t =
    let B = scanExc (+) 0 shp

    -- let Bs = map2 (\ n m -> replicate n m) shp B |> flatten
    let inds = scanExc (+) 0 shp |> map2 (\n i->if n>0 then i else -1) shp
    let size = ( last inds ) + ( last shp )
    let vls = scatter (replicate size 0) inds B
    let F = scatter (replicate size 0) inds shp
    let Bs = sgmSumInt F vls

    let I_off = map (\i -> Bs[i] + I_xss[i]) (iota (length I_xss))
    let D_res = scatter (copy D_xss) I_off V_xss
    in D_res

-- let segmented_scan [n] 't (op: t -> t -> t) (ne: t)
--                           (flags: [n]bool) (as: [n]t): [n]t =
--   (unzip (scan (\(x_flag,x) (y_flag,y) ->
--                 (x_flag || y_flag,
--                  if y_flag then y else x `op` y))
--           (false, ne)
--           (zip flags as))).2

-- let segmented_reduce [n] 't (op: t -> t -> t) (ne: t)
--                             (flags: [n]bool) (as: [n]t) =
--   -- Compute segmented scan.  Then we just have to fish out the end of
--   -- each segment.
--   let as' = segmented_scan op ne flags as
--   -- Find the segment ends.
--   let segment_ends = rotate 1 flags
--   -- Find the offset for each segment end.
--   let segment_end_offsets = segment_ends |> map i32.bool |> scan (+) 0
--   let num_segments = if n > 1 then segment_end_offsets[n-1] else 0
--   -- Make room for the final result.  The specific value we write here
--   -- does not matter; they will all be overwritten by the segment
--   -- ends.
--   let scratch = replicate num_segments ne
--   -- Compute where to write each element of as'.  Only segment ends
--   -- are written.
--   let index i f = if f then i-1 else -1
--   in scatter scratch (map2 index segment_end_offsets segment_ends) as'

-- segmented scan
let segscan [n] 't (op: t -> t -> t) (ne: t) (arr: [n](t, bool)): [n]t =
    let ps = scan (\ (v1,f1) (v2,f2) ->
                        let f = f1 || f2
                        let v = if f2 then v2 else op v1 v2
                        in (v,f) ) (ne,false) arr
    let (res,_) = unzip ps
    in res

-- segmented reduce
let segreduce [n] 't (op: t -> t -> t) (ne: t) (arr: [n](t, bool)): []t =
    let scanned = segscan op ne arr
    let (_,tfs) = unzip arr
    let ends = rotate 1 tfs
    let (res,_) = filter (\(_,tf) -> tf) (zip scanned ends) |> unzip
    in res

-----------------------------------------
--- Weekly 2, TASK 4                  ---
--- The Lifted Version of Partition2  ---
--- (segmented version of Partition2) ---
-----------------------------------------
-- Please implement the function below, which is supposed to
--   be the lifted version of `partition2` function given above.
-- The current `main` function is testing quicksort, which will likely
--   not terminate (infinite loop) unless your implementation of `partition2L`
--   is correct. So, for debugging purposes write a new `main` function and
--   input dataset, which tests `partition2L`.
--
-- Arguments of `partition2L` are:
--   `(shp: [m]i32, arr: [n]t)` is the flat-representation of
--            the irregular 2-dim (input) array to be partitioned;
--            `shp` is its shape, and `arr` is its flat data;
--   `condsL` is an irregular 2-dim array of booleans, which has
--            the same shape (`shp`) and flat-length (`n`) as the
--            input to-be-partitioned array.
-- The result is a tuple:
--    the first element is an array of split points of size `m`,
--       i.e., the index in each segment where the `false` elements
--       start.
--    the second element is the flat-representation of the partitioned result:
--       the first element should simply be `shp` (redundant)
--       the second element should be the flat-data of the partitioned result.
-- Please note that `partition2` ends with a call to `scatter`, hence you will
--   probably need to apply the flattening rule you wrote to solve TASK3.
--
let partition2L 't [n] [m]
                -- the shape of condsL is also shp
                (condsL: [n]bool) (dummy: t)
                (shp: [m]i32, arr: [n]t) :
                ([m]i32, ([m]i32, [n]t)) =
  let begs   = scan (+) 0 shp
  let flags  = mkFlagArray shp 0i32 (map (+1) (iota m))
  let outinds= sgmSumInt flags <| map (\f -> if f==0 then 0 else f-1) flags

-- xss: [[1,2,3],[4,5,6,7]]
-- shp: [3,4]
-- flg: [1,0,0,1,0,0,0]
-- xss: [1,2,3,4,5,6,7]
-- con: [F,T,F,T,F,T,F]

  let tflgs = map (\ c -> if c then 1i32 else 0) condsL
  let fflgs = map (\ b -> 1 - b) tflgs

-- tflg: [0,1,0,1,0,1,0]
-- fflg: [1,0,1,0,1,0,1]

  let indsTL = sgmSumInt flags tflgs
-- indsT: [0,1,1,1,1,2,2]
  let tmpL   = sgmSumInt flags fflgs
-- tmp: [1,1,2,0,1,1,2]
--   let fl = map (bool.i32) flags
--   let lasts = segreduce (+) 0 (zip tflgs fl)
-- lasts: [1,2]
--   let lastsP = map2 (\ n m -> replicate n m) shp lasts
--   let inds = scanExc (+) 0 shp |> map2 (\n i->if n>0 then i else -1) shp
--   let size = ( last inds ) + ( last shp )
--   let vls = scatter (replicate size 0) inds lasts
--   let F = scatter (replicate size 0) inds shp
--   let lastsP = sgmSumInt F vls



-- lasts: [1,1,1,2,2,2,2]
--   let indsF = map2  (\l t -> l + t) lastsP tmp
-- indsF: [2,2,3,2,3,3,4]

  let lstL = map2 (\s b -> if s==0 then -1 else unsafe indsTL[b-1] ) shp begs

  -- let indsF = map (+lst) tmp
  let indsFL = map2 (\t sgmind-> t + unsafe lstL[sgmind]) tmpL outinds



-- con:   [F,T,F,T,F,T,F]
-- indsT: [0,1,1,1,1,2,2]
-- indsF: [2,2,3,2,3,3,4]
-- inds:  [1,0,2,0,2,1,3]
  let inds = map3 (\ c iT iF -> if c then iT-1 else iF-1) condsL indsTL indsFL

  let data = replicate n dummy
  let fltarr = seg_scatter shp data inds arr

  in  (lstL, (shp,fltarr))

--       = = = = = = = =
-- res: [1,2] [3,4] [2,1,3,4,6,5,7]


-----------------------
--- Parallel Filter ---
-----------------------
let partition2 [n] 't (conds: [n]bool) (dummy: t) (arr: [n]t) : (i32, [n]t) =
  let tflgs = map (\ c -> if c then 1 else 0) conds
  let fflgs = map (\ b -> 1 - b) tflgs

  let indsT = scan (+) 0 tflgs
  let tmp   = scan (+) 0 fflgs
  let lst   = if n > 0 then indsT[n-1] else -1
  let indsF = map (+lst) tmp

  let inds  = map3 (\ c indT indF -> if c then indT-1 else indF-1) conds indsT indsF

  let fltarr= scatter (replicate n dummy) inds arr
  in  (lst, fltarr)


-- patition2 main
-- ==
-- compiled input  { [3i32,4] [1i32,2,3,4,5,6,7] }
--          output { [1,2] [3,4] [2i32,1,3,4,6,5,7] }
entry main [m][n] (shp: [m]i32) (arr: [n]i32) : ([m]i32, [m]i32, [n]i32) =
    let (ps, (shp',arr')) =
        partition2L (map (\x -> (x % 2) == 0i32) arr) 0i32 (shp, arr)
    in  (ps, shp', arr')
