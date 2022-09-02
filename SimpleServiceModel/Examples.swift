//
//  Examples.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.


import Foundation

/*
https://www.swiftbysundell.com/articles/dependency-injection-using-factories-in-swift/
https://www.swiftbysundell.com/articles/dependency-injection-and-unit-testing-using-async-await/
https://www.swiftbysundell.com/articles/different-flavors-of-dependency-injection-in-swift/
https://www.cocoawithlove.com/blog/separated-services-layer.html
https://medium.engineering/how-we-build-swiftui-features-in-the-medium-application-21323a960910
 */


/*

protocol ViewControllerFactory {
    func makeMessageListViewController() -> MessageListViewController
    func makeMessageViewController(for message: Message) -> MessageViewController
}

protocol MessageLoaderFactory {
    func makeMessageLoader() -> MessageLoader
}


class MessageListViewController: UITableViewController {
    // Here we use protocol composition to create a Factory type that includes
    // all the factory protocols that this view controller needs.
    typealias Factory = MessageLoaderFactory & ViewControllerFactory

    private let factory: Factory
    // We can now lazily create our MessageLoader using the injected factory.
    private lazy var loader = factory.makeMessageLoader()

    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
}

//As you can see above, we use lazy properties in order to be able to refer to other properties of the same class when initializing our objects. This is a really convenient and nice way to setup your dependency graph, as you can utilize the compiler to help you avoid problems like circular dependencies.
class DependencyContainer {
    private lazy var messageSender = MessageSender(networkManager: networkManager)
    private lazy var networkManager = NetworkManager(urlSession: .shared)
}

extension DependencyContainer: ViewControllerFactory {
    func makeMessageListViewController() -> MessageListViewController {
        return MessageListViewController(factory: self)
    }

    func makeMessageViewController(for message: Message) -> MessageViewController {
        return MessageViewController(message: message, sender: messageSender)
    }
}

extension DependencyContainer: MessageLoaderFactory {
    func makeMessageLoader() -> MessageLoader {
        return MessageLoader(networkManager: networkManager)
    }
}

//In the root -
let container = DependencyContainer()
let listViewController = container.makeMessageListViewController()

window.rootViewController = UINavigationController(
    rootViewController: listViewController
)
*/

/*

class ProductViewModel {
    var title: String { product.name }
    var detailText: String { product.description }
    var price: Price { product.price(in: localUser.currency) }
    ...

    private var product: Product
    private let localUser: User
    private let urlSession: URLSession

    init(product: Product, localUser: User, urlSession: URLSession = .shared) {
        self.product = product
        self.localUser = localUser
        self.urlSession = urlSession
    }

    func reload() async throws {
        let url = URL.forLoadingProduct(withID: product.id)
        let (data, _) = try await urlSession.data(from: url)
        let decoder = JSONDecoder()
        product = try decoder.decode(Product.self, from: data)
    }
}

class ProductLoader {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func loadProduct(withID id: Product.ID) async throws -> Product {
        let url = URL.forLoadingProduct(withID: id)
        let (data, _) = try await urlSession.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Product.self, from: data)
    }
}

class ProductViewModel {
    ...
    private var product: Product
    private let localUser: User
    private let loader: ProductLoader

    init(product: Product, localUser: User, loader: ProductLoader) {
        self.product = product
        self.localUser = localUser
        self.loader = loader
    }

    func reload() async throws {
        product = try await loader.loadProduct(withID: product.id)
    }
}

protocol Networking {
    func data(
    from url: URL,
    delegate: URLSessionTaskDelegate?
) async throws -> (Data, URLResponse)
}

extension Networking {
    // If we want to avoid having to always pass 'delegate: nil'
    // at call sites where we're not interested in using a delegate,
    // we also have to add the following convenience API (which
    // URLSession itself provides when using it directly):
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

extension URLSession: Networking {}


class ProductLoader {
    private let networking: Networking

    init(networking: Networking = URLSession.shared) {
        self.networking = networking
    }

    func loadProduct(withID id: Product.ID) async throws -> Product {
        let url = URL.forLoadingProduct(withID: id)
        let (data, _) = try await networking.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Product.self, from: data)
    }
}

class NetworkingMock: Networking {
    var result = Result<Data, Error>.success(Data())

    func data(
        from url: URL,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {
        try (result.get(), URLResponse())
    }
}

class ProductViewModelTests: XCTestCase {
    private var product: Product!
    private var networking: NetworkingMock!
    private var viewModel: ProductViewModel!

    override func setUp() {
        super.setUp()

        //https://www.swiftbysundell.com/articles/defining-testing-data-in-swift/
        product = .stub()
        networking = NetworkingMock()
        viewModel = ProductViewModel(
            product: product,
            localUser: .stub(),
            loader: ProductLoader(networking: networking)
        )
    }

    func testReloadingProductUpdatesTitle() async throws {
        product.name = "Reloaded product"
        networking.result = try .success(JSONEncoder().encode(product))
        XCTAssertNotEqual(viewModel.title, product.name)

        try await viewModel.reload()
        XCTAssertEqual(viewModel.title, product.name)
    }
    
    ...
}
*/

