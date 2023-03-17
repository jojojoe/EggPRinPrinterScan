//
//  PRinPageRangeSelectView.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/16.
//

import UIKit
import PickerView

class PRinPageRangeSelectView: UIView {

    let allPageSelectImageV = UIImageView()
    var minPageCount: Int = 1
    var maxPageCount: Int = 10
    var currentMin: Int = 1
    var currentMax: Int = 10
    let pageRangeLabel = UILabel()
    let minPicker = PickerView()
    let maxPicker = PickerView()
    
    var minPickerList: [Int] = []
    var maxPickerList: [Int] = []
    
    func updatePage(min: Int, max: Int) {
        minPageCount = min
        maxPageCount = max
        currentMin = min
        currentMax = max
        
        allPageSelectImageV.isHidden = false
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor = UIColor(hexString: "#F5F5F5")
        //
        let topBannerBgV = UIView()
        addSubview(topBannerBgV)
        topBannerBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalToSuperview().offset(20)
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
        
        pageRangeLabel.text = "Pages \(currentMin)-\(currentMax)"
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
        addSubview(bottomBgV)
        bottomBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBannerBgV.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
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
        
        let minPickerCenterPoint = UIView()
        minPickerCenterPoint.backgroundColor = UIColor.white
        bottomBgV.addSubview(minPickerCenterPoint)
        
        let maxPickerCenterPoint = UIView()
        maxPickerCenterPoint.backgroundColor = UIColor.white
        bottomBgV.addSubview(maxPickerCenterPoint)
        
        for i in 0..<maxPageCount {
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
        minPicker.currentSelectedRow = currentMin - 1
        minPicker.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.right.equalTo(toLabel.snp.left).offset(-35)
            $0.width.equalTo(50)
            $0.height.equalTo(100)
        }
        
        //
        minPickerCenterPoint.snp.makeConstraints {
            $0.center.equalTo(minPicker)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        minPickerCenterPoint.layer.cornerRadius = 16
        
        //
        //
        maxPicker.backgroundColor = .clear
        maxPicker.translatesAutoresizingMaskIntoConstraints = false
        bottomBgV.addSubview(maxPicker)
        maxPicker.dataSource = self
        maxPicker.delegate = self
        maxPicker.scrollingStyle = .default
        maxPicker.selectionStyle = .none
        maxPicker.currentSelectedRow = currentMax - 1
        maxPicker.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.left.equalTo(toLabel.snp.right).offset(35)
            $0.width.equalTo(50)
            $0.height.equalTo(100)
        }
        //
        maxPickerCenterPoint.snp.makeConstraints {
            $0.center.equalTo(maxPicker)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        maxPickerCenterPoint.layer.cornerRadius = 16
        
        
    }

    @objc func allPageBtnClick(sender: UIButton) {
        allPageSelectImageV.isHidden = false
    }
    
    
}



extension PRinPageRangeSelectView: PickerViewDataSource {
    
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        if pickerView == minPicker {
            return minPickerList.count
        } else {
            return maxPickerList.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        if pickerView == minPicker {
            let item = minPickerList[row]
            return "\(item + 1)"
        } else {
            let item = maxPickerList[row]
            return "\(item + 1)"
        }
        return "1"
    }
    
}

extension PRinPageRangeSelectView: PickerViewDelegate {
    
    // MARK: - PickerViewDelegate
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 40.0
    }

    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
        if pickerView == minPicker {
            let item = minPickerList[row]
            currentMin = item + 1
            debugPrint("currentMin - \(currentMin)")
        } else {
            let item = maxPickerList[row]
            currentMax = item + 1
            debugPrint("currentMin - \(currentMax)")
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
