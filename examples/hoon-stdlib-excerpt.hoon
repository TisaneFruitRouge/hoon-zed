::
::::    /sys/hoon                                       ::
  ::                                                    ::
=<  ride
=>  %136  =>
::                                                      ::
::::    0: version stub                                 ::
  ::                                                    ::
~%  %k.136  ~  ~                                        ::
|%
++  hoon-version  +
--  =>
~%  %one  +  ~
::    layer-1
::
::  basic mathematical operations
|%
::    unsigned arithmetic
+|  %math
++  add
  ~/  %add
  ::    unsigned addition
  ::
  ::  a: augend
  ::  b: addend
  |=  [a=@ b=@]
  ::  sum
  ^-  @
  ?:  =(0 a)  b
  $(a (dec a), b +(b))
::
++  dec
  ~/  %dec
  ::    unsigned decrement by one.
  |=  a=@
  ~_  leaf+"decrement-underflow"
  ?<  =(0 a)
  =+  b=0
  ::  decremented integer
  |-  ^-  @
  ?:  =(a +(b))  b
  $(b +(b))
::
++  div
  ~/  %div
  ::    unsigned divide
  ::
  ::  a: dividend
  ::  b: divisor
  |:  [a=`@`1 b=`@`1]
  ::  quotient
  ^-  @
  -:(dvr a b)
::
++  dvr
  ~/  %dvr
  ::    unsigned divide with remainder
  ::
  ::  a: dividend
  ::  b: divisor
  |:  [a=`@`1 b=`@`1]
  ::  p: quotient
  ::  q: remainder
  ^-  [p=@ q=@]
  ~_  leaf+"divide-by-zero"
  ?<  =(0 b)
  =+  c=0
  |-
  ?:  (lth a b)  [c a]
  $(a (sub a b), c +(c))
::
++  gte
  ~/  %gte
  ::    unsigned greater than or equals
  ::
  ::  returns whether {a >= b}.
  ::
  ::  a: left hand operand (todo: name)
  ::  b: right hand operand
  |=  [a=@ b=@]
  ::  greater than or equal to?
  ^-  ?
  !(lth a b)
::
++  gth
  ~/  %gth
  ::    unsigned greater than
  ::
  ::  returns whether {a > b}
  ::
  ::  a: left hand operand (todo: name)
  ::  b: right hand operand
  |=  [a=@ b=@]
  ::  greater than?
  ^-  ?
  !(lte a b)
::
++  lte
  ~/  %lte
  ::    unsigned less than or equals
  ::
  ::  returns whether {a <= b}.
  ::
  ::  a: left hand operand (todo: name)
  ::  b: right hand operand
  |=  [a=@ b=@]
  ::  less than or equal to?
  |(=(a b) (lth a b))
::
++  lth
  ~/  %lth
  ::    unsigned less than
  ::
  ::  a: left hand operand (todo: name)
  ::  b: right hand operand
  |=  [a=@ b=@]
  ::  less than?
  ^-  ?
  ?&  !=(a b)
      |-
      ?|  =(0 a)
          ?&  !=(0 b)
              $(a (dec a), b (dec b))
  ==  ==  ==
::
++  max
  ~/  %max
  ::    unsigned maximum
  |=  [a=@ b=@]
  ::  the maximum
  ^-  @
  ?:  (gth a b)  a
  b
::
++  min
  ~/  %min
  ::    unsigned minimum
  |=  [a=@ b=@]
  ::  the minimum
  ^-  @
  ?:  (lth a b)  a
  b
::
++  mod
  ~/  %mod
  ::    unsigned modulus
  ::
  ::  a: dividend
  ::  b: divisor
  |:  [a=`@`1 b=`@`1]
  ::  the remainder
  ^-  @
  +:(dvr a b)
::
++  mul
  ~/  %mul
  ::    unsigned multiplication
  ::
  ::  a: multiplicand
  ::  b: multiplier
  |:  [a=`@`1 b=`@`1]
  ::  product
  ^-  @
  =+  c=0
  |-
  ?:  =(0 a)  c
  $(a (dec a), c (add b c))
::
++  sub
  ~/  %sub
  ::    unsigned subtraction
  ::
  ::  a: minuend
  ::  b: subtrahend
  |=  [a=@ b=@]
  ~_  leaf+"subtract-underflow"
  ::  difference
  ^-  @
  ?:  =(0 b)  a
  $(a (dec a), b (dec b))