/*
 // https://www.swiftbysundell.com/articles/avoiding-singletons-in-swift/
 
class ProfileViewController: UIViewController {
    private let user: User
    private let logOutService: LogOutService
    private lazy var nameLabel = UILabel()

    init(user: User, logOutService: LogOutService) {
        self.user = user
        self.logOutService = logOutService
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name
    }

    private func handleLogOutButtonTap() {
        logOutService.logOut()
    }
}

protocol LogOutService {
    func logOut()
}

protocol NetworkService {
    func request(_ endpoint: Endpoint, completionHandler: @escaping () -> Void)
}

protocol NavigationService {
    func showLoginScreen()
    func showProfile(for user: User)
    //...
}

class LogOutService {
    private let user: User
    private let networkService: NetworkService
    private let navigationService: NavigationService

    init(user: User,
         networkService: NetworkService,
         navigationService: NavigationService) {
        self.user = user
        self.networkService = networkService
        self.navigationService = navigationService
    }

    func logOut() {
        networkService.request(.logout(user)) { [weak self] in
            self?.navigationService.showLoginScreen()
        }
    }
}

extension AppDelegate: NavigationService {
    func showLoginScreen() {
        navigationController.viewControllers = [
            LoginViewController(
                loginService: UserManager.shared,
                navigationService: self
            )
        ]
    }

    func showProfile(for user: User) {
        let viewController = ProfileViewController(
            user: user,
            logOutService: UserManager.shared
        )

        navigationController.pushViewController(viewController, animated: true)
    }
}
 */
 
// https://github.com/hmlongco/Factory
 
// https://github.com/hmlongco/Resolver/blob/master/Documentation/Introduction.md

/*
protocol ServiceTypeProtocol {
    
}

extension Container {
    static let myService = Factory<MyServiceType> { MyService() }
    //or
    static let myService = Factory { MyService() as ServiceTypeProtocol }
}

class ContentViewModel: ObservableObject {
    @Injected(Container.myService) private var myService
    // or
    // dependencies
    private let myService = Container.myService()
    private let eventLogger = Container.eventLogger()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.myService.register { MockService2() }
        ContentView()
    }
}

also

extension Container {
    static func setupMocks() {
        myService.register { MockServiceN(4) }
        sharedService.register { MockService2() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.setupMocks()
        ContentView()
    }
}

Unless altered, the default scope is unique; every time the factory is asked for an instance of an object it will get a new instance of that object.

Other common scopes are cached and shared.
extension Container {
    static let someService = Factory(scope: .singleton) {
        SomeService()
    }
}

extension Container.Scope {
    static var session = Cached()
}

extension Container {
    static let authentication = Factory(scope: .session) {
        Authentication()
    }
}

func logout() {
    Container.Scope.session.reset()
    ...
}

 extension Container {
     static let constructedService = Factory {
        MyConstructedService(service: myService())
     }
 }
 
 class OrderContainer: SharedContainer {
     static let optionalService = Factory<SimpleService?> {
         nil
     }
     static let constructedService = Factory {
         MyConstructedService(service: myServiceType())
     }
     static let additionalService = Factory(scope: .session) {
         SimpleService()
     }
 }
 
 class PaymentsContainer: SharedContainer {
     static let anotherService = Factory {
        AnotherService(OrderContainer.optionalService())
     }
 }
 
 extension SharedContainer {
     static let api = Factory<APIServiceType> { APIService() }
 }
 
*/

/*
https://www.cocoawithlove.com/blog/separated-services-layer.html
public struct Services {
   let networkService: NetworkService
   let keyValueService: KeyValueService
}

extension Services {
   public init() {
      self.init(networkService: URLSession.shared, keyValueService: UserDefaults.standard)
   }
}

public extension Services {
   static var mock: Services {
      return Services(networkService: MockNetworkService(), keyValueService: MockKeyValueService())
   }
}
*/
