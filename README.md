[Bitcoin : chậm và phí mắc , sẽ không dùng bitcoin là smart contract 
Dùng Ethereum: 
Ngược lại với bitcoin, Ethereum họ định vị là siêu máy tính với smart contract 
Stack blockchain: dựa vào bitcioint,  
=> đóng gói và ghi lại , và sẽ có transition ghi lên bitcoin 
=> sẽ có 1 bảng backup 
Tận dung 
- mua nhiều để vào ví : dạng passed 
Bitcoin đổi thành 1 đồng khác => ETH 
Với Stack thì có thể đổi trực tiếp là BTC luôn 
Clarity 
Xây dựng sản phẩm trên clarity developer
Stack hiện tại có 2 quĩ lớn :  
OK coin 
Trust machine 
Smart contract là gì  
Hợp đồng thông minh 

Khi nào bạn cần hợp đồng : có 1 sự cam kết giữa 2 bên 

Ví dụ bạn đi thuê nhà : có hợp đồng , có thời hạn , có giá thuê, vi phạm sẽ bị gì đó 

 

Trong blochain y chang v , nhưng khác biệt là ko có bên nào ở giữa giải quyết,  

Vd :  

 

 

Thay vì bên thứ 3 phải đợi qui trình, đọc vô hiểu , ký vô transition, sẽ có tương tác nhiều bên 

1 triệu người vô thì cũng được luôn 

Ví dụ bạn mượn tiền của 1 ai đó thì phải kí giấy tờ , thế chấp 

 

 

 

 

 

 

 

Cài đặt clarinet 

Clarinet –version 

 

 

10^6 micro stack 

 

Địa chỉ ví 

 

 

Vào setting:  Devnet.toml 

Devnet: Tức là môi trưởng ảo chạy thử  

Ví đuôi GM, nó sẽ lấy cái ví này và deploy cái contract này 

 

 

 

Lấy địa chỉ ví chấm tới cái tên contract của bạn 

Trong contract sẽ define các function 

 

Clarinet call function smart contract stacks 

 

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation say-hello) 

 

Thường sẽ call contract , ví hiện tại là deployer luôn 

Bạn muốn nó là 1 cái ví khác: 

Câu lệnh set người call cái function này là ai  

::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 

 

Thiết lập về người giữ ví, không phải chủ smart contract nữa thì phải gọi lại cái vi đó , và thêm dấu nháy trước thì mới vào được cái hàm này 

Câu lệnh bình thường với người giữ ví: (contract-call? .donation say-hello) 

Câu với với user được chỉ định  

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation say-hello) 

 

Vì là hàm public nên mọi người mọi ví có thể call được 

 

Public function và cách gọi hàm của một contract 

 

 

Tham số : người cần đc nhận 

Số tiền cần nhận  

Thông tin mô tả 

Liên lạc 

=> người call muốn thêm 1 người muốn nhận tiền được 

(define-public (list-needer) (needer principal) (neededAmount unit) (description: (string-ascii 100) (contact: (string-ascii 100)) ) 

 

) 

 

clarinet console 

(define-public (list-needer (needer principal) (neededAmount uint) (description (string-ascii 100)) (contact (string-ascii 100)) ) 

    (begin  

      (print needer) 

      (print neededAmount) 

      (print description) 

      (print contact) 

      (ok "say hello") 

    ) 

) 

Muốn thằng địa chỉ ví cuối nhận tiền 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u1000000 "He need money" "user@gmail.com" ) 

 

 

Tiến hành đưa data vào cái map vào tiến hành lưu vào blockchain luôn 

Kiểu dữ liệu map 

Cần lưu dữ liệu này vào 1 cái data structure 

 

Mỗi address (princial) chỉ tạo nhận được donation 

 

 

 

 

(define-map ListingData principal 

        {neededAmount: uint, 

        description: (string-ascii 100), 

        contact: (string-ascii 100)} ) 

 

 

 

(define-public (list-needer (needer principal) (neededAmount uint) (description (string-ascii 100)) (contact (string-ascii 100)) ) 

    (begin  

        (map-insert ListingData needer {neededAmount: neededAmount, description: description, contact: contact }) 

        (ok needer) 

    ) 

) 

 

 

 

 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u1000000 "He need money" "user@gmail.com" ) 

 

 

Viết cái hàm và trả về data z 

 

Read-only function  

=> sẽ hông tốn phí 

 

 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u1000000 "He need money" "user@gmail.com" ) 

(contract-call? .donation get-listing 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6) 

Key của ví này có thì sẽ có dữ liệu là some 

Không có thì none 

 

Hàm donate-stx, keyword let và get 

Fds 

trước khi mình chuyển tiền phải lấy được cái neddingData của người muốn chuyển 

 

(define-public (donate-stx) (needer principal) (amount uint)) 

  ( 

    let 

      (listing (map-get? ListingData needer) 

      ) 

  ) 

 

 

Let : 

 

 

