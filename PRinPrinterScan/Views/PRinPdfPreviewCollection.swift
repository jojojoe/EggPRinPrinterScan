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

    var pdfDocument: PDFDocument
    var collection: UICollectionView!
    let thumbnailCache = NSCache<NSNumber, UIImage>()
    private let downloadQueue = DispatchQueue(label: "com.printscan.pdfviewer.thumbnail")
    private let downloadQueue_big = DispatchQueue(label: "com.printscan.pdfviewer.big")
    
    var currentSheetCount: Int = 1
    var currentRangeMin: Int
    var currentRangeMax: Int
    var totalPageCount: Int
    var pdfCount: Int
    
    var loadPdfPhotoGroup = DispatchGroup()
    var urlPathListDict: [String:URL] = [:]
    var hasloadBigPDFImg: Bool = false
    
    
    
    func updatePerPage(sheetCount: Int, rangeMin: Int, rangeMax: Int, pageCount: Int) {
        self.currentSheetCount = sheetCount
        self.currentRangeMin = rangeMin
        self.currentRangeMax = rangeMax
        self.totalPageCount = pageCount
        
        collection.reloadData()
    }
    
    func processMakeNewPDFImagesUrls() -> [URL] {
        var urls: [URL] = []
        
        for indexPathItem in 0..<totalPageCount {
            let canvasBgV = UIView(frame: CGRect(x: 0, y: 0, width: pdfWidth, height: pdfHeight))
            //
            var perPages: [Int] = []
            let perPageIndexBegin = indexPathItem * currentSheetCount
            for idx in 0..<currentSheetCount {
                let pagecount = perPageIndexBegin + idx
                if pagecount < pdfCount {
                    perPages.append(pagecount)
                }
            }
            
            var imgVs: [UIImageView] = []
            for pageIdx in perPages {
                let imgV = UIImageView()
                imgV.contentMode = .scaleAspectFit
                canvasBgV.addSubview(imgV)
                imgVs.append(imgV)
                
                if let imgurl = self.urlPathListDict["\(pageIdx)"] {
                    imgV.image = try? UIImage(url: imgurl)
                }
            }
            
            if currentSheetCount == 1 {
                let img0 = imgVs[0]
                img0.frame = CGRect(x: 0, y: 0, width: canvasBgV.bounds.size.width, height: canvasBgV.bounds.size.height)
            } else if currentSheetCount == 2 {
                layoutImgsFrame(imgVs: imgVs, widCount: 1, heiCount: 2, perWid: canvasBgV.bounds.size.width, perHei: canvasBgV.bounds.size.height/2)
            } else if currentSheetCount == 4 {
                layoutImgsFrame(imgVs: imgVs, widCount: 2, heiCount: 2, perWid: canvasBgV.bounds.size.width/2, perHei: canvasBgV.bounds.size.height/2)
            } else if currentSheetCount == 6 {
                layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 2, perWid: canvasBgV.bounds.size.width/3, perHei: canvasBgV.bounds.size.height/2)
            } else if currentSheetCount == 9 {
                layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 3, perWid: canvasBgV.bounds.size.width/3, perHei: canvasBgV.bounds.size.height/3)
            } else if currentSheetCount == 16 {
                layoutImgsFrame(imgVs: imgVs, widCount: 4, heiCount: 4, perWid: canvasBgV.bounds.size.width/4, perHei: canvasBgV.bounds.size.height/4)
            }
            
            if let bigImg = canvasBgV.screenshot {
                let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
                let filePath = NSTemporaryDirectory() + "\(dateStr)\(".jpg")"
                let fileUrl = URL(fileURLWithPath: filePath)
                if let imgdata = bigImg.jpegData(compressionQuality: 0.8) {
                    do {
                        try imgdata.write(to: fileUrl)
                        urls.append(fileUrl)
                    } catch {
                        
                    }
                }
            }
        }
        
        return urls
    }
    
    init(frame: CGRect, pdfDocument: PDFDocument, rangeMin: Int, rangeMax: Int , pageCount: Int) {
        self.pdfCount = pdfDocument.pageCount
        self.pdfDocument = pdfDocument
        self.totalPageCount = pageCount
        self.currentRangeMin = rangeMin
        self.currentRangeMax = rangeMax
        super.init(frame: frame)
        
        setupV()
        loadPdfBigImg()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPdfBigImg() {
        
        let pdfPageSize = CGRect(x: 0, y: 0, width: pdfWidth, height: pdfHeight)
        
        loadPdfPhotoGroup = DispatchGroup()
        
        urlPathListDict.removeAll()
        
        for pageIdx in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIdx) {
                let pageNumber = pageIdx
                let key = NSNumber(value: pageNumber)
                let size = pdfPageSize.size
                loadPdfPhotoGroup.enter()
                downloadQueue_big.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    let thumbnail = page.thumbnail(of: size, for: .cropBox)
                    self.loadPdfPhotoGroup.leave()
                    //
                    let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
                    let filePath = NSTemporaryDirectory() + "\(dateStr)\(".jpg")"
                    let fileUrl = URL(fileURLWithPath: filePath)
                    if let imgdata = thumbnail.jpegData(compressionQuality: 0.8) {
                        try? imgdata.write(to: fileUrl)
                    }
                    
                    //
                    self.urlPathListDict["\(pageIdx)"] = fileUrl
                    
                }
            }
        }
        
        
        loadPdfPhotoGroup.notify(queue: DispatchQueue.main) {
            [weak self] in
            guard let `self` = self else {return}
            self.hasloadBigPDFImg = true
            debugPrint("has load big pdf image")
        }
        
        
    }
    
