//
//  SentimentAnalyzer.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import Foundation
import NaturalLanguage

public enum SentimentAnalyzer {
    public static func score(text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Double(sentiment?.rawValue ?? "0") ?? 0
    }
}
