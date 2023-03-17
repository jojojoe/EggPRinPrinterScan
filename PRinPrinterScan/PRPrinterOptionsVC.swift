//
//  PRPrinterOptionsVC.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit
import WebKit
import PDFKit
import KRProgressHUD

let pdfWidth: CGFloat = 595
let pdfHeight: CGFloat = 842


class PRPrinterOptionsVC: UIViewController {
    
    let pdfPreviewBgV = UIView()
    let pageRangeInfoL = UILabel()
    var contentUrl: URL
    let printerNameL = UILabel()
    var copiesCount: Int = 1 {
        didSet {
            copiesCountL.text = "\(copiesCount)"
        }
    }
    let copiesCountL = UILabel()
    
    var rangeMin: Int = 1 {
        didSet {
            if rangeMax == 1 {
                pageRangeInfoL.text = "Page \(rangeMin)"
            } else {
                pageRangeInfoL.text = "Pages \(rangeMin)-\(rangeMax)"
            }
        }
    }
    var rangeMax: Int = 1 {
        didSet {
            if rangeMax == 1 {
                pageRangeInfoL.text = "Page \(rangeMin)"
            } else {
                pageRangeInfoL.text = "Pages \(rangeMin)-\(rangeMax)"
            }
        }
    }
    var currentTotalPageCount: Int = 1 // 下面预览的总页面数（选择完每页展示多少pdf page 后的页面数 小于 pdf的文件页面个数 ）
    
    var pageSizeStr = "A4"
    var currentSheetStr: String = "1"
    
    
    var document: PDFDocument = PDFDocument()
    var previewCollection: PRinPdfPreviewCollection?
    
    init(contentUrl: URL) {
        self.contentUrl = contentUrl
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
        pageSizeSelectBtn.addTarget(self, action: #selector(pageSizeSelectBtnClick(sender: )), for: .touchUpInside)
        
        //
        let pageSizeL = UILabel()
        pageSizeSelectBtn.addSubview(pageSizeL)
        pageSizeL.textColor = .black
        pageSizeL.font = UIFont(name: "SFProText-Regular", size: 14)
        pageSizeL.text = "Paper size"
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
            $0.right.equalToSuperview().offset(-18)
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
        pagePerSheetL.text = "Pages per sheet"
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
                self.updatePerSheetCount(sheetStr: sheetItem)
            }
        }

        //
        view.addSubview(pdfPreviewBgV)
        pdfPreviewBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(pagePerSheetBgV.snp.bottom).offset(5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        
        //
        let targetUrl = contentUrl
        
        if targetUrl.relativePath.hasSuffix("pdf") || targetUrl.relativePath.hasSuffix("PDF") {
            if let docu = PDFDocument(url: targetUrl) {
                self.processDocumentWith(docu: docu)
            }
        } else if targetUrl.relativePath.hasSuffix("jpg") || targetUrl.relativePath.hasSuffix("JPG") || targetUrl.relativePath.hasSuffix("png") || targetUrl.relativePath.hasSuffix("PNG") {
            do {
                let targetimg = try UIImage(url: targetUrl)
                if let img = targetimg {
                    let pdfdata = porcessImgToPDF(image: img)
                    if let docu = PDFDocument(data: pdfdata) {
                        self.processDocumentWith(docu: docu)
                    }
                }
            } catch {
                debugPrint("jpg url error - \(error)")
            }
            
        } else {
            let webView: WKWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            if targetUrl.relativePath.hasSuffix("txt") || targetUrl.relativePath.hasSuffix("TXT") {
                do {
                    let data = try Data(contentsOf: targetUrl)
                    webView.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: targetUrl)
                    KRProgressHUD.show()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        [weak self] in
                        guard let `self` = self else {return}
                        KRProgressHUD.dismiss()
                        let pdfdata = self.pdfDataRepresentation(webView: webView)
                        if let docu = PDFDocument(data: pdfdata) {
                            self.processDocumentWith(docu: docu)
                        }
                        
                    }
                    
                } catch {
                    debugPrint("txt url error - \(error)")
                }
            } else {
                do {
                    let data = try Data(contentsOf: targetUrl)
                    webView.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: targetUrl)
                    KRProgressHUD.show()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        [weak self] in
                        guard let `self` = self else {return}
                        KRProgressHUD.dismiss()
                        let pdfdata = self.pdfDataRepresentation(webView: webView)
                        if let docu = PDFDocument(data: pdfdata) {
                            self.processDocumentWith(docu: docu)
                        }
                        
                    }
                    
                } catch {
                    
                }
            }
        }
    }
    
    func processDocumentWith(docu: PDFDocument) {
        //
        self.document = docu
        self.rangeMin = 1
        let totalPageCount = sheetPageTotalCount(sheet: currentSheetStr.int ?? 1)
        rangeMin = 1
        rangeMax = totalPageCount
        
        
        
        
        self.rangeMax = self.document.pageCount
        self.previewCollection = PRinPdfPreviewCollection(frame: .zero, pdfDocument: self.document, rangeMin: self.rangeMin, rangeMax: self.rangeMax, pageCount: totalPageCount)
        pdfPreviewBgV.addSubview(self.previewCollection!)
        self.previewCollection!.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
    }
    
    
    
}

