# ExampleApp

Demo application for ARCNavigation package.

## Requirements

- Xcode 16.0+
- iOS 17.0+

## Running the Example

1. Open `ExampleApp.xcodeproj` in Xcode:
   ```bash
   cd Example/ExampleApp
   open ExampleApp.xcodeproj
   ```

2. The package is referenced locally from the parent directory

3. Select a simulator and press Run (⌘R)

## Regenerating the Project (if needed)

If you need to regenerate the Xcode project after modifying `project.yml`:

```bash
brew install xcodegen  # if not installed
cd Example/ExampleApp
xcodegen generate
```

## Features Demonstrated

### Type-Safe Routes
- **AppRoute enum**: Defines all navigable destinations
- **Associated values**: Pass data through routes (`User`, `Int`)
- **Route protocol**: Each route provides its own view via `view()`

### Router Navigation
- **navigate(to:)**: Push new routes onto the stack
- **pop()**: Go back one screen
- **popToRoot()**: Return to the root view
- **popTo(_:)**: Navigate back to a specific route

### Stack Inspection
- **currentRoutes**: Access all routes in the stack for debugging
- **count**: Number of routes in the stack
- **isEmpty**: Check if at root

## Demo Screens

| Screen | Purpose |
|--------|---------|
| **Home** | Main hub with user list and quick actions |
| **Profile** | Shows user data passed via associated value |
| **Settings** | Displays stack debug info with `currentRoutes` |
| **Detail** | Recursive navigation with incrementing IDs |
