//
//  PRinPdfPreviewCollection.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/14.
//

import UIKit
import Foundation
import PDFKit

class PRinPdfPreviewCollection: UIView {

    var collection: UICollectionView!
    let thumbnailCache = NSCache<NSNumber, UIImage>()
    private let downloadQueue = DispatchQueue(label: "com.printscan.pdfviewer.thumbnail")
    
    
    func updatePerPage() {
        collection.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePdfRange() {

        collection.reloadData()
    }
    
    func updateContentSize() {
        
    }
    
    func setupV() {
        
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
        collection.register(cellWithClass: PDFThumbnailGridCell.self)
    }
    
   

}

extension PRinPdfPreviewCollection: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDFThumbnailGridCell.self, for: indexPath)
        
        cell.canvasBgV.removeSubviews()
 
        let currentSheetCount = PRPrinterManager.default.currentSheetStr.int ?? 1
        //
        var perPages: [Int] = []
        let perPageIndexBegin = indexPath.item * currentSheetCount
        for idx in 0..<currentSheetCount {
            let pagecount = perPageIndexBegin + idx
            if pagecount < PRPrinterManager.default.document.pageCount {
                perPages.append(pagecount)
            }
        }
        
        var imgVs: [UIImageView] = []
        for pageIdx in perPages {
            let imgV = UIImageView()
            imgV.contentMode = .scaleAspectFit
            cell.canvasBgV.addSubview(imgV)
            imgVs.append(imgV)
            
            if let page = PRPrinterManager.default.document.page(at: pageIdx) {
                let pageNumber = pageIdx
                let key = NSNumber(value: pageNumber)
                if let thumbnail = thumbnailCache.object(forKey: key) {
                    imgV.image = thumbnail
                } else {
                    let size = CGSize(width: cell.size.width * 2, height: cell.size.height * 2)
                    downloadQueue.async {
                        let thumbnail = page.thumbnail(of: size, for: .cropBox)
                        self.thumbnailCache.setObject(thumbnail, forKey: key)
                        if cell.pageNumber == pageNumber {
                            DispatchQueue.main.async {
                                imgV.image = thumbnail
                            }
                        }
                    }
                }
            }
        }
        
        if currentSheetCount == 1 {
            let img0 = imgVs[0]
            img0.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
        } else if currentSheetCount == 2 {
            PRPrinterManager.default.layoutImgsFrame(imgVs: imgVs, widCount: 1, heiCount: 2, perWid: cell.bounds.size.width, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 4 {
            PRPrinterManager.default.layoutImgsFrame(imgVs: imgVs, widCount: 2, heiCount: 2, perWid: cell.bounds.size.width/2, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 6 {
            PRPrinterManager.default.layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 2, perWid: cell.bounds.size.width/3, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 9 {
            PRPrinterManager.default.layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 3, perWid: cell.bounds.size.width/3, perHei: cell.bounds.size.height/3)
        } else if currentSheetCount == 16 {
            PRPrinterManager.default.layoutImgsFrame(imgVs: imgVs, widCount: 4, heiCount: 4, perWid: cell.bounds.size.width/4, perHei: cell.bounds.size.height/4)
        }
        
        cell.allPage = PRPrinterManager.default.currentSheetTotalPageCount
        cell.pageNumber = indexPath.item
        cell.canvasBgV.layer.borderColor = UIColor.black.cgColor
        
        if indexPath.item + 1 >= PRPrinterManager.default.currentRangeMin && indexPath.item + 1 <= PRPrinterManager.default.currentRangeMax {
            cell.isHighlighted = true
            cell.canvasBgV.layer.borderWidth = 2
        } else {
            cell.isHighlighted = false
            cell.canvasBgV.layer.borderWidth = 0
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PRPrinterManager.default.currentSheetTotalPageCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRinPdfPreviewCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid: CGFloat = (UIScreen.main.bounds.width - 24 * 2 - (10 * 2) - 1) / 2
        
        return CGSize(width: wid, height: wid / (PRPrinterManager.default.currentPaperSizeItem.pwidth / PRPrinterManager.default.currentPaperSizeItem.pheight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 200
    }
    
}

extension PRinPdfPreviewCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class PDFThumbnailGridCell: UICollectionViewCell {

    // MARK: - Outlets
    var canvasBgV = UIView()
    var pageNumberLabel: UILabel = UILabel()

    // MARK: - Variables
    override var isHighlighted: Bool {
        didSet {
//            self.alpha = isHighlighted ? 1 : 0.4
        }
    }
    var allPage: Int = 1
    var pageNumber = 0 {
        didSet {
            pageNumberLabel.text = "Page \(pageNumber+1) of \(allPage)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupV() {
        contentView.backgroundColor = .white
        
        //
        canvasBgV.backgroundColor = .clear
        contentView.addSubview(canvasBgV)
        canvasBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let pageNumbBgV = UIView()
        contentView.addSubview(pageNumbBgV)
        pageNumbBgV.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        //
        contentView.addSubview(pageNumberLabel)
        pageNumberLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        pageNumberLabel.textColor = UIColor.white
        pageNumberLabel.font = UIFont(name: "SFProText-Black", size: 8)
        pageNumberLabel.adjustsFontSizeToFitWidth = true
        pageNumbBgV.snp.makeConstraints {
            $0.center.equalTo(pageNumberLabel)
            $0.height.equalTo(20)
            $0.left.equalTo(pageNumberLabel.snp.left).offset(-10)
            $0.right.equalTo(pageNumberLabel.snp.right).offset(10)
        }
        pageNumbBgV.layer.cornerRadius = 10
        
    }
    
    
}
