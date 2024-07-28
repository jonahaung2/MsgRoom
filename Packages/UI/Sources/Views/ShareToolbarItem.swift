//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 26/7/24.
//

import SwiftUI

struct ShareToolbarItem: ToolbarContent, @unchecked Sendable {
    let url: URL
    let type: DisplayType
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if type == .image {
                let transferable = MediaUIImageTransferable(url: url)
                ShareLink(item: transferable, preview: .init("status.media.contextmenu.share",
                                                             image: transferable))
            } else {
                ShareLink(item: url)
            }
        }
    }
}
struct MediaUIImageTransferable: Codable, Transferable {
    let url: URL
    
    func fetchData() async -> Data {
        do {
            return try await URLSession.shared.data(from: url).0
        } catch {
            return Data()
        }
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .jpeg) { transferable in
            await transferable.fetchData()
        }
    }
}
enum DisplayType {
    case image
    case av
    
    init(from attachmentType: MediaAttachment.SupportedType) {
        switch attachmentType {
        case .image:
            self = .image
        case .video, .gifv, .audio:
            self = .av
        }
    }
}
public struct MediaAttachment: Codable, Identifiable, Hashable, Equatable {
  public struct MetaContainer: Codable, Equatable {
    public struct Meta: Codable, Equatable {
      public let width: Int?
      public let height: Int?
    }

    public let original: Meta?
  }

  public enum SupportedType: String {
    case image, gifv, video, audio
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public let id: String
  public let type: String
  public var supportedType: SupportedType? {
    SupportedType(rawValue: type)
  }

  public var localizedTypeDescription: String? {
    if let supportedType {
      switch supportedType {
      case .image:
        return NSLocalizedString("accessibility.media.supported-type.image.label", bundle: .main, comment: "A localized description of SupportedType.image")
      case .gifv:
        return NSLocalizedString("accessibility.media.supported-type.gifv.label", bundle: .main, comment: "A localized description of SupportedType.gifv")
      case .video:
        return NSLocalizedString("accessibility.media.supported-type.video.label", bundle: .main, comment: "A localized description of SupportedType.video")
      case .audio:
        return NSLocalizedString("accessibility.media.supported-type.audio.label", bundle: .main, comment: "A localized description of SupportedType.audio")
      }
    }
    return nil
  }

  public let url: URL?
  public let previewUrl: URL?
  public let description: String?
  public let meta: MetaContainer?

  public static func imageWith(url: URL) -> MediaAttachment {
    .init(id: UUID().uuidString,
          type: "image",
          url: url,
          previewUrl: url,
          description: nil,
          meta: nil)
  }

  public static func videoWith(url: URL) -> MediaAttachment {
    .init(id: UUID().uuidString,
          type: "video",
          url: url,
          previewUrl: url,
          description: nil,
          meta: nil)
  }
}

extension MediaAttachment: Sendable {}
extension MediaAttachment.MetaContainer: Sendable {}
extension MediaAttachment.MetaContainer.Meta: Sendable {}
extension MediaAttachment.SupportedType: Sendable {}
