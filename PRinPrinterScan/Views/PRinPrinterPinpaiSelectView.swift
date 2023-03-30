//
//  PRinPrinterPinpaiSelectView.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit

class PRinPrinterPinpaiSelectView: UIView {
    var collection: UICollectionView!
    var closeClickBlock: (()->Void)?
    var contentItemClickBlock: (()->Void)?
    var currentIndexP: IndexPath?
    var list: [String] = [
        "HP",
        "Canon",
        "Lenovn",
        "Brother",
        "Epson",
        "Samsung",
        "Konica",
        "Toshiba",
        "Lexmark",
        "Pantum",
        "Kyocera",
        "Ricoh",
        "Sharp",
        "TA Triumph-Adler",
        "Savin",
        "Lanier",
        "NRG",
        "Gestetner",
        "Xerox",
        "Olivetti",
        "OKI",
        "Fiji Xerox",
        "Develop",
        "Sindoh",
        "Infotec",
        "Aurora",
        "Dell",
        "Muratec",
        "Panasonic",
        "FUJIFIRE",
        "Deli",
        "NEC",
        "Star Micronics",
        "NTT",
        "KODAK",
        "Xiaomi",
        "G&G",
        "f+ imaging",
        "ZINK",
        "LG",
        "Prink",
        "Rollo",
        "Riso",
        "Other"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        seupC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seupC() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //
        let bgBtn = UIButton()
        addSubview(bgBtn)
        bgBtn.setImage(UIImage(named: ""), for: .normal)
        bgBtn.snp.makeConstraints {
            $0.left.top.bottom.right.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(closeBtnClick(sender: )), for: .touchUpInside)
        //
        let contentBgV = UIView()
        contentBgV.backgroundColor = .white
        contentBgV.layer.cornerRadius = 20
        addSubview(contentBgV)
        contentBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(6)
            $0.right.equalToSuperview().offset(-6)
            $0.bottom.equalToSuperview().offset(-6)
            $0.height.equalTo(425)
        }
        //
        let topL = UILabel()
        contentBgV.addSubview(topL)
        topL.text = "Select Printer Brand"
        topL.font = UIFont(name: "SFProText-Semibold", size: 20)
        topL.textColor = UIColor.black
        topL.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let closeBtn = UIButton()
        contentBgV.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.snp.makeConstraints {
            $0.centerY.equalTo(topL.snp.centerY)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        contentBgV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-5)
            $0.top.equalTo(closeBtn.snp.bottom).offset(2)
        }
        collection.register(cellWithClass: PRPrinterPinPaiCell.self)
        
    }
    
    @objc func closeBtnClick(sender: UIButton?) {
        closeClickBlock?()
    }

}

extension PRinPrinterPinpaiSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PRPrinterPinPaiCell.self, for: indexPath)
        let item = list[indexPath.item]
        cell.nameL.text = item
        
        if currentIndexP?.item == indexPath.item {
            cell.arrowImgV.isHighlighted = true
        } else {
            cell.arrowImgV.isHighlighted = false
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

extension PRinPrinterPinpaiSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 24 - 12, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension PRinPrinterPinpaiSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currentIndexP = indexPath
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            [weak self] in
            guard let `self` = self else {return}
            self.contentItemClickBlock?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class PRPrinterPinPaiCell: UICollectionViewCell {
    
    let nameL = UILabel()
    let arrowImgV = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor(hexString: "#F5F5F5")
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        //
        contentView.addSubview(nameL)
        nameL.font = UIFont(name: "SFProText-Medium", size: 14)
        nameL.textColor = UIColor.black
        nameL.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(contentView.snp.left).offset(18)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        
        arrowImgV.image = UIImage(named: "pinpaiselect_n")
        arrowImgV.highlightedImage = UIImage(named: "pinpaiselect_s")
        arrowImgV.contentMode = .scaleAspectFill
        arrowImgV.backgroundColor = .clear
        arrowImgV.clipsToBounds = true
        contentView.addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        
    }
}
