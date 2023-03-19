//
//  PRPrinterClipboardVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/19.
//

import UIKit

class PRPrinterClipboardVC: UIViewController {

    let contentTextV = UITextView()
    var toolView = UIView()
    var pasteButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentTextV.becomeFirstResponder()
    }
    

    func setupV() {
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        view.clipsToBounds = true
        //
        let topBanner = UIView()
        view.addSubview(topBanner)
        topBanner.backgroundColor = .white
        topBanner.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        //
        let backBtn = UIButton()
        topBanner.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        backBtn.setImage(UIImage(named: "backVector"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let printerBtn = UIButton()
        topBanner.addSubview(printerBtn)
        printerBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        printerBtn.setImage(UIImage(named: "printerVector"), for: .normal)
        printerBtn.addTarget(self, action: #selector(printerBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topNameL = UILabel()
        topBanner.addSubview(topNameL)
        topNameL.text = "Clipboard"
        topNameL.font = UIFont(name: "SFProText-Medium", size: 16)
        topNameL.textColor = UIColor(hexString: "#000000")
        topNameL.snp.makeConstraints {
            $0.centerY.equalTo(printerBtn.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        
        // tool view
        view.addSubview(toolView)
        toolView.backgroundColor = UIColor(hexString: "#FFFFFF")
        toolView.frame = CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: 40)
        
        // tool keyborder hiden view
        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.setTitleColor(.systemBlue, for: .normal)
        pasteButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 15)
        pasteButton.addTarget(self, action: #selector(pasteButtonClick(sender: )), for: .touchUpInside)
        toolView.addSubview(pasteButton)
        pasteButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        //
        view.addSubview(contentTextV)
        contentTextV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(topBanner.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
//        contentTextV.delegate = self
        contentTextV.textColor = UIColor.black
        contentTextV.font = UIFont(name: "SFProText-Medium", size: 18)
        contentTextV.placeholder = "Type your text here..."
        contentTextV.placeholderColor = UIColor(hexString: "#999999") ?? .black
        contentTextV.inputAccessoryView = toolView
        contentTextV.layer.cornerRadius = 12
        contentTextV.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        self.contentTextV.resignFirstResponder()
    }
    
    @objc func printerBtnClick(sender: UIButton) {
        self.contentTextV.resignFirstResponder()
        
        let printInVC = UIPrintInteractionController.shared
        
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
        let textFormatter = UISimpleTextPrintFormatter(text: contentTextV.text)
        textFormatter.startPage = 0
        textFormatter.perPageContentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textFormatter.maximumContentWidth = 16 * 72.0
        printInVC.printFormatter = textFormatter
        
        printInVC.present(animated: true) {
            controller, completed, error in
            
        }
    }
    
    @objc func pasteButtonClick(sender: UIButton) {
        if let str = UIPasteboard.general.string {
            contentTextV.text = contentTextV.text + " " + str
        }
    }
    
    
    
    
}

extension UITextView {
    
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil { // 不存在是 创建 绑定
                if (self.font == nil) { // 防止没大小时显示异常 系统默认设置14
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = UIFont.systemFont(ofSize: 14)//self.font
                label?.textColor = UIColor.lightGray
                label?.textAlignment = self.textAlignment
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            } else {
                label?.font = self.font
                label?.textColor = label?.textColor.withAlphaComponent(0.6)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

