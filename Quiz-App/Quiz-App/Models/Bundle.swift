//
//  Bundle.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 18/03/25.
//
import Foundation

private var bundleKey: UInt8 = 0

extension Bundle {
    static func setLanguage(_ languageCode: String) {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    var currentLocalizedBundle: Bundle {
        if let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle {
            return bundle
        }
        return Bundle.main
    }
}
