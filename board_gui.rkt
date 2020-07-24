#lang racket/gui
(require lang/posn)
(require 2htdp/image )
(provide (all-defined-out))
(require "board.rkt")
;(require "main_gui.rkt")
(define (get-coords s r c a) ; return a make -posn pair
  (make-posn (+ (* 0.5 a) (* (- c 1) a (+ 0.1 (* 0.15 (- 2 s))))) (+ (* 0.5 a) (* (- r 1) a (+ 0.1 (* 0.15 (- 2 s)))))))
;(struct posn (x y) #:transparent )
(define a 700 )
(define bg (empty-scene a a  "cyan" ))
(define p (make-pen "magenta" 8 "solid" "round" "round"))
(define sq0 (square (* 0.8 a) "outline" p )) ; sq0 gets the vertical lines as well
(define sq1 (square (* 0.5 a) "outline" p))
(define sq2 (square (* 0.2 a) "outline" p))
(set! sq0 (add-line
           (add-line
            (add-line
             (add-line sq0 (* 0.4 a) 0 (* 0.4 a) (* 0.3 a) p)
             (* 0.4 a) (* 0.5 a) (* 0.4 a) (* 0.8 a) p) 0
                                                        (* 0.4 a) (* 0.3 a) (* 0.4 a) p) (* 0.5 a) (* 0.4 a) (* 0.8 a) (* 0.4 a) p ))

(define piece%
  (class object%
    (init-field pos)
    (init-field s)
    (init-field r)
    (init-field c)
    (init-field [ color 'ud] )
    (init-field [img '()] )
    
    (super-new)

    (define/public (over-it? x y z)
      (and (<= (magnitude (- x (posn-x pos))) z) (<= (magnitude (- y (posn-y pos))) z)))))


;(define gamepieceu%
;  (class object%
;     (init-field pos)
;    (init-field s )
;    (init-field r )
;    (init-field c )
;    (define radius 30)
;    (define small 34)
;    (init-field [color "black"])
;     (init-field [img (circle radius "solid" "black")])
;    (super-new)
;    (define/public (over-it? x y)
;      (and (<= (magnitude (- x (posn-x pos))) 32) (<= (magnitude (- y (posn-y pos))) 32)))
;    (define/public (change-radius nr) (displayln "w")
;      (set! small nr))
;    (define/public (get-rad)
;      small)
;    ))

(define gamepieceu%
  (class piece%
    
    (inherit-field pos)
    (inherit-field s)
    (inherit-field r)
    (inherit-field c)
    (inherit-field img)
    (inherit-field color)
    (define radius 30)
    (define small 34)
    (super-new [color "black"] [img (circle radius "solid" "black")])
    
    (define/override (over-it? x y)
      (super over-it? x y 32))
    (define/public (change-radius nr) (displayln "w")
      (set! small nr))
    (define/public (get-rad)
      small)
    ))
;(define gamepiecec%
;  (class object%
;     (init-field pos)
;    (init-field s )
;    (init-field r )
;    (init-field c )
;    (define radius 30)
;    (init-field [color "white"])
;     (init-field [img (circle 30 "solid" "white")])
;    (super-new)
;    (define/public (over-it? x y)
;      (and (<= (magnitude (- x (posn-x pos))) 32) (<= (magnitude (- y (posn-y pos))) 32)))
;    ))

(define gamepiecec%
  (class piece%
    (inherit-field pos)
    (inherit-field s)
    (inherit-field r)
    (inherit-field c)
    (inherit-field img)
    (inherit-field color)
    (define radius 30)
    (super-new [color "white"]
               [img (circle 30 "solid" "white")])
    (define/override (over-it? x y)
      (super over-it? x y 32))
    ))

;(define cpiece (circle 30 "solid" "white"))
;(define upiece (circle 30 "solid" "black"))
;(define button%
;  (class object%
;     (init-field pos)
;    (init-field s )
;    (init-field r )
;    (init-field c )
;     (init-field [img (circle 10 "solid" "red")])
;    (super-new)
;    (define/public (over-it? x y)
;      (and (<= (magnitude (- x (posn-x pos))) 11) (<= (magnitude (- y (posn-y pos))) 11)))
;    ))

(define button%
  (class piece%
    (inherit-field pos)
    (inherit-field s)
    (inherit-field r)
    (inherit-field c)
    (inherit-field img)
    ;(inherit-field color)
    (super-new [color "red"]
               [img (circle 10 "solid" "red")])
    (define/override (over-it? x y)
      (super over-it? x y 11))
    ))
;(define t )
(set! bg (place-images (list sq0 sq1 sq2) (list  (make-posn (/ a 2) (/ a 2)) (make-posn (/ a 2) (/ a 2)) (make-posn (/ a 2) (/ a 2))) bg))
(define (red-puter) ; updates board also gives acc
  (define acc '())
  (define s 0)
  (define r 0)
  (define c 0)
  (define (nextc ) (set! c (modulo ( + c 1) 3)))
  (define (nextr ) (set! r (modulo ( + r (quotient (+ c 1) 3)) 3)))
  (define (nexts ) (set! s (modulo (+ s (quotient (+ r (quotient (+ c 1) 3)) 3)) 3)))
  (define (iter) (cond ( (and ( = s 2) (= r 2) (= c 2)) (set! acc (cons (make-object button% (get-coords s r c a) s r c) acc))   )
                       ( (and (= r 1) (= c 1)) (nexts) (nextr) (nextc) (iter))
                       (else  (set! acc (cons (make-object button% (get-coords s r c a) s r c) acc)) (nexts) (nextr) (nextc) (iter))))
  (iter)
  ;(displayln acc)
 ; (define buttons (iter))
  (set! bg (place-images (map (lambda (t) (get-field img t)) acc ) (map (lambda (t) (get-field pos t)) acc) bg))
  acc)
(define buttonlist (red-puter))
  
(define hs (empty-scene a a "white"))
;(define pic (make-object bitmap% a a))
;(send pic load-file "nnm.jpg")
(set! hs (place-image (bitmap/file "nnm.jpg") (/ a 2) (/ a 2) hs))
(define circl (circle 10 "solid" "black"))
(define ellips (ellipse 400 70 "solid" "black"))
(set! hs (place-image ellips 350 70 hs))
(define nam (text "NINE MEN'S MORRIS" 35 "white"))
(set! hs (place-image nam 350 70 hs))
(define rhom (rhombus 85 120 "solid" "black"))
(set! hs (place-images (list rhom rhom) (list (make-posn  (/ a 2) (* 0.43 a)) (make-posn  (/ a 2) (* 0.57 a))) hs))
(define single (text "SINGLE
PLAYER" 20 "white"))
(define double (text "DOUBLE
PLAYER" 20 "white"))
(set! hs (place-images (list single double) (list (make-posn  (/ a 2) (* 0.43 a)) (make-posn  (/ a 2) (* 0.57 a))) hs))