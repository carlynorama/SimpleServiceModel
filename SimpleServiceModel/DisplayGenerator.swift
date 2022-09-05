//
//  DisplayGenerator.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/4/22.
//

import Foundation

final class DisplayGenerator:GraphicsDriver {
    static let shared = DisplayGenerator()
    
    private(set) var epicenter:CGPoint
    private(set) var size:CGSize
    private(set) var xFactor:Double
    private(set) var yFactor:Double
    
    
    init() {
        self.size = CGSize(width: 100, height: 100)
        self.xFactor = 0.5
        self.yFactor = 0.5
        epicenter = CGPoint(x: 50, y: 50)
    }
    
    func updateSize(to size:CGSize) {
        if self.size != size {
            self.size = size
            epicenter = calculateEpicenter(size:size, px:xFactor, py:yFactor)
        }
    }
    
    func calculateEpicenter(size:CGSize, px:Double, py:Double) -> CGPoint {
        CGPoint(x: size.width * px, y: size.height * py)
    }
    
    func updateFactors(_ x:Double,_ y:Double) {
        //guard and throw if not 1-0?
        if self.xFactor != x || self.yFactor != y {
            self.xFactor = x
            self.yFactor = y
            epicenter = calculateEpicenter(size:size, px:xFactor, py:yFactor)
            print(epicenter)
        }
    }
//
//    func update(_ point:CGPoint) {
//        //guard and throw for being on screen?
//
//        if point != epicenter {
//            self.xFactor = point.x/size.width
//            self.yFactor = point.y/size.height
//
//            //recaluclated and compared for error check?
//            epicenter = point
//        }
//
//    }
    
}
