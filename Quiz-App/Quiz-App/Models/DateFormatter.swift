//
//  DateFormatter.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 17/03/25.
//

import Foundation
extension DateFormatter {
    public static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
