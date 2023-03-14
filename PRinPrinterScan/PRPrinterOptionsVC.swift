//
//  PRPrinterOptionsVC.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit
import WebKit

class PRPrinterOptionsVC: UIViewController {
    
    var contentUrls: [URL]
    let printerNameL = UILabel()
    var copiesCount: Int = 1
    let copiesCountL = UILabel()
    var rangeMin: Int = 1
    var rangeMax: Int = 3
    var pageSizeStr = "A4"
    
    
    
    init(contentUrls: [URL]) {
        self.contentUrls = contentUrls
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
        
    }
    

    func setupContent() {
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
        topNameL.text = "Print Options"
        topNameL.font = UIFont(name: "SFProText-Medium", size: 16)
        topNameL.textColor = UIColor(hexString: "#000000")
        topNameL.snp.makeConstraints {
            $0.centerY.equalTo(printerBtn.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let printerSelectBtn = UIButton()
        printerSelectBtn.backgroundColor = .white
        printerSelectBtn.layer.cornerRadius = 12
        view.addSubview(printerSelectBtn)
        printerSelectBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(20)
            $0.height.equalTo(52)
        }
        printerSelectBtn.addTarget(self, action: #selector(printerSelectBtnClick(sender: )), for: .touchUpInside)
        
        //
        let printerSelectL = UILabel()
        printerSelectBtn.addSubview(printerSelectL)
        printerSelectL.textColor = .black
        printerSelectL.font = UIFont(name: "SFProText-Regular", size: 14)
        printerSelectL.text = "Printer"
        printerSelectL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        
        printerSelectBtn.addSubview(printerNameL)
        printerNameL.textColor = UIColor(hexString: "#999999")
        printerNameL.font = UIFont(name: "SFProText-Regular", size: 14)
        printerNameL.text = "No printer selected"
        printerNameL.textAlignment = .right
        printerNameL.lineBreakMode = .byTruncatingTail
        printerNameL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.height.greaterThanOrEqualTo(10)
            $0.left.equalTo(printerSelectBtn.snp.left).offset(80)
        }
        //
        let printerarrowImgV = UIImageView()
        printerarrowImgV.image = UIImage(named: "Frame 13")
        printerarrowImgV.contentMode = .scaleAspectFill
        printerarrowImgV.backgroundColor = .clear
        printerarrowImgV.clipsToBounds = true
        printerSelectBtn.addSubview(printerarrowImgV)
        printerarrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-18)
            $0.width.equalTo(16/2)
            $0.height.equalTo(24/2)
        }
        
