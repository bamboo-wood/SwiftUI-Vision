//
//  VisionRequestTypes.swift
//  SwiftUI+Vision
//
//  Created by 佐々木一樹 on 2024/01/06.
//

import Foundation

enum VisionRequestTypes {
    case unknown
    case faceRect(rectBox: [CGRect], info: [[String: String]])
    case faceLandmarks(drawPoints: [(closed: Bool, points: [CGPoint])], info: [[String: String]])
    case word(rectBox: [CGRect], info: [[String: String]])
    case character(rectBox: [CGRect], info: [[String: String]])
    case textRecognize(info: [[String: String]])
    case barcode(rectBox: [CGRect], info: [[String: String]])
    case rectBoundingBoxes(rectBox: [CGRect])
    case rect(drawPoints: [(closed: Bool, points: [CGPoint])], info: [[String: String]])

    struct Set: OptionSet {
        typealias Element = VisionRequestTypes.Set
        let rawValue: Int8
        init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        static let faceRect = Set(rawValue: 1 << 0)
        static let faceLandmarks = Set(rawValue: 1 << 1)
        static let text = Set(rawValue: 1 << 2)
        static let textRecognize = Set(rawValue: 1 << 3)
        static let barcode = Set(rawValue: 1 << 4)
        static let rect = Set(rawValue: 1 << 5)

        static let all: Set = [.faceRect,
                               .faceLandmarks,
                               .text,
                               .barcode,
                               .rect]
    }
}
