# Contributing to nota.nvim

Thanks for considering a contribution. This document covers the guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Create a new branch from `main` for your change
3. Make your changes
4. Submit a pull request against `main`

## Commit Messages

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification. Every commit message must follow this format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | When to use |
|---|---|
| `feat` | A new feature or user-facing functionality |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Code style changes (formatting, whitespace, etc.) that do not affect logic |
| `refactor` | Code changes that neither fix a bug nor add a feature |
| `perf` | Performance improvements |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks, dependency updates, CI changes |
| `revert` | Reverting a previous commit |

### Scope

Scope is optional but encouraged. Use the module name when applicable:

- `create` -- changes to note creation logic
- `search` -- changes to search/picker logic
- `config` -- changes to setup or configuration handling
- `template` -- changes to the note template

### Examples

```
feat(create): add support for custom templates
fix(search): handle empty notes directory without error
docs: update installation instructions for packer
refactor(config): simplify default option merging
chore: update minimum Neovim version requirement
```

### Breaking Changes

If a commit introduces a breaking change, add `!` after the type/scope and include a `BREAKING CHANGE:` footer:

```
feat(config)!: rename notes_path to vault_path

BREAKING CHANGE: the `notes_path` option has been renamed to `vault_path`.
Update your setup() call accordingly.
```

## Code Style

- Use clear, descriptive variable and function names
- Add LuaDoc annotations (`---@param`, `---@return`) to public functions
- Keep functions short and focused
- Local helper functions should be declared `local` and placed above the functions that use them

## Pull Requests

- Keep PRs focused on a single change
- Reference any related issues in the PR description
- Make sure the plugin loads without errors before submitting
- Test your changes manually in Neovim

## Reporting Issues

When opening an issue, include:

- Neovim version (`nvim --version`)
- Plugin manager and configuration
- Steps to reproduce the problem
- Expected vs actual behavior
