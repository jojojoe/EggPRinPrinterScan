//
//  PRPrinterViewController.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/13.
//

import UIKit

class PRPrinterViewController: UIViewController {

    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
    }
    
    func setupContent() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        //
        let topLabel1 = UILabel()
        view.addSubview(topLabel1)
        topLabel1.font = UIFont(name: "SFProText-Black", size: 24)
        topLabel1.textColor = UIColor(hexString: "#4285F4")
        topLabel1.text = "SUPER"
        topLabel1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let topLabel2 = UILabel()
        view.addSubview(topLabel2)
        topLabel2.font = UIFont(name: "SFProText-Black", size: 24)
        topLabel2.textColor = UIColor.black
        topLabel2.text = "PRINTER"
        topLabel2.snp.makeConstraints {
            $0.left.equalTo(topLabel1.snp.right).offset(5)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let connectBgV = UIView()
        connectBgV.backgroundColor = .white
        connectBgV.layer.cornerRadius = 18
        view.addSubview(connectBgV)
        connectBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(110)
            $0.top.equalTo(topLabel1.snp.bottom).offset(24)
        }
        connectBgV.layer.shadowColor = UIColor.lightGray.cgColor
        connectBgV.layer.shadowOffset = CGSize(width: 0, height: 2)
        connectBgV.layer.shadowRadius = 10
        connectBgV.layer.shadowOpacity = 0.8
        
        //
        let connectLabel = UILabel()
        connectBgV.addSubview(connectLabel)
        connectLabel.text = "Connect Your Device"
        connectLabel.textColor = .black
        connectLabel.font = UIFont(name: "SFProText-Semibold", size: 18)
        connectLabel.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.top.equalToSuperview().offset(26)
            $0.width.height.greaterThanOrEqualTo(12)
        }
        
        //
        let connectBtn = UIButton()
        connectBtn.backgroundColor = UIColor(hexString: "#4285F4")
        connectBtn.setTitle("Connect", for: .normal)
        connectBtn.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14)
        connectBtn.setTitleColor(.white, for: .normal)
        connectBtn.layer.cornerRadius = 16
        connectBgV.addSubview(connectBtn)
        connectBtn.snp.makeConstraints {
            $0.left.equalTo(connectLabel.snp.left)
            $0.top.equalTo(connectLabel.snp.bottom).offset(10)
            $0.width.equalTo(90)
            $0.height.equalTo(32)
        }
        connectBtn.addTarget(self, action: #selector(connectBtnClick(sender: )), for: .touchUpInside)
        
        //
        let connectImgV = UIImageView()
        connectImgV.contentMode = .scaleAspectFit
        connectBgV.addSubview(connectImgV)
        connectImgV.image = UIImage(named: "homemainprinter1")
        connectImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.width.height.equalTo(62)
        }
        //
        let btnHeight: CGFloat = 152
        //
        let documentBtn = PRinMPrintBottomBtn()
        view.addSubview(documentBtn)
        documentBtn.iconImgV.image = UIImage(named: "docume")
        documentBtn.nameL.text = "Document"
        documentBtn.infoL.text = "Print any document"
        documentBtn.addTarget(self, action: #selector(documentBtnClick(sender: )), for: .touchUpInside)
        documentBtn.snp.makeConstraints {
            $0.left.equalTo(connectBgV.snp.left)
            $0.right.equalTo(view.snp.centerX).offset(-12)
            $0.top.equalTo(connectBgV.snp.bottom).offset(24)
            $0.height.equalTo(btnHeight)
        }
        
        //
        let photoBtn = PRinMPrintBottomBtn()
        view.addSubview(photoBtn)
        photoBtn.iconImgV.image = UIImage(named: "photos")
        photoBtn.nameL.text = "Photo"
        photoBtn.infoL.text = "Print from gallery"
        photoBtn.addTarget(self, action: #selector(photoBtnClick(sender: )), for: .touchUpInside)
        photoBtn.snp.makeConstraints {
            $0.right.equalTo(connectBgV.snp.right)
            $0.left.equalTo(view.snp.centerX).offset(12)
            $0.top.equalTo(documentBtn.snp.top)
            $0.height.equalTo(btnHeight)
        }
        
        //
        let clipboardBtn = PRinMPrintBottomBtn()
        view.addSubview(clipboardBtn)
        clipboardBtn.iconImgV.image = UIImage(named: "copiese")
        clipboardBtn.nameL.text = "Clipboard"
        clipboardBtn.infoL.text = "Print my clipboard"
        clipboardBtn.addTarget(self, action: #selector(clipboardBtnClick(sender: )), for: .touchUpInside)
        clipboardBtn.snp.makeConstraints {
            $0.left.equalTo(documentBtn.snp.left)
            $0.right.equalTo(documentBtn.snp.right)
            $0.top.equalTo(documentBtn.snp.bottom).offset(24)
            $0.height.equalTo(btnHeight)
        }
        
        //
        let webBtn = PRinMPrintBottomBtn()
        view.addSubview(webBtn)
        webBtn.iconImgV.image = UIImage(named: "web")
        webBtn.nameL.text = "Web"
        webBtn.infoL.text = "Print any websites"
        webBtn.addTarget(self, action: #selector(webBtnClick(sender: )), for: .touchUpInside)
        webBtn.snp.makeConstraints {
            $0.left.equalTo(photoBtn.snp.left)
            $0.right.equalTo(photoBtn.snp.right)
            $0.top.equalTo(clipboardBtn.snp.top)
            $0.height.equalTo(btnHeight)
        }
    }
    
    @objc func connectBtnClick(sender: UIButton) {
        showConnectPinPai()
    }
    
    @objc func documentBtnClick(sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.mainVC.present(documentPicker, animated: true)
    }
    
    @objc func photoBtnClick(sender: UIButton) {
        
    }
    
    @objc func clipboardBtnClick(sender: UIButton) {
        
    }
    
    @objc func webBtnClick(sender: UIButton) {
        
    }
    
}

extension PRPrinterViewController {
    func showConnectPinPai() {
        let printerBrandV = PRinPrinterPinpaiSelectView()
        self.mainVC.view.addSubview(printerBrandV)
        printerBrandV.alpha = 0
        printerBrandV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            printerBrandV.alpha = 1
        } completion: { _ in
            
        }
        printerBrandV.closeClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async { [unowned printerBrandV] in
                UIView.animate(withDuration: 0.3, delay: 0) {
                    printerBrandV.alpha = 0
                } completion: { finished in
                    if finished {
                        printerBrandV.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    
    
    
    
}

class PRinMPrintBottomBtn: UIButton {
    
    let iconImgV = UIImageView()
    let nameL = UILabel()
    let infoL = UILabel()
    
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8

        //
        
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        
        //
        addSubview(nameL)
        nameL.textColor = .black
        nameL.font = UIFont(name: "SFProText-Medium", size: 16)
        nameL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(8)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        addSubview(infoL)
        infoL.textColor = .darkGray
        infoL.font = UIFont(name: "SFProText-Regular", size: 12)
        infoL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameL.snp.bottom).offset(4)
            $0.width.height.greaterThanOrEqualTo(10)
        }
    }
    
    
    
    
}

extension PRPrinterViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .import {
            // What should be the line below?
            for (ind, url) in urls.enumerated() {
                debugPrint("documentURLs - \(ind) path - \(url)")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                let pageOptionVC = PRPrinterOptionsVC(contentUrls: urls)
                self.mainVC.navigationController?.pushViewController(pageOptionVC, animated: true)
            }
        }
    }
}


