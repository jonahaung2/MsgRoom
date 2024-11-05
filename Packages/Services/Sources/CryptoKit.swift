//
//  CryptoService.swift
//  Services
//
//  Created by Aung Ko Min on 5/11/24.
//

import Foundation
import Cryptor

public enum CryptoService {
    
    public static func encrypt(_ value: String) {
        guard let data = Cryptor.humanFriendlyPlainMessageToDataPlainMessage(value) else { return }
    }
}
