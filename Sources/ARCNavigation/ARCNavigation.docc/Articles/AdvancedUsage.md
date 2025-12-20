# Advanced Usage

Explore advanced patterns and techniques for complex navigation scenarios.

## Overview

ARCNavigation supports sophisticated navigation patterns including MVVM architecture integration, complex navigation flows, and state monitoring. This guide covers advanced techniques to maximize the power of ARCNavigation.

## MVVM Integration

ARCNavigation works seamlessly with the MVVM (Model-View-ViewModel) pattern. You can inject the router into your ViewModels to keep navigation logic separate from your views.

### ViewModel with Router

```swift
import ARCNavigation

@Observable
final class HomeViewModel {
    private let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    // MARK: - Navigation Methods

    func openUserProfile(userName: String) {
        // Add business logic, validation, analytics, etc.
        guard !userName.isEmpty else { return }
        router.navigate(to: .profile(userName: userName))
    }

    func openSettings() {
        router.navigate(to: .settings)
    }

    func openDetailIfValid(id: Int) {
        guard id > 0 else {
            print("Invalid ID")
            return
        }
        router.navigate(to: .detail(id: id))
    }

    func navigateBack() {
        router.pop()
    }
}
```

### View Using ViewModel

```swift
struct HomeView: View {
    @Environment(Router<AppRoute>.self) private var router
    @State private var viewModel: HomeViewModel?

    var body: some View {
        VStack {
            if let viewModel {
                Button("Open Profile") {
                    viewModel.openUserProfile(userName: "Alice")
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HomeViewModel(router: router)
            }
        }
    }
}
```

## Navigation State Monitoring

You can monitor the navigation state using the router's inspection properties.

### Checking Stack State

```swift
struct DebugView: View {
    @Environment(Router<AppRoute>.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Navigation Debug")
                .font(.headline)

            Text("Stack size: \(router.count)")
            Text("Is empty: \(router.isEmpty ? "Yes" : "No")")

            Divider()

            Text("Current Routes:")
            ForEach(Array(router.currentRoutes.enumerated()), id: \.offset) { index, route in
                Text("[\(index)] \(String(describing: route))")
                    .font(.caption)
            }
        }
        .padding()
    }
}
```

### Conditional Navigation

Use the stack state to make navigation decisions:

```swift
func navigateToDetails() {
    // Only navigate if we're not already deep in the stack
    guard router.count < 5 else {
        print("Navigation stack too deep")
        return
    }

    router.navigate(to: .detail(id: 42))
}

func navigateBackSafely() {
    // Check before popping
    if !router.isEmpty {
        router.pop()
    }
}
```

## Complex Navigation Flows

### Multi-Step Flows

Create complex navigation flows with sequential screens:

```swift
class OnboardingViewModel {
    private let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    func startOnboarding() {
        router.navigate(to: .onboardingWelcome)
    }

    func continueToProfile() {
        router.navigate(to: .onboardingProfile)
    }

    func continueToPreferences() {
        router.navigate(to: .onboardingPreferences)
    }

    func completeOnboarding() {
        // Navigate to main app and clear onboarding stack
        router.popToRoot()
        router.navigate(to: .home)
    }

    func cancelOnboarding() {
        router.popToRoot()
    }
}
```

### Conditional Navigation Paths

Navigate to different screens based on conditions:

```swift
func handleUserAction(isAuthenticated: Bool) {
    if isAuthenticated {
        router.navigate(to: .dashboard)
    } else {
        router.navigate(to: .login)
    }
}

func navigateToContent(contentType: ContentType) {
    switch contentType {
    case .article(let id):
        router.navigate(to: .article(id: id))
    case .video(let id):
        router.navigate(to: .videoPlayer(id: id))
    case .gallery(let id):
        router.navigate(to: .gallery(id: id))
    }
}
```

## Navigation with Associated Values

Leverage Swift's enum associated values for type-safe parameter passing:

```swift
enum AppRoute: Route {
    case home
    case userProfile(User)
    case editProfile(User, mode: EditMode)
    case search(query: String, filters: [Filter])
    case productDetail(Product, relatedProducts: [Product])

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .userProfile(let user):
            UserProfileView(user: user)
        case .editProfile(let user, let mode):
            EditProfileView(user: user, mode: mode)
        case .search(let query, let filters):
            SearchResultsView(query: query, filters: filters)
        case .productDetail(let product, let related):
            ProductDetailView(product: product, relatedProducts: related)
        }
    }
}

enum EditMode {
    case create
    case edit
    case view
}
```

## Navigation Guards

Implement navigation guards to control access:

```swift
class NavigationGuard {
    private let router: Router<AppRoute>
    private let authService: AuthService

    init(router: Router<AppRoute>, authService: AuthService) {
        self.router = router
        self.authService = authService
    }

    func navigateToProtectedRoute(_ route: AppRoute) {
        guard authService.isAuthenticated else {
            router.navigate(to: .login)
            return
        }

        router.navigate(to: route)
    }

    func navigateWithPermissionCheck(_ route: AppRoute, requiredPermission: Permission) {
        guard authService.hasPermission(requiredPermission) else {
            router.navigate(to: .unauthorized)
            return
        }

        router.navigate(to: route)
    }
}
```

## Programmatic Navigation from Non-View Code

Access the router from services or managers:

```swift
class NotificationHandler {
    private let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    func handleNotificationTap(notification: Notification) {
        switch notification.type {
        case .message(let userId):
            router.navigate(to: .chat(userId: userId))
        case .like(let postId):
            router.navigate(to: .post(id: postId))
        case .follow(let userId):
            router.navigate(to: .profile(userName: userId))
        }
    }
}
```

## Best Practices

### 1. Keep Routes Focused

```swift
// Good: Clear, focused routes
enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings
}

// Avoid: Generic routes with too many parameters
enum AppRoute: Route {
    case screen(type: String, data: Any, options: [String: Any])
}
```

### 2. Use Meaningful Associated Values

```swift
// Good: Type-safe and self-documenting
case productDetail(Product, showReviews: Bool)

// Avoid: Primitive obsession
case productDetail(String, String, Bool)
```

### 3. Centralize Navigation Logic

```swift
// Good: Centralized in ViewModel
class ProductViewModel {
    func viewProduct(_ product: Product) {
        router.navigate(to: .productDetail(product, showReviews: true))
    }
}

// Avoid: Scattered navigation calls in views
Button("View") {
    router.navigate(to: .productDetail(product, showReviews: true))
}
```

### 4. Handle Edge Cases

```swift
func popToSpecificRoute(_ route: AppRoute) {
    // Check if route exists before navigating
    guard router.currentRoutes.contains(route) else {
        print("Route not found in stack")
        return
    }

    router.popTo(route)
}
```

## Performance Considerations

### Avoid Heavy Computation in route.view()

```swift
// Good: Lightweight view creation
func view() -> some View {
    switch self {
    case .profile(let id):
        ProfileView(userID: id)
    }
}

// Avoid: Heavy computation
func view() -> some View {
    switch self {
    case .profile(let id):
        let userData = fetchUserData(id) // Don't do this!
        ProfileView(userData: userData)
    }
}
```

### Use Lazy Initialization

Views are created only when navigated to, so expensive operations should be in the view's `onAppear` or ViewModel initialization.

## Next Steps

- Learn about <doc:TestingGuide> to test complex navigation flows
- Understand the <doc:Architecture> behind ARCNavigation
- Review <doc:GettingStarted> for basic concepts