//    func updatePdfData(document: PDFDocument) {
//        pdfDocument = document
//        collection.reloadData()
//
//    }
    
    func updatePdfRange(min: Int, max: Int) {
        currentRangeMin = min
        currentRangeMax = max
        collection.reloadData()
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
    
    func layoutImgsFrame(imgVs: [UIImageView], widCount: Int, heiCount: Int, perWid: CGFloat, perHei: CGFloat) {
        
        let wid: CGFloat = perWid
        let hei: CGFloat = perHei
        var originx: CGFloat = 0
        var originy: CGFloat = 0
        
        for (indx, imgv) in imgVs.enumerated() {
            let chu = indx / widCount
            let yu = indx % widCount
            originy = CGFloat(chu) * hei
            originx = CGFloat(yu) * wid
            imgv.frame = CGRect(x: originx, y: originy, width: wid, height: hei)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDFThumbnailGridCell.self, for: indexPath)
        
        cell.canvasBgV.removeSubviews()
 
        //
        var perPages: [Int] = []
        let perPageIndexBegin = indexPath.item * currentSheetCount
        for idx in 0..<currentSheetCount {
            let pagecount = perPageIndexBegin + idx
            if pagecount < pdfCount {
                perPages.append(pagecount)
            }
        }
        
        var imgVs: [UIImageView] = []
        for pageIdx in perPages {
            let imgV = UIImageView()
            imgV.contentMode = .scaleAspectFit
            cell.canvasBgV.addSubview(imgV)
            imgVs.append(imgV)
            if let page = pdfDocument.page(at: pageIdx) {
                let pageNumber = pageIdx
                let key = NSNumber(value: pageNumber)
                if let thumbnail = thumbnailCache.object(forKey: key) {
                    imgV.image = thumbnail
                } else {
                    let size = cell.size
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
            layoutImgsFrame(imgVs: imgVs, widCount: 1, heiCount: 2, perWid: cell.bounds.size.width, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 4 {
            layoutImgsFrame(imgVs: imgVs, widCount: 2, heiCount: 2, perWid: cell.bounds.size.width/2, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 6 {
            layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 2, perWid: cell.bounds.size.width/3, perHei: cell.bounds.size.height/2)
        } else if currentSheetCount == 9 {
            layoutImgsFrame(imgVs: imgVs, widCount: 3, heiCount: 3, perWid: cell.bounds.size.width/3, perHei: cell.bounds.size.height/3)
        } else if currentSheetCount == 16 {
            layoutImgsFrame(imgVs: imgVs, widCount: 4, heiCount: 4, perWid: cell.bounds.size.width/4, perHei: cell.bounds.size.height/4)
        }
          
        cell.pageNumber = indexPath.item
        if indexPath.item + 1 >= currentRangeMin && indexPath.item + 1 <= currentRangeMax {
            cell.isHighlighted = true
        } else {
            cell.isHighlighted = false
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalPageCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRinPdfPreviewCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid: CGFloat = (UIScreen.main.bounds.width - 24 * 2 - (10 * 2) - 1) / 2
        return CGSize(width: wid, height: wid * 297.0/210.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 100
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
            self.alpha = isHighlighted ? 1 : 0.8
        }
    }

    var pageNumber = 0 {
        didSet {
            pageNumberLabel.text = String(pageNumber)
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
        contentView.addSubview(pageNumberLabel)
        pageNumberLabel.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().offset(-5)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        pageNumberLabel.textColor = UIColor.darkGray
        pageNumberLabel.font = UIFont(name: "SFProText-Black", size: 12)
        
    }
    
    
}
