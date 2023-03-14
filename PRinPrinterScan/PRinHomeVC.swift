//
//  PRinHomeVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/13.
//

import UIKit
import SnapKit
import WebKit
import YPImagePicker
import Photos

class PRinHomeVC: UIViewController, ImageScannerControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scanBtn = UIButton()
        view.addSubview(scanBtn)
        scanBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        scanBtn.setTitle("Scan", for: .normal)
        scanBtn.setTitleColor(.black, for: .normal)
        scanBtn.backgroundColor = .lightGray
        scanBtn.addTarget(self, action: #selector(scanBtnClick(sender: )), for: .touchUpInside)
        
        //
        let connectBtn = UIButton()
        view.addSubview(connectBtn)
        connectBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        connectBtn.setTitle("Connect", for: .normal)
        connectBtn.setTitleColor(.black, for: .normal)
        connectBtn.backgroundColor = .lightGray
        connectBtn.addTarget(self, action: #selector(connectBtnClick(sender: )), for: .touchUpInside)
        
        //
        let printItemBtn = UIButton()
        view.addSubview(printItemBtn)
        printItemBtn.snp.makeConstraints {
            $0.top.equalTo(connectBtn.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        printItemBtn.setTitle("PrintItem", for: .normal)
        printItemBtn.setTitleColor(.black, for: .normal)
        printItemBtn.backgroundColor = .lightGray
        printItemBtn.addTarget(self, action: #selector(printItemBtnClick(sender: )), for: .touchUpInside)
        
        
        //
        let filePickerBtn = UIButton()
        view.addSubview(filePickerBtn)
        filePickerBtn.snp.makeConstraints {
            $0.top.equalTo(scanBtn.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        filePickerBtn.setTitle("Document", for: .normal)
        filePickerBtn.setTitleColor(.black, for: .normal)
        filePickerBtn.backgroundColor = .lightGray
        filePickerBtn.addTarget(self, action: #selector(filePickerBtnClick(sender: )), for: .touchUpInside)
        
        
        //
        let printImageBtn = UIButton()
        view.addSubview(printImageBtn)
        printImageBtn.snp.makeConstraints {
            $0.top.equalTo(filePickerBtn.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        printImageBtn.setTitle("PrintPhotos", for: .normal)
        printImageBtn.setTitleColor(.black, for: .normal)
        printImageBtn.backgroundColor = .lightGray
        printImageBtn.addTarget(self, action: #selector(printImageBtnClick(sender: )), for: .touchUpInside)
        
        
        
        
        
    }


    @objc func scanBtnClick(sender: UIButton) {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    @objc func connectBtnClick(sender: UIButton) {
        showPrinterPicker()
    }
    
    @objc func printItemBtnClick(sender: UIButton) {
        if let url = URL(string: "ipps://Joe-MacBook-Pro.local.:8632/ipp/print/save") {
            let printer = UIPrinter(url: url)
            Task {
                let connect =  await printer.contactPrinter()
                if connect {
                    printToPrinter1(printer: printer)
                } else {
                    printToPrinter1()
                }
            }
        } else {
            printToPrinter1()
        }
        
//        printToPrinter2()
//        printToPrinter3()
    }
    
    @objc func filePickerBtnClick(sender: UIButton) {
//        showFilesPickerAction()
        showFilesPickerAction2()
    }
    
    @objc func printImageBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
        
    }
    
    
}

//MARK: 文件选取
extension PRinHomeVC: UIDocumentBrowserViewControllerDelegate, UIDocumentPickerDelegate {
    func showFilesPickerAction() {
//        let vc = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: ["public.content","public.text","public.source-code","public.image","public.audiovisual-content","com.adobe.pdf","com.apple.keynote.key","com.microsoft.word.doc","com.microsoft.excel.xls","com.microsoft.powerpoint.ppt"])
        
        
        var documentBrowser = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: ["public.content"])
//        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(fileVCBackBtnClick(sender: )))
        
        let btnItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(fileVCBackBtnClick(sender: )))

        btnItem.width = 60
        documentBrowser.additionalTrailingNavigationBarButtonItems = [btnItem]
        
        documentBrowser.delegate = self
        documentBrowser.modalPresentationStyle = .pageSheet
        self.present(documentBrowser, animated: true)

    }
    
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        for (ind, urls) in documentURLs.enumerated() {
            debugPrint("documentURLs - \(ind) path - \(documentURLs)")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            self.printToPrinter(urlItems: documentURLs)
            self.printToPrinter(targetUrl: documentURLs[0])
        }
    }
    
    
    
    func showFilesPickerAction2() {
        
        var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .import {
            // What should be the line below?
            for (ind, url) in urls.enumerated() {
                debugPrint("documentURLs - \(ind) path - \(url)")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
    //            self.printToPrinter(urlItems: documentURLs)
                if let tarurl = urls.first {
                    self.printToPrinter(targetUrl: tarurl)
                }
                
            }
        }
    }
    
   

    
    
    @objc func fileVCBackBtnClick(sender: UIBarButtonItem) {
        self.presentedViewController?.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: 打印相关
extension PRinHomeVC {
    // UIPrinterPickerControllerをモーダル表示する
    func showPrinterPicker() {
        
        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        printerPicker.present(animated: true, completionHandler: {
            
            [unowned self] printerPickerController, userDidSelect, error in
            
            if (error != nil) {
                print("Error : \(error)")
            } else {
                // 選択したUIPrinterを取得する
                if let printer: UIPrinter = printerPickerController.selectedPrinter {
                    print("Printer displayName : \(printer.displayName)")
                    print("Printer url : \(printer.url)")
                    self.printToPrinter1(printer: printer)
                } else {
                    print("Printer is not selected")
                }
            }
        })
    }

    func printToPrinter(imgItems: [UIImage], printer: UIPrinter? = nil) {

        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
//        info.printerID = "ipps://Joe-MacBook-Pro.local.:8632/ipp/print/save"
//        info.printerID = "Save Original to Simulator @ Joe MacBook Pro"
//        info.jobName = "Sample Print"
//        info.orientation = .portrait // Portrait or Landscape
//        info.outputType = .general //ContentType
        
        printInVC.printInfo = info
        
        //        array of NSData, NSURL, UIImage.
        printInVC.printingItems = imgItems
        
        if let printer_m = printer {
            printInVC.print(to: printer_m, completionHandler: {
                controller, completed, error in
                
            })
        } else {
            printInVC.present(animated: true) {
                controller, completed, error in
                
            }
        }
    }
    func printToPrinter(urlItems: [URL], printer: UIPrinter? = nil) {

        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        let info = UIPrintInfo(dictionary: nil)
//        info.printerID = "ipps://Joe-MacBook-Pro.local.:8632/ipp/print/save"
//        info.printerID = "Save Original to Simulator @ Joe MacBook Pro"
//        info.jobName = "Sample Print"
//        info.orientation = .portrait // Portrait or Landscape
//        info.outputType = .general //ContentType
        
        printInVC.printInfo = info
        
        //        array of NSData, NSURL, UIImage.
        printInVC.printingItems = urlItems
        
        if let printer_m = printer {
            printInVC.print(to: printer_m, completionHandler: {
                controller, completed, error in
                
            })
        } else {
            printInVC.present(animated: true) {
                controller, completed, error in
                
            }
        }
    }
    
    func printToPrinter(targetUrl: URL, printer: UIPrinter? = nil) {
        
        let printInVC = UIPrintInteractionController.shared
        
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = "Sample Print"
        info.orientation = .portrait // Portrait or Landscape
        info.outputType = .general //ContentType
        
        let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        webV.load(URLRequest(url: targetUrl))
        
        printInVC.printFormatter = webV.viewPrintFormatter()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            if let printer_m = printer {
                printInVC.print(to: printer_m, completionHandler: {
                    controller, completed, error in

                })
            } else {
                printInVC.present(animated: true) {
                    controller, completed, error in

                }
            }
        }
    }
    
    // 打印预览
    func printToPrinter1(printer: UIPrinter? = nil) {

        let printImg = UIImage(named: "1.png")
        let printImg2 = UIImage(named: "2.png")
        var pringtpdf: Data?
        do {
            let printPdfData = try Data(contentsOf: Bundle.main.url(forResource: "qing", withExtension: ".pdf")!)
            pringtpdf = printPdfData
        } catch {
            
        }
        
        let printInVC = UIPrintInteractionController.shared
        printInVC.showsPaperSelectionForLoadedPapers = true
        if #available(iOS 15.0, *) {
            printInVC.showsPaperOrientation = true
        } else {
            // Fallback on earlier versions
        }
        let info = UIPrintInfo(dictionary: nil)
//        info.printerID = "ipps://Joe-MacBook-Pro.local.:8632/ipp/print/save"
//        info.printerID = "Save Original to Simulator @ Joe MacBook Pro"
//        info.jobName = "Sample Print"
//        info.orientation = .portrait // Portrait or Landscape
//        info.outputType = .general //ContentType
//        printInVC.showsPageRange = true
        
        
        
        printInVC.printInfo = info
        printInVC.printingItems = [printImg, printImg2, pringtpdf]
        if let printer_m = printer {
            printInVC.print(to: printer_m, completionHandler: {
                controller, completed, error in
                
            })
        } else {
            printInVC.present(animated: true) {
                controller, completed, error in
                
            }
        }
    }
    
    // text
    func printToPrinter2(printer: UIPrinter? = nil) {
        
        let printInVC = UIPrintInteractionController.shared
        
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = "Sample Print"
        info.orientation = .portrait // Portrait or Landscape
        info.outputType = .general //ContentType
        
        let textFormatter = UISimpleTextPrintFormatter(text: "hello world  hhhhhh!")
        textFormatter.startPage = 0
        textFormatter.perPageContentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 72)
        textFormatter.maximumContentWidth = 16 * 72.0
        printInVC.printFormatter = textFormatter
        
        if let printer_m = printer {
            printInVC.print(to: printer_m, completionHandler: {
                controller, completed, error in
                
            })
        } else {
            printInVC.present(animated: true) {
                controller, completed, error in
                
            }
        }
    }
    
    // webview
    func printToPrinter3(printer: UIPrinter? = nil) {
        
        let printInVC = UIPrintInteractionController.shared
        
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = "Sample Print"
        info.orientation = .portrait // Portrait or Landscape
        info.outputType = .general //ContentType
        
        let pdfurl = Bundle.main.url(forResource: "qing", withExtension: ".pdf")!
        
        let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        webV.load(URLRequest(url: pdfurl))
        
        printInVC.printFormatter = webV.viewPrintFormatter()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if let printer_m = printer {
                printInVC.print(to: printer_m, completionHandler: {
                    controller, completed, error in

                })
            } else {
                printInVC.present(animated: true) {
                    controller, completed, error in

                }
            }
        }
    }
    
}

extension PRinHomeVC {
    
}


extension PRinHomeVC {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
        
        let resultImg = results.croppedScan.image
        
        
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }

}

//MARK: 打印照片
extension PRinHomeVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 9
        config.library.defaultMultipleSelection = true
        config.screens = [.library]
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor = UIColor.white
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    imgs.append(photo.image)
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                self.showEditVC(images: imgs)
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
     
    func presentPhotoPickerController() {

    }
    
    func showEditVC(images: [UIImage]) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            [weak self] in
            guard let `self` = self else {return}
            self.printToPrinter(imgItems: images)
        }
     
        
    }
}



