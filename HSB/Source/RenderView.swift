import Foundation
import MetalKit

public class RenderView: NSObject, MTKViewDelegate, ImageConsumer {
    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    var mtkView: MTKView
    var currentTexture: Texture?
    var renderPipelineState:MTLRenderPipelineState!
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    public func draw(in view: MTKView) {
        if let currentDrawable = self.mtkView.currentDrawable, let imageTexture = currentTexture {
            let commandBuffer = sharedMetalRenderingDevice.commandQueue.makeCommandBuffer()
            
            let outputTexture = Texture(
                orientation: .portrait,
                texture: currentDrawable.texture)
            
            commandBuffer?.renderQuad(
                pipelineState: renderPipelineState,
                inputTextures: [0:imageTexture],
                outputTexture: outputTexture)
            
            commandBuffer?.present(currentDrawable)
            commandBuffer?.commit()
        }
    }
    
    override init() {
        mtkView = MTKView()

        super.init()
        
        self.mtkView.device = sharedMetalRenderingDevice.device
        self.mtkView.framebufferOnly = false
        self.mtkView.autoResizeDrawable = true
        
        let (pipelineState, _) = generateRenderPipelineState(
            device:sharedMetalRenderingDevice,
            vertexFunctionName:"oneInputVertex",
            fragmentFunctionName:"passthroughFragment",
            operationName:"RenderView")
        
        self.renderPipelineState = pipelineState
        
        self.mtkView.enableSetNeedsDisplay = false
        self.mtkView.isPaused = true
    }

    
    public func newTextureAvailable(_ texture:Texture, fromSourceIndex:UInt) {
        self.mtkView.drawableSize = CGSize(width: texture.texture.width, height: texture.texture.height)
        currentTexture = texture
        self.mtkView.draw()
    }
}