(define-public (donate-stx (needer principal) (amount uint) ) 

  (let 

      ( 

          (listing (map-get? ListingData needer)) 

      ) 

      (ok (get neededAmount listing )) 

  ) 

) 

 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u1000000 "He need money" "user@gmail.com" ) 

 

 

(contract-call? .donation donate-stx 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u100) 

(ok (some u1000000)) 

 

 

Giải thích thêm về kiểu dữ liệu tuple và keywork get 

Tuple là 1 kiểu dữ liệu  

 

Trong clarity  

1 name sẽ có field và kiểu dữ liệu của field đó. 

{neededAmount: uint, 

        receivedAmount: uint, 

        description: (string-ascii 100), 

        contact: (string-ascii 100)} ) 

 

Mỗi field sẽ có name và kiểu dữ liệu 

 

Loại dữ liệu trả về none hoặc some thì cần dùng câu lệnh wrap 

 

 

Check coi có dữ liệu không, không không trả về thằng err phần sau 

 

13/ Define- constant trong clarity 

(define-constant LISTING_NOT_FOUND (err u101)) 

 

14/ try! Và stx-transfer 

 

 

 

 

(define-public (donate-stx (needer principal) (amount uint) ) 

  (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          (neededAmountValue (get neededAmount listing)) 

          (contact (get contact listing)) 

      ) 

      (try! (stx-transfer? neededAmountValue tx-sender needer)) 

      (ok neededAmountValue) 

  ) 

) 

 

 

 

 

 

 

-======================================== 

(define-constant LISTING_NOT_FOUND (err u101)) 

 

 

(define-map ListingData principal 

        {neededAmount: uint, 

        receivedAmount: uint, 

        description: (string-ascii 100), 

        contact: (string-ascii 100)} ) 

 

 

 

(define-public (list-needer (needer principal) (neededAmount uint) (description (string-ascii 100)) (contact (string-ascii 100)) ) 

    (begin  

        (map-insert ListingData needer {neededAmount: neededAmount, receivedAmount: u0, description: description, contact: contact }) 

        (ok needer) 

    ) 

) 

 

(define-read-only (get-listing (needer principal)) 

  (begin  

    (map-get? ListingData needer) 

  ) 

) 

 

 

(define-public (donate-stx (needer principal) (amount uint) ) 

  (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          (neededAmountValue (get neededAmount listing)) 

          (contact (get contact listing)) 

      ) 

      (try! (stx-transfer? neededAmountValue tx-sender needer)) 

      (ok neededAmountValue) 

  ) 

) 

Câu lệnh call: update data hiện tại 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6  u1000000 "He  

need money" user@gmail.com) 

Câu lệnh donate: 

(contract-call? .donation donate-stx 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6  u1000000) 

 

Câu lệnh update data 

::get_assets_maps 

 

 

Thằng call cái function này , TX sender mất 1 triệu và chuyển cho thằng z6 

Tại vì đây là cái try , nếu thành công 

 

 

15/ map-set và cách cập nhật lại giá trị của một map 

 

Map-set lại giá trị , value của 1 cái key 

 

Xem cái tuple đã được thay đổi hay chưa 

 

(contract-call? .donation get-listing  'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6) 

 

Sẽ thấy received amount + thêm 1 tr 

Đổi thằng call là thằng khác, đổi thằng d6 mà donate cho thằng z6 

tx-sender switched to ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 

 

 

Kiểm tra dữ liệu được nhận  

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation get-listing  'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6) 

 
 

 

16/ Cách dùng merge để cập nhật lại giá trị của map 

 

 

 

Thay vì cách cũ là map set , có bao nhiêu field trong tuple, thì bạn sẽ set lại hết luôn 

Ví dụ nó có nhiều field nó lấy dữ liệu merge lại 

 

 

Tạo 1 listing  

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6  u1000000 "He  

need money" user@gmail.com) 

Chuyển tiền cho cái listing đó 

Chuyển 222 

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation donate-stx 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u22222) 

Sau rồi mình chuyển cái ví sang ví khác 

::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 

Dùng thằng này transfer lượng tiền lớn qua 

{"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","recipient":"STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6","amount":"1000000","memo":""}} 

GetListing mà ra 333 là đúng 

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation get-listing  'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6) 

 

 

Bài 17 / Cách dùng biến với define-data-var 

Khai báo 1 biến cho toàn bộ chương trình luôn 

(define-data-var total_listing uint u0) 

 

-------------------------------------- 

(define-public (list-needer (needer principal) (neededAmount uint) (description (string-ascii 100)) (contact (string-ascii 100)) ) 

    (begin  

        (map-insert ListingData needer { 

          neededAmount: neededAmount, receivedAmount: u0, description: description, contact: contact  

          }) 

        (var-set total_listing (+ u1 (var-get total_listing) ))   

        (ok needer) 

    ) 

) 

