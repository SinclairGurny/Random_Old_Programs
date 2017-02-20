#lang racket/gui
;; Battleship AI

;;TODO
;;add strip on bottom that displays (mode and current boat, which boats havent been placed, etc.)
;;AI find longest strip of open squares and divide into smallest
;;  If hit radiate and finish boat
;;AI modes reduce, radiate

;; Basic Functions and Macros
(define-syntax printc
  (syntax-rules ()
    ((_ arg ...) (begin (begin (display arg)(display " ")) ... (newline)))))

(define (get-coor x y)
  (list (/ (- x (modulo x 30)) 30) (modulo (/ (- y (modulo y 30)) 30) 10) (if (< y 300) 0 1)))

(define (onGrid coor)
  (if [foldl (lambda [x y] (and (and (>= x 0) (< x 10)) y)) #t coor]
      #t #f))

(define (vfindf proc v)
  (if (not (vector? v)) #f
      (let ([len (vector-length v)])
        (if (= len 0) #f (let loop ([index 1][value (vector-ref v 0)])
                           (if [proc value] value (if [= index len] #f (loop [+ index 1][vector-ref v index]))))))))
        
(define (between c1 c2)
  (when [and (pair? c1) (pair? c2)]
    (cond ([= (second c1) (second c2)]
           (let ([x1 (first c1)][x2 (first c2)][y (second c1)])
             (append-map (lambda [x] (list (list x y))) (range (min x1 x2) (+ 1 (max x1 x2))))))
          ([= (first c1) (first c2)]
           (let ([y1 (second c1)][y2 (second c2)][x (first c1)])
             (append-map (lambda [y] (list (list x y))) (range (min y1 y2) (+ 1 (max y1 y2)))))))))

(define (assoc-v-index ls val)
  (let ([len (vector-length ls)])
    (if [= len 0] #f (let loop ([n 0]) (if [equal? (car (vector-ref ls n)) val] n (if [= (+ n 1) len] #f (loop [+ n 1])))))))

(define (isCollision ls boat-ls)
  (if [or (vfindf (lambda [boat] (let ([bet (between (second boat) (third boat))])
                               (if [not (void? bet)] (findf (lambda [c] (member c bet)) ls) #f))) boat-ls)
           (findf (lambda [hi] (not (onGrid hi))) ls)]
      #t #f))

(define (shoot coor player)
  (match player
    ['P (if [assoc coor attackP] #f (set! attackP (append attackP (list (list coor (if [member coor attackP] #f (isHit coor boatHealthA player)))))))]
    ['A (if [assoc coor attackA] #f (set! attackA (append attackA (list (list coor (if [member coor attackA] #f (isHit coor boatHealthP player)))))))]))


(define (isHit coor boat-health player)
  (let loop ([index 0])
    (if [< index (vector-length boat-health)]
        (let ([boat (vector-ref boat-health index)])
          (if [findf (lambda [x] (equal? x coor)) (cdr boat)]
              (begin
                (set! boat (remove coor boat))
                (when [= 1 (length boat)] (sunk player (car boat)))
                (vector-set! boat-health index boat)
                #t)
              (loop (add1 index))))
        #f)))

(define (sunk player id)
  (let ([boat (match id
                [2 "Destroyer"]
                [3 "Cruiser"]
                [13 "Submarine"]
                [4 "Battleship"]
                [5 "Aircraft Carrier"])])
    (match player
      ['A (printc "My" boat "was sunk")]
      ['P (printc "You sunk my" boat)])))

(define (done boat-health)
  (foldl (lambda (x y) (and x y)) #t (vector->list (vector-map (lambda [x] (= 1 (length x))) boat-health))))
    

;;
(define (reset-boat-ls) (list->vector (map (lambda [x] (list x '() '())) '(2 3 13 4 5))))
(define (reset-boat-health boat-ls)
  (vector-map (lambda [boat] (append (list (car boat)) (between (second boat) (third boat)))) boat-ls))

;;Game Variables and Constants
(define attackP '());attack grid for player
(define attackA '());            for AI

(define boatsP (reset-boat-ls));player's boats (id start end)
(define boatsA (reset-boat-ls));AI's boats
(define boatHealthP #f)
(define boatHealthA #f)

(define boat-colors '((2 "Gainsboro") (3 "LightGray") (13 "Silver") (4 "Gray") (5 "DarkGray")))
(define prevBoat '())
(define currBoat -1)
(define orientation #t);true is horizontal, false if vertical

(define attacking #f);true when game has started, after setup of boats
(define mode 0)
;possibly change to 0-setup, 1-game loop, 2-winner

(define highlighted '())


;;AI Functions and Macros
(define (randomize-ships)
  (let ([new (lambda [] (list (random 10) (random 10)))]
        [admissable (lambda [c-ls bs] (and (not (isCollision c-ls bs))
                                           (not (findf (lambda [c] (not (onGrid c))) c-ls))))]
        [second-new (lambda [c id] (if [= (modulo (random 10) 2) 0]
                                       (list (+ (first c) (sub1 (modulo id 10))) (second c))
                                       (list (first c) (+ (second c) (sub1 (modulo id 10))))))])
    (let loop ([boatsI (vector 2 3 13 4 5)][boatsF (vector)][coor1 (new)])
      (if [> (vector-length boatsI) 0]
          (let ([coor2 (second-new coor1 (vector-ref boatsI 0))])
            (if [admissable (between coor1 coor2) boatsF]
                (loop [vector-drop boatsI 1][vector-append boatsF (vector (list (vector-ref boatsI 0) coor1 coor2))][new])
                (loop boatsI boatsF (new))))
          boatsF))))

(define (end-set-up)
  (set! boatHealthP (reset-boat-health boatsP))
  (set! attacking #t)
  (set! currBoat -1)
  (set! prevBoat '())
  (set! highlighted '()))

(define (AI-set-up)
  (set! boatsA (randomize-ships))
  (set! boatHealthA (reset-boat-health boatsA)))

(define (attack ls);random attack
  (let loop ([coor (list (random 10) (random 10))])
    (if [not (findf (lambda [x] (equal? coor (car x))) ls)]
        coor
        (loop [list (random 10) (random 10)]))))

;; GUI and Prmary Game Loops

(define (canvas-paint)
  (lambda [canvas dc]
    (send dc set-pen "white" 0 'transparent)
    (send dc set-brush "blue" 'solid)
    (send dc draw-rectangle 0 0 300 300)
    (send dc set-brush "black" 'solid)
    (send dc draw-rectangle 0 300 300 300)
    
    ;boats
    (send dc set-pen "white" 0 'transparent)
    (vector-map
     (lambda [boat]
       (let ([start (second boat)][end (third boat)])
         (send dc set-brush (second (findf (lambda [y] (equal? (first boat) (first y))) boat-colors)) 'solid)
         (when (and (pair? start) (pair? end))
           (map (lambda [bc] (send dc draw-rectangle (* 30 (first bc)) (+ (* 30 (second bc)) 300) 30 30)) (between start end)))))
     boatsP)
    
    ;hits/misses
    (send dc set-pen "white" 0 'transparent)
    (send dc set-brush "red" 'solid)
    (map (lambda [shot] (when [second shot] (send dc draw-ellipse (+ (* 30 (first (car shot))) 10) (+ (* 30 (second (car shot))) 10) 10 10))) attackP)
    (map (lambda [shot] (when [second shot] (send dc draw-ellipse (+ (* 30 (first (car shot))) 10) (+ (* 30 (second (car shot))) 310) 10 10))) attackA)
    (send dc set-brush "lightgray" 'solid)
    (map (lambda [shot] (when [not (second shot)] (send dc draw-ellipse (+ (* 30 (first (car shot))) 10) (+ (* 30 (second (car shot))) 10) 10 10))) attackP)
    (map (lambda [shot] (when [not (second shot)] (send dc draw-ellipse (+ (* 30 (first (car shot))) 10) (+ (* 30 (second (car shot))) 310) 10 10))) attackA)
    
    ;selected
    (send dc set-pen "white" 0 'transparent)
    (send dc set-brush "yellow" 'solid)
    (map (lambda [x] (send dc draw-rectangle (* 30 (first x)) (+ (* 30 (second x)) 300) 30 30)) highlighted)
    
    ;gridlines
    (send dc set-pen "white" 1 'solid)
    (send dc set-brush "white" 'transparent)
    (do ([i 0 (+ i 1)]) ([= i 10])
      (do ([j 0 (+ j 1)]) ([= j 10])
        (send dc draw-rectangle (* 30 j) (* 30 i) 30 30)
        (send dc draw-rectangle (* 30 j) (+ (* 30 i) 300) 30 30)))))

(define my-canvas%
  (class canvas%
    (define/override (on-event event)
      (match (send event get-event-type)
        ['left-up (if [not attacking]
                 (when [and (not (equal? currBoat -1)) (pair? highlighted)]
                   (vector-set! boatsP (assoc-v-index boatsP currBoat) (list currBoat (first highlighted) (last highlighted)))
                   (set! prevBoat (append (list currBoat) prevBoat)))
                 
                 (let ([coor (get-coor (send event get-x) (send event get-y))])
                   (when [equal? (third coor) 0]
                     (let ([s (shoot (take coor 2) 'P)]);;;;;;;;;;;;;
                       (when s
                         (if [done boatHealthA]
                             (begin
                               (printc "You Win!")
                               (send this on-paint))
                             (begin
                               (shoot (attack attackA) 'A)
                               (when [done boatHealthP]
                                 (printc "You Lose!"))
                               (send this on-paint))))))))]
        ['right-up (when [not attacking] (set! orientation (not orientation)))]
        ['motion (when [and (not attacking) (> currBoat 0)]
               (let ([coor (get-coor (send event get-x) (send event get-y))])
                 (let ([mouseX (first coor)] [mouseY (second coor)])
                   (if orientation
                       (set! highlighted (between (list mouseX mouseY) (list (+ mouseX (sub1 (modulo currBoat 10))) mouseY)))
                       (set! highlighted (between (list mouseX mouseY) (list mouseX (+ mouseY (sub1 (modulo currBoat 10)))))))
                   (when [isCollision highlighted boatsP]
                     (set! highlighted '())))))]
        [_ #f])
      (send this on-paint))
    
    (define/override (on-char event)
      (let ([key (send event get-key-code)])
        ;(printc "Keyboard:" key)
        (when [not attacking]
          (match key
            [#\1 (set! currBoat 2)]
            ['numpad1 (set! currBoat 2)]
            [#\2 (set! currBoat 3)]
            ['numpad2 (set! currBoat 3)]
            [#\3 (set! currBoat 13)]
            ['numpad3 (set! currBoat 13)]
            [#\4 (set! currBoat 4)]
            ['numpad4 (set! currBoat 4)]
            [#\5 (set! currBoat 5)]
            ['numpad5 (set! currBoat 5)]
            
            [#\return (when [and (not attacking) (vfindf (lambda [boat] (and (pair? (second boat)) (pair? (third boat)))) boatsP)]
                        (printc "Starting Game")
                        (end-set-up)
                        (send this on-paint)
                        (AI-set-up))]
            [#\backspace (when [pair? prevBoat]
                           (set! currBoat (first prevBoat))
                           (set! prevBoat (cdr prevBoat))
                           (vector-set! boatsP (assoc-v-index boatsP currBoat) (list currBoat '() '())))]
            [_ #f]))
          (match key
            [#\r (printc "RESET")
                 (set! highlighted '())
                 (set! attackP '())
                 (set! attackA '())
                 (set! boatsP (reset-boat-ls))
                 (set! boatsA (reset-boat-ls))
                 (set! prevBoat '())
                 (set! currBoat -1)
                 (set! orientation #t)
                 (set! attacking #f);;0
                 (send this on-paint)]
           [_ #f])
          
          (when [> currBoat 0];rehighlights on mouse pos
            (define-values [point _] (get-current-mouse-state))
            (letrec ([mouseCoor (get-coor (- (send point get-x) (send f get-x)) (- (send point get-y) (+ (send f get-y) 30)))]
                     [mouseX (first mouseCoor)]
                     [mouseY (second mouseCoor)]);change (list mX mY) to take or other fn
              (if orientation
                  (set! highlighted (between (list mouseX mouseY) (list (+ mouseX (- (modulo currBoat 10) 1)) mouseY)))
                  (set! highlighted (between (list mouseX mouseY) (list mouseX (+ mouseY (- (modulo currBoat 10) 1))))))
              (when (isCollision highlighted boatsP)
                (set! highlighted '()))
              (when [findf (lambda [highCoor] (or (>= (first highCoor) 10) (>= (second highCoor) 10))) highlighted]
                (set! highlighted '()))))
          (send this on-paint)))
    
    (super-new)))

(define f (new frame% [label "Battleship"][width 306][height 628][x 300][y 30][style '(no-resize-border)]))
(define c (new my-canvas% [parent f][paint-callback (canvas-paint)]))

(send f show #t)

;;Print Instructions to console
(printc "Place all five of your ships")
(printc "Select which ship using 1-5, sorted by increasing size")
(printc "Click to place")
(printc "Right click to rotate")
(printc "Esc to undo")
(printc "Once all boats are placed, press Enter to start")