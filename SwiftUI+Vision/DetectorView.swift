//
//  DetectorView.swift
//  SwiftUI+Vision
//
//  Created by 佐々木一樹 on 2024/01/05.
//

import SwiftUI

struct DetectorView: View {
    let image: UIImage
    let detectType: VisionRequestTypes.Set
    @StateObject var viewModel = DetectorViewModel()

    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.6)
                .overlay {
                    GeometryReader { proxy -> AnyView in
                        viewModel.input(imageFrame: proxy.frame(in: .local))
                        return AnyView(EmptyView())
                    }
                }
//            DetectedInformationView(info: viewModel.detectedInfo)
        }
        .onAppear {
            viewModel.onAppear(image: image, detectType: detectType)
        }
    }
}

#Preview {
    DetectorView(image: UIImage(resource: .people), detectType: .all)
}
