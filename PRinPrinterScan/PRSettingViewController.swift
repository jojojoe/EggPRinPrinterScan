//
//  PRSettingViewController.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit

class PRSettingViewController: UIViewController {
    
    var mainVC: ViewController!
    
    let subscribeBanner = UIButton()
    var collection: UICollectionView!
    
    let itemList: [[String : String]] = [
        ["id":"0", "icon":"Frame 10", "title":"Restore Purchase"],
        ["id":"1", "icon":"Frame 11", "title":"Share Our App"],
        ["id":"2", "icon":"Frame 8", "title":"Terms of use"],
        ["id":"3", "icon":"Frame 12", "title":"Privacy Policy"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
    }
    
    func setupV() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PRSettingCell.self)
        
        //
        
        collection.addSubview(subscribeBanner)
        subscribeBanner.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo((UIScreen.main.bounds.width - 24 * 2))
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(192.0/686.0 * (UIScreen.main.bounds.width - 24 * 2))
        }
        subscribeBanner.layer.shadowOffset = CGSize(width: 0, height: 4)
        subscribeBanner.layer.shadowColor = UIColor(hexString: "#FE9F4B")!.cgColor
        subscribeBanner.layer.shadowOpacity = 0.15
        subscribeBanner.layer.shadowRadius = 8
        subscribeBanner.addTarget(self, action: #selector(subscribeBannerClick(sender: )), for: .touchUpInside)
        
        //
        
        //
        let subBannerImagV = UIImageView()
        subBannerImagV.image = UIImage(named: "Group 129")
        subscribeBanner.addSubview(subBannerImagV)
        subBannerImagV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let subNameL = UILabel()
        subscribeBanner.addSubview(subNameL)
        subNameL.text = "PRINT PREMIUM"
        subNameL.font = UIFont(name: "SFProText-Bold", size: 18)
        subNameL.textColor = UIColor(hexString: "#A63A21")
        subNameL.snp.makeConstraints {
            $0.bottom.equalTo(subscribeBanner.snp.centerY)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.greaterThanOrEqualTo(10)
        }

        let infoNameL = UILabel()
        subscribeBanner.addSubview(infoNameL)
        infoNameL.text = "Unlock All Features"
        infoNameL.font = UIFont(name: "SFProText-Semibold", size: 12)
        infoNameL.textColor = UIColor(hexString: "#A63A21")
        infoNameL.snp.makeConstraints {
            $0.top.equalTo(subscribeBanner.snp.centerY).offset(4)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        if PRPurchaseSubManager.default.isInSubscribe {
            subscribeBanner.isHidden = true
        } else {
            subscribeBanner.isHidden = false
        }
        
        
    }
    
    
    
    @objc func subscribeBannerClick(sender: UIButton) {
        let subsVC = PRPrinterStoreVC()
        subsVC.modalPresentationStyle = .fullScreen
        self.present(subsVC, animated: true)
    }
     

}

extension PRSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: PRSettingCell.self, for: indexPath)
        let item = itemList[indexPath.item]
        let iconName = item["icon"] ?? ""
        let titleName = item["title"]
        
        cell.iconImgV.image = UIImage(named: iconName)
        cell.nameL.text = titleName
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if PRPurchaseSubManager.default.isInSubscribe {
            return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 130, left: 0, bottom: 0, right: 0)
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension PRSettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemList[indexPath.item]
        let idstr = item["id"]
        if idstr == "0" {
            // restore
        } else if idstr == "1" {
            // share
        } else if idstr == "2" {
            // terms
        } else if idstr == "3" {
            // privacy
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class PRSettingCell: UICollectionViewCell {
    let iconImgV = UIImageView()
    let nameL = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconImgV.contentMode = .scaleAspectFill
        iconImgV.backgroundColor = .clear
        iconImgV.clipsToBounds = true
        contentView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.width.height.equalTo(20)
        }
        
        //
        contentView.addSubview(nameL)
        nameL.textColor = UIColor.black
        nameL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImgV.snp.right).offset(18)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let arrowImgV = UIImageView()
        arrowImgV.image = UIImage(named: "Frame 13")
        arrowImgV.contentMode = .scaleAspectFill
        arrowImgV.backgroundColor = .clear
        arrowImgV.clipsToBounds = true
        contentView.addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
            $0.width.equalTo(16/2)
            $0.height.equalTo(24/2)
        }
        
        
    }
}

