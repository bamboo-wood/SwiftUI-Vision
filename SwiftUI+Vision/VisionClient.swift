//
//  VisionClient.swift
//  SwiftUI+Vision
//
//  Created by 佐々木一樹 on 2024/01/05.
//

import Foundation
import Vision

final class VisionClient: ObservableObject {
    enum VisionError: Error {
        case typeNotSet
        case visionError(error: Error)
    }

    @Published var result: VisionRequestTypes = .unknown
    @Published var error: VisionError?

    @Published var detectedFrame: [CGRect] = []
    @Published var detectedPoints: [(closed: Bool, points: [CGPoint])] = []

    private var requestTypes: VisionRequestTypes.Set = []
    private var imageViewFrame: CGRect = .zero

    func configure(type: VisionRequestTypes.Set, imageViewFrame: CGRect) {
        requestTypes = type
        self.imageViewFrame = imageViewFrame
    }

    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        guard !requestTypes.isEmpty else {
            error = VisionError.typeNotSet
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
//        let requests = makeImageRequests()
        do {
//            try imageRequestHandler.perform(requests)
        } catch {
            self.error = VisionError.visionError(error: error)
        }
    }
}
