# ARCNavigation Makefile
# Development automation for Swift Package

.PHONY: all build test lint format clean docs pre-commit help

# Default target
all: build test lint

# Build the package
build:
	@echo "Building ARCNavigation..."
	swift build

# Build for release
release:
	@echo "Building for release..."
	swift build -c release

# Run tests
test:
	@echo "Running tests..."
	swift test

# Run SwiftLint
lint:
	@echo "Running SwiftLint..."
	swiftlint lint

# Fix SwiftLint issues
lint-fix:
	@echo "Fixing SwiftLint issues..."
	swiftlint lint --fix

# Run SwiftFormat check
format-check:
	@echo "Checking formatting..."
	swiftformat --lint .

# Apply SwiftFormat
format:
	@echo "Applying SwiftFormat..."
	swiftformat .

# Clean build artifacts
clean:
	@echo "Cleaning..."
	swift package clean
	rm -rf .build

# Generate documentation
docs:
	@echo "Generating documentation..."
	swift package generate-documentation

# Pre-commit checks (run before committing)
pre-commit: format lint-fix build test
	@echo "Pre-commit checks passed!"

# Show help
help:
	@echo "ARCNavigation Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build, test, and lint (default)"
	@echo "  build        Build the package"
	@echo "  release      Build for release"
	@echo "  test         Run tests"
	@echo "  lint         Run SwiftLint"
	@echo "  lint-fix     Fix SwiftLint issues"
	@echo "  format-check Check formatting with SwiftFormat"
	@echo "  format       Apply SwiftFormat"
	@echo "  clean        Clean build artifacts"
	@echo "  docs         Generate documentation"
	@echo "  pre-commit   Run all checks before committing"
	@echo "  help         Show this help message"
