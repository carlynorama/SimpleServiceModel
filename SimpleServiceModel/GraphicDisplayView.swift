//
//  GraphicDisplayView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/4/22.
//

import SwiftUI

struct GraphicDisplayView: View {
    let displayGenerator:GraphicsDriver
    
//    var rect: CGRect {
//        (CGRect(origin: displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0)))
//    }
//
//    func frect() -> CGRect {
//        CGRect(origin: displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0))
//    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                displayGenerator.updateSize(to: size)
                let mark = context.resolve(Image(systemName: "circle"))
                let rect = CGRect(origin: displayGenerator.epicenter, size:CGSize(width: 12.0, height: 12.0))
                context.draw(mark, in: rect)
            }
            .border(Color.blue)
        }
    }
}
struct GraphicDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicDisplayView(displayGenerator: Services.forPreviews.graphicsDriver as! DisplayGenerator)
    }
}
