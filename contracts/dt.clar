(impl-trait .sip-010ft.sip010-ft-trait)

;;error constants
(define-constant ERR_NOT_OWNER (err u404))

;;constants
(define-constant name "DT TOKEN")
(define-constant symbol "DT")
(define-constant decimals u6)
(define-constant owner tx-sender)

(define-fungible-token DT u100000000)

;;read-only functions
(define-read-only (get-name)
  (ok name)
)

(define-read-only (get-symbol)
  (ok symbol)
)

(define-read-only (get-decimals)
  (ok decimals)
)

(define-read-only (get-balance (sender principal))
  (ok (ft-get-balance DT sender))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply DT))
)

(define-read-only (get-token-uri)
  (ok none)
)

;; public functions
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (try! (ft-transfer? DT amount sender recipient))
        (match memo to-print (print to-print) 0x)
        (ok true)
    )
)

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender owner) ERR_NOT_OWNER)
        (ft-mint? DT amount recipient)
    )
)