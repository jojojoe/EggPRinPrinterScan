//
//  PRPrinterPageSizeSelectVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/17.
//

import UIKit

struct PRPaperSize {
    var name: String
    var pwidth: CGFloat
    var pheight: CGFloat
}


class PRPrinterPageSizeSelectVC: UIViewController {
    
    var homeVC: PRPrinterOptionsVC?
    var collection: UICollectionView!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupV()
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
        let topNameL = UILabel()
        topBanner.addSubview(topNameL)
        topNameL.text = "Paper Size"
        topNameL.font = UIFont(name: "SFProText-Medium", size: 16)
        topNameL.textColor = UIColor(hexString: "#000000")
        topNameL.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        

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
            $0.left.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(20)
            $0.height.equalTo(364)
        }
        collection.register(cellWithClass: PRpriPageSizeCell.self)
        collection.backgroundColor = .white
        collection.layer.cornerRadius = 12
        
    }
    
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        self.homeVC?.updatePaperSize()
        
    }
    
}

extension PRPrinterPageSizeSelectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PRpriPageSizeCell.self, for: indexPath)
        
        let item = PRPrinterManager.default.paperSizeList[indexPath.item]
        cell.namelabel.text = item.name
        
        if PRPrinterManager.default.currentPaperSizeItem.name == item.name {
            cell.contentImgV.isHidden = false
        } else {
            cell.contentImgV.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PRPrinterManager.default.paperSizeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRPrinterPageSizeSelectVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 24 * 2, height: 52)
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

extension PRPrinterPageSizeSelectVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = PRPrinterManager.default.paperSizeList[indexPath.item]
        PRPrinterManager.default.currentPaperSizeItem = item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class PRpriPageSizeCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let namelabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentImgV.image = UIImage(named: "pinpaiselect_s")
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
        
        let boline = UIView()
        boline.backgroundColor = UIColor(hexString: "#F5F5F5")
        contentView.addSubview(boline)
        boline.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        //
        contentView.addSubview(namelabel)
        namelabel.font = UIFont(name: "SFProText-Medium", size: 14)
        namelabel.textColor = .black
        namelabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.greaterThanOrEqualTo(10)
        }
    }
}
