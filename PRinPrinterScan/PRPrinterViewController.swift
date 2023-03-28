//
//  PRPrinterViewController.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/13.
//

import UIKit
import Photos
import YPImagePicker

class PRPrinterViewController: UIViewController {

    var mainVC: ViewController!
    
    
    private let radarAnimation = "radarAnimation"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationLayer?.add(animationGroup!, forKey: radarAnimation)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationLayer?.removeAnimation(forKey: radarAnimation)
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
        connectBgV.layer.shadowOffset = CGSize(width: 0, height: 4)
        connectBgV.layer.shadowRadius = 10
        connectBgV.layer.shadowOpacity = 0.3
        
        //
        let connectLabel = UILabel()
        connectBgV.addSubview(connectLabel)
        connectLabel.text = "Connect Your Device"
        connectLabel.textColor = .black
        connectLabel.font = UIFont(name: "SFProText-Bold", size: 18)
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
        let leidaBgV = UIView()
        connectBgV.addSubview(leidaBgV)
        leidaBgV.backgroundColor = .clear
        leidaBgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.width.height.equalTo(62)
        }
        let first = makeRadarAnimation(showRect: CGRect(x: -10, y: -10, width: 82, height: 82), isRound: true)
        leidaBgV.layer.addSublayer(first)
        //
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
    
    private func makeRadarAnimation(showRect: CGRect, isRound: Bool) -> CALayer {
        // 1. 一个动态波
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = showRect
        // showRect 最大内切圆
        if isRound {
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height)).cgPath
        } else {
            // 矩形
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height), cornerRadius: 10).cgPath
        }
        shapeLayer.fillColor = UIColor(hexString: "#9CCAFF")!.cgColor
        // 默认初始颜色透明度
        shapeLayer.opacity = 0.0
        
        animationLayer = shapeLayer
        
        // 2. 需要重复的动态波，即创建副本
        let replicator = CAReplicatorLayer()
        replicator.frame = shapeLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 0.5
        replicator.addSublayer(shapeLayer)
        
        // 3. 创建动画组
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0)  // 开始透明度
        opacityAnimation.toValue = NSNumber(floatLiteral: 0)      // 结束时透明底
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if isRound {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0, 0, 0))      // 缩放起始大小
        } else {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
            
        }
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0))      // 缩放结束大小
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        animationGroup.duration = 2       // 动画执行时间
        animationGroup.repeatCount = HUGE   // 最大重复
        animationGroup.autoreverses = false
        
        self.animationGroup = animationGroup
        
//        shapeLayer.add(animationGroup, forKey: radarAnimation)
        
        return replicator
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
        checkAlbumAuthorization()
    }
    
    @objc func clipboardBtnClick(sender: UIButton) {
        let vc = PRPrinterClipboardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func webBtnClick(sender: UIButton) {
        let vc = PRPrinterWebPrinterVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3

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

extension PRPrinterViewController {
    
    func showPrinterVC(images: [UIImage]) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let targetUrl = PRPrinterManager.default.porcessImgToPDF(images: images)
            let pageOptionVC = PRPrinterOptionsVC(contentUrl: targetUrl)
            self.mainVC.navigationController?.pushViewController(pageOptionVC, animated: true)
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if let targetUrl = urls.first {
                    let pageOptionVC = PRPrinterOptionsVC(contentUrl: targetUrl)
                    self.mainVC.navigationController?.pushViewController(pageOptionVC, animated: true)
                }
            }
        }
    }
}

extension PRPrinterViewController: UIImagePickerControllerDelegate {
    
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
                            self.showPhotoDeniedAlert()
                        }
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.showPhotoDeniedAlert()
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.showPhotoDeniedAlert()
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.showPhotoDeniedAlert()
                        }
                    default: break
                    }
                }
            }
        }
    }
    
    func showPhotoDeniedAlert() {
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
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 9
        config.screens = [.library]
        config.library.defaultMultipleSelection = true
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
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                self.showPrinterVC(images: imgs)
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
}

