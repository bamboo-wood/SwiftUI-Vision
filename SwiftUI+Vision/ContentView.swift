//
//  ContentView.swift
//  SwiftUI+Vision
//
//  Created by 佐々木一樹 on 2024/01/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DetectorView(image: .people, detectType: .all)
    }
}

#Preview {
    ContentView()
}
