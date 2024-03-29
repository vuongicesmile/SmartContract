;; smae implements tract
(use-trait sip-010 .sip-010ft.sip010-ft-trait)




(define-constant LISTING_NOT_FOUND (err u101)) 

(define-constant CAN_NOT_DONATE_YOURSELF (err u102)) 

(define-constant YOU_ALREADY_VOTE_FOR_THIS_LISTING (err u103)) 

(define-data-var total_listing uint u0) 


;; Todo: them 1 map listingVotes 
;; {listing-needer, voter } => {is_upvote} 

;;  listing-needer : tuc la key nguoi vote cho cai map 

;; vote : tuc la nguoi vote 

;; is_update => true 

;; is_update => false 

 

(define-map ListingVotes { listing-needer: principal, voter: principal } 

                         { is_upvote: bool, comment: (string-ascii 100)} 

) 


(define-map ListingData principal 

        {neededAmount: uint, 

        receivedAmount: uint, 

        description: (string-ascii 100), 

        contact: (string-ascii 100), 

        ;; Todo: them updateVotecount,downvote count 

        upVoteCount: uint, 

        downVoteCount: uint 

        } 

  ) 

(define-public (list-needer (needer principal) (neededAmount uint) (description (string-ascii 100)) (contact (string-ascii 100)) ) 

    (begin  

    ;; Todo: update new fields for listing data map 


        (map-insert ListingData needer { 

          neededAmount: neededAmount, receivedAmount: u0, description: description, contact: contact ,  

          upVoteCount: u0, downVoteCount: u0 

          }) 

        (var-set total_listing (+ u1 (var-get total_listing) ))   

        (ok needer) 

    ) 

) 

 



(define-public (vote-listing (needer principal) (vote bool) (comment (string-ascii 100)) ) 
 (let 
      ( 
          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 
          ;; if vote true ++vote 
      ) 
    (asserts! (map-insert ListingVotes {listing-needer: needer, voter: tx-sender} {is_upvote: vote, comment: comment}) YOU_ALREADY_VOTE_FOR_THIS_LISTING )  
    ;; todo update map listingData 
    ;; if 
    (if vote 
        (ok (upvote needer)) 
        (ok (downvote needer)) 
    )    
  ) 
) 

;;Todo:  viet function upvote,downvote 
(define-private (upvote (needer principal)) 
;; update cai listing data
      (map-set ListingData needer 
      (merge (unwrap-panic (map-get? ListingData needer)) 
      { upVoteCount: (+ u1
      (get upVoteCount (unwrap-panic (map-get? ListingData needer)))
      
      )} 
      ))
)

(define-private (downvote (needer principal)) 
;; update cai listing data
      (map-set ListingData needer 
      (merge (unwrap-panic (map-get? ListingData needer)) 
      { downVoteCount: (+ u1
      (get downVoteCount (unwrap-panic (map-get? ListingData needer)))
      )} 
      ))
)


(define-read-only (get-listing (needer principal)) 
  (begin  
    (map-get? ListingData needer) 
  ) 
) 

(define-read-only (get-listing-vote (needer principal) (voter principal)) 
  (begin  
    (map-get? ListingVotes {listing-needer: needer, voter: voter}) 
  ) 
) 

 

(define-read-only (get-total-listing) 

  (var-get total_listing) 

) 

 

 

(define-public (donate-stx (needer principal) (amount uint) ) 

 

  (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          (neededAmountValue (get neededAmount listing)) 

          (contact (get contact listing)) 

          (description (get description listing)) 

          (currentReceiveAmount (get receivedAmount listing)) 

      ) 

     (asserts! (not (is-eq tx-sender needer)) CAN_NOT_DONATE_YOURSELF) 

      (try! (stx-transfer? neededAmountValue tx-sender needer)) 

      (map-set ListingData needer (merge  

        listing { receivedAmount: (+ amount currentReceiveAmount) } 

      )) 
      ;; (map-set ListingData needer { 

      ;;     neededAmount: neededAmountValue, receivedAmount: (+ amount currentReceiveAmount), description: description, contact: contact  

      ;; }) 

      (ok neededAmountValue) 

  ) 

) 
;; TODO: Create custom token: DT (Donation Token)
(define-public (donate-dt (sipcontract <sip-010>) (needer principal) (amount uint)) 
  (contract-call? sipcontract transfer amount tx-sender needer none)
)

;; TODO: Create custom token: DT (Donation Token)
;; Create Donation NFT
;; Donate by DT token and Donation NFT


  (define-public (say-hello) 
    (ok "hello world")
  )