extension PRPrinterOptionsVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func printerBtnClick(sender: UIButton) {
        if currentSheetStr == "1" {
            showSystemPrinter(urls: [contentUrl])
        } else {
            if let previewCo = previewCollection {
                let resultUlrs = previewCo.processMakeNewPDFImagesUrls()
                showSystemPrinter(urls: resultUlrs)
            }

        }
    }
    
    
    @objc func printerSelectBtnClick(sender: UIButton) {
        showPrinterPicker()
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
    
    @objc func pageSizeSelectBtnClick(sender: UIButton) {
        
    }
    
    func sheetPageTotalCount(sheet: Int) -> Int {
        var sheetPageCount: Int = 0
        
        let perCount: Int = sheet
        let documentPageCount = document.pageCount
        let chushu = documentPageCount / perCount
        let yushu = documentPageCount % perCount
        if yushu == 0 {
            sheetPageCount = chushu
        } else {
            sheetPageCount = chushu + 1
        }
        currentTotalPageCount = sheetPageCount
        return sheetPageCount
    }
    
    func updatePerSheetCount(sheetStr: String) {
        currentSheetStr = sheetStr
        let sheetCou = sheetStr.int ?? 1
        let totalPageCount = sheetPageTotalCount(sheet: sheetCou)
        rangeMin = 1
        rangeMax = totalPageCount
        
        self.previewCollection?.updatePerPage(sheetCount: sheetCou, rangeMin: rangeMin, rangeMax: rangeMax, pageCount: totalPageCount)
        
    }
    
    
    func showSystemPrinter(urls: [URL]) {
        
        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sample Print"
//        info.orientation = .portrait // Portrait or Landscape
//        info.outputType = .general //ContentType
        printInVC.printInfo = info
        printInVC.printingItems = urls //array of NSData, NSURL, UIImage.
        printInVC.present(animated: true) {
            controller, completed, error in
            
        }
    }
    
}

extension PRPrinterOptionsVC {
    
    func porcessImgToPDF(image: UIImage) -> Data {
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        let bounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = bounds.size.width
        let pdfHeight = bounds.size.height
        UIGraphicsBeginPDFPage()
        let imageW = image.size.width
        let imageH = image.size.height
        if (imageW <= pdfWidth && imageH <= pdfHeight) {
            let originX = (pdfWidth - imageW) / 2
            let originY = (pdfHeight - imageH) / 2
            image.draw(in: CGRect(x: originX, y: originY, width: imageW, height: imageH))

        } else {
            var widthm: CGFloat = 0
            var heightm: CGFloat = 0
            
            if ((imageW / imageH) > (pdfWidth / pdfHeight)) {
                widthm = pdfWidth
                heightm = widthm * imageH / imageW
            } else {
                heightm = pdfHeight;
                widthm = heightm * imageW / imageH;
            }
            image.draw(in: CGRect(x: (pdfWidth - widthm) / 2, y: (pdfHeight - heightm) / 2, width: widthm, height: heightm))
            
        }
        UIGraphicsEndPDFContext()
        
        return Data(pdfData)
    }
    
    
    func porcessImgToPDF(images: [UIImage]) -> URL {
        
        let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
        let filePath = NSTemporaryDirectory() + "\(dateStr)\(".pdf")"
        
        UIGraphicsBeginPDFContextToFile(filePath, .zero, nil)
        
        let bounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = bounds.size.width
        let pdfHeight = bounds.size.height
        
        for image in images {
            
            UIGraphicsBeginPDFPage()
            let imageW = image.size.width
            let imageH = image.size.height
            if (imageW <= pdfWidth && imageH <= pdfHeight) {
                let originX = (pdfWidth - imageW) / 2
                let originY = (pdfHeight - imageH) / 2
                image.draw(in: CGRect(x: originX, y: originY, width: imageW, height: imageH))
            } else {
                var widthm: CGFloat = 0
                var heightm: CGFloat = 0
                
                if ((imageW / imageH) > (pdfWidth / pdfHeight)) {
                    widthm = pdfWidth
                    heightm = widthm * imageH / imageW
                } else {
                    heightm = pdfHeight;
                    widthm = heightm * imageW / imageH;
                }
                image.draw(in: CGRect(x: (pdfWidth - widthm) / 2, y: (pdfHeight - heightm) / 2, width: widthm, height: heightm))
            }
        }
        
        UIGraphicsEndPDFContext()
        let url = URL(fileURLWithPath: filePath)
        return url
    }
    
}


extension PRPrinterOptionsVC {
    func showPrinterPicker() {
        
        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        printerPicker.present(animated: true, completionHandler: {
            
            [unowned self] printerPickerController, userDidSelect, error in
            
            if (error != nil) {
                debugPrint("Error : \(String(describing: error))")
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
//        let page = CGRect(x: 0, y: 0, width: 210, height: 297)
        
        let page = CGRect(x: 0, y: 0, width: pdfWidth, height: pdfHeight)
        let printable = CGRectInset(page, 20, 20)
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






