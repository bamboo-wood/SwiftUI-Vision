//
//  DetectorViewModel.swift
//  SwiftUI+Vision
//
//  Created by 佐々木一樹 on 2024/01/05.
//

import Combine
import Foundation
import UIKit

final class DetectorViewModel: ObservableObject {
    @Published var image: UIImage = .init()

    @Published var detectedFrame: [CGRect] = []
    @Published var detectedPoints: [(closed: Bool, points: [CGPoint])] = []
    @Published var detectedInfo: [[String: String]] = []

    private var cancellables: Set<AnyCancellable> = []
    private var errorCancellables: Set<AnyCancellable> = []
    private var imageViewFramePublisher = PassthroughSubject<CGRect, Never>()
    private var originImagePublisher = PassthroughSubject<(CGImage, VisionRequestTypes.Set), Never>()

    private let visionClient = VisionClient()

    init() {
        imageViewFramePublisher
            .removeDuplicates()
            .prefix(2)
            .last()
            .combineLatest(originImagePublisher)
            .sink { imageRect, originImageArg in
                let (cgImage, detectTypes) = originImageArg
                let fullImageWidth = CGFloat(cgImage.width)
                let fullImageHeight = CGFloat(cgImage.height)
                let targetWidth = imageRect.width
                let ratio = fullImageWidth / targetWidth
                let imageFrame = CGRect(x: 0, y: 0, width: targetWidth, height: fullImageHeight / ratio)

                self.visionClient.configure(type: detectTypes, imageViewFrame: imageFrame)

                let cgOrientation = CGImagePropertyOrientation(self.image.imageOrientation)

                self.clearAllInfo()

                self.visionClient.performVisionRequest(image: cgImage, orientation: cgOrientation)
            }
            .store(in: &cancellables)
    }

    func onAppear(image: UIImage, detectType: VisionRequestTypes.Set) {
        self.image = image
        guard let resizedImage = resize(image: image) else { return }
        guard let cgImage = resizedImage.cgImage else {
            print("Trying to show an image not backed by CGImage!")
            return
        }
        originImagePublisher.send((cgImage, detectType))
    }

    func input(imageFrame: CGRect) {
        imageViewFramePublisher.send(imageFrame)
    }

    private func resize(image: UIImage) -> UIImage? {
        let width: Double = 640
        let aspectScale = image.size.height / image.size.width

        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    private func clearAllInfo() {
        detectedFrame.removeAll()
        detectedPoints.removeAll()
        detectedInfo.removeAll()
    }
}

// Convert UIImageOrientation to CGImageOrientation for use in Vision analysis.
extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}
