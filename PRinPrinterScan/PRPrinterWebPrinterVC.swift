//
//  PRPrinterWebPrinterVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/19.
//

import UIKit
import WebKit

class PRPrinterWebPrinterVC: UIViewController {

    let textfieldV = UITextField()
    let webV = WKWebView()
    var toolView = UIView()
    var pasteButton = UIButton()
    var clearButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textfieldV.becomeFirstResponder()
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
        topNameL.text = "Webview"
        topNameL.font = UIFont(name: "SFProText-Medium", size: 16)
        topNameL.textColor = UIColor(hexString: "#000000")
        topNameL.snp.makeConstraints {
            $0.centerY.equalTo(printerBtn.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let inpBgV = UIView()
        view.addSubview(inpBgV)
        inpBgV.backgroundColor = .white
        inpBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(20)
            $0.height.equalTo(52)
        }
        inpBgV.layer.cornerRadius = 12
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
        inpBgV.addSubview(textfieldV)
        textfieldV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-44)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
        }
        textfieldV.font = UIFont(name: "SFProText-Medium", size: 12)
        textfieldV.textColor = .black
        textfieldV.placeholder = "Web URL"
        textfieldV.returnKeyType = .go
        textfieldV.delegate = self
        textfieldV.inputAccessoryView = toolView
        //
        
        clearButton.setImage(UIImage(named: "Group 77"), for: .normal)
        inpBgV.addSubview(clearButton)
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-6)
            $0.width.height.equalTo(40)
        }
        clearButton.addTarget(self, action: #selector(clearButtonClick(sender: )), for: .touchUpInside)
        clearButton.isHidden = true
        //
        webV.layer.cornerRadius = 12
        webV.clipsToBounds = true
        view.addSubview(webV)
        webV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inpBgV.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        
        
    }

    
    @objc func pasteButtonClick(sender: UIButton) {
        if let str = UIPasteboard.general.string {
            textfieldV.text = str
        }
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        self.textfieldV.resignFirstResponder()
    }
    
    @objc func printerBtnClick(sender: UIButton) {
        self.textfieldV.resignFirstResponder()
        
        let printInVC = UIPrintInteractionController.shared
        
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
        printInVC.printFormatter = webV.viewPrintFormatter()
        
        printInVC.present(animated: true) {
            controller, completed, error in
            
        }
    }
    
    @objc func clearButtonClick(sender: UIButton) {
        textfieldV.text = ""
    }
    
}

extension PRPrinterWebPrinterVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" && string == "" {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let urlstr = textField.text, let url = URL(string: urlstr) {
            
            webV.load(URLRequest(url: url))
        }
        
        return true
    }
}
