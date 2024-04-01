//
//  MsgCell.swift
//  Msgr
//
//  Created by Aung Ko Min on 22/10/22.
//

import SwiftUI
import XUI
struct MsgCell<MsgItem: Msgable>: View {

    @EnvironmentObject internal var chatViewModel: MsgRoomViewModel<MsgItem>
    @Environment(Msg.self) private var msg
    let style: MsgStyle

    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            } else if style.showTopPadding {
                Spacer(minLength: 15)
            }

            HStack(alignment: .bottom, spacing: 0) {
                leftView()
                
                VStack(alignment: msg.recieptType.hAlignment, spacing: 2) {
                    if style.isSelected {
                        let text = msg.recieptType == .Send ? MsgDateView.dateFormatter.string(from: msg.date) : msg.senderId
                        HiddenLabelView(text: text, padding: .top)
                    }
                    bubbleView()
                        .modifier(DraggableModifier(direction: msg.recieptType == .Send ? .left : .right))
                    if style.isSelected {
                        HiddenLabelView(text: msg.deliveryStatus.description, padding: .bottom)
                    }
                }
                rightView()
            }
        }
        .flippedUpsideDown()
        .transition(.move(edge: .top))
    }

    fileprivate func leftView() -> some View {
        Group {
            if msg.recieptType == .Send {
                Spacer(minLength: 15)
            } else {
                VStack {
                    if style.showAvatar, let contact = chatViewModel.con.contactPayload {
                        ContactAvatarView(id: contact.id, urlString: contact.photoURL.str, size: ChatKit.cellLeftRightViewWidth)
                    }
                }
                .frame(width: ChatKit.cellLeftRightViewWidth + 10)
            }
        }
    }

    fileprivate func rightView() -> some View {
        Group {
            if msg.recieptType == .Receive {
                Spacer(minLength: ChatKit.cellAlignmentSpacing)
            } else {
                VStack {
                    CellProgressView(progress: msg.deliveryStatus)
                        .padding(.trailing, 5)
                }
                .frame(width: ChatKit.cellLeftRightViewWidth)
            }
        }
    }

    internal func bubbleView() -> some View {
        Group {
            switch msg.msgType {
            case .Text:
                TextBubble(text: msg.text)
                    .foregroundColor(style.textColor)
                    .background(style.bubbleShape.fill(style.bubbleColor))
            case .Image:
                ImageBubble()
            case .Location:
                LocationBubble()
            case .Emoji:
                Text("Emoji")
            default:
                EmptyView()
            }
        }
        .gesture(
            TapGesture(count: 1)
                .onEnded {
                    
                    withAnimation {
                        chatViewModel.selectedId = msg.id == chatViewModel.selectedId ? nil : msg.id
                    }
                }
        )
    }
}
struct DraggableModifier : ViewModifier {

    enum Direction {
        case left, right, top, bottom
        var isVertical: Bool { self == .top || self == .bottom }
        var isHorizontal: Bool { self == .left || self == .right }

        func offset(for draggableOffset: CGSize) -> CGSize {
            let width = self.isVertical ? 0 : (self == .left ? min(0, draggableOffset.width) : max(0, draggableOffset.width))
            let height = self.isHorizontal ? 0 : (self == .top ? max(0, draggableOffset.height) : min(0, draggableOffset.height))

            return .init(width: width, height: height)
        }
    }

    let direction: Direction
    @State private var draggedOffset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .offset(draggedOffset)
            .highPriorityGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        let offset = direction.offset(for: value.translation)
                        let distance = abs(offset.width)
                        if distance < 200 {
                            if Int(distance) > 190 {
                                
                            } else {
                                self.draggedOffset = offset
                            }
                        }
                    }
                    .onEnded { value in
                        if draggedOffset.width != 0 {
                            draggedOffset.width = 0
                            
                        }
                    }
            )
            .onAppear {
                draggedOffset = .zero
            }
    }
}
struct ContactAvatarView: View {
    let id: String
    let urlString: String

    @State private var image: UIImage?
    let size: CGFloat
    var body: some View {
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

extension UIImage {
    func tinted(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))

        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()
        return imageColored
    }
}

extension UIImage {
    func temporaryLocalFileUrl() throws -> URL? {
        guard let imageData = jpegData(compressionQuality: 1.0) else { return nil }
        let imageName = "\(UUID().uuidString).jpg"
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imageName)
        let photoURL = URL(fileURLWithPath: localPath)
        try imageData.write(to: photoURL)
        return photoURL
    }
}
