//
//  MsgPrefetcher.swift
//
//
//  Created by Aung Ko Min on 5/7/24.
//

import Foundation
import ImageLoader

final class ChatMsgPreFetcher: ObservableObject, ScrollViewPrefetcherDelegate {
    
    private let imagePrefetcher: ImagePrefetcher
    private let scrollViewPrefetcer: ScrollViewPrefetcher
    let urls: [URL] = []
    
    init() {
        self.imagePrefetcher = ImagePrefetcher()
        self.scrollViewPrefetcer = ScrollViewPrefetcher()
//        self.urls = demoPhotosURLs
        self.scrollViewPrefetcer.delegate = self
    }
    
    func onAppear(_ index: Int) {
        scrollViewPrefetcer.onAppear(index)
    }
    
    func onDisappear(_ index: Int) {
        scrollViewPrefetcer.onDisappear(index)
    }
    func getAllIndicesForPrefetcher(_ prefetcher: ScrollViewPrefetcher) -> Range<Int> {
        urls.indices
    }
    
    func prefetcher(_ prefetcher: ScrollViewPrefetcher, prefetchItemsAt indices: [Int]) {
        imagePrefetcher.startPrefetching(with: indices.map { urls[$0] })
    }
    func prefetcher(_ prefetcher: ScrollViewPrefetcher, cancelPrefechingForItemAt indices: [Int]) {
        imagePrefetcher.stopPrefetching(with: indices.map { urls[$0] })
    }
}

protocol ScrollViewPrefetcherDelegate: AnyObject {
    func getAllIndicesForPrefetcher(_ prefetcher: ScrollViewPrefetcher) -> Range<Int>
    func prefetcher(_ prefetcher: ScrollViewPrefetcher, prefetchItemsAt indices: [Int])
    func prefetcher(_ prefetcher: ScrollViewPrefetcher, cancelPrefechingForItemAt indices: [Int])
}

final class ScrollViewPrefetcher {
    private let prefetchWindowSize: Int
    
    weak var delegate: ScrollViewPrefetcherDelegate?
    
    private var visibleIndices: Set<Int> = []
    private var flushedVisibleIndices: Set<Int> = []
    private var isRefreshScheduled = false
    private var prefetchWindow = 0..<0
    
    init(prefetchWindowSize: Int = 12) {
        self.prefetchWindowSize = prefetchWindowSize
    }
    
    func onAppear(_ index: Int) {
        visibleIndices.insert(index)
        scheduleRefreshIfNeeded()
    }
    
    func onDisappear(_ index: Int) {
        visibleIndices.remove(index)
        scheduleRefreshIfNeeded()
    }
    
    /// SwiftUI sometimes calls onAppear in unexpected order, buffer takes care of it.
    private func scheduleRefreshIfNeeded() {
        guard !isRefreshScheduled else { return }
        isRefreshScheduled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.updatePrefetchWindow()
        }
    }
    
    private func updatePrefetchWindow() {
        isRefreshScheduled = false
        guard !visibleIndices.isEmpty else { return } // Should never happen
        
        if flushedVisibleIndices.isEmpty {
            // Showing screen for the first time
            let lowerBound = visibleIndices.max()! + 1
            updatePrefetchWindow(lowerBound..<(lowerBound + prefetchWindowSize))
        } else {
            // Need to figure out in which direction we the user is scrolling
            let isScrollingDown = visibleIndices.max()! > flushedVisibleIndices.max()!
            if isScrollingDown || visibleIndices.contains(0) {
                let lowerBound = visibleIndices.max()! + 1
                updatePrefetchWindow(lowerBound..<(lowerBound + prefetchWindowSize))
            } else {
                let upperBound = visibleIndices.min()! - 1
                updatePrefetchWindow((upperBound - prefetchWindowSize)..<upperBound)
            }
        }
        
        flushedVisibleIndices = visibleIndices
    }
    
    private func updatePrefetchWindow(_ newPrefetchWindow: Range<Int>) {
        let oldPrefetchIndices = Set(prefetchWindow)
        let newPrefetchIndices = Set(newPrefetchWindow)
        
        prefetchWindow = newPrefetchWindow
        
        let allIndices = Set(delegate?.getAllIndicesForPrefetcher(self) ?? 0..<0)
        
        let removedIndicides = oldPrefetchIndices
            .subtracting(newPrefetchIndices)
            .intersection(allIndices) // Only call for visible items
            .sorted()
        let addedIndices = newPrefetchIndices
            .subtracting(oldPrefetchIndices)
            .intersection(allIndices) // Only call for visible items
            .sorted()
        
        delegate?.prefetcher(self, prefetchItemsAt: addedIndices)
        delegate?.prefetcher(self, cancelPrefechingForItemAt: removedIndicides)
    }
}
