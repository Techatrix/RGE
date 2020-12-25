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

; line <-> circle intersections
(define (line-circle-intersections circle-pos circle-r p1 p2)
  (define delta (vec2-sub p2 p1))
  (define A (vec2-sum (vec2-pow2 delta)))
  (define B (* 2 (vec2-sum (vec2-mult delta (vec2-sub p1 circle-pos)))))
  (define C (- (vec2-sum (vec2-pow2 (vec2-sub p1 circle-pos)))
               (* circle-r circle-r)))
  (define det (- (* B B) (* 4 A C)))
  
  (cond [(or (<= A 0.0000001) (< det 0)) (values #f #f)]
        [(zero? det)
         (define t (/ (- B) (+ A A)))
         (values (vec2-add p1 (vec2-scalar delta t)) #f)]
        [else
         (define t1 (/ (- (sqrt det) B) (+ A A)))
         (define t2 (/ (- (- (sqrt det)) B) (+ A A)))
         (values (vec2-add p1 (vec2-scalar delta t1))
                 (vec2-add p1 (vec2-scalar delta t2)))]))

; rectangle <-> circle intersect
(define (rect-circle-intersect? rect-pos rect-size circle-pos circle-r)
  (define A rect-pos)
  (define B (vec2-add rect-pos (vec2 (vec2-x rect-size) 0)))
  (define C (vec2-add rect-pos (vec2 0 (vec2-y rect-size))))
  (define D (vec2-add rect-pos rect-size))

  (define (intersect? p1 p2)
    (define-values (ip1 ip2) (line-circle-intersections circle-pos circle-r p1 p2))
    (or (and (vec2? ip1)
             (<= (vec2-x p1) (vec2-x ip1) (vec2-x p2))
             (<= (vec2-y p1) (vec2-y ip1) (vec2-y p2)))
        (and (vec2? ip2)
             (<= (vec2-x p1) (vec2-x ip2) (vec2-x p2))
             (<= (vec2-y p1) (vec2-y ip2) (vec2-y p2)))))
  
  (or (point-in-rectangle? circle-pos rect-pos rect-size)
      (intersect? A B)
      (intersect? B D)
      (intersect? C D)
      (intersect? A C)))
