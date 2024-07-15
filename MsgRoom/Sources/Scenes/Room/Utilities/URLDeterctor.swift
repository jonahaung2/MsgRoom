//
//  URLDeterctor.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation

public extension String {
    func webURLs() -> [String] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches.compactMap {
            guard let url = $0.url,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  components.url != nil,
                  ["http", "https"].contains(components.scheme)
            else {
                return nil
            }
            return url.absoluteString.isEmpty ? nil : url.absoluteString
        }
    }
    var isWebUrl: Bool {
        let urls = self.webURLs()
        guard urls.count == 1, let found = urls.first else { return false }
        return found == self
    }
    func emailAddresses() -> [String] {
        guard  let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches.compactMap {
            guard let url = $0.url,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  components.scheme == "mailto"
            else {
                return nil
            }
            return components.path
        }
    }
    var isEmailAddress: Bool {
        let emails = self.emailAddresses()
        guard emails.count == 1, let found = emails.first else { return false }
        return found == self
    }
    func phoneNumbers() -> [String] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue) else {
            return []
        }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches.compactMap { $0.phoneNumber }
    }
    var isPhoneNumber: Bool {
        let phoneNumbers = self.phoneNumbers()
        guard phoneNumbers.count == 1, let found = phoneNumbers.first else { return false }
        return found == self
    }
}
