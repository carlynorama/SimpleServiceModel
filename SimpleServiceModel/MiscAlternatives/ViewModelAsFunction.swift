//
//import SwiftUI
//import Foundation
//import Combine
//
////https://www.youtube.com/watch?v=uTLG_LgjWGA
////https://github.com/aflockofswifts/meetings#functional-viewmodels
//
//func viewModel(
//    input1: some Publisher<String, Never>,
//    input2: some Publisher<String, Never>
//) async ->  (
//    lowercased: some Publisher<String, Never>,
//    uppercased: some Publisher<String, Never>
//) {
//    (
//        lowercased: input1.map(\.localizedLowercase),
//        uppercased: input2.map(\.localizedUppercase)
//    )
//}
//
//struct ModelFunctionView: View {
//    @PublishedState private var input1 = ""
//    @PublishedState private var input2 = ""
//    @State private var lowercase = ""
//    @State private var uppercase = ""
//    var body: some View {
//        VStack(alignment: .leading) {
//            TextField("text1", text: $input1.binding)
//            Text(lowercase)
//            TextField("text1", text: $input2.binding)
//            Text(uppercase)
//            Spacer()
//        }
//        .padding()
//        .task {
//            let (lowercased, uppercased) = await viewModel(input1: $input1.publisher, input2: $input2.publisher)
//            subscribe(lowercased) { lowercase = $0 }
//            subscribe(uppercased) { uppercase = $0 }
//        }
//    }
//}
//
//func subscribe<Value: Sendable>(
//    _ publisher: some Publisher<Value, Never>,
//    observe: @escaping (Value) -> Void
//) {
//    Task { @MainActor in
//        for await value in publisher.values {
//            observe(value)
//        }
//    }
//}
//
//@propertyWrapper
//struct PublishedState<Value>: DynamicProperty {
//    final class Projection: ObservableObject {
//        @Published var value: Value
//        var publisher: some Publisher<Value, Never>  {
//            $value
//        }
//        private(set) lazy var binding: Binding<Value> = {
//            .init(get: { self.value }, set: { self.value = $0 })
//        }()
//        init(value: Value) {
//            self.value = value
//        }
//    }
//    @StateObject var projection: Projection
//    var wrappedValue: Value {
//        get { projection.value }
//        nonmutating set { projection.value = newValue }
//    }
//    var projectedValue: Projection {
//        projection
//    }
//    init(wrappedValue: Value) {
//        let projection = Projection(value: wrappedValue)
//        _projection = .init(wrappedValue: projection)
//    }
//}
