//
//  ContactAvatarView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI

public struct ContactAvatarView: View {
    let id: String
    let urlString: String
    
    @State private var image: UIImage?
    let size: CGFloat
    
    init(id: String, urlString: String, image: UIImage? = nil, size: CGFloat) {
        self.id = id
        self.urlString = urlString
        self.image = image
        self.size = size
    }
    public var body: some View {
        ZStack {
            let url = self.url
            let image = self.image ?? UIImage(contentsOfFile: url.path)
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .task {
                        if let image = await downloadImageFrom(urlString: urlString, localPath: url.path) {
                            self.image = image
                        }
                    }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func downloadImageFrom(urlString: String?, localPath: String) async -> UIImage? {
        guard let urlString, let url = URL(string: urlString) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)?.resized(to: .init(width: 75, height: 75))
            try image?.jpegData(compressionQuality: 1)?.write(to: URL(filePath: localPath))
            return image
        } catch {
            print(error)
            return nil
        }
    }
    
    private var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(self.id).jpg")
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            try? FileManager.default.createDirectory(atPath: path.absoluteString, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}


extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
        CGSize(
            width: size.width * widthRatio,
            height: size.height * widthRatio
        )
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
extension UIImage {
    static let circleImage: UIImage = {
        let size: CGSize = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        let circleImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return circleImage
    }()
}
