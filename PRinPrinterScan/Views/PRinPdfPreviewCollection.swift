//
//  PRinPdfPreviewCollection.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/14.
//

import UIKit
import PDFKit

class PRinPdfPreviewCollection: UIView {

    var pdfDocument: PDFDocument
    var collection: UICollectionView!
    let thumbnailCache = NSCache<NSNumber, UIImage>()
    private let downloadQueue = DispatchQueue(label: "com.printscan.pdfviewer.thumbnail")
    
    
    var currentRangeMin: Int
    var currentRangeMax: Int
    
    init(frame: CGRect, pdfDocument: PDFDocument, rangeMin: Int, rangeMax: Int) {
        self.pdfDocument = pdfDocument
        self.currentRangeMin = rangeMin
        self.currentRangeMax = rangeMax
        super.init(frame: frame)
        
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePdfData(document: PDFDocument) {
        pdfDocument = document
        collection.reloadData()
        
        
    }
    
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PDFThumbnailGridCell.self, for: indexPath)
        
        if let page = pdfDocument.page(at: indexPath.item) {
            let pageNumber = indexPath.item
            cell.pageNumber = pageNumber
            let key = NSNumber(value: pageNumber)
            if let thumbnail = thumbnailCache.object(forKey: key) {
                cell.image = thumbnail
            } else {
                let size = cell.size
                downloadQueue.async {
                    let thumbnail = page.thumbnail(of: size, for: .cropBox)
                    self.thumbnailCache.setObject(thumbnail, forKey: key)
                    if cell.pageNumber == pageNumber {
                        DispatchQueue.main.async {
                            cell.image = thumbnail
                        }
                    }
                }
            }
            if indexPath.item + 1 >= currentRangeMin && indexPath.item + 1 <= currentRangeMax {
                cell.isHighlighted = true
            } else {
                cell.isHighlighted = false
            }
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocument.pageCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PRinPdfPreviewCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        210 / 297
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
    var imageView: UIImageView = UIImageView()
    var pageNumberLabel: UILabel = UILabel()

    // MARK: - Variables
    override var isHighlighted: Bool {
        didSet {
            imageView.alpha = isHighlighted ? 1 : 0.8
        }
    }
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
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
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
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
