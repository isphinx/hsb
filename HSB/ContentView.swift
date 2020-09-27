//
//  ContentView.swift
//  HSB
//
//  Created by lucas lee on 24/9/20.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    @State var open = false
    @State var modal = false
    @State var hueValue : Double = 88.0
    @State var satValue : Double = 1.0
    @State var briValue : Double = 0.0
    
    var picture = PictureInput(image:UIImage(named:"Neon-Source.png")!)
    var hueFilter = HueAdjustment()
    var satFilter = SaturationAdjustment()
    var briFilter = BrightnessAdjustment()
    var metalRender = RenderView()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.open.toggle() }) {
                    Text("HSB")
                }.padding(.leading, 5.0)
                .popover(isPresented: self.$open, arrowEdge: .bottom) {
                    VStack {
                        HStack {
                            Text("Hue").frame(width: 90)
                            Slider(value: Binding(get: {self.hueValue}, set: { (newVal) in
                                if (self.hueValue != newVal) {
                                    self.hueValue = newVal
                                    self.hueFilter.hue = Float(newVal)
                                    self.picture.processImage()
                                }
                            }), in: 81...95, step: 0.1).padding()
                        }
                        HStack {
                            Text("Saturation ").frame(width: 90)
                            Slider(value: Binding(get: {self.satValue}, set: { (newVal) in
                                if (self.satValue != newVal) {
                                    self.satValue = newVal
                                    self.satFilter.saturation = Float(newVal)
                                    self.picture.processImage()
                                }
                            }), in: 0.0...2.0, step: 0.1).padding()
                        }
                        HStack {
                            Text("Brightness ").frame(width: 90)
                            Slider(value: Binding(get: {self.briValue}, set: { (newVal) in
                                if (self.briValue != newVal) {
                                    self.briValue = newVal
                                    self.briFilter.brightness = Float(newVal)
                                    self.picture.processImage()
                                }
                            }), in: -1.0...1.0, step: 0.1).padding()
                        }
                    }.frame(width:300)
                }
                Spacer()
                Button(action: { self.modal.toggle()
                }, label: {
                    Text("modal")
                }).sheet(isPresented: self.$modal, content: {
                    Text("hello")
                })
            }
            
            MetalView(renderView: metalRender).onAppear {
                picture --> hueFilter --> satFilter --> briFilter --> metalRender
                picture.processImage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

