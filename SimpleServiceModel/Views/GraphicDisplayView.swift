//
//  GraphicDisplayView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/4/22.
// https://www.evl.uic.edu/pape/data/Earth/
// 

import SwiftUI

struct GraphicDisplayView: View {
    let displayGenerator:GraphicsDriver
    let markSize = CGSize(width: 12.0, height: 12.0)
    
//    var rect: CGRect {
//        (CGRect(origin: displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0)))
//    }
//
    func translatedRect(rect:CGRect, size:CGSize) -> CGRect {
        CGRect(origin: displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0))
    }
    
    var body: some View {
        ZStack {
            Image("WorldMap").resizable()
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    displayGenerator.updateSize(to: size)
                    let mark = context.resolve(Image(systemName: "circle"))
                    let rect = CGRect(origin: displayGenerator.epicenter, size:markSize)
                    context.translateBy(x: -markSize.width/2, y: -markSize.height/2)
                    context.draw(mark, in: rect)
                }
                
            }
        }.border(.background)
    }
}
struct GraphicDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicDisplayView(displayGenerator: Services.forPreviews.graphicsDriver as! DisplayGenerator)
    }
}
