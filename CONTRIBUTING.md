# Contributing to CPP-Starter-Template

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/CPP-Starter-Template.git
   cd CPP-Starter-Template
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- CMake 3.21+
- C++20 compatible compiler (GCC 11+, Clang 14+, MSVC 19.30+)
- Git

### Building

```bash
# Configure with debug preset
cmake --preset debug

# Build
cmake --build --preset debug

# Run tests
ctest --preset debug
```

### Available Presets

| Preset | Description |
|--------|-------------|
| `debug` | Debug build with sanitizers |
| `release` | Optimized release build with LTO |
| `relwithdebinfo` | Release with debug info |
| `coverage` | Debug build with coverage instrumentation |

## Code Style

- Follow the existing code style defined in `.clang-format`
- Run `clang-format` before committing:
  ```bash
  find include src test bench examples -name '*.cpp' -o -name '*.h' | xargs clang-format -i
  ```
- Use `clang-tidy` for static analysis:
  ```bash
  cmake --preset debug -DENABLE_CLANG_TIDY=ON
  cmake --build --preset debug
  ```

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code refactoring |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Other changes |

### Examples

```
feat(cmake): add Coverage.cmake module
fix(config): correct Config.h.in variable substitution
docs(readme): update build instructions
test(calculator): add edge case tests for division
ci(github): add Windows MSVC build job
```

## Pull Request Process

1. Ensure your changes build and all tests pass on your local machine
2. Update documentation if you're changing behavior
3. Add tests for new functionality
4. Update `CHANGELOG.md` under the `[Unreleased]` section
5. Submit a pull request with a clear description

## Reporting Issues

- Use the GitHub issue templates
- Include your OS, compiler version, and CMake version
- Provide minimal reproduction steps
- Include relevant build/error logs

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
