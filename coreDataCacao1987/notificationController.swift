//
//  notificationController.swift
//  coreDataCacao1987
//
//  Created by Rudi Krämer on 30.03.18.
//  Copyright © 2018 Rudi Krämer. All rights reserved.
//

import Foundation
import CloudCore
import os.log

class CloudCoreDelegateHandler: CloudCoreDelegate {
    
    func willSyncFromCloud() {
        os_log("🔁 Started fetching from iCloud", log: OSLog.default, type: .debug)
        DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

    }
    
    func didSyncFromCloud() {
        os_log("✅ Finishing fetching from iCloud", log: OSLog.default, type: .debug)
        DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func willSyncToCloud() {
        os_log("💾 Started saving to iCloud", log: OSLog.default, type: .debug)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func didSyncToCloud() {
        os_log("✅ Finished saving to iCloud", log: OSLog.default, type: .debug)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func error(error: Error, module: Module?) {
        print("⚠️ CloudCore error detected in module \(String(describing: module)): \(error)")
    }
    
}
