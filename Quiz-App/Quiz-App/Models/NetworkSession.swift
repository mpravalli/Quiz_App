//
//  NetworkSession.swift
//  Quiz-App
//
//  Created by Makula Pravallika on 14/04/25.
//

import Foundation
protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
