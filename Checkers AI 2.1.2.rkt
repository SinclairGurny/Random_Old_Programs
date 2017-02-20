#lang racket
(require racket/gui)
;;; Checkers AI 2.1 ;;;
;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;; checkers ;;
(define squares '((1 0)(3 0)(5 0)(7 0)
                  (0 1)(2 1)(4 1)(6 1)
                  (1 2)(3 2)(5 2)(7 2)
                  (0 3)(2 3)(4 3)(6 3)
                  (1 4)(3 4)(5 4)(7 4)
                  (0 5)(2 5)(4 5)(6 5)
                  (1 6)(3 6)(5 6)(7 6)
                  (0 7)(2 7)(4 7)(6 7)))

(define red-checkers '((6 7 #f)(4 7 #f)(2 7 #f)(0 7 #f)
                       (7 6 #f)(5 6 #f)(3 6 #f)(1 6 #f)
                       (6 5 #f)(4 5 #f)(2 5 #f)(0 5 #f)))
(define ai-checkers '((1 0 #f)(3 0 #f)(5 0 #f)(7 0 #f)
                      (0 1 #f)(2 1 #f)(4 1 #f)(6 1 #f)
                      (1 2 #f)(3 2 #f)(5 2 #f)(7 2 #f)))

(define isOnAI #t)

(define selected '())
(define canStop #t)
(define isSelected #f)
(define move-ls '())
(define redTurn #t)

(define canDisplay #f)

;; macros ;;
(define-syntax printc
  (syntax-rules ()
    ((_ arg ...) (begin (begin (display arg)(display " ")) ... (newline)))))

(define (now) (call/cc (lambda (cc) (cc cc))))

(define-syntax set-item!
  (syntax-rules ()
    ((_ ls n val) (let ([return (now)])
                    (if (procedure? return)
                        (begin
                          (cond [(not (pair? ls)) (return #f)]
                                [(or (< n 0) (>= n (length ls))) (return #f)])
                          (let loop ([i n][v (car ls)][prev '()][next (cdr ls)])
                            (if (= i 0)
                                (return (append prev (list val) next))
                                (loop [- i 1][car next][append prev (list v)][cdr next]))))
                        (set! ls return))))))

(define-syntax remove-item!
  (syntax-rules ()
    ((_ ls n) (let ((return (now)))
                (if (procedure? return)
                    (begin
                      (cond [(not (pair? ls)) (return #f)]
                            [(or (< n 0) (>= n (length ls))) (return #f)])
                      (let loop ([i n][v (car ls)][prev '()][next (cdr ls)])
                        (if (= i 0)
                            (return (append prev next))
                            (loop [- i 1][car next][append prev (list v)][cdr next]))))
                    (set! ls return))))))

;; functions ;;
(define (vector-find vec val)
  (let ([n 0][ans '()])
    (for ([item vec])
      (when (= item val) (set! ans (append ans (list n))))
      (set! n (add1 n)))
    ans))

(define (member-coor ls coor)
  (let ([a (append coor '(#f))][b (append coor '(#t))])
    (or (member a ls) (member b ls))))

(define (find ls val)
  (let ((return (now)))
    (if (procedure? return)
        (begin
          (cond [(not (pair? ls)) (return #f)]
                [(or (not (pair? (car ls))) (not (pair? val))) (return #f)])
          (if (equal? (car ls) val)
              0
              (let loop ([l (cdr ls)][n 1])
                (if (pair? l) 
                    (if (equal? (car l) val)
                        (return n)
                        (if (pair? (cdr l))
                            (loop [cdr l] [+ n 1])
                            (return #f)))
                    (return #f)))))
        return)))

(define (find-coor ls val)
  (let ((return (now))
        (equal? (lambda (lst1 lst2) (if (and (eqv? (car lst1) (car lst2)) (eqv? (second lst1) (second lst2))) #t #f))))
    (if (procedure? return)
        (begin
          (cond [(not (pair? ls)) (return #f)]
                [(or (not (pair? (car ls))) (not (pair? val))) (return #f)])
          (if (equal? (car ls) val)
              0
              (let loop ([l (cdr ls)][n 1])
                (if (pair? l) 
                    (if (equal? (car l) val)
                        (return n)
                        (if (pair? (cdr l))
                            (loop [cdr l] [+ n 1])
                            (return #f)))
                    (return #f)))))
        return)))

(define (get-click-pos x y)
  (map (lambda (n) (/ (- n (modulo n 75)) 75)) (list x y)))

(define (onboard n)
  (if (and (>= n 0) (<= n 7)) #t #f))

(define (ongrid coor)
  (if coor
      (foldl (lambda (a b) (and a b)) #t (map onboard coor))
      #f))

;; ------ move functions --------
(define (isOpen coor)
    (let ([a (append coor '(#f))][b (append coor '(#t))])
            (not (or (member a red-checkers) (member b red-checkers) (member a ai-checkers) (member b ai-checkers)))))

(define (isOpen2 coor ai-checks)
  (let ([a (append coor '(#f))][b (append coor '(#t))])
            (not (or (member a red-checkers) (member b red-checkers) (member a ai-checks) (member b ai-checks)))))

(define (halfCoor scoor ecoor)
  (let ([sx (car scoor)]
        [sy (cadr scoor)]
        [ex (car ecoor)]
        [ey (cadr ecoor)])
    (list (/ (+ sx ex) 2) (/ (+ sy ey) 2))))

(define (twoApart scoor ecoor)
  (let ([a (halfCoor scoor ecoor)])
    (if (and (integer? (car a)) (integer? (cadr a))) #t #f)))

(define (find-move coor color iJ)
  (let ([x (car coor)][y (cadr coor)] [moves (list coor)])
    (when (eqv? color 'red)
      (let ([checker (list-ref red-checkers (find-coor red-checkers coor))])
        (if (third checker)
            (begin
              (if (and (isOpen (list (- x 1) (- y 1))) (ongrid (list (- x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (- y 2))) (ongrid (list (- x 2) (- y 2))) (find-coor ai-checkers (list (- x 1) (- y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (- x 2) (- y 2) #t))))
                          (set! moves (append moves (list (find-move (list (- x 2) (- y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (+ x 1) (- y 1))) (ongrid (list (+ x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (- y 2))) (ongrid (list (+ x 2) (- y 2))) (find-coor ai-checkers (list (+ x 1) (- y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (+ x 2) (- y 2) #t))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (- y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (- x 1) (+ y 1))) (ongrid (list (- x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (+ y 2))) (ongrid (list (- x 2) (+ y 2))) (find-coor ai-checkers (list (- x 1) (+ y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (- x 2) (+ y 2) #t))))
                          (set! moves (append moves (list (find-move (list (- x 2) (+ y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (+ x 1) (+ y 1))) (ongrid (list (+ x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (+ y 2))) (ongrid (list (+ x 2) (+ y 2))) (find-coor ai-checkers (list (+ x 1) (+ y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (+ x 2) (+ y 2) #t))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (+ y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f)))))))
            (begin
              (if (and (isOpen (list (- x 1) (- y 1))) (ongrid (list (- x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (- y 2))) (ongrid (list (- x 2) (- y 2))) (find-coor ai-checkers (list (- x 1) (- y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (- x 2) (- y 2) #f))))
                          (set! moves (append moves (list (find-move (list (- x 2) (- y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (+ x 1) (- y 1))) (ongrid (list (+ x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (- y 2))) (ongrid (list (+ x 2) (- y 2))) (find-coor ai-checkers (list (+ x 1) (- y 1))))
                        (begin
                          (set! red-checkers (append red-checkers (list (list (+ x 2) (- y 2) #f))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (- y 2)) 'red #t))))
                          (remove-item! red-checkers (- (length red-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (set! moves (append moves '(#f #f)))))))
    (when (eqv? color 'blue)
      (let ((checker (list-ref ai-checkers (find-coor ai-checkers coor))))
        (if (third checker)
            (begin
              (if (and (isOpen (list (+ x 1) (+ y 1))) (ongrid (list (+ x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (+ y 2))) (ongrid (list (+ x 2) (+ y 2))) (find-coor red-checkers (list (+ x 1) (+ y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (+ x 2) (+ y 2) #t))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (+ y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (- x 1) (+ y 1))) (ongrid (list (- x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (+ y 2))) (ongrid (list (- x 2) (+ y 2))) (find-coor red-checkers (list (- x 1) (+ y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (- x 2) (+ y 2) #t))))
                          (set! moves (append moves (list (find-move (list (- x 2) (+ y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (+ x 1) (- y 1))) (ongrid (list (+ x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (- y 2))) (ongrid (list (+ x 2) (- y 2))) (find-coor red-checkers (list (+ x 1) (- y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (+ x 2) (- y 2) #t))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (- y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (- x 1) (- y 1))) (ongrid (list (- x 1) (- y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (- y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (- y 2))) (ongrid (list (- x 2) (- y 2))) (find-coor red-checkers (list (- x 1) (- y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (- x 2) (- y 2) #t))))
                          (set! moves (append moves (list (find-move (list (- x 2) (- y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f)))))))
            (begin
              (if (and (isOpen (list (+ x 1) (+ y 1))) (ongrid (list (+ x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (+ x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (+ x 2) (+ y 2))) (ongrid (list (+ x 2) (+ y 2))) (find-coor red-checkers (list (+ x 1) (+ y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (+ x 2) (+ y 2) #f))))
                          (set! moves (append moves (list (find-move (list (+ x 2) (+ y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (if (and (isOpen (list (- x 1) (+ y 1))) (ongrid (list (- x 1) (+ y 1))) (not iJ))
                  (set! moves (append moves (list (list (list (- x 1) (+ y 1)) #f #f #f #f))))
                  (begin
                    (if (and (isOpen (list (- x 2) (+ y 2))) (ongrid (list (- x 2) (+ y 2))) (find-coor red-checkers (list (- x 1) (+ y 1))))
                        (begin
                          (set! ai-checkers (append ai-checkers (list (list (- x 2) (+ y 2) #f))))
                          (set! moves (append moves (list (find-move (list (- x 2) (+ y 2)) 'blue #t))))
                          (remove-item! ai-checkers (- (length ai-checkers) 1)))
                        (set! moves (append moves '(#f))))))
              (set! moves (append moves '(#f #f)))))))
    (let ([jm #f][start (car moves)])
      (do ((i 1(+ i 1)))((> i 4))
        (when (list-ref moves i)
          (when (twoApart start (car (list-ref moves i)))
            (set! jm #t))))
      (when jm
        (do ((i 1(+ i 1)))((> i 4))
          (when (list-ref moves i)
            (when (not (twoApart start (car (list-ref moves i))))
              (set-item! moves i #f))))))
    moves))
;; AI ;;

(define ai-thought '())

(define (quick-check coor)
  (let ([x (car coor)][y (cadr coor)][return (now)])
    (if (procedure? return)
        (begin
          (for ([dy '(-1 1)][dy2 '(-2 2)])
            (for ([dx '(-1 1)][dx2 '(-2 2)])
              (let ([coor1 (list (+ x dx) (+ y dy))])
                (when (ongrid coor1)
                  (let ([r1 (find-coor red-checkers coor1)]
                        [b1 (find-coor ai-checkers coor1)])
                    (if (not r1)
                        (unless b1 (return #t))
                        (let ([coor2 (list (+ x dx2) (+ y dy2))])
                          (when (ongrid coor2)
                            (unless (find-coor red-checkers coor2)
                              (unless (find-coor ai-checkers coor2)
                                (return #t)))))))))))
          (return #f))
        return)))

(define sub-list? (lambda (ls1 ls2)
                    (if (> (length ls1) (length ls2))
                        #f
                        (let loop ((a (car ls1)) (b (car ls2)) (aa (cdr ls1)) (bb (cdr ls2)))
                          (if (not (equal? a b))
                              #f
                              (if (and (pair? aa) (pair? bb))
                                  (loop (car aa) (car bb) (cdr aa) (cdr bb))
                                  #t))))))

(define (traverse l)
  (letrec ([ans '()]
           [t (lambda (l p)
                (let ((f #f))
                  (set! p (append p (list (car l))))
                  (let ([a (second l)])
                    (if a
                        (t a p)
                        (when (not f) (begin (set! f #t) (set! ans (append ans (list p)))))))
                  (let ((a (third l)))
                    (if a
                        (t a p)
                        (when (not f) (begin (set! f #t) (set! ans (append ans (list p)))))))
                  (let ((a (fourth l)))
                    (if a
                        (t a p)
                        (when (not f) (begin (set! f #t) (set! ans (append ans (list p)))))))
                  (let ((a (fifth l)))
                    (if a
                        (t a p)
                        (when (not f) (begin (set! f #t) (set! ans (append ans (list p)))))))))])
    (t l '())
    (let ([rem '()])
      (for ([node (in-list ans)])
        (when (<= (length node) 1)
          (set! rem (append rem (list node))))
        (when (equal? (cdr node) '())
          (set! rem (append rem (list node))))
        (for ([node2 (in-list ans)])
          (when (not (equal? node node2))
            (when (sub-list? node node2)
              (set! rem (append (list node)))))))
      (set! rem (append rem (list (list (caar ans)))))
      (for ([remnode (in-list rem)])
        (set! ans (remove remnode ans))))
    ans))

(define (jump-check coor isBlue isKing)
  (let ([x (car coor)][y (cadr coor)][return (now)]
        [d-ls '((-1 1) (-2 2) (-1 1) (-2 2))])
    (if (procedure? return)
        (begin
          (when (not isKing)
            (if isBlue
                (set! d-ls '((1)(2)(-1 1)(-2 2)))
                (set! d-ls '((-1)(-2)(-1 1)(-2 2)))))
          (for ([dy (in-list (first d-ls))][dy2 (in-list (second d-ls))])
            (for ([dx (in-list (third d-ls))][dx2 (in-list (fourth d-ls))])
              (let ([coor1 (list (+ x dx) (+ y dy))][coor2 (list (+ x dx2) (+ y dy2))])
                (when (and (ongrid coor1) (ongrid coor2))
                  (let ([r1 (member-coor red-checkers coor1)]
                        [b1 (member-coor ai-checkers coor1)])
                    (if isBlue
                        (when (and r1 (isOpen coor2) (ongrid coor2)) (return #t))
                        (when (and b1 (isOpen coor2) (ongrid coor2)) (return #t))))))))
          (return #f))
        return)))

(define (canBeJumped coor ai-checks)
  (let ([x (car coor)][y (cadr coor)])
    (let ([ld (list (sub1 x) (add1 y))]
          [rd (list (add1 x) (add1 y))]
          [lu (list (sub1 x) (sub1 y))]
          [ru (list (add1 x) (sub1 y))]
          [return (now)])
      (if (procedure? return)
          (begin
            (when (and (member-coor red-checkers ld) (isOpen2 ru ai-checks) (ongrid ru)) (return #t))
            (when (and (member-coor red-checkers rd) (isOpen2 lu ai-checks) (ongrid lu)) (return #t))
            (when (and (member-coor red-checkers lu) (isOpen2 rd ai-checks) (ongrid rd)) (return #t))
            (when (and (member-coor red-checkers ru) (isOpen2 ld ai-checks) (ongrid ld)) (return #t))
            (return #f))
          return))))

(define (couldBeJumped coor ai-checks)
  (let ([x (car coor)][y (cadr coor)])
    (let ([ld (list (sub1 x) (add1 y))]
          [rd (list (add1 x) (add1 y))]
          [lu (list (sub1 x) (sub1 y))]
          [ru (list (add1 x) (sub1 y))]
          [return (now)])
      (if (procedure? return)
          (begin
            (when (and (isOpen2 ld ai-checks) (ongrid ld) (isOpen2 ru ai-checks) (ongrid ru)) (return #t))
            (when (and (isOpen2 rd ai-checks) (ongrid rd) (isOpen2 lu ai-checks) (ongrid lu)) (return #t))
            (return #f))
          return))))

(define (ai-choose-move)
  (let ([possible-moves '()])
    (for ([checker ai-checkers])
      (when (quick-check checker)
        (let ([traversed-move (traverse (find-move checker 'blue #f))])
          (when (pair? traversed-move)
                 (set! possible-moves (append possible-moves traversed-move))))))
    (let ([p-m (filter (lambda (x) (twoApart (car x) (cadr x))) possible-moves)])
      (when (not (equal? p-m '()))
          (set! possible-moves p-m)))
    (define move-enum (make-vector (length possible-moves)))
    (for ([move possible-moves][n (in-range (length possible-moves))])
      (let ([enum 0][ai-checkers2 '()])
        ;;enums;;
        ;(printc "move:" move)
        (if (twoApart (car move) (cadr move))
            (begin
              ;(printc "jump")
              (set! enum (+ enum (* (sub1 (length move)) 10))))
            (when (and (< (cadar move) (cadadr move)) (not (caddar move)))
              (begin
                ;(printc "advance")
                (set! enum (+ enum  1 -1)))))
        
        (set! ai-checkers2 (append (remove (car move) ai-checkers) (list (append (last move) (list (third (car move)))))))
        (when (and (canBeJumped (car move) ai-checkers) (not (canBeJumped (last move) ai-checkers2)))
          (begin
            ;(printc "get out of jump")
            (set! enum (+ enum 10))))
        
        (when (canBeJumped (last move) ai-checkers2)
          (begin
            ;(printc "get into jump")
            (set! enum (+ enum -20))))
        
        (when (and (couldBeJumped (car move) ai-checkers)
                   (not (couldBeJumped (last move) (append ai-checkers2))))
          (begin
            ;(printc "get out of bad position")
            (set! enum (+ enum 10 -10))))
        
        (when (couldBeJumped (last move) (append (remove (car move) ai-checkers) (append (last move) (list (third (car move))))))
          (begin
            ;(printc "get into bad position")
            (set! enum (+ enum -10 10))))
        
        (if (> (count (lambda (c) (or (couldBeJumped c ai-checkers) (canBeJumped c ai-checkers))) ai-checkers)
               (count (lambda (c) (or (couldBeJumped c ai-checkers2) (canBeJumped c ai-checkers2))) ai-checkers2))
            (begin
              ;(printc "closes up bad positions")
              (set! enum (+ enum 5)))
            (begin
              ;(printc "opens up bad positions")
              (set! enum (+ enum -5))))
        
        (when (= (second (car move)) 0)
          (begin
            ;(printc "leaving back row")
            (set! enum (+ enum -25))))
        ;protect, double-jump protect, guard, 
        ;;---------------------------;;
        (vector-set! move-enum n enum)))
    (if (> (length possible-moves) 0)
        (letrec ([max (vector-argmax (lambda (x) x) move-enum)]
                 [indices (vector-find move-enum max)]
                 [final-move (list-ref indices (random (length indices)))])
          ;(printc "final move:" final-move ":" max "->" move-enum)
          (list-ref possible-moves final-move))
        #f)))

;; GUI ;;
(define my-canvas%
  (class canvas%
    (define click-count 0)
    (define/override (on-event event)
      (cond ((eqv? (send event get-event-type) 'left-up)
             (set! click-count (+ click-count 1))
             (begin
               (letrec ([coor (get-click-pos (send event get-x) (send event get-y))]
                        [red (if (find-coor red-checkers coor) #t #f)]
                        [blue (if (find-coor ai-checkers coor) #t #f)]
                        [select (if (find-coor selected coor) #t #f)]
                        [color (call/cc (lambda (cc) (begin (when red (cc 'red)) (when blue (cc 'blue)) (when select (cc 'yellow)) (cc 'other))))])
                 
                 (when (and (not isSelected) (or (and (eqv? color 'red) redTurn) (and (eqv? color 'blue) (not redTurn)))) ;start move
                       (begin
                         ;;check for jumps;;
                         (let ([ans #f][available '()][c #f][checkers (if redTurn red-checkers ai-checkers)])
                           (for ([checker (in-list checkers)])
                             (when (jump-check checker (eqv? color 'blue) (third checker)) (set! ans #t)))
                           (when ans
                             (for ([checker (in-list checkers)])
                               (when (jump-check checker (eqv? color 'blue) (third checker))
                                 (set! available (append available (list checker))))))
                           ;;
                           (set! c (member-coor available coor))
                           (when (xor (and ans c) (not (or ans c)))
                             (set! move-ls (find-move coor color #f))
                             (for ([sel (in-list (cdr move-ls))])
                               (when sel (set! selected (append selected (list (car sel))))))
                             (if (eqv? selected '())
                                 (set! isSelected #f)
                                 (set! isSelected #t))))))
                 
                 (when (and isSelected (eqv? color 'yellow)) ;end move
                       (begin
                         (letrec ([start (car move-ls)]
                                  [red (find-coor red-checkers start)]
                                  [blue (find-coor ai-checkers start)])
                           (when red
                             (if (= (second coor) 0)
                                 (set-item! red-checkers red (append coor '(#t)))
                                 (set-item! red-checkers red (append coor (list (third (list-ref red-checkers red))))))
                             (when (twoApart (car move-ls) coor) (remove-item! ai-checkers (find-coor ai-checkers (halfCoor (car move-ls) coor)))))
                           (when blue
                             (if (= (second coor) 7)
                                 (set-item! ai-checkers blue (append coor '(#t)))
                                 (set-item! ai-checkers blue (append coor (list (third (list-ref ai-checkers blue))))))
                             (when (twoApart (car move-ls) coor) (remove-item! red-checkers (find-coor red-checkers (halfCoor (car move-ls) coor)))))
                           (for ([mov (in-list (cdr move-ls))])
                             (when mov
                               (when (equal? coor (car mov))
                                 (set! move-ls mov))))
                           (set! selected '())
                           (for ([mov (in-list (cdr move-ls))])
                             (when mov
                               (set! canStop #f)
                               (set! selected (append selected (list (car mov))))))
                           (when (eqv? selected '())
                             (set! redTurn (not redTurn))
                             (set! canStop #t)
                             (set! isSelected #f))
                           ;;;
                           (when (and isOnAI (not redTurn)) ;plays AI's move
                             (begin
                               ;(let ([current-move (time (ai-choose-move))])
                               (let ([current-move (ai-choose-move)])
                                 ;(printc "ai choose: " current-move)
                                 (when current-move
                                   ;(printc "CBJ:" (canBeJumped (car current-move)) (canBeJumped (last current-move)))
                                   (if (not (twoApart (car current-move) (cadr current-move)))
                                       (begin
                                         ;(printc "ai moving")
                                         (let ([num (find-coor ai-checkers (car current-move))])
                                           (if (= (second (second current-move)) 7)
                                               (set-item! ai-checkers num (append (second current-move) '(#t)))
                                               (set-item! ai-checkers num (append (second current-move) (list (third (list-ref ai-checkers num))))))))
                                       (begin
                                         ;(printc "ai jumping")
                                         (for ([current (in-list current-move)] [rest-ls (in-list (cdr current-move))])
                                           (let ([num (find-coor ai-checkers current)])
                                             (if (= (second rest-ls) 7)
                                                 (set-item! ai-checkers num (append rest-ls '(#t)))
                                                 (set-item! ai-checkers num (append rest-ls (list (third (list-ref ai-checkers num))))))
                                             (remove-item! red-checkers (find-coor red-checkers (halfCoor current rest-ls))))))))
                                 (set! redTurn (not redTurn))))))))
                 
                 (when (and isSelected (eqv? color 'other) canStop) ;deselect possible moves
                   (set! move-ls '())
                   (set! selected '())
                   (set! isSelected #f))
                 
                 (when canDisplay
                   (begin
                     (printc "move: " move-ls)
                     (printc "parsed move: " (traverse move-ls))
                     (printc "color: " color)
                     (printc "isRedTurn: " redTurn)
                     (if isSelected (printc "isSelected") (printc "isNotSelected"))))
                 )
               (send this on-paint)))))
    (define/override (on-char event) ;reset
      (when (eqv? #\r (send event get-key-code))
        (printc "RESET")
        (set! selected '())
        (set! canStop #t)
        (set! isSelected #f)
        (set! move-ls '())
        (set! redTurn #t)
        (set! red-checkers '((6 7 #f)(4 7 #f)(2 7 #f)(0 7 #f) (7 6 #f)(5 6 #f)(3 6 #f)(1 6 #f) (6 5 #f)(4 5 #f)(2 5 #f)(0 5 #f)))
        (set! ai-checkers '((1 0 #f)(3 0 #f)(5 0 #f)(7 0 #f) (0 1 #f)(2 1 #f)(4 1 #f)(6 1 #f) (1 2 #f)(3 2 #f)(5 2 #f)(7 2 #f)))
        (send this on-paint))
      (when (eqv? #\a (send event get-key-code))
        (printc "TOGGLE AI")
        (set! isOnAI (not isOnAI))
        (set! selected '())
        (set! canStop #t)
        (set! isSelected #f)
        (set! move-ls '())
        (set! redTurn #t)
        (set! red-checkers '((6 7 #f)(4 7 #f)(2 7 #f)(0 7 #f) (7 6 #f)(5 6 #f)(3 6 #f)(1 6 #f) (6 5 #f)(4 5 #f)(2 5 #f)(0 5 #f)))
        (set! ai-checkers '((1 0 #f)(3 0 #f)(5 0 #f)(7 0 #f) (0 1 #f)(2 1 #f)(4 1 #f)(6 1 #f) (1 2 #f)(3 2 #f)(5 2 #f)(7 2 #f)))
        (send this on-paint)))
    (super-new)))

(define (canvas-paint)
  (lambda (canvas dc)
    (send dc set-pen "white" 0 'transparent)
    (do ((i 0(+ i 1))(f 1(+ f 1)))((= i 8))
      (do ((j 0(+ j 1)))((= j 8))
        (if (= (modulo f 2) 1)
            (begin (send dc set-brush "white" 'solid) (set! f 2))
            (begin (send dc set-brush "black" 'solid) (set! f 1)))
        (send dc draw-rectangle (* 75 j) (* 75 i) 75 75)))
    
    (send dc set-brush "red" 'solid)
    (when (pair? red-checkers)
      (for ([checker (in-list red-checkers)])
        (if (third checker)
            (send dc draw-rounded-rectangle (+ 5 (* 75 (car checker))) (+ 5 (* 75 (second checker))) 65 65)
            (send dc draw-ellipse (+ 5 (* 75 (car checker))) (+ 5 (* 75 (second checker))) 65 65))))
    
    (send dc set-brush "mediumblue" 'solid)
    (when (pair? ai-checkers)
      (for ([checker (in-list ai-checkers)])
        (if (third checker)
            (send dc draw-rounded-rectangle (+ 5 (* 75 (car checker))) (+ 5 (* 75 (second checker))) 65 65)
            (send dc draw-ellipse (+ 5 (* 75 (car checker))) (+ 5 (* 75 (second checker))) 65 65))))
    
    (send dc set-brush "yellow" 'solid)
    (when (pair? selected)
      (for ([sel-check selected])
        (send dc draw-ellipse (+ 30 (* 75 (car sel-check))) (+ 30 (* 75 (second sel-check))) 15 15)))))

(define f (new frame% [label "Racket Checkers GUI"][width 605][height 628][x 700][y 30][style '(no-resize-border)]))
(define c (new my-canvas% [parent f][paint-callback (canvas-paint)]))
;;start game;;
(send f show #t)