# Changelog

All notable changes to this Neovim configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-18

### Added

- **Testing Framework**: Comprehensive testing infrastructure for unit and integration tests
  - Plenary.nvim integration for unit tests
  - Mini.test integration for integration tests
  - Test directory structure (`tests/unit`, `tests/integration`, `tests/fixtures`)
  - Minimal init file for isolated test environment (`tests/minimal_init.lua`)
  - Bash test runner script (`scripts/run_tests.sh`) with colored output
  - Lua test runner module (`lua/test_runner.lua`) with Neovim commands
  - Example unit tests demonstrating Vim API, Lua stdlib, and utility testing
  - Example integration tests for buffer operations, windows, autocommands, and keymaps
  - Test runner commands: `:TestUnit`, `:TestIntegration`, `:TestAll`, `:TestFile`, `:TestNearest`

- **Documentation**:
  - Comprehensive TESTING.md guide with examples and best practices
  - CLAUDE.md file documenting architecture for AI assistance

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 5 test files (2 unit, 3 integration) |
| Total Plugins | 401 installed plugins |
| Config Lines of Code | ~1,411 lines (Lua/Vim) |
| Plugin Lines of Code | ~169,752 lines |

---

## Template for Future Entries

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing functionality

### Deprecated
- Features marked for removal

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | N test files |
| Total Plugins | N installed plugins |
| Config Lines of Code | N lines (Lua/Vim) |
| Plugin Lines of Code | N lines |
```

---

## Versioning Guidelines

- **MAJOR** (X.0.0): Incompatible changes, major refactoring, breaking changes
- **MINOR** (0.X.0): New features, enhancements, plugin additions
- **PATCH** (0.0.X): Bug fixes, minor tweaks, documentation updates
