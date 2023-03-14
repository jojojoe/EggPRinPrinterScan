//
//  PRPurchaseSubManager.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/14.
//

import UIKit

class PRPurchaseSubManager: NSObject {
    static let `default` = PRPurchaseSubManager()
    
    var isInSubscribe = false
    
    override init() {
        super.init()
        loadContent()
    }

    func loadContent() {
        
    }
    
    
    
}
