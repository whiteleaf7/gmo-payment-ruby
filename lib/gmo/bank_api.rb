# coding: utf-8

# A client for the GMO Payment API.
#
# example
# gmo = Gmo::Payment::BankAPI.new({
#   shop_id:     "foo",
#   shop_pass:   "bar",
#   host:        "mul-pay.com",
#   locale:      "ja"

# })
# result = gmo.post_request("EntryTran.idPass", options)
module Gmo
  module Payment

    module BankAPIMethods

      def initialize(options = {})
        @shop_id   = options[:shop_id]
        @shop_pass = options[:shop_pass]
        @host      = options[:host]
        @locale    = options.fetch(:locale, :en)
        unless @shop_id && @shop_pass && @host
          raise ArgumentError, "Initialize must receive a hash with :shop_id, :shop_pass and either :host! (received #{options.inspect})"
        end
      end
      attr_reader :shop_id, :shop_pass, :host, :locale

      #          API                    和名                        説明
      # EntryTranGANB.idPass       取引登録         オーダーIDを指定して取引を登録します。
      # ExecTranGANB.idPass        取引実行         登録された取引に対してバーチャル口座を発行します。
      # CancelTranGANB.idPass      取引停止         取引を停止し、バーチャル口座を削除します。
      # InquiryTransferGANB.idPass 入金履歴情報取得 指定された取引のバーチャル口座に対する入金情報を返却します。
      # SearchTradeMulti.idPass    取引状態参照     指定された取引の状態を返却します。<Paste>

      ## 2.1.取引登録
      # これ以降の決済取引で必要となる取引 ID と取引パスワードの発行を行い、取引を開始します。
      ### @param ###
      # OrderID
      # Amount
      # Tax
      ### @return ###
      # OrderID
      # AccessID
      # AccessPass
      # ErrCode
      # ErrInfo
      ### example ###
      # gmo.entry_tran_ganb({
      #   order_id: 100,
      #   amount: 10000,
      #   tax: 1000
      # })
      # {"OrderID"=>"100", "AccessID"=>"a41d83f1f4c908baeda04e6dc03e300c", "AccessPass"=>"d72eca02e28c88f98b9341a33ba46d5d"}
      def entry_tran_ganb(options = {})
        name = "EntryTranGANB.idPass"
        required = [:order_id, :amount]
        assert_required_options(required, options)
        post_request name, options
      end

      ## 2.2.取引実行
      # 振込依頼に関する情報を受け取り、バーチャル口座の口座情報を返却します。
      ### @param ###
      # AccessID
      # AccessPass
      # OrderID
      # ClientField1
      # ClientField2
      # ClientField3
      # AccountHolderOptionalName
      # TradeDays
      # TradeReason
      # TradeClientName
      # TradeClientMailaddress
      ### @return ###
      # AccessID
      # BankCode
      # BankName
      # BranchCode
      # BranchName
      # AccountType
      # AccountNumber
      # AccountHolderName
      # AvailableDate
      # ErrCode
      # ErrInfo
      ### example ###
      # gmo.exec_tran_ganb({
      #   order_id:      100,
      #   access_id:    "a41d83f1f4c908baeda04e6dc03e300c",
      #   access_pass:  "d72eca02e28c88f98b9341a33ba46d5d",
      #   trade_days:    7,
      #   client_field_1: "client_field1"
      # })
      # {"AccessID"=>"cc3b3a9da2c80da2d9da6f6ce1cf367a", "BankCode"=>"0310", "BankName"=>"ジーエムオーアオゾラネット", "BranchCode"=>"503", "BranchName"=>"郷骸竹", "AccountType"=>"1", "AccountNumber"=>"5247184", "AccountHolderName"=>"テストショップnull", "AvailableDate"=>"20191118"}
      def exec_tran_ganb(options = {})
        name = "ExecTranGANB.idPass"
        required = [:access_id, :access_pass, :order_id]
        assert_required_options(required, options)
        post_request name, options
      end

      ## 2.3.取引停止
      # 指定した取引を停止します。
      ### @param ###
      # AccessID
      # AccessPass
      # OrderID
      ### @return ###
      # OrderID
      # Status
      # ClientField1
      # ClientField2
      # ClientField3
      # TotalTransferAmount
      # TotalTransferCount
      # LatestTransferAmount
      # LatestTransferDate
      # LatestTransferName
      # LatestTransferBankName
      # LatestTransferBranchName
      # ErrCode
      # ErrInfo
      ### example ###
      # gmo.cancel_tran_ganb({
      #   order:id:      100,
      #   access_id:    "a41d83f1f4c908baeda04e6dc03e300c",
      #   access_pass:  "d72eca02e28c88f98b9341a33ba46d5d"
      # })
      # {"OrderID"=>"100", "Status"=>"STOP", "ClientField1"=>"", "ClientField2"=>"", "ClientField3"=>"", "TotalTransferAmount"=>"0", "TotalTransferCount"=>"0", "LatestTransferAmount"=>"0", "LatestTransferDate"=>"", "LatestTransferName"=>"", "LatestTransferBankName"=>"", "LatestTransferBranchName"=>""}
      def cancel_tran_ganb(options = {})
        name = "CancelTranGANB.idPass"
        required = [:access_id, :access_pass, :order_id]
        assert_required_options(required, options)
        post_request name, options
      end

      ## 2.4.入金履歴情報取得
      # 指定した取引の入金履歴情報を返却します。（最長で直近1年分を返却します）
      ### @param ###
      # AccessID
      # AccessPass
      # OrderID
      # DateFrom
      # DateTo
      ### @return ###
      # # 正常終了の場合
      # TransferDate
      # TransferName
      # TransferBankName
      # TransferBranchName
      # TransferAmount
      # (上記を1セットとした配列)
      # # 異常終了の場合
      # ErrCode
      # ErrInfo
      ### example ###
      # gmo.inquiry_transfer_ganb({
      #   order_id:      100,
      #   access_id:    "a41d83f1f4c908baeda04e6dc03e300c",
      #   access_pass:  "d72eca02e28c88f98b9341a33ba46d5d",
      #   date_from:    "20191101",
      #   date_to:      "20191130",
      # })
      # => [{"TransferDate"=>"20191111",
      #  "TransferName"=>"ADMINISTRATOR",
      #  "TarnsferBankName"=>"ﾃｽﾄｷﾞﾝｺｳ",
      #  "TradeBranchName"=>"ﾃｽﾄｼﾃﾝ",
      #  "TransferAmount"=>"1000"},
      # {"TransferDate"=>"20191111",
      #  "TransferName"=>"ADMINISTRATOR",
      #  "TarnsferBankName"=>"ﾃｽﾄｷﾞﾝｺｳ",
      #  "TradeBranchName"=>"ﾃｽﾄｼﾃﾝ",
      #  "TransferAmount"=>"2000"}]
      def inquiry_transfer_ganb(options = {})
        name = "InquiryTransferGANB.idPass"
        required = [:access_id, :access_pass, :order_id]
        assert_required_options(required, options)
        post_request name, options
      end

      # 2.5.取引状態参照
      # 指定したオーダーIDの取引情報を取得します。
      ### @params ###
      # OrderID
      ### @return ###
      # Status
      # ProcessDate
      # AccessID
      # AccessPass
      # Amount
      # Tax
      # ClientField1
      # ClientField2
      # ClientField3
      # PayType
      # GanbBankCode
      # GanbBankName
      # GanbBranchCode
      # GanbBranchName
      # GanbAccountType
      # GanbAccountNumber
      # GanbAccountHolderName
      # GanbExpireDays
      # GanbExpireDate
      # GanbTradeReason
      # GanbTradeClientName
      # GanbTotalTransferAmount
      # GanbTotalTransferCount
      # GanbLatestTransferAmount
      # GanbLatestTransferDate
      # GanbLatestTransferName
      # GanbLatestTransferBankName
      # ErrCode
      # ErrInfo
      ### example ###
      # gmo.search_trade_multi({
      #   order_id: 100
      # })
      # {"Status"=>"TRADING", "ProcessDate"=>"20191111121345", "AccessID"=>"cc3b3a9da2c80da2d9da6f6ce1cf367a", "AccessPass"=>"69f1246d318144bc5e11188d3e9dde25", "Amount"=>"10000", "Tax"=>"", "ClientField1"=>"", "ClientField2"=>"", "ClientField3"=>"", "PayType"=>"36", "GanbBankCode"=>"0310", "GanbBankName"=>"ジーエムオーアオゾラネット", "GanbBranchCode"=>"503", "GanbBranchName"=>"郷骸竹", "GanbAccountType"=>"1", "GanbAccountNumber"=>"5247184", "GanbAccountHolderName"=>"テストショップnull", "GanbExpireDays"=>"7", "GanbExpireDate"=>"20191118", "GanbTradeReason"=>"", "GanbTradeClientName"=>"", "GanbTotalTransferAmount"=>"0", "GanbTotalTransferCount"=>"0", "GanbLatestTransferAmount"=>"", "GanbLatestTransferDate"=>"", "GanbLatestTransferName"=>"", "GanbLatestTransferBankName"=>""}
      def search_trade_multi(options = {})
        name = "SearchTradeMulti.idPass"
        required = [:order_id]
        options[:pay_type] = "36"
        assert_required_options(required, options)
        post_request name, options
      end

      def parse_nested_query(result_body, path)
        if result_body.start_with?("ErrCode=") || path != "/payment/InquiryTransferGANB.idPass"
          return super
        end

        # /payment/InquiryTransferGANB.idPass の正常系出力は特殊で、
        # 1履歴1行として、履歴の数分下記のフォーマットで返ってくる
        # {TransferDate}|{TransferName}|{TarnsferBankName}|{TradeBranchName}|{TransferAmount}
        body = NKF.nkf("-wSx", result_body)
        body.lines(chomp: true).map do |line|
          params = line.split("|")
          {
            "TransferDate" => params[0],
            "TransferName" => params[1],
            "TarnsferBankName" => params[2],
            "TradeBranchName" => params[3],
            "TransferAmount" => params[4]
          }
        end
      end

      private

        def api_call(name, args = {}, verb = "post", options = {})
          args.merge!({ "ShopID" => @shop_id, "ShopPass" => @shop_pass })
          api(name, args, verb, options) do |response|
            if response.is_a?(Hash) && !response["ErrInfo"].nil?
              raise APIError.new(response, locale)
            end
          end
        end

    end

  end
end
