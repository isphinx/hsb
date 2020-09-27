//
//  MetalView.swift
//  HSB
//
//  Created by lucas lee on 26/9/20.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    typealias UIViewType = MTKView
    var renderView: RenderView
    
    func makeCoordinator() -> RenderView {
        renderView
    }
    func makeUIView(context: UIViewRepresentableContext<MetalView>) -> MTKView {
        renderView.mtkView.delegate = context.coordinator
        return renderView.mtkView
    }
    func updateUIView(_ nsView: MTKView, context: UIViewRepresentableContext<MetalView>) {
    }
}
