//
//  BundleExtension.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

//extend the bundle for app name, version, copy right and etc
extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    var version: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    var build: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    var copyright: String? {
        return object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
    }
}
