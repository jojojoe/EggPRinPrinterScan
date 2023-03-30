//
//  PRPrinterStoreVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/21.
//

import UIKit
import SnapKit
import KRProgressHUD

class PRPrinterStoreVC: UIViewController {

    let monthBeforePrice: Double = 9.99
    var defaultMonthPrice: Double = 6.99
    var defaultYearPrice: Double = 24.99
    var currentSymbol: String = "$"
    
    let backBtn = UIButton()
    let theContinueBtn = UIButton()
    let monthBgBtn = UIButton()
    let yearBgBtn = UIButton()
    
    let yearPriceLabel = UILabel()
    let yearPriceInfoLabel = UILabel()
    
    let monthPriceLabel = UILabel()
    let monthPriceInfoLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupV()
    }
    
    func setupV() {
        view.backgroundColor = .white
        setupContinueBtn()
        setupYearPurchaseBtn()
        setupMonthPurchaseBtn()
        setupDescribeLabels()
        fetchPriceLabels()
        updateIapBtnStatus()
    }
    
    
    
    func setupContinueBtn() {
        view.addSubview(theContinueBtn)
        theContinueBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(48)
        }
        theContinueBtn.layer.cornerRadius = 24
        theContinueBtn.backgroundColor = UIColor(hexString: "#4285F4")
        theContinueBtn.setTitle("Continue", for: .normal)
        theContinueBtn.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        theContinueBtn.setTitleColor(.white, for: .normal)
        theContinueBtn.addTarget(self, action: #selector(theContinueBtnClick(sender: )), for: .touchUpInside)
        
        //
        let purchaseNoticeTextV = UITextView()
        purchaseNoticeTextV.textAlignment = .center
        purchaseNoticeTextV.font = UIFont(name: "SFProText-Regular", size: 10)
        purchaseNoticeTextV.textColor = UIColor(hexString: "#666666")
        view.addSubview(purchaseNoticeTextV)
        purchaseNoticeTextV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-0)
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(theContinueBtn.snp.bottom).offset(15)
        }
        purchaseNoticeTextV.text = purchaseNoticeStr
        
    }
    
    func setupMonthPurchaseBtn() {
        
        view.addSubview(monthBgBtn)
        monthBgBtn.backgroundColor = UIColor(hexString: "#F5F5F5")
        monthBgBtn.layer.borderColor = UIColor(hexString: "#F5F5F5")!.cgColor
        monthBgBtn.layer.borderWidth = 1
        monthBgBtn.layer.cornerRadius = 12
        monthBgBtn.addTarget(self, action: #selector(monthBgBtnClick(sender: )), for: .touchUpInside)
        monthBgBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(18)
            $0.bottom.equalTo(yearBgBtn.snp.top).offset(-12)
            $0.height.equalTo(67)
        }
        //
        let monthTitleLabel = UILabel()
        monthTitleLabel.text = "Monthly"
        monthTitleLabel.textColor = .black
        monthTitleLabel.font = UIFont(name: "SFProText-Bold", size: 14)
        monthBgBtn.addSubview(monthTitleLabel)
        monthTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //

        monthPriceLabel.text = "\(currentSymbol)\(defaultMonthPrice)/month"
        monthPriceLabel.textColor = .black
        monthPriceLabel.font = UIFont(name: "SFProText-Medium", size: 12)
        monthBgBtn.addSubview(monthPriceLabel)
        monthPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        monthPriceInfoLabel.text = "\(currentSymbol)\(defaultMonthPrice)/mo"
        monthPriceInfoLabel.textColor = .black
        monthPriceInfoLabel.font = UIFont(name: "SFProText-Bold", size: 14)
        monthBgBtn.addSubview(monthPriceInfoLabel)
        monthPriceInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.greaterThanOrEqualTo(1)
        }

        //
        let monthBeforePriceLabel = UILabel()
        let monthBeforeStr = "\(currentSymbol)\(monthBeforePrice)"
        monthBeforePriceLabel.textColor = UIColor(hexString: "#999999")
        monthBeforePriceLabel.font = UIFont(name: "SFProText-Regular", size: 14)
        monthBgBtn.addSubview(monthBeforePriceLabel)
        monthBeforePriceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(monthPriceInfoLabel.snp.left).offset(-12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        monthBeforePriceLabel.attributedText = NSAttributedString(string: monthBeforeStr, attributes: [NSAttributedString.Key.font : (UIFont(name: "SFProText-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)), NSAttributedString.Key.foregroundColor : (UIColor(hexString: "#999999") ?? UIColor.white), NSAttributedString.Key.strikethroughStyle : 1, NSAttributedString.Key.strikethroughColor : (UIColor(hexString: "#999999") ?? UIColor.white)])
        
        //
        let monthPreImgV = UIImageView()
        monthPreImgV.image("Group 126")
        monthBgBtn.addSubview(monthPreImgV)
        monthPreImgV.snp.makeConstraints {
            $0.width.height.equalTo(108/2)
            $0.right.equalTo(monthBgBtn.snp.right).offset(18)
            $0.top.equalTo(monthBgBtn.snp.right).offset(-20)
        }
        
    }
    
    func setupYearPurchaseBtn() {

        view.addSubview(yearBgBtn)
        yearBgBtn.backgroundColor = UIColor(hexString: "#F5F5F5")
        yearBgBtn.layer.borderColor = UIColor(hexString: "#F5F5F5")!.cgColor
        yearBgBtn.layer.borderWidth = 1
        yearBgBtn.layer.cornerRadius = 12
        yearBgBtn.addTarget(self, action: #selector(yearBgBtnClick(sender: )), for: .touchUpInside)
        yearBgBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(18)
            $0.bottom.equalTo(theContinueBtn.snp.top).offset(-40)
            $0.height.equalTo(67)
        }
        //
        let yearTitleLabel = UILabel()
        yearTitleLabel.text = "Yearly"
        yearTitleLabel.textColor = .black
        yearTitleLabel.font = UIFont(name: "SFProText-Bold", size: 14)
        yearBgBtn.addSubview(yearTitleLabel)
        yearTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //

        yearPriceLabel.text = "\(currentSymbol)\(defaultYearPrice)/year"
        yearPriceLabel.textColor = .black
        yearPriceLabel.font = UIFont(name: "SFProText-Medium", size: 12)
        yearBgBtn.addSubview(yearPriceLabel)
        yearPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        yearPriceInfoLabel.text = "\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
        yearPriceInfoLabel.textColor = .black
        yearPriceInfoLabel.font = UIFont(name: "SFProText-Bold", size: 14)
        yearBgBtn.addSubview(yearPriceInfoLabel)
        yearPriceInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
    }
    
    func setupDescribeLabels() {
        let describeBgV = UIView()
        view.addSubview(describeBgV)
        describeBgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(monthBgBtn.snp.top).offset(-40)
            $0.height.equalTo(160)
        }
        //
        let descTitleLabel = UILabel()
        describeBgV.addSubview(descTitleLabel)
        descTitleLabel.numberOfLines = 2
        descTitleLabel.font = UIFont(name: "SFProText-Bold", size: 24)
        descTitleLabel.textAlignment = .center
        descTitleLabel.textColor = .black
        descTitleLabel.text = "Unlimited Access to\nAll Features"
        descTitleLabel.adjustsFontSizeToFitWidth = true
        descTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(230)
            $0.height.greaterThanOrEqualTo(60)
        }
        //
        let descLabel1 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel1)
        descLabel1.contentL.text = "All printing features"
        descLabel1.snp.makeConstraints {
            $0.left.equalTo(descTitleLabel.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descTitleLabel.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        //
        let descLabel2 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel2)
        descLabel2.contentL.text = "Unlimited Scan & Fax"
        descLabel2.snp.makeConstraints {
            $0.left.equalTo(descTitleLabel.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descLabel1.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        //
        let descLabel3 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel3)
        descLabel3.contentL.text = "Support all printer brands"
        descLabel3.snp.makeConstraints {
            $0.left.equalTo(descTitleLabel.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descLabel2.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        
        //
        let topIconImgV = UIImageView()
        view.addSubview(topIconImgV)
        topIconImgV.image = UIImage(named: "Group 3548")
        topIconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(describeBgV.snp.top).offset(0)
            $0.left.equalToSuperview()
        }
        topIconImgV.contentMode = .scaleAspectFit
        
        //
        
        backBtn.setImage(UIImage(named: "Group 78"), for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
    }
    
    @objc func monthBgBtnClick(sender: UIButton) {
        PRPrinterStoreManager.default.currentIapType = .month
        updateIapBtnStatus()
    }
    
    @objc func yearBgBtnClick(sender: UIButton) {
        PRPrinterStoreManager.default.currentIapType = .year
        updateIapBtnStatus()
    }
    
    @objc func theContinueBtnClick(sender: UIButton) {
        PRPrinterStoreManager.default.subscribeIapOrder(iapType: PRPrinterStoreManager.default.currentIapType, source: "shop") {[weak self] subSuccess, errorStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if subSuccess {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was successful!")
                    self.backBtnClick(sender: self.backBtn)
                } else {
                    KRProgressHUD.showError(withMessage: errorStr ?? "The subscription failed")
                }
            }

        }
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    let purchaseNoticeStr = """
    The payment will be charged to your Google PlayAccount within 24
     hours prior to the end of the free trialperiod - if applicable
     - or at the confirmation of yourpurchase. Your
    subscription automatically renews unlessauto-renew is
    turned off at least 24 hours before theend of the current
    period You can cancel auto-renewalat anytime, but this
    won't affect the currently activesubscription period.Your
    Google Play account will becharged for renewal within 24
    hours prior to the end ofthe current period, and identify
    the cost of the renewalWe take the satisfaction and
    security of our customersvery seriously. By signing up
    to the subscriptions, youagree with our
    Terms of Use and Privacy Policy.

    """

}

extension PRPrinterStoreVC {
    
    func updatePrice(products: [PRPrinterStoreManager.IAPProduct]) {
        let product0 = products[0]
        let product1 = products[1]
        currentSymbol = product0.priceLocale.currencySymbol ?? "$"
        
        if product0.iapID == PRPrinterStoreManager.IAPType.month.rawValue {
            defaultMonthPrice = product0.price
            defaultYearPrice = product1.price
        } else {
            defaultYearPrice = product0.price
            defaultMonthPrice = product1.price
        }
        monthPriceLabel.text = "\(currentSymbol)\(defaultMonthPrice)/month"
        monthPriceInfoLabel.text = "\(currentSymbol)\(defaultMonthPrice)/mo"
        yearPriceLabel.text = "\(currentSymbol)\(defaultYearPrice)/year"
        yearPriceInfoLabel.text = "\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
    }
    
    func fetchPriceLabels() {
        
        if PRPrinterStoreManager.default.currentProducts.count == PRPrinterStoreManager.default.iapTypeList.count {
            updatePrice(products: PRPrinterStoreManager.default.currentProducts)
        } else {
            PRPrinterStoreManager.default.fetchPurchaseInfo {[weak self] productList in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if productList.count == PRPrinterStoreManager.default.iapTypeList.count {
                        self.updatePrice(products: productList)
                    }
                }
            }
        }
    }
    
    func updateIapBtnStatus() {
        if PRPrinterStoreManager.default.currentIapType == .year {
            yearBgBtn.layer.borderColor = UIColor(hexString: "#4285F4")!.cgColor
            monthBgBtn.layer.borderColor = UIColor(hexString: "#F5F5F5")!.cgColor
        } else if PRPrinterStoreManager.default.currentIapType == .month {
            monthBgBtn.layer.borderColor = UIColor(hexString: "#4285F4")!.cgColor
            yearBgBtn.layer.borderColor = UIColor(hexString: "#F5F5F5")!.cgColor
        }
    }
}

class PRStoreDesInfoLabel: UIView {
    var contentL = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentL)
        contentL.textColor = UIColor.black
        contentL.font = UIFont(name: "SFProText-Semibold", size: 14)
        contentL.textAlignment = .left
        contentL.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
        }
        //
        let iconImgV = UIImageView()
        addSubview(iconImgV)
        iconImgV.image = UIImage(named: "pinpaiselect_s")
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Double {
    func accuracyToString(position: Int) -> String {
        
        //四舍五入
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(position), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        let ouncesDecimal: NSDecimalNumber = NSDecimalNumber(value: self)
        let roundedOunces: NSDecimalNumber = ouncesDecimal.rounding(accordingToBehavior: roundingBehavior)
        
        //生成需要精确的小数点格式，
        //比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
        //也就是说精确到第几位，小数点后面就有几个“0”
        var formatterString : String = "0."
        if position > 0 {
            for _ in 0 ..< position {
                formatterString.append("0")
            }
        }else {
            formatterString = "0"
        }
        let formatter : NumberFormatter = NumberFormatter()
        //设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
        formatter.positiveFormat = formatterString
        //然后把这个number 对象格式化成我们需要的格式，
        //最后以string 类型返回结果。
        var roundingStr = formatter.string(from: roundedOunces) ?? "0.00"
        
        if roundingStr.range(of: ".") != nil {
            
            let sub1 = String(roundingStr.suffix(1))
            if sub1 == "0" {
                roundingStr = String(roundingStr.prefix(roundingStr.count-1))
                let sub2 = String(roundingStr.suffix(1))
                if sub2 == "0" {
                    roundingStr = String(roundingStr.prefix(roundingStr.count-2))
                }
            }
        }
        
        return roundingStr
    }

}