        //
        let copiesToolBgV = UIView()
        view.addSubview(copiesToolBgV)
        copiesToolBgV.backgroundColor = .white
        copiesToolBgV.layer.cornerRadius = 12
        copiesToolBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(156)
            $0.top.equalTo(printerSelectBtn.snp.bottom).offset(16)
        }
        //
        let copiesSelectBgV = UIView()
        copiesSelectBgV.backgroundColor = .clear
        copiesToolBgV.addSubview(copiesSelectBgV)
        copiesSelectBgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(52)
        }
        let copiesSelectL = UILabel()
        copiesSelectBgV.addSubview(copiesSelectL)
        copiesSelectL.textColor = .black
        copiesSelectL.font = UIFont(name: "SFProText-Regular", size: 14)
        copiesSelectL.text = "Copies"
        copiesSelectL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let copiesCountAddBtn = UIButton()
        copiesSelectBgV.addSubview(copiesCountAddBtn)
        copiesCountAddBtn.setImage(UIImage(named: "ic_copyadd"), for: .normal)
        copiesCountAddBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-8)
            $0.width.height.equalTo(34)
        }
        copiesCountAddBtn.addTarget(self, action: #selector(copiesCountAddBtnClick(sender: )), for: .touchUpInside)
        //
        copiesSelectBgV.addSubview(copiesCountL)
        copiesCountL.backgroundColor = UIColor(hexString: "#4285F4")
        copiesCountL.textColor = UIColor.white
        copiesCountL.textAlignment = .center
        copiesCountL.layer.cornerRadius = 14
        copiesCountL.clipsToBounds = true
        copiesCountL.text = "\(copiesCount)"
        copiesCountL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(copiesCountAddBtn.snp.left)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
        }
        //
        let copiesCountJianBtn = UIButton()
        copiesSelectBgV.addSubview(copiesCountJianBtn)
        copiesCountJianBtn.setImage(UIImage(named: "ic_copyjian"), for: .normal)
        copiesCountJianBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(34)
            $0.right.equalTo(copiesCountL.snp.left)
        }
        copiesCountJianBtn.addTarget(self, action: #selector(copiesCountJianBtnClick(sender: )), for: .touchUpInside)
        //
        let pageRangeSelectBtn = UIButton()
        copiesToolBgV.addSubview(pageRangeSelectBtn)
        pageRangeSelectBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(copiesSelectBgV.snp.bottom)
            $0.height.equalTo(52)
        }
        //
        let pageRangeL = UILabel()
        pageRangeSelectBtn.addSubview(pageRangeL)
        pageRangeL.textColor = .black
        pageRangeL.font = UIFont(name: "SFProText-Regular", size: 14)
        pageRangeL.text = "Range"
        pageRangeL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let pageRangearrowImgV = UIImageView()
        pageRangearrowImgV.image = UIImage(named: "Frame 13")
        pageRangearrowImgV.contentMode = .scaleAspectFill
        pageRangearrowImgV.backgroundColor = .clear
        pageRangearrowImgV.clipsToBounds = true
        pageRangeSelectBtn.addSubview(pageRangearrowImgV)
        pageRangearrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-18)
            $0.width.equalTo(16/2)
            $0.height.equalTo(24/2)
        }
        //
        let pageRangeInfoL = UILabel()
        pageRangeSelectBtn.addSubview(pageRangeInfoL)
        pageRangeInfoL.textColor = UIColor(hexString: "#999999")
        pageRangeInfoL.font = UIFont(name: "SFProText-Regular", size: 14)
        pageRangeInfoL.text = "Pages \(rangeMin)-\(rangeMax)"
        pageRangeInfoL.textAlignment = .right
        pageRangeInfoL.lineBreakMode = .byTruncatingTail
        pageRangeInfoL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.height.greaterThanOrEqualTo(10)
            $0.left.equalTo(printerSelectBtn.snp.left).offset(80)
        }
        //
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#F5F5F5")
        copiesToolBgV.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(pageRangeSelectBtn.snp.top)
            $0.height.equalTo(1)
        }
        
        //
        let pageSizeSelectBtn = UIButton()
        copiesToolBgV.addSubview(pageSizeSelectBtn)
        pageSizeSelectBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(pageRangeSelectBtn.snp.bottom)
            $0.height.equalTo(52)
        }
        //
        let pageSizeL = UILabel()
        pageSizeSelectBtn.addSubview(pageSizeL)
        pageSizeL.textColor = .black
        pageSizeL.font = UIFont(name: "SFProText-Regular", size: 14)
        pageSizeL.text = "Range"
        pageSizeL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let pageSizearrowImgV = UIImageView()
        pageSizearrowImgV.image = UIImage(named: "Frame 13")
        pageSizearrowImgV.contentMode = .scaleAspectFill
        pageSizearrowImgV.backgroundColor = .clear
        pageSizearrowImgV.clipsToBounds = true
        pageSizeSelectBtn.addSubview(pageSizearrowImgV)
        pageSizearrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
            $0.width.equalTo(16/2)
            $0.height.equalTo(24/2)
        }
        //
        let pageSizeInfoL = UILabel()
        pageSizeSelectBtn.addSubview(pageSizeInfoL)
        pageSizeInfoL.textColor = UIColor(hexString: "#999999")
        pageSizeInfoL.font = UIFont(name: "SFProText-Regular", size: 14)
        pageSizeInfoL.text = "\(pageSizeStr)"
        pageSizeInfoL.textAlignment = .right
        pageSizeInfoL.lineBreakMode = .byTruncatingTail
        pageSizeInfoL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.height.greaterThanOrEqualTo(10)
            $0.left.equalTo(printerSelectBtn.snp.left).offset(80)
        }
        
        //
        let line2 = UIView()
        line2.backgroundColor = UIColor(hexString: "#F5F5F5")
        copiesToolBgV.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(pageRangeSelectBtn.snp.bottom)
            $0.height.equalTo(1)
        }
        
        //
        let pagePerSheetBgV = UIView()
        view.addSubview(pagePerSheetBgV)
        pagePerSheetBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(copiesToolBgV.snp.bottom).offset(16)
            $0.height.equalTo(118)
        }
        pagePerSheetBgV.backgroundColor = .white
        pagePerSheetBgV.layer.cornerRadius = 12
        //
        let pagePerSheetL = UILabel()
        pagePerSheetBgV.addSubview(pagePerSheetL)
        pagePerSheetL.textColor = .black
        pagePerSheetL.font = UIFont(name: "SFProText-Regular", size: 14)
        pagePerSheetL.text = "Range"
        pagePerSheetL.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let sheetSelectV = PRinPagePerSheetSelectView()
        pagePerSheetBgV.addSubview(sheetSelectV)
        sheetSelectV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(pagePerSheetL.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
        }
        sheetSelectV.perSheetSelectBlock = {
            [weak self] sheetItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
            }
        }
        
        //
        if let targetUrl = contentUrls.first {
            //
            let webView: WKWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            view.addSubview(webView)
            if targetUrl.relativePath.hasSuffix("txt") || targetUrl.relativePath.hasSuffix("TXT") {
                do {
                    let data = try Data(contentsOf: targetUrl)
                    webView.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: targetUrl)

                } catch {
                    
                }
            } else if targetUrl.relativePath.hasSuffix("pdf") || targetUrl.relativePath.hasSuffix("PDF") {
                do {
                    let data = try Data(contentsOf: targetUrl)
                    webView.load(data, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: targetUrl)
                } catch {
                    
                }
            } else {
                webView.load(URLRequest(url: targetUrl))
            }
            

