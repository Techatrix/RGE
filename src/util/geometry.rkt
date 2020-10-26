#lang racket

(require "structures.rkt")

(provide (all-defined-out))

(define (rect-get-points rect)
  (define a (car rect))
  (define b (cadr rect))
  (values
   (min (vec2-x a) (vec2-x b))
   (max (vec2-x a) (vec2-x b))
   (min (vec2-y a) (vec2-y b))
   (max (vec2-y a) (vec2-y b))))

; point inside circle?
(define (point-in-circle? point circle-pos circle-r)
  (< (vec2-dist point circle-pos) circle-r))

; point inside rectangle?
(define (point-in-rectangle? point rect-pos rect-size)
  (define-values (px py rx1 ry1 rx2 ry2)
    (values
     (vec2-x point)
     (vec2-y point)
     (vec2-x rect-pos)
     (vec2-y rect-pos)
     (+ (vec2-x rect-pos) (vec2-x rect-size))
     (+ (vec2-y rect-pos) (vec2-y rect-size))))

  (define x? (and (> px rx1) (< px rx2)))
  (define y? (and (> py ry1) (< py ry2)))
  
  (and x? y?))

; line <-> circle intersect
(define (line-circle-intersect? circle-pos circle-r p1 p2)
  (define-values (x0 y0) (values (vec2-x circle-pos) (vec2-y circle-pos)))
  (define-values (x1 y1 x2 y2) (values (vec2-x p1) (vec2-y p1) (vec2-x p2) (vec2-y p2)))
  
  (cond [(vec2-eq? p1 p2) #f]
        [else
         (define-values (x0 y0) (values (vec2-x circle-pos) (vec2-y circle-pos)))
         (define dx (- x2 x1))
         (define dy (- y2 y1))

         ; if dx == 0 -> a != 0, b = 0, c = x1||x2
         ; if dy == 0 -> a = 0, b != 0, c = y1||y2

         (define-values (a b c)
           (cond [(zero? dx) (values 1 0 (- x1))]
                 [(zero? dy) (values 0 1 (- y1))]
                 [else
                  (define m (/ dy dx))
                  (define n (- y1 (* m x1)))
                  
                  (values (- m) 1 (- n))]))

         (define z (+ (* a a) (* b b)))
         (define x3 (/ (- (* b (- (*    b x0)  (* a y0))) (* a c)) z))
         (define y3 (/ (- (* a (+ (* (- b) x0) (* a y0))) (* b c)) z))
         
         (define dist (vec2-dist circle-pos (vec2 x3 y3)))
         (define r (cond [(not (zero? dx)) (/ (- x3 x1) dx)]
                         [else (/ (- y3 y1) dy)]))

         (and (< dist circle-r)
              (<= r 1)
              (>= r -1))]))

; rectangle <-> circle intersect
(define (rect-circle-intersect? rect-pos rect-size circle-pos circle-r)
  (define x (vec2 (vec2-x rect-size) 0))
  (define y (vec2 0 (vec2-y rect-size)))
  (define A rect-pos)
  (define B (vec2-add rect-pos x))
  (define C (vec2-add (vec2-add rect-pos x) y))
  (define D (vec2-add rect-pos y))
  (or (point-in-rectangle? circle-pos rect-pos rect-size)
      (line-circle-intersect? circle-pos circle-r A B)
      (line-circle-intersect? circle-pos circle-r B C)
      (line-circle-intersect? circle-pos circle-r C D)
      (line-circle-intersect? circle-pos circle-r D A)
      ))
