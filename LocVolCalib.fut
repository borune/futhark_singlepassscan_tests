let tridagPar [n] (a:  [n]f32, b: [n]f32, c: [n]f32, y: [n]f32 ): *[n]f32 =
  #[unsafe]
  ----------------------------------------------------
  -- Recurrence 1: b[i] = b[i] - a[i]*c[i-1]/b[i-1] --
  --   solved by scan with 2x2 matrix mult operator --
  ----------------------------------------------------
  let b0   = b[0]
  let mats = map  (\(i: i32): (f32,f32,f32,f32)  ->
                     if 0 < i
                     then (b[i], 0.0-a[i]*c[i-1], 1.0, 0.0)
                     else (1.0,  0.0,             0.0, 1.0))
                  (iota n)
  let scmt = scan (\(a0,a1,a2,a3) (b0,b1,b2,b3) ->
                     let value = 1.0/(a0*b0)
                     in ( (b0*a0 + b1*a2)*value,
                          (b0*a1 + b1*a3)*value,
                          (b2*a0 + b3*a2)*value,
                          (b2*a1 + b3*a3)*value))
                  (1.0,  0.0, 0.0, 1.0) mats
  let b    = map (\(t0,t1,t2,t3) ->
                    (t0*b0 + t1) / (t2*b0 + t3))
                 scmt
  ------------------------------------------------------
  -- Recurrence 2: y[i] = y[i] - (a[i]/b[i-1])*y[i-1] --
  --   solved by scan with linear func comp operator  --
  ------------------------------------------------------
  let y0   = y[0]
  let lfuns= map  (\(i: i32): (f32,f32)  ->
                     if 0 < i
                     then (y[i], 0.0-a[i]/b[i-1])
                     else (0.0,  1.0))
                  (iota n)
  let cfuns= scan (\(a: (f32,f32)) (b: (f32,f32)): (f32,f32)  ->
                     let (a0,a1) = a
                     let (b0,b1) = b
                     in ( b0 + b1*a0, a1*b1 ))
                  (0.0, 1.0) lfuns
  let y    = map (\(tup: (f32,f32)): f32  ->
                    let (a,b) = tup
                    in a + b*y0)
                 cfuns
  ------------------------------------------------------
  -- Recurrence 3: backward recurrence solved via     --
  --             scan with linear func comp operator  --
  ------------------------------------------------------
  let yn   = y[n-1]/b[n-1]
  let lfuns= map (\(k: i32): (f32,f32)  ->
                    let i = n-k-1
                    in  if   0 < k
                        then (y[i]/b[i], 0.0-c[i]/b[i])
                        else (0.0,       1.0))
                 (iota n)
  let cfuns= scan (\(a: (f32,f32)) (b: (f32,f32)): (f32,f32)  ->
                     let (a0,a1) = a
                     let (b0,b1) = b
                     in (b0 + b1*a0, a1*b1))
                  (0.0, 1.0) lfuns
  let y    = map (\(tup: (f32,f32)): f32  ->
                    let (a,b) = tup
                    in a + b*yn)
                 cfuns
  let y    = map (\i -> y[n-i-1]) (iota n)
  in y

-- ==
-- entry: tridagPar_f32
-- random input { [1000000]f32 [1000000]f32 [1000000]f32 [1000000]f32 } auto output
entry tridagPar_f32 (a: []f32, b: []f32, c: []f32, y: []f32) =
  tridagPar_f32 (a,b,c,y)