::
::    tree addressing
+|  %tree
++  cap
  ~/  %cap
  ::    tree head
  ::
  ::  tests whether an `a` is in the head or tail of a noun. produces %2 if it
  ::  is within the head, or %3 if it is within the tail.
  |=  a=@
  ^-  ?(%2 %3)
  ?-  a
    %2        %2
    %3        %3
    ?(%0 %1)  !!
    *         $(a (div a 2))
  ==
::
++  mas
  ~/  %mas
  ::    axis within head/tail
  ::
  ::  computes the axis of `a` within either the head or tail of a noun
  ::  (depends whether `a` lies within the head or tail).
  |=  a=@
  ^-  @
  ?-  a
    ?(%2 %3)  1
    ?(%0 %1)  !!
    *         (add (mod a 2) (mul $(a (div a 2)) 2))
  ==
::
++  peg
  ~/  %peg
  ::    axis within axis
  ::
  ::  computes the axis of {b} within axis {a}.
  |=  [a=@ b=@]
  ?<  =(0 a)
  ?<  =(0 b)
  ::  a composed axis
  ^-  @
  ?-  b
    %1  a
    %2  (mul a 2)
    %3  +((mul a 2))
    *   (add (mod b 2) (mul $(b (div b 2)) 2))
  ==
::
::  #  %containers
::
::    the most basic of data types
+|  %containers
::
+$  bite
  ::    atom slice specifier
  ::
  $@(bloq [=bloq =step])
::
+$  bloq
  ::    blocksize
  ::
  ::  a blocksize is the power of 2 size of an atom. ie, 3 is a byte as 2^3 is
  ::  8 bits.
  @
::
++  each
  |$  [this that]
  ::    either {a} or {b}, defaulting to {a}.
  ::
  ::  mold generator: produces a discriminated fork between two types,
  ::  defaulting to {a}.
  ::
  $%  [%| p=that]
      [%& p=this]
  ==
::
+$  gate
  ::    function
  ::
  ::  a core with one arm, `$`--the empty name--which transforms a sample noun
  ::  into a product noun. If used dryly as a type, the subject must have a
  ::  sample type of `*`.
  $-(* *)
::
++  list
  |$  [item]
  ::    null-terminated list
  ::
  ::  mold generator: produces a mold of a null-terminated list of the
  ::  homogeneous type {a}.
  ::
  $@(~ [i=item t=(list item)])
::
++  lone
  |$  [item]
  ::    single item tuple
  ::
  ::  mold generator: puts the face of `p` on the passed in mold.
  ::
  p=item
::
++  lest
  |$  [item]
  ::    null-terminated non-empty list
  ::
  ::  mold generator: produces a mold of a null-terminated list of the
  ::  homogeneous type {a} with at least one element.
  [i=item t=(list item)]
::
+$  mold
  ::    normalizing gate
  ::
  ::  a gate that accepts any noun, and validates its shape, producing the
  ::  input if it fits or a default value if it doesn't.
  ::
  ::  examples: * @ud ,[p=time q=?(%a %b)]
  $~(* $-(* *))
::
++  pair
  |$  [head tail]
  ::    dual tuple
  ::
  ::  mold generator: produces a tuple of the two types passed in.
  ::
  ::  a: first type, labeled {p}
  ::  b: second type, labeled {q}
  ::
  [p=head q=tail]
::
++  pole
  |$  [item]
  ::    faceless list
  ::
  ::  like ++list, but without the faces {i} and {t}.
  ::
  $@(~ [item (pole item)])
::
++  qual
  |$  [first second third fourth]
  ::    quadruple tuple
  ::
  ::  mold generator: produces a tuple of the four types passed in.
  ::
  [p=first q=second r=third s=fourth]
::
++  quip
  |$  [item state]
  ::    pair of list of first and second
  ::
  ::  a common pattern in hoon code is to return a ++list of changes, along with
  ::  a new state.
  ::
  ::  a: type of list item
  ::  b: type of returned state
  ::
  [(list item) state]
::
++  step
  ::    atom size or offset, in bloqs
  ::
  _`@u`1
::
++  trap
  |$  [product]
  ::    a core with one arm `$`
  ::
  _|?($:product)
::
++  tree
  |$  [node]
  ::    tree mold generator
  ::
  ::  a `++tree` can be empty, or contain a node of a type and
  ::  left/right sub `++tree` of the same type. pretty-printed with `{}`.
  ::
  $@(~ [n=node l=(tree node) r=(tree node)])
