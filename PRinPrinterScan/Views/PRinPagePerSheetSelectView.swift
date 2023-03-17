//
//  PRinPagePerSheetSelectView.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit

class PRinPagePerSheetSelectView: UIView {
    var list: [String] = ["1", "2", "4", "6", "9", "16"]
    var currentItem: String = "1"
    var collection: UICollectionView!
    var perSheetSelectBlock: ((String)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        seupC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seupC() {
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PRPrinterPerSheetCell.self)
        
        
    }
    
    
    
    
}

extension PRinPagePerSheetSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PRPrinterPerSheetCell.self, for: indexPath)
        let item = list[indexPath.item]
        let iconName = "sheet\(indexPath.item + 1)"
        cell.iconImgV.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        cell.nameL.text = "\(indexPath.item)"
        if currentItem == item {
            cell.imgBgV.backgroundColor = UIColor(hexString: "#4285F4")
            cell.iconImgV.tintColor = UIColor(hexString: "#FFFFFF")
        } else {
            cell.imgBgV.backgroundColor = UIColor(hexString: "#F5F5F5")
            cell.iconImgV.tintColor = UIColor(hexString: "#4285F4")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRinPagePerSheetSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wi: CGFloat = ((UIScreen.main.bounds.width - 24 * 2 - 16 * 2) - (5 * 10) - 1) / 6
        return CGSize(width: wi, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension PRinPagePerSheetSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        perSheetSelectBlock?(item)
        currentItem = item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class PRPrinterPerSheetCell: UICollectionViewCell {
    
    let iconImgV = UIImageView()
    let nameL = UILabel()
    let imgBgV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor(hexString: "#FFFFFF")
        
        contentView.clipsToBounds = true
        //
        
        contentView.addSubview(imgBgV)
        imgBgV.layer.cornerRadius = 10
        imgBgV.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(self.bounds.width)
        }
        imgBgV.backgroundColor = UIColor(hexString: "#F5F5F5")
//        imgBgV.backgroundColor = UIColor(hexString: "#4285F4")
        
        //
        iconImgV.contentMode = .scaleAspectFit
        iconImgV.backgroundColor = .clear
        iconImgV.clipsToBounds = true
        imgBgV.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalToSuperview().offset(8)
        }
        //
        contentView.addSubview(nameL)
        nameL.textColor = UIColor(hexString: "#666666")
        nameL.font = UIFont(name: "SFProText-Regular", size: 10)
        nameL.snp.makeConstraints {
            $0.top.equalTo(imgBgV.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
    }
}
