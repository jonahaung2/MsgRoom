//
//  File.swift
//  Services
//
//  Created by Aung Ko Min on 31/10/24.
//

import Foundation
import Observation
import Models
import Database

@Observable public class DemoMsgWebSocket: NSObject {
    
    public let msgs: AsyncStream<Msg>
    private(set) var isConnected = false
    private let continuation: AsyncStream<Msg>.Continuation
    private var pollingTimer: Timer?
    private let webSocketTask: URLSessionWebSocketTask = URLSession.shared.webSocketTask(with: URL(string: "wss://ws.postman-echo.com/raw")!)
    
    public override init() {
        (msgs, continuation) = AsyncStream.makeStream(of: Msg.self)
    }
    
    public func connect() {
        webSocketTask.delegate = self
        webSocketTask.resume()
        isConnected = true
    }
    
    public func disconnect() {
        pollingTimer?.invalidate()
        webSocketTask.cancel(with: .normalClosure, reason: nil)
        isConnected = false
    }
    
    public func send(message: Msg) {
        if let data = message.data {
            webSocketTask.send(.data(data)) { error in
                if let error {
                    print(error)
                }
                self.continuation.yield(message)
            }
        }
    }
    
    public func startPolling() {
        pollingTimer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.webSocketTask.receive { [weak self] result in
                guard let self else { return }
                guard isConnected else { return }
                handle(result)
            }
        }
        RunLoop.main.add(pollingTimer!, forMode: .common)
    }
}

extension DemoMsgWebSocket: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
    }
}

private extension DemoMsgWebSocket {
    private func handle(_ result: Result<URLSessionWebSocketTask.Message, any Error>) {
        switch result {
        case .success(let success):
            switch success {
            case .data(let data):
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(Msg.self, from: data) {
                    continuation.yield(decoded)
                }
            case .string(let string):
                print(string)
            @unknown default:
                break
            }
        case .failure(_):
            break
        }
    }
}

extension PModelProxy {
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