::
++  trel
  |$  [first second third]
  ::    triple tuple
  ::
  ::  mold generator: produces a tuple of the three types passed in.
  ::
  [p=first q=second r=third]
::
++  unit
  |$  [item]
  ::    maybe
  ::
  ::  mold generator: either `~` or `[~ u=a]` where `a` is the
  ::  type that was passed in.
  ::
  $@(~ [~ u=item])
--  =>
::
~%  %two  +  ~
::    layer-2
::
|%
::    2a: unit logic
+|  %unit-logc
::
++  biff                                                ::  apply
  |*  [a=(unit) b=$-(* (unit))]
  ?~  a  ~
  (b u.a)
::
++  bind                                                ::  argue
  |*  [a=(unit) b=gate]
  ?~  a  ~
  [~ u=(b u.a)]
::
++  bond                                                ::  replace
  |*  a=(trap)
  |*  b=(unit)
  ?~  b  $:a
  u.b
::
++  both                                                ::  all the above
  |*  [a=(unit) b=(unit)]
  ?~  a  ~
  ?~  b  ~
  [~ u=[u.a u.b]]
::
++  clap                                                ::  combine
  |*  [a=(unit) b=(unit) c=_=>(~ |=(^ +<-))]
  ?~  a  b
  ?~  b  a
  [~ u=(c u.a u.b)]