(contract-call? .donation list-needer 'ST2REHHS5J3CERCRBEPMGH7921Q6PYKAADT7JP2VB  u1000000 "He need money" "user@gmail.com" 

 

(contract-call? .donation get-total-listing) 

 

 

 

 

18/ Control flow và error handling, keyword asserts 

 

 

Từ trước đến giờ , khi viết begin  và let thì nó sẽ chạy từ trên xuống dưới 

1 cách nữa dùng asserts! Để gọi bắt lỗi 

 

. Tự donate cho chính bản thân thì throw exception 

 

Nếu mà thẳng call trùng với needer luôn => báo lỗi không được 

(define-public (donate-stx (needer principal) (amount uint) ) 

 

  (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          (neededAmountValue (get neededAmount listing)) 

          (contact (get contact listing)) 

          (description (get description listing)) 

          (currentReceiveAmount (get receivedAmount listing)) 

      ) 

      

      (try! (stx-transfer? neededAmountValue tx-sender needer)) 

      (map-set ListingData needer (merge  

        listing { receivedAmount: (+ amount currentReceiveAmount) } 

      )) 

(define-public (donate-stx (needer principal) (amount uint) ) 

 

  (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          (neededAmountValue (get neededAmount listing)) 

          (contact (get contact listing)) 

          (description (get description listing)) 

          (currentReceiveAmount (get receivedAmount listing)) 

      ) 

      

      (try! (stx-transfer? neededAmountValue tx-sender needer)) 

      (map-set ListingData needer (merge  

        listing { receivedAmount: (+ amount currentReceiveAmount) } 

      )) 

----------------------------- 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6  u1000000 "He  

need money" user@gmail.com) 

::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.donation donate-stx 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 u111111) 

 

  

 

Nếu đúng thì thực hiện cái bên dưới , sai thì throw ra lỗi 

 

 

 

Section 4 : Bài tập tự luyện 

Bài 19: Bài tập viết tính năng upvote,downvote 

Cho phép user upvote hoặc downvote 1 cái list 

Cái nào trông có vẻ thiệt thì nó upvate để ủng hộ còn downvote để ngta phản đối tính năng đó 

 

Bài 20/ Tạo map ListingVotes 

;; {listing-needer, voter } => {is_upvote} 

;;  listing-needer : tuc la key nguoi vote cho cai map 

;; vote : tuc la nguoi vote 

;; is_update => true 

;; is_update => false 

 

(define-map ListingVotes { listing-needer: principal, voter: principal } 

                         { is_upvote: bool, comment: (string-ascii 100)} 

) 

Bài 21: function vote-listing 

;;Todo:  viet function upvote,downvote 

(define-public (vote-listing (needer principal) (vote bool) (comment (string-ascii 100)) ) 

 (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          ;; if vote true ++vote 

      ) 

    (asserts! (map-set ListingVotes {listing-needer: needer, voter: tx-sender} {is_upvote: vote, comment: comment}) YOU_ALREADY_VOTE_FOR_THIS_LISTING )  

    ;; todo update map listingData 

    (ok needer) 

  ) 

 

) 

 

 

Bài 22: Chạy hàm vote-listing 

Tạo list needer 

(contract-call? .donation list-needer 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6  u1000000 "He need money" user@gmail.com) 
 

(contract-call? .donation vote-listing 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 true "I can confirm he needs money") 

 

Chưa có hàm get listing vote 

 

(define-read-only (get-listing-vote (needer principal) (voter principal))  

  (begin   

    (map-get? ListingVotes {listing-needer: needer, voter: voter})  

  )  

)  

 

>> (contract-call? .donation get-listing-vote  'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)  

(some (tuple (comment "I can confirm he needs money") (is_upvote true))) 

>> 

Bài 23: Viết hàm upvote, keyword unwrap-panic 

Viết hàm upvote và downvote để cập nhật lại cái ListingData map này 

Sài key word mới là unwrap-panic để lấy được dữ liệu mới  

sdf 

 

 

 

 

 

sdsd 

 

 

====================== 

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

 

;;Todo:  viet function upvote,downvote 

(define-public (vote-listing (needer principal) (vote bool) (comment (string-ascii 100)) ) 

 (let 

      ( 

          (listing (unwrap! (map-get? ListingData needer) LISTING_NOT_FOUND )) 

          ;; if vote true ++vote 

      ) 

    (asserts! (map-set ListingVotes {listing-needer: needer, voter: tx-sender} {is_upvote: vote, comment: comment}) YOU_ALREADY_VOTE_FOR_THIS_LISTING )  

    ;; todo update map listingData 

    (ok needer) 

  ) 

 

) 

 

(define-read-only (get-listing (needer principal)) 

  (begin  

    (map-get? ListingData needer) 

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

 
](https://explorer.hiro.so/sandbox/contract-call/ST000000000000000000002AMW42H.pox-3?chain=testnet)https://explorer.hiro.so/sandbox/contract-call/ST000000000000000000002AMW42H.pox-3?chain=testnet
