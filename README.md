<div align="center">

# C++ Project Starter Template

[![CI](https://github.com/hun756/CPP-Starter-Template/actions/workflows/ci.yml/badge.svg)](https://github.com/hun756/CPP-Starter-Template/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![C++](https://img.shields.io/badge/C++-20-blue.svg)](https://en.cppreference.com/w/cpp/20)
[![CMake](https://img.shields.io/badge/CMake-3.21+-064F8C.svg)](https://cmake.org/)

A production-ready C++20 project template with modern CMake, CI/CD, and best practices already configured.

Skip the setup and start building.

</div>

---

## What's Included

**Build System**
- Modern CMake 3.21+ with presets, `PROJECT_IS_TOP_LEVEL`, and `CONFIGURE_DEPENDS`

**Language**
- C++20 standard with concepts, ranges, and coroutines support

**Testing**
- Google Test v1.15 with auto-discovery and GMock integration

**Benchmarking**
- Google Benchmark v1.9 for performance tracking

**Code Quality**
- Sanitizers: ASan, UBSan, TSan, MSan, LSan
- Static analyzers: clang-tidy, cppcheck, include-what-you-use

**Coverage**
- lcov/gcovr integration with HTML reports and branch coverage

**Performance**
- Link Time Optimization (LTO) and Precompiled Headers (PCH)

**Documentation**
- Doxygen setup with UML diagram support

**Packaging**
- CPack configured for DEB, RPM, NSIS, ZIP, and TGZ

**CI/CD**
- GitHub Actions with multi-platform, multi-compiler pipeline

**Installation**
- CMake export with `find_package()` support

**Code Formatting**
- Professional clang-format configuration (760+ lines)

**Symbol Visibility**
- Export headers for proper shared library support

## Requirements

**Required:**
- CMake 3.21+
- C++ Compiler: GCC 11+, Clang 14+, or MSVC 19.30+
- Git 2.x+

**Optional:**
- Doxygen — API documentation
- lcov or gcovr — Code coverage reports
- clang-tidy — Static analysis
- cppcheck — Additional static analysis

## Quick Start

### Using CMake Presets (Recommended)

```bash
# Clone the repository
git clone https://github.com/hun756/CPP-Starter-Template.git my-project
cd my-project

# Configure and build
cmake --preset debug
cmake --build --preset debug

# Run tests
ctest --preset debug

# Run the executable
./build/debug/bin/cpp_project_template
```

### Classic CMake

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build . -j$(nproc)
ctest --output-on-failure
```

## Project Structure

```
my-project/
├── .github/
│   ├── workflows/
│   │   └── ci.yml                 # Multi-platform CI pipeline
│   ├── dependabot.yml             # Automated dependency updates
│   └── ISSUE_TEMPLATE/            # Bug report & feature request templates
├── cmake/
│   ├── CompilerWarnings.cmake     # Strict warning flags (GCC/Clang/MSVC)
│   ├── Sanitizers.cmake           # Runtime error detection (ASan, UBSan, TSan)
│   ├── StaticAnalyzers.cmake      # Static analysis (cppcheck, clang-tidy, IWYU)
│   ├── LTO.cmake                  # Link Time Optimization
│   ├── Coverage.cmake             # Code coverage with lcov/gcovr
│   ├── Dependencies.cmake         # FetchContent dependency management
│   ├── Packaging.cmake            # CPack packaging configuration
│   └── configs/
│       ├── Config.h.in            # Version info template → ProjectConfig.h
│       └── *Config.cmake.in       # Package config for find_package()
├── include/myproject/             # Public headers (your API)
│   ├── ModuleA.h
│   └── ModuleB.h
├── src/                           # Implementation files
│   ├── ModuleA.cpp
│   ├── ModuleB.cpp
│   └── main.cpp
├── test/                          # Unit tests (auto-discovered)
│   ├── CMakeLists.txt
│   ├── ModuleATest.cpp
│   └── ModuleBTest.cpp
├── bench/                         # Performance benchmarks
│   ├── CMakeLists.txt
│   ├── CalculatorBench.cpp
│   └── StringProcessorBench.cpp
├── examples/                      # Usage examples (auto-discovered)
│   ├── CMakeLists.txt
│   └── example*.cpp
├── docs/                          # Doxygen documentation
│   ├── CMakeLists.txt
│   └── Doxyfile.in
├── .clang-format                  # Code formatting rules
├── .clang-tidy                    # Static analysis configuration
├── .editorconfig                  # Cross-editor formatting consistency
├── CMakeLists.txt                 # Main build configuration
├── CMakePresets.json              # Build presets (debug, release, CI)
├── CHANGELOG.md                   # Version history
├── CONTRIBUTING.md                # Contribution guidelines
├── CODE_OF_CONDUCT.md             # Community standards
├── LICENSE                        # MIT License
└── README.md
```

## Build Options

| Option | Default | Description |
|--------|---------|-------------|
| `BUILD_SHARED_LIBS` | `OFF` | Build shared libraries instead of static |
| `BUILD_EXAMPLES` | `ON` | Build example programs |
| `BUILD_TESTS` | `ON` | Build unit tests |
| `BUILD_BENCHMARKS` | `OFF` | Build performance benchmarks |
| `ENABLE_COVERAGE` | `OFF` | Enable code coverage instrumentation |
| `ENABLE_SANITIZERS` | `OFF` | Enable sanitizers (ASan, UBSan) in debug builds |
| `ENABLE_PCH` | `OFF` | Enable precompiled headers |
| `ENABLE_LTO` | `OFF` | Enable Link Time Optimization |
| `ENABLE_CPPCHECK` | `OFF` | Enable static analysis with cppcheck |
| `ENABLE_CLANG_TIDY` | `OFF` | Enable static analysis with clang-tidy |

Example — build with sanitizers and shared libraries:

```bash
cmake --preset debug -DBUILD_SHARED_LIBS=ON -DENABLE_SANITIZERS=ON
```

## Available Presets

| Preset | Description |
|--------|-------------|
| `debug` | Debug build with sanitizers enabled |
| `release` | Optimized release build with LTO |
| `relwithdebinfo` | Release with debug information |
| `coverage` | Debug build with coverage instrumentation |
| `ci-linux-gcc` | CI configuration for Linux + GCC |
| `ci-linux-clang` | CI configuration for Linux + Clang |
| `ci-windows-msvc` | CI configuration for Windows + MSVC |
| `ci-macos-clang` | CI configuration for macOS + AppleClang |

## Code Coverage

```bash
# Configure, build, and run tests with coverage
cmake --preset coverage
cmake --build --preset coverage
ctest --preset coverage

# Generate HTML report
cmake --build --preset coverage --target coverage

# Open the report
open build/coverage/coverage_report/index.html    # macOS
xdg-open build/coverage/coverage_report/index.html # Linux
```

## Documentation

Generate API documentation with Doxygen:

```bash
cmake --preset debug
cmake --build --preset debug --target cpp_project_template_docs
```

## Packaging

Create distributable packages:

```bash
cmake --preset release
cmake --build --preset release
cd build/release && cpack
```

## Using This Library in Your Project

After installation:

```cmake
find_package(cpp_project_template REQUIRED)
target_link_libraries(your_target PRIVATE cpp_project_template::cpp_project_template)
```

Or via `FetchContent`:

```cmake
include(FetchContent)
FetchContent_Declare(
    cpp_project_template
    GIT_REPOSITORY https://github.com/hun756/CPP-Starter-Template.git
    GIT_TAG main
)
FetchContent_MakeAvailable(cpp_project_template)
target_link_libraries(your_target PRIVATE cpp_project_template::cpp_project_template)
```

## Customizing the Template

1. **Rename the project:** Change `cpp_project_template` in `CMakeLists.txt` to `project(your_name ...)`
2. **Rename namespace:** Replace `myproject` with your namespace in `include/` and `src/`
3. **Rename include dir:** Rename `include/myproject/` to `include/your_project/`
4. **Update Config:** Update `cmake/configs/cpp_project_templateConfig.cmake.in` filename
5. **Add source files:** Create `.cpp` files in `src/` — automatically picked up
6. **Add tests:** Create `*Test.cpp` files in `test/` — automatically discovered
7. **Add benchmarks:** Create `*Bench.cpp` files in `bench/` — automatically built
8. **Add examples:** Create `.cpp` files in `examples/` — automatically built

## Contributing

Contributions are welcome! Please read the [Contributing Guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) first.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit with [Conventional Commits](https://www.conventionalcommits.org/): `git commit -m 'feat: add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
