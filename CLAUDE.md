# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Codebase Overview

This is a Neovim configuration repository (nvimdots) with a modular Lua-based architecture. The configuration uses lazy.nvim for plugin management and supports Neovim 0.11+.

## Key Files and Structure

- `init.lua` - Main entry point, loads core configuration
- `lua/core/` - Core configuration modules (options, settings, events, plugin management)
- `lua/keymap/` - Keybinding configurations
- `lua/modules/` - Plugin configurations organized by category:
  - `configs/completion/` - LSP, cmp, and completion plugins
  - `configs/editor/` - Editor enhancement plugins
  - `configs/lang/` - Language-specific configurations
  - `configs/tool/` - Development tools and utilities
  - `configs/ui/` - UI and theme configurations
- `lua/user/` - User-specific customizations and overrides
- `lazy-lock.json` - Locked plugin versions for reproducible setup

## Development Commands

This is a Neovim configuration, so there are no traditional build/test commands. Key development workflows:

- **Plugin Management**: Lazy.nvim handles plugin installation/updates automatically
- **Configuration Testing**: Reload Neovim config with `:source $MYVIMRC` or restart Neovim
- **Linting**: Uses stylua for Lua formatting (config in `stylua.toml`)
- **Health Checks**: Run `:checkhealth` to verify Neovim and plugin status

## Common Development Tasks

1. **Add a new plugin**: Add to appropriate config file in `lua/modules/configs/` and run `:Lazy sync`
2. **Modify keybindings**: Edit files in `lua/keymap/` or `lua/user/keymap/`
3. **Customize settings**: Modify `lua/core/settings.lua` or user overrides in `lua/user/settings.lua`
4. **Add language support**: Create new server config in `lua/modules/configs/completion/servers/`

## Architecture Notes

- **Modular Design**: Configuration is split into logical modules for easy maintenance
- **User Overrides**: User-specific changes go in `lua/user/` to avoid conflicts with upstream updates
- **Plugin Management**: Uses lazy.nvim with lockfile for reproducible setups
- **Cross-Platform**: Supports Linux, macOS, and Windows with platform-specific configurations
- **Performance Optimized**: Targets <50ms startup time with lazy loading strategies

## Important Configuration Files

- `lua/core/settings.lua` - Global settings and preferences
- `lua/core/options.lua` - Neovim option defaults
- `lua/core/pack.lua` - Plugin specification and lazy.nvim setup
- `lua/keymap/init.lua` - Main keybinding entry point