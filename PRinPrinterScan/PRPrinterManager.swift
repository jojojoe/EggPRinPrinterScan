//
//  PRPrinterManager.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/18.
//

import UIKit
import PDFKit


class PRPrinterManager: NSObject {
    
    static let `default` = PRPrinterManager()
    
    var document: PDFDocument = PDFDocument()
    
    let pdfWidth: CGFloat = 595
    let pdfHeight: CGFloat = 842

    let paperSizeList: [PRPaperSize] = [
        PRPaperSize(name: "A4", pwidth: 210 * 2, pheight: 297 * 2),
        PRPaperSize(name: "A3", pwidth: 297 * 2, pheight: 420 * 2),
        PRPaperSize(name: "B5", pwidth: 176 * 2, pheight: 250 * 2),
        PRPaperSize(name: "JIS B5", pwidth: 182 * 2, pheight: 257 * 2),
        PRPaperSize(name: "Legal", pwidth: 216 * 2, pheight: 356 * 2),
        PRPaperSize(name: "Lettler", pwidth: 216 * 2, pheight: 279 * 2),
        PRPaperSize(name: "Tabloid", pwidth: 279 * 2, pheight: 432 * 2)
    ]

    var currentPaperSizeItem: PRPaperSize = PRPaperSize(name: "A4", pwidth: 210 * 2, pheight: 297 * 2)
    
    
    private let downloadQueue_big = DispatchQueue(label: "com.printscan.pdfviewer.big")
    var loadPdfPhotoGroup = DispatchGroup()
    var urlPathListDict: [String:URL] = [:]
    var hasloadBigPDFImg: Bool = false
    
    
    var currentRangeMin: Int = 1
    var currentRangeMax: Int = 1
    var currentSheetTotalPageCount: Int = 1 // 下面预览的总页面数（选择完每页展示多少pdf page 后的页面数 小于 pdf的文件页面个数 ）
    
    var currentSheetStr: String = "1"
    
    
    func updateAndProcessSheetPageTotalCount(sheetStr: String) {
        currentSheetStr = sheetStr
        var sheetPageCount: Int = 0
        
        let perCount: Int = sheetStr.int ?? 1
        let documentPageCount = document.pageCount
        let chushu = documentPageCount / perCount
        let yushu = documentPageCount % perCount
        if yushu == 0 {
            sheetPageCount = chushu
        } else {
            sheetPageCount = chushu + 1
        }
        currentSheetTotalPageCount = sheetPageCount
        currentRangeMin = 1
        currentRangeMax = sheetPageCount
    }
    
    func loadPdfBigImg() {
        
        let pdfPageSize = CGRect(x: 0, y: 0, width: PRPrinterManager.default.currentPaperSizeItem.pwidth, height: PRPrinterManager.default.currentPaperSizeItem.pheight)
        loadPdfPhotoGroup = DispatchGroup()
        urlPathListDict.removeAll()
        
        for pageIdx in 0..<document.pageCount {
            if let page = document.page(at: pageIdx) {
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
    
    func processMakeNewPDFImagesUrls() -> [URL] {
        var urls: [URL] = []
        
        for indexPathItem in 0..<currentSheetTotalPageCount {
            let canvasBgV = UIView(frame: CGRect(x: 0, y: 0, width: PRPrinterManager.default.currentPaperSizeItem.pwidth, height: PRPrinterManager.default.currentPaperSizeItem.pheight))
            //
            let currentSheetCount = currentSheetStr.int ?? 1
            
            var perPages: [Int] = []
            let perPageIndexBegin = indexPathItem * currentSheetCount
            for idx in 0..<(currentSheetStr.int ?? 1) {
                let pagecount = perPageIndexBegin + idx
                if pagecount < document.pageCount {
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
    
}

extension PRPrinterManager {
    
    func porcessImgToPDF(image: UIImage) -> Data {
        
        let pdfData = NSMutableData()
        let pagesize = CGRect(x: 0, y: 0, width: PRPrinterManager.default.currentPaperSizeItem.pwidth, height: PRPrinterManager.default.currentPaperSizeItem.pheight)
        UIGraphicsBeginPDFContextToData(pdfData, pagesize, nil)
        let bounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = bounds.size.width
        let pdfHeight = bounds.size.height
        UIGraphicsBeginPDFPage()
        let imageW = image.size.width
        let imageH = image.size.height
        if (imageW <= pdfWidth && imageH <= pdfHeight) {
            let originX = (pdfWidth - imageW) / 2
            let originY = (pdfHeight - imageH) / 2
            image.draw(in: CGRect(x: originX, y: originY, width: imageW, height: imageH))

        } else {
            var widthm: CGFloat = 0
            var heightm: CGFloat = 0
            if ((imageW / imageH) > (pdfWidth / pdfHeight)) {
                widthm = pdfWidth
                heightm = widthm * imageH / imageW
            } else {
                heightm = pdfHeight;
                widthm = heightm * imageW / imageH;
            }
            image.draw(in: CGRect(x: (pdfWidth - widthm) / 2, y: (pdfHeight - heightm) / 2, width: widthm, height: heightm))
            
        }
        UIGraphicsEndPDFContext()
        
        return Data(pdfData)
    }
    
    
    func porcessImgToPDF(images: [UIImage]) -> URL {
        
        let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
        let filePath = NSTemporaryDirectory() + "\(dateStr)\(".pdf")"
        
        UIGraphicsBeginPDFContextToFile(filePath, .zero, nil)
        
        let bounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = bounds.size.width
        let pdfHeight = bounds.size.height
        
        for image in images {
            
            UIGraphicsBeginPDFPage()
            let imageW = image.size.width
            let imageH = image.size.height
            if (imageW <= pdfWidth && imageH <= pdfHeight) {
                let originX = (pdfWidth - imageW) / 2
                let originY = (pdfHeight - imageH) / 2
                image.draw(in: CGRect(x: originX, y: originY, width: imageW, height: imageH))
            } else {
                var widthm: CGFloat = 0
                var heightm: CGFloat = 0
                
                if ((imageW / imageH) > (pdfWidth / pdfHeight)) {
                    widthm = pdfWidth
                    heightm = widthm * imageH / imageW
                } else {
                    heightm = pdfHeight;
                    widthm = heightm * imageW / imageH;
                }
                image.draw(in: CGRect(x: (pdfWidth - widthm) / 2, y: (pdfHeight - heightm) / 2, width: widthm, height: heightm))
            }
        }
        
        UIGraphicsEndPDFContext()
        let url = URL(fileURLWithPath: filePath)
        return url
    }
    
}
