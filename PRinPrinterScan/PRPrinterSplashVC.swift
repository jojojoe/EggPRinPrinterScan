//
//  PRPrinterSplashVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/21.
//

import UIKit
import EllipsePageControl


class PRPrinterSplashVC: UIViewController {

    var collection: UICollectionView!
    let theContinueBtn = UIButton()
    let infoLabel = UILabel()
    let pagecontrol = EllipsePageControl()
    var infoList: [[String: String]] = []
    var currentInfoIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let info1 = ["name": "Scan Document\nwith A Single Tap", "icon": "splashpage1"]
        let info2 = ["name": "One-click printing\nwithout complex settings", "icon": "splashpage2"]
        let info3 = ["name": "Print all documents\nWith formats", "icon": "splashpage3"]
        infoList = [info1, info2, info3]//
        
        setupV()
        
        infoLabel.text = infoList[currentInfoIndex]["name"]
        
    }
    
    func setupV() {
        view.backgroundColor = .white
        //
        let topCanvasV = UIView()
        view.addSubview(topCanvasV)
        topCanvasV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-240)
        }
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        topCanvasV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PRPrinterSplashCell.self)
        //
        
        view.addSubview(theContinueBtn)
        theContinueBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
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
        let contiArrowImgV = UIImageView()
        theContinueBtn.addSubview(contiArrowImgV)
        contiArrowImgV.image("Vector")
        contiArrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(20)
            $0.height.equalTo(11)
        }
        //
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(theContinueBtn.snp.top).offset(-20)
            $0.top.equalTo(topCanvasV.snp.bottom).offset(20)
            $0.left.equalTo(40)
        }
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 2
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.black
        infoLabel.font = UIFont(name: "SFProText-Semibold", size: 24)
        
        let pageControlBgV = UIView()
        view.addSubview(pageControlBgV)
        pageControlBgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topCanvasV.snp.bottom).offset(10)
            $0.width.equalTo(68)
            $0.height.equalTo(10)
        }
        //

        pagecontrol.frame = CGRect(x: 0, y: 0, width: 68, height: 10)
        pagecontrol.numberOfPages = infoList.count
        pagecontrol.currentPage = 0
        pagecontrol.currentColor = UIColor(hexString: "#4285F4")!
        pagecontrol.otherColor = UIColor(hexString: "#D9D9D9")!
        
        pageControlBgV.addSubview(pagecontrol)
        
        //
        
    }

}

extension PRPrinterSplashVC {
    @objc func theContinueBtnClick(sender: UIButton) {
        if currentInfoIndex == infoList.count - 1 {
            
        } else {
            currentInfoIndex += 1
            pagecontrol.currentPage = currentInfoIndex
//            infoLabel.text = infoList[currentInfoIndex]["name"]
            collection.scrollToItem(at: IndexPath(item: currentInfoIndex, section: 0), at: .centeredHorizontally, animated: true)
        }

    }
}

extension PRPrinterSplashVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PRPrinterSplashCell.self, for: indexPath)
        let item = infoList[indexPath.item]
//        let infoStr = item["name"]
        let iconStr = item["icon"]
        cell.contentImgV.image = UIImage(named: iconStr ?? "")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRPrinterSplashVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PRPrinterSplashVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collection {
            if let indexP = collection.indexPathForItem(at: CGPoint(x: view.bounds.width/2 + collection.contentOffset.x, y: 50)) {
                if indexP.item != currentInfoIndex {
                    currentInfoIndex = indexP.item
                    pagecontrol.currentPage = currentInfoIndex
                    infoLabel.text = infoList[currentInfoIndex]["name"]
                }
                
            }
        }

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}


class PRPrinterSplashCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}
