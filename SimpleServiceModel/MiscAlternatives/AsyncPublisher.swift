//
//  FlavorManager.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/8/22.
//
//  https://www.youtube.com/watch?v=ePPm2ftSVqw

import SwiftUI

struct FlavorsView: View {
    
    @StateObject private var viewModel = FlavorVM()
    
    var body: some View {
        VStack {
            Text(viewModel.thisWeeksSpecial)
            ScrollView {
                VStack {
                    ForEach(viewModel.flavorsToDisplay) {
                        Text($0.name)
                    }
                }
            }
        }.task {
            await viewModel.start()
        }
    }
    

}

struct FlavorsView_Previews: PreviewProvider {
    static var previews: some View {
        FlavorsView()
    }
}


struct Flavor:Identifiable {
    let name:String
    let id = UUID()
    let description:String
}

let flavors = [
 Flavor(name: "Vanilla", description: "Yummy"),
 Flavor(name: "Strawberry", description: "Yummy"),
 Flavor(name: "Chocolate", description: "Yummy"),
 Flavor(name: "Butter Pecan", description: "Yummy"),
 Flavor(name: "Mint Chocolate Chip", description: "Yummy"),
]


import Foundation


actor FlavorManager {
    @Published var myFlavors:[Flavor] = []
    
    @Published var currentFlavor:Flavor = Flavor(name: "Apple Pie", description: "Seasonal Yummy")

    func addData() async {
        for flavor in flavors {
            myFlavors.append(flavor)
            try? await  Task.sleep(nanoseconds: 2_000_000_000)
            currentFlavor = flavor
        }
    }
}

class FlavorVM:ObservableObject {
    @MainActor @Published var flavorsToDisplay: [Flavor] = []
    @MainActor @Published var thisWeeksSpecial:String = ""
    
    let manager = FlavorManager()
    
    init() {
        listen()
    }
    
    private func listen() {
        Task {
            for await value in await manager.$myFlavors.values {
                await MainActor.run {
                    self.flavorsToDisplay = value
                }
            }
            //This loop never exits. no code here will execute.
        }
        
        Task {
            for await value in await manager.$currentFlavor.values {
                await MainActor.run {
                    self.thisWeeksSpecial = "\(value.name): \(value.description)"
                }
            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}
