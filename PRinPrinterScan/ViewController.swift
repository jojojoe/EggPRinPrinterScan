//
//  ViewController.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/10.
//

import UIKit
import SnapKit
import WebKit
import YPImagePicker
import Photos
import SwifterSwift
import Vision
import VisionKit
import PDFKit


class ViewController: UIViewController {

    
    let printerPageVC = PRPrinterViewController()
    let settingPageVC = PRSettingViewController()
    let scaneBtn = PRinMainBottomBtn()
    let printBtn = PRinMainBottomBtn()
    let settingBtn = PRinMainBottomBtn()
    
    
    func setupContentV() {
        //
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.white
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-66)
        }
        //
        
        bottomBar.addSubview(scaneBtn)
        scaneBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(66)
        }
        scaneBtn.addTarget(self, action: #selector(scaneBtnClick(sender: )), for: .touchUpInside)
        scaneBtn.iconImgV.image = UIImage(named: "tabscan")
        scaneBtn.iconImgV.highlightedImage = UIImage(named: "tabscan_s")
        scaneBtn.nameL.text = "Scan"
        
        //

        bottomBar.addSubview(printBtn)
        printBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(66)
        }
        printBtn.addTarget(self, action: #selector(printBtnClick(sender: )), for: .touchUpInside)
        printBtn.iconImgV.image = UIImage(named: "tabprinter")
        printBtn.iconImgV.highlightedImage = UIImage(named: "tabprinter_s")
        printBtn.nameL.text = "Printer"
        
        //
        
        bottomBar.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-40)
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(66)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        settingBtn.iconImgV.image = UIImage(named: "tabsett")
        settingBtn.iconImgV.highlightedImage = UIImage(named: "tabsett_s")
        settingBtn.nameL.text = "Setting"
        
        //
        let contentBgV = UIView()
        view.addSubview(contentBgV)
        contentBgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top).offset(0)
        }
        //
        let bottomLine = UIView()
        view.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor(hexString: "#CCCCCC")?.withAlphaComponent(0.35)
        bottomLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(1)
        }
        
        //
        self.addChild(printerPageVC)
        contentBgV.addSubview(printerPageVC.view)
        printerPageVC.view.didMoveToSuperview()
        printerPageVC.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        printerPageVC.mainVC = self
        //
        
        self.addChild(settingPageVC)
        contentBgV.addSubview(settingPageVC.view)
        settingPageVC.view.didMoveToSuperview()
        settingPageVC.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        settingPageVC.mainVC = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentV()

        printBtnClick(sender: printBtn)
        
    }
 
}
 

extension ViewController {
    @objc func scaneBtnClick(sender: UIButton) {
        let scanningDocumentVC = VNDocumentCameraViewController()
        scanningDocumentVC.delegate = self
        self.present(scanningDocumentVC, animated: true, completion: nil)
    }
    
    @objc func printBtnClick(sender: UIButton) {
        printerPageVC.view.isHidden = false
        settingPageVC.view.isHidden = true
        printBtn.isSelected = true
        settingBtn.isSelected = false
        scaneBtn.isSelected = false
//        printBtn.iconImgV.isHighlighted = true
//        settingBtn.iconImgV.isHighlighted = false
    }
    
    @objc func settingBtnClick(sender: UIButton) {
        printerPageVC.view.isHidden = true
        settingPageVC.view.isHidden = false
        printBtn.isSelected = false
        settingBtn.isSelected = true
        scaneBtn.isSelected = false
//        printBtn.iconImgV.isHighlighted = false
//        settingBtn.iconImgV.isHighlighted = true
    }
    
    
    
}


 

class PRinMainBottomBtn: UIButton {
    
    let iconImgV = UIImageView()
    let nameL = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconImgV.isHighlighted = true
                nameL.textColor = UIColor(hexString: "#4285F4")
            } else {
                iconImgV.isHighlighted = false
                nameL.textColor = UIColor(hexString: "#CCCCCC")
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {

        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        //
        addSubview(nameL)
        nameL.font = UIFont(name: "SFProText-Medium", size: 10)
        nameL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(8)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        
    }
    
    
    
    
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        debugPrint("Found \(scan.pageCount)")
        
        let pdfDocument = PDFDocument()
        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            // ... your code here
            let pdfPage = PDFPage(image: img)
            pdfDocument.insert(pdfPage!, at: i)
        }
        let data = pdfDocument.dataRepresentation()
        
        let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
        let filePath = NSTemporaryDirectory() + "\(dateStr)\(".pdf")"
        let fileUrl = URL(fileURLWithPath: filePath)
        
        
        do{
            debugPrint("Documet: \(filePath)")
            try data?.write(to: fileUrl)
        } catch(let error) {
            print("error is \(error.localizedDescription)")
        }
//        let originalImage = scan.imageOfPage(at: 0)
//        let newImage = compressedImage(originalImage)
        controller.dismiss(animated: true)
//        processImage(newImage)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            let pageOptionVC = PRPrinterOptionsVC(contentUrl: fileUrl)
            self.navigationController?.pushViewController(pageOptionVC, animated: true)
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        
        controller.dismiss(animated: true)
    }
}
