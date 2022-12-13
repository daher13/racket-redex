#lang racket

(require redex)

(define-language RegexL
  (ch ::= string)
  (n ::= natural)
  (x ::= natural)
  (y ::= natural)
  (p ::= natural)
  (i ::= (char ch) (split x y) (jmp x))
  (op ::= (i n))
  (input ::= (ch ...))
  (ilist ::= (op ...))
  (state ::= (ilist input p))
  )

(define ->e
  (reduction-relation RegexL
                      #:domain state
                      #:codomain state
                      (--> ((op_1 ... ((char ch_1) p_1) op_2 ...) (ch_1 ch ...) p_1) ((op_1 ... ((char ch_1) p_1) op_2 ...) (ch ...) ,(add1 (term p_1))))
                      (--> ((op_1 ... ((jmp x_1) p_1) op_2 ...) input p_1) ((op_1 ... ((jmp x_1) p_1) op_2 ...) input x_1))
                      (--> ((op_1 ... ((split x_1 y_1) p_1) op_2 ...) input p_1) ((op_1 ... ((split x_1 y_1) p_1) op_2 ...) input x_1))
                      (--> ((op_1 ... ((split x_1 y_1) p_1) op_2 ...) input p_1) ((op_1 ... ((split x_1 y_1) p_1) op_2 ...) input y_1))
                      ))

;; (traces ->e (term ((((char "a") 0) ((split 0 2) 1) ((char "b") 2) ((split 2 4) 3)) ("b" "b" "b" "b" "c") 0)))

(provide (all-defined-out))
