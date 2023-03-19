//
//  PRPrinterPageRangeSelectVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/17.
//

import UIKit
import PickerView
import PDFKit

class PRPrinterPageRangeSelectVC: UIViewController {

    
    var homeVC: PRPrinterOptionsVC?
    let allPageSelectImageV = UIImageView()
//    var minPageCount: Int = 1
//    var maxPageCount: Int = 10
//    var currentMin: Int = 1
//    var currentMax: Int = 10
    let pageRangeLabel = UILabel()
    let minPicker = PickerView()
    let maxPicker = PickerView()
    let pdfPreviewBgV = UIView()
    var isautoScrollNoSelect = false
    var previewCollection = PRinPdfPreviewCollection()
    
    var minPickerList: [Int] = []
    var maxPickerList: [Int] = []
    
//    func updatePage(min: Int, max: Int, document: PDFDocument, totalPageCount: Int) {
//
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
        
        //
        if PRPrinterManager.default.currentRangeMin == 1 && PRPrinterManager.default.currentRangeMax == PRPrinterManager.default.currentSheetTotalPageCount {
            allPageSelectImageV.isHidden = false
        } else {
            allPageSelectImageV.isHidden = true
        }
        
        //
        
        pdfPreviewBgV.addSubview(previewCollection)
        previewCollection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview()
        }
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
        topNameL.text = "Page Range"
        topNameL.font = UIFont(name: "SFProText-Medium", size: 16)
        topNameL.textColor = UIColor(hexString: "#000000")
        topNameL.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let topBannerBgV = UIView()
        view.addSubview(topBannerBgV)
        topBannerBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(topBanner.snp.bottom).offset(20)
            $0.height.equalTo(102)
        }
        topBannerBgV.backgroundColor = .white
        topBannerBgV.layer.cornerRadius = 12
        
        //
        let allPagesLabel = UILabel()
        allPagesLabel.text = "All Pages"
        allPagesLabel.textColor = UIColor.black
        allPagesLabel.font = UIFont(name: "SFProText-Medium", size: 14)
        topBannerBgV.addSubview(allPagesLabel)
        allPagesLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.greaterThanOrEqualTo(10)
            $0.bottom.equalTo(topBannerBgV.snp.centerY)
        }
        //
        
        topBannerBgV.addSubview(allPageSelectImageV)
        allPageSelectImageV.image = UIImage(named: "pinpaiselect_s")
        allPageSelectImageV.snp.makeConstraints {
            $0.centerY.equalTo(allPagesLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
        //
        let allPageBtn = UIButton()
        topBannerBgV.addSubview(allPageBtn)
        allPageBtn.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(allPagesLabel.snp.bottom)
        }
        allPageBtn.addTarget(self, action: #selector(allPageBtnClick(sender: )), for: .touchUpInside)
        //
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#F5F5F5")
        topBannerBgV.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(topBannerBgV.snp.centerY)
            $0.height.equalTo(1)
        }
        
        //
        
        updatePageCountLabe()
        pageRangeLabel.textColor = UIColor.black
        pageRangeLabel.font = UIFont(name: "SFProText-Medium", size: 14)
        topBannerBgV.addSubview(pageRangeLabel)
        pageRangeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.greaterThanOrEqualTo(10)
            $0.top.equalTo(topBannerBgV.snp.centerY)
        }
        
        //
        let bottomBgV = UIView()
        view.addSubview(bottomBgV)
        bottomBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBannerBgV.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-320)
        }
        
        //
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = UIColor.black
        toLabel.font = UIFont(name: "SFProText-Bold", size: 16)
        bottomBgV.addSubview(toLabel)
        toLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let minPickerCenterPoint = UIView()
        minPickerCenterPoint.backgroundColor = UIColor.white
        bottomBgV.addSubview(minPickerCenterPoint)
        
        let maxPickerCenterPoint = UIView()
        maxPickerCenterPoint.backgroundColor = UIColor.white
        bottomBgV.addSubview(maxPickerCenterPoint)
        
        for i in 0..<PRPrinterManager.default.currentSheetTotalPageCount {
            minPickerList.append(i)
            maxPickerList.append(i)
        }
        
        //
        minPicker.backgroundColor = .clear
        minPicker.translatesAutoresizingMaskIntoConstraints = false
        bottomBgV.addSubview(minPicker)
        minPicker.dataSource = self
        minPicker.delegate = self
        minPicker.scrollingStyle = .default
        minPicker.selectionStyle = .none
        minPicker.currentSelectedRow = PRPrinterManager.default.currentRangeMin - 1
        minPicker.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.right.equalTo(toLabel.snp.left).offset(-35)
            $0.width.equalTo(50)
            $0.height.equalTo(150)
        }
        
        //
        minPickerCenterPoint.snp.makeConstraints {
            $0.center.equalTo(minPicker)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        minPickerCenterPoint.layer.cornerRadius = 16
        
        //
        maxPicker.backgroundColor = .clear
        maxPicker.translatesAutoresizingMaskIntoConstraints = false
        bottomBgV.addSubview(maxPicker)
        maxPicker.dataSource = self
        maxPicker.delegate = self
        maxPicker.scrollingStyle = .default
        maxPicker.selectionStyle = .none
        maxPicker.currentSelectedRow = PRPrinterManager.default.currentRangeMax - 1
        maxPicker.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.left.equalTo(toLabel.snp.right).offset(35)
            $0.width.equalTo(50)
            $0.height.equalTo(150)
        }
        //
        maxPickerCenterPoint.snp.makeConstraints {
            $0.center.equalTo(maxPicker)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        maxPickerCenterPoint.layer.cornerRadius = 16
        
        //
        
        view.addSubview(pdfPreviewBgV)
        pdfPreviewBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(bottomBgV.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
     
    func updatePageCountLabe() {
        if PRPrinterManager.default.currentRangeMin == PRPrinterManager.default.currentRangeMax {
            pageRangeLabel.text = "Page \(PRPrinterManager.default.currentRangeMin)"
        } else {
            pageRangeLabel.text = "Pages \(PRPrinterManager.default.currentRangeMin)-\(PRPrinterManager.default.currentRangeMax)"
        }
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        self.homeVC?.updatePageRange()
        
    }
    
    
    @objc func allPageBtnClick(sender: UIButton) {
        allPageSelectImageV.isHidden = false
        
        PRPrinterManager.default.currentRangeMin = 1
        PRPrinterManager.default.currentRangeMax = PRPrinterManager.default.currentSheetTotalPageCount
        minPicker.selectRow(PRPrinterManager.default.currentRangeMin - 1, animated: true)
        maxPicker.selectRow(PRPrinterManager.default.currentRangeMax - 1, animated: true)
        updatePageCountLabe()
        updatePreviewCollection()
    }
    
}

extension PRPrinterPageRangeSelectVC {
    
    func updatePreviewCollection() {
        previewCollection.updatePdfRange()
        
    }
    
    func updateMinPage(min: Int) {
        if isautoScrollNoSelect == true {
            isautoScrollNoSelect = false
            return
        }
        
        PRPrinterManager.default.currentRangeMin = min
        if min > 1 {
            allPageSelectImageV.isHidden = true
        } else {
            if PRPrinterManager.default.currentRangeMax == PRPrinterManager.default.currentSheetTotalPageCount {
                allPageSelectImageV.isHidden = false
            }
        }
        if min > PRPrinterManager.default.currentRangeMax {
            PRPrinterManager.default.currentRangeMax = min
            isautoScrollNoSelect = true
            maxPicker.selectRow(min - 1, animated: true)
        }
        updatePageCountLabe()
        updatePreviewCollection()
    }
    
    func updateMaxPage(max: Int) {
        if isautoScrollNoSelect == true {
            isautoScrollNoSelect = false
            return
        }
        
        PRPrinterManager.default.currentRangeMax = max
        if max < PRPrinterManager.default.currentSheetTotalPageCount {
            allPageSelectImageV.isHidden = true
        } else {
            if PRPrinterManager.default.currentRangeMin == 1 {
                allPageSelectImageV.isHidden = false
            }
        }
        if max < PRPrinterManager.default.currentRangeMin {
            PRPrinterManager.default.currentRangeMin = max
            isautoScrollNoSelect = true
            minPicker.selectRow(max - 1, animated: true)
        }
        
        
        
        updatePageCountLabe()
        updatePreviewCollection()
    }
    
   
    
    
}


extension PRPrinterPageRangeSelectVC: PickerViewDataSource {
    
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        if pickerView == minPicker {
            return minPickerList.count
        } else {
            return maxPickerList.count
        }
        
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        if pickerView == minPicker {
            let item = minPickerList[row]
            return "\(item + 1)"
        } else {
            let item = maxPickerList[row]
            return "\(item + 1)"
        }
        
    }
    
}

extension PRPrinterPageRangeSelectVC: PickerViewDelegate {
    
    // MARK: - PickerViewDelegate
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 40.0
    }

    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
        if pickerView == minPicker {
            let item = minPickerList[row]
            let min = item + 1
            updateMinPage(min: min)
            debugPrint("currentMin - \(min)")
        } else {
            let item = maxPickerList[row]
            let max = item + 1
            updateMaxPage(max: max)
            debugPrint("currentMin - \(max)")
        }
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if (highlighted) {
            label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        } else {
            label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
        }
        
        if (highlighted) {
            label.textColor = UIColor(red: 66.0/255.0, green: 133.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        } else {
            label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        }
    }
     
    
}
