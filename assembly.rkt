#lang racket

(require redex)

(define-language AssemblyL
  (v ::= b n)
  (b ::= true false)
  (n ::= natural)
  (x ::= variable-not-otherwise-mentioned)
  (op ::= + or and (push v) pop (load x) (store x))
  (stk ::= (v ...)) ;; stack
  (l ::= (x v)) ;; location
  (m ::= (l ...)) ;; memory
  (prog ::= (op ...))
  (type ::= nat bool)
  (stkt ::= (type ...))
  (state ::= (m stk prog))
  (a ::= (x type)) ;; assoc
  (gamma ::= (a ...))
  )


(define ->e
  (reduction-relation AssemblyL
                      #:domain state
                      #:codomain state
                      (--> (m (v_1 v ...) (pop op ...)) (m (v ...) (op ...)))
                      (--> (m (v_1 v_2 v ...) (+ op ...)) (m (,(+ (term v_1) (term v_2))  v ...) (op ...)))
                      (--> ((l ...) (v_1 v ...) ((store x_1) op ...)) (((x_1 v_1) l ...) (v ...) (op ...)))
                      (--> ((l_1 ... (x_1 v_1) l_2 ...) (v ...) ((load x_1) op ...)) ((l_1 ... (x_1 v_1) l_2 ...) (v_1 v ...) (op ...)))
                      (--> (m (v_1 v ...) (pop op ...)) (m (v ...) (op ...)))
                      (--> (m (v ...) ((push v_1) op ...)) (m (v_1 v ...) (op ...)))
                      (--> (m (b_1 b_2 v ...) (or op ...)) (m (,(or (term b_1) (term b_2)) v ...) (op ...)))
                      (--> (m (b_1 b_2 v ...) (and op ...)) (m (,(and (term b_1) (term b_2)) v ...) (op ...)))
                      ))


(define-judgment-form AssemblyL
  #:mode     (types    I   I    I         O) ;; para funcionar as coisas quando chama judgment holds - o que é entrada e saída
  #:contract (types gamma stkt (op ...) stkt) ;; o que é esperado em cada entrada
  [
   -----------------------------------------------------"T-empty"
   (types gamma stkt () stkt)
   ]
  [
   (types gamma (nat type ...) (op ...) stkt)
   --------------------------------------------------------"T-plus"
   (types gamma (nat nat type ...) (+ op ...) stkt)
   ]

  [
   (types gamma (bool type ...) (op ...) stkt)
   -----------------------------------------------------"T-or"
   (types gamma (bool bool type ...) (or op ...) stkt)
   ]

  [
   -----------------------------------------------------"T-and"
   (types gamma (bool bool type ...) and (bool type ...))
   ]

  [
   (tyval v type_1)
   (types gamma (type_1 type ...) (op ...) stkt)
   ----------------------------------------------------------"T-push"
   (types gamma (type ...) ((push v) op ...) stkt)
   ]

  [
   (types ((x type_1) a ...) (type ...) (op ...) stkt)
   ---------------------------------------------------------------"T-store"
   (types (a ...) (type_1 type ...) ((store x) op ...) stkt)
   ]

  [
   (types (a_1 ... a_2 ...) (type_1 type ...) (op ...) stkt)
   -----------------------------------------------------------------------"T-load"
   (types (a_1 ... (x type_1) a_2 ...) (type ...) ((load x) op ...) stkt)
   ]
  )

(define-judgment-form AssemblyL
  #:mode     (tyval  I   O )
  #:contract (tyval  v type)
  [
   -----------------------------------------------------"T-nat"
   (tyval n nat)
   ]

  [
   -----------------------------------------------------"T-bool"
   (tyval b bool)
   ]
  )
;; (define (types? e)
;;   (not (null? (judgment-holds (types () (nat nat) + stkt)
;;                               stkt)))) ;; output


;; (judgment-holds (types () (nat nat ) + stkt)
;;                             stkt)

;; (traces ->e (term (((x 10) (y 12) (z 13)) (10 11) (pop))))

;; (traces ->e (term (() (true false) (or))))

;; (redex-match AssemblyL m (term ((y 2))))

;; push 10
;; store x
;; push 20
;; store y
;; load x
;; load y
;; +