::
++  clef                                                ::  compose
  |*  [a=(unit) b=(unit) c=_=>(~ |=(^ `+<-))]
  ?~  a  ~
  ?~  b  ~
  (c u.a u.b)
::
++  drop                                                ::  enlist
  |*  a=(unit)
  ?~  a  ~
  [i=u.a t=~]
::
++  fall                                                ::  default
  |*  [a=(unit) b=*]
  ?~(a b u.a)
::
++  flit                                                ::  make filter
  |*  a=$-(* ?)
  |*  b=*
  ?.((a b) ~ [~ u=b])
::
++  hunt                                                ::  first of units
  |*  [ord=$-(^ ?) a=(unit) b=(unit)]
  ^-  %-  unit
      $?  _?>(?=(^ a) u.a)
          _?>(?=(^ b) u.b)
      ==
  ?~  a  b
  ?~  b  a
  ?:((ord u.a u.b) a b)
::
++  lift                                                ::  lift mold (fmap)
  |*  a=mold                                            ::  flipped
  |*  b=(unit)                                          ::  curried
  (bind b a)                                            ::  bind
::
++  mate                                                ::  choose
  |*  [a=(unit) b=(unit)]
  ?~  b  a
  ?~  a  b
  ?.(=(u.a u.b) ~>(%mean.'mate' !!) a)
::
++  need                                                ::  demand
  ~/  %need
  |*  a=(unit)
  ?~  a  ~>(%mean.'need' !!)
  u.a
::
++  some                                                ::  lift (pure)
  |*  a=*
  [~ u=a]
::
::    2b: list logic
+|  %list-logic
::  +snoc: append an element to the end of a list
::
++  snoc
  |*  [a=(list) b=*]
  (weld a ^+(a [b]~))
::
::  +lure: List pURE
++  lure
  |*  a=*
  [i=a t=~]
::
++  fand                                                ::  all indices
  ~/  %fand
  |=  [nedl=(list) hstk=(list)]
  =|  i=@ud
  =|  fnd=(list @ud)
  |-  ^+  fnd
  =+  [n=nedl h=hstk]
  |-
  ?:  |(?=(~ n) ?=(~ h))
    (flop fnd)
  ?:  =(i.n i.h)
    ?~  t.n
      ^$(i +(i), hstk +.hstk, fnd [i fnd])
    $(n t.n, h t.h)
  ^$(i +(i), hstk +.hstk)
::
++  find                                                ::  first index
  ~/  %find
  |=  [nedl=(list) hstk=(list)]
  =|  i=@ud
  |-   ^-  (unit @ud)
  =+  [n=nedl h=hstk]
  |-
  ?:  |(?=(~ n) ?=(~ h))
     ~
  ?:  =(i.n i.h)
    ?~  t.n
      `i
    $(n t.n, h t.h)
  ^$(i +(i), hstk +.hstk)
::
++  flop                                                ::  reverse
  ~/  %flop
  |*  a=(list)
  =>  .(a (homo a))
  ^+  a
  =+  b=`_a`~
  |-
  ?~  a  b
  $(a t.a, b [i.a b])
::
++  gulf                                                ::  range inclusive
  |=  [a=@ b=@]
  ?>  (lte a b)
  |-  ^-  (list @)
  ?:(=(a +(b)) ~ [a $(a +(a))])
::
++  homo                                                ::  homogenize
  |*  a=(list)
  ^+  =<  $
    |@  ++  $  ?:(*? ~ [i=(snag 0 a) t=$])
    --
  a
::  +join: construct a new list, placing .sep between every pair in .lit
::
++  join
  |*  [sep=* lit=(list)]
  =.  sep  `_?>(?=(^ lit) i.lit)`sep
  ?~  lit  ~
  =|  out=(list _?>(?=(^ lit) i.lit))
  |-  ^+  out
  ?~  t.lit
    (flop [i.lit out])
  $(out [sep i.lit out], lit t.lit)
::
::  +bake: convert wet gate to dry gate by specifying argument mold
::
++  bake
  |*  [f=gate a=mold]
  |=  arg=a
  (f arg)
::
++  lent                                                ::  length
  ~/  %lent
  |=  a=(list)
  ^-  @
  =+  b=0
  |-
  ?~  a  b
  $(a t.a, b +(b))
::
++  levy
  ~/  %levy                                             ::  all of
  |*  [a=(list) b=$-(* ?)]
  |-  ^-  ?
  ?~  a  &
  ?.  (b i.a)  |
  $(a t.a)
::
++  lien                                                ::  some of
  ~/  %lien
  |*  [a=(list) b=$-(* ?)]
  |-  ^-  ?
  ?~  a  |
  ?:  (b i.a)  &
  $(a t.a)
::
++  limo                                                ::  listify
  |*  a=*
  ^+  =<  $
    |@  ++  $  ?~(a ~ ?:(*? [i=-.a t=$] $(a +.a)))
    --
  a
::
++  murn                                                ::  maybe transform
  ~/  %murn
  |*  [a=(list) b=$-(* (unit))]
  =>  .(a (homo a))
  |-  ^-  (list _?>(?=(^ a) (need (b i.a))))
  ?~  a  ~
  =/  c  (b i.a)
  ?~  c  $(a t.a)
  [+.c $(a t.a)]
::
++  oust                                                ::  remove
  ~/  %oust
  |*  [[a=@ b=@] c=(list)]
  (weld (scag +<-< c) (slag (add +<-< +<->) c))
::
++  reap                                                ::  replicate
  ~/  %reap
  |*  [a=@ b=*]
  |-  ^-  (list _b)
  ?~  a  ~
  [b $(a (dec a))]
::
++  rear                                                ::  last item of list
  ~/  %rear
  |*  a=(list)
  ^-  _?>(?=(^ a) i.a)
  ?>  ?=(^ a)
  ?:  =(~ t.a)  i.a  ::NOTE  avoiding tmi
  $(a t.a)
::
++  reel                                                ::  right fold
  ~/  %reel
  |*  [a=(list) b=_=>(~ |=([* *] +<+))]
  |-  ^+  ,.+<+.b
  ?~  a
    +<+.b
  (b i.a $(a t.a))
::
++  roll                                                ::  left fold
  ~/  %roll
  |*  [a=(list) b=_=>(~ |=([* *] +<+))]
  |-  ^+  ,.+<+.b
  ?~  a
    +<+.b
  $(a t.a, b b(+<+ (b i.a +<+.b)))
::
++  scag                                                ::  prefix
  ~/  %scag
  |*  [a=@ b=(list)]
  |-  ^+  b
  ?:  |(?=(~ b) =(0 a))  ~
  [i.b $(b t.b, a (dec a))]
::
++  skid                                                ::  separate
  ~/  %skid
  |*  [a=(list) b=$-(* ?)]
  |-  ^+  [p=a q=a]
  ?~  a  [~ ~]
  =+  c=$(a t.a)
  ?:((b i.a) [[i.a p.c] q.c] [p.c [i.a q.c]])
::
++  skim                                                ::  only
  ~/  %skim
  |*  [a=(list) b=$-(* ?)]
  |-
  ^+  a
  ?~  a  ~
  ?:((b i.a) [i.a $(a t.a)] $(a t.a))
::
++  skip                                                ::  except
  ~/  %skip
  |*  [a=(list) b=$-(* ?)]
  |-
  ^+  a
  ?~  a  ~
  ?:((b i.a) $(a t.a) [i.a $(a t.a)])
::
++  slag                                                ::  suffix
  ~/  %slag
  |*  [a=@ b=(list)]
  |-  ^+  b
  ?:  =(0 a)  b
  ?~  b  ~
  $(b t.b, a (dec a))
::
++  snag                                                ::  index
  ~/  %snag
  |*  [a=@ b=(list)]
  |-  ^+  ?>(?=(^ b) i.b)
  ?~  b
    ~_  leaf+"snag-fail"
    !!
  ?:  =(0 a)  i.b
  $(b t.b, a (dec a))
::
++  snip                                                ::  drop tail off list
  ~/  %snip
  |*  a=(list)
  ^+  a
  ?~  a  ~
  ?:  =(~ t.a)  ~
  [i.a $(a t.a)]
::
++  sort  !.                                            ::  quicksort
  ~/  %sort
  |*  [a=(list) b=$-([* *] ?)]
  =>  .(a ^.(homo a))
  |-  ^+  a
  ?~  a  ~
  =+  s=(skid t.a |:(c=i.a (b c i.a)))
  %+  weld
    $(a p.s)
  ^+  t.a
  [i.a $(a q.s)]
::
++  spin                                                ::  stateful turn
  ::
  ::  a: list
  ::  b: state
  ::  c: gate from list-item and state to product and new state
  ~/  %spin
  |*  [a=(list) b=* c=_|=(^ [** +<+])]
  =>  .(c `$-([_?>(?=(^ a) i.a) _b] [_-:(c) _b])`c)
  =/  acc=(list _-:(c))  ~
  ::  transformed list and updated state
  |-  ^-  (pair _acc _b)
  ?~  a
    [(flop acc) b]
  =^  res  b  (c i.a b)
  $(acc [res acc], a t.a)
::
++  spun                                                ::  internal spin
  ::
  ::  a: list
  ::  b: gate from list-item and state to product and new state
  ~/  %spun
  |*  [a=(list) b=_|=(^ [** +<+])]
  ::  transformed list
  p:(spin a +<+.b b)
::
++  swag                                                ::  slice
  |*  [[a=@ b=@] c=(list)]
  (scag +<-> (slag +<-< c))
::  +turn: transform each value of list :a using the function :b
::
++  turn
  ~/  %turn
  |*  [a=(list) b=gate]
  =>  .(a (homo a))
  ^-  (list _?>(?=(^ a) (b i.a)))
  |-
  ?~  a  ~
  [i=(b i.a) t=$(a t.a)]
::
++  weld                                                ::  concatenate
  ~/  %weld
  |*  [a=(list) b=(list)]
  =>  .(a ^.(homo a), b ^.(homo b))
  |-  ^+  b
  ?~  a  b
  [i.a $(a t.a)]
::
++  snap                                               ::  replace item
  ~/  %snap
  |*  [a=(list) b=@ c=*]
  ^+  a
  (weld (scag b a) [c (slag +(b) a)])
::
++  into                                               ::  insert item
  ~/  %into
  |*  [a=(list) b=@ c=*]
  ^+  a
  (weld (scag b a) [c (slag b a)])
::
++  welp                                                ::  faceless weld
  ~/  %welp
  |*  [* *]
  ?~  +<-
    +<-(. +<+)
  +<-(+ $(+<- +<->))
::
++  zing                                                ::  promote
  ~/  %zing
  |*  *
  ?~  +<
    +<
  (welp +<- $(+< +<+))
::
::    2c: bit arithmetic
+|  %bit-arithmetic
::
++  bex                                                 ::  binary exponent
  ~/  %bex
  |=  a=bloq
  ^-  @
  ?:  =(0 a)  1
  (mul 2 $(a (dec a)))
::
++  can                                                 ::  assemble
  ~/  %can
  |=  [a=bloq b=(list [p=step q=@])]
  ^-  @
  ?~  b  0
  (add (end [a p.i.b] q.i.b) (lsh [a p.i.b] $(b t.b)))
::
++  cat                                                 ::  concatenate
  ~/  %cat
  |=  [a=bloq b=@ c=@]
  (add (lsh [a (met a b)] c) b)
::
++  cut                                                 ::  slice
  ~/  %cut
  |=  [a=bloq [b=step c=step] d=@]
  (end [a c] (rsh [a b] d))
::
++  end                                                 ::  tail
  ~/  %end
  |=  [a=bite b=@]
  =/  [=bloq =step]  ?^(a a [a *step])
  (mod b (bex (mul (bex bloq) step)))
::
