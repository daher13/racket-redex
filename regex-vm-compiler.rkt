#lang racket

(require redex)
(require rackcheck)

(require "./regex-vm-processor.rkt")

(define-language RegexL
  (ch ::= "a" "b" "c")
  (n ::= natural)
  (p ::= natural)
  (x ::= natural)
  (y ::= natural)
  (i ::= ch "*" "?" "+" "|")
  (op ::= (i n))
  (input ::= (op ...))
  (vm ::= (char ch) (split x y) (jmp x))
  (vmlist ::= (vm ...))
  (state ::= (vmlist input))
  )

(define ->c
  (reduction-relation RegexL
                      #:domain state
                      #:codomain state
                      (--> ((vm ...) ((ch_1 n_1) (ch_2 n_2) op ...)) ((vm ... (char ch_1)) ((ch_2 n_2) op ...)))
                      (--> ((vm ...) ((ch_1 n))) ((vm ... (char ch_1)) ()))
                      (--> ((vm ...) ((ch_1 n_1) ("*" n_2) op ...)) (( vm ... (split n_2 ,(add1 (term n_2))) (char ch_1) (jmp n_1)) (op ...)))
                      (--> ((vm ...) ((ch_1 n_1) ("?" n_2) op ...)) (( vm ... (split n_1 n_2) (char ch_1)) (op ...)))
                      (--> ((vm ...) ((ch_1 n_1) ("+" n_2) op ...)) (( vm ... (char ch_1) (split n_1  ,(add1 (term n_2))   ) ) (op ...)))
                      (--> ((vm ...) ((ch_1 n_1) ("|" n_2) (ch_3 n_3) op ...)) ((vm ... (split n_1 n_3) (char ch_1) (jmp n_3) (char ch_3)) (op ...)))
                      ))

;; (traces ->c (term (() (("a" 0) ("+" 1) ("b" 2) ("+" 3)))))

(define (list-to-input i p o)
  (if (not (equal? p (length i)))
      (list-to-input i (add1 p) (append o (list (list (string (list-ref i p)) p))))
      o
      ))
  

(define (string->input s)
  (list-to-input (string->list s) 0 '()))

(define (cgen:letter)
  (gen:choice (gen:const #\a) (gen:const #\b) (gen:const #\c)))
  
(define (cgen:symbol)
  (gen:tuple (cgen:letter) (gen:choice (gen:const #\+) (gen:const #\*) (gen:const #\?))))

(define (cgen:or)
  (gen:tuple (cgen:letter) (gen:const #\|) (cgen:letter)))

(define (cgen:input n)
  (cond
    [(zero? n) (gen:choice (cgen:letter) (cgen:symbol) (cgen:or))]
    [else (gen:let ([e (cgen:input (sub1 n))])
                   e)]
    ))
  
;; (list->string (car (sample (cgen:input 5) 1)))

(sample (cgen:input 4) 1)

;; (string->input "a+b+a|a")

;; (traces ->e (term ,(string->input "a+b+a|a")))