//            printInVC.printFormatter = webV.viewPrintFormatter()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                if let printer_m = printer {
//                    printInVC.print(to: printer_m, completionHandler: {
//                        controller, completed, error in
//
//                    })
//                } else {
//                    printInVC.present(animated: true) {
//                        controller, completed, error in
//
//                    }
//                }
//            }
        }
        
    }
    
    
}

extension PRPrinterOptionsVC {
    
    @objc func backBtnClick(sender: UIButton) {
        
    }
    
    @objc func printerBtnClick(sender: UIButton) {
        
    }
    
    @objc func printerSelectBtnClick(sender: UIButton) {
        
    }
    
    @objc func copiesCountAddBtnClick(sender: UIButton) {
        if copiesCount < 9 {
            copiesCount += 1
        }
        
    }
    
    @objc func copiesCountJianBtnClick(sender: UIButton) {
        if copiesCount > 1 {
            copiesCount -= 1
        }
    }
    
    func updateCopiesCountLabel() {
        copiesCountL.text = "\(copiesCount)"
    }
    
    
    
    
    
}

extension PRPrinterOptionsVC {
    func showPrinterPicker() {
        
        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        printerPicker.present(animated: true, completionHandler: {
            
            [unowned self] printerPickerController, userDidSelect, error in
            
            if (error != nil) {
                debugPrint("Error : \(error)")
            } else {
                if let printer: UIPrinter = printerPickerController.selectedPrinter {
                    debugPrint("Printer displayName : \(printer.displayName)")
                    debugPrint("Printer url : \(printer.url)")
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.printerNameL.text = printer.displayName
                    }
                } else {
                    debugPrint("Printer is not selected")
                }
            }
        })
    }
}


extension PRPrinterOptionsVC {
    func pdfDataRepresentation(webView: WKWebView) -> Data {
        let fmt: UIViewPrintFormatter = webView.viewPrintFormatter()
        let render: UIPrintPageRenderer = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        let page = CGRect(x: 0, y: 0, width: 210 * 5, height: 297 * 5)
        let printable = CGRectInset(page, 50, 50)
        render.setValue(page, forKey: "paperRect")
        render.setValue(printable, forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage()
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext()
        return Data(pdfData)
    }
    
    
}






