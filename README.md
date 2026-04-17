# nota.nvim

*Nota* -- from Latin, meaning "note" or "mark". Short, universal, and to the point. Much like the plugin itself.

A lightweight Neovim plugin for structured daily note-taking. Designed as a terminal-native alternative to heavier note-taking tools with complex UIs. No databases, no web views, no background processes -- just markdown files in a git repo.

Create dated notes with a single command, organized into year/month/day directories. Search existing notes with Telescope, fzf-lua, or a built-in fallback.

## Installation

### lazy.nvim

```lua
{
  "kmgrime/nota.nvim",
  config = function()
    require("nota").setup({
      notes_path = "~/notes/journal",
    })
  end,
}
```

### packer.nvim

```lua
use({
  "kmgrime/nota.nvim",
  config = function()
    require("nota").setup({
      notes_path = "~/notes/journal",
    })
  end,
})
```

## Configuration

The `setup()` function accepts a table with the following options:

| Option | Type | Default | Description |
|---|---|---|---|
| `notes_path` | `string` | `nil` (required) | Absolute or `~`-relative path to your notes directory |
| `date_format` | `string` | `"%Y-%m-%d"` | Date format used in filenames and directory structure |
| `separator` | `string` | `"_"` | Character used to replace spaces in subject names |

## Usage

### `:nota`

Prompts you for a subject name and creates a new note for today.

For example, entering `meeting notes` on 2026-04-15 creates:

```
~/notes/journal/2026/04/15/2026-04-15-meeting_notes.md
```

With the following template:

```markdown
---
Date: 2026-04-15
Subject: meeting notes
Description: 
---

### Note1

- 
```

The cursor is placed on the bullet point, ready for input.

If a note with the same subject already exists for today, you are prompted to either open the existing file or cancel.

### `:notasearch`

Opens a fuzzy finder to browse and open existing notes. The plugin checks for available search providers in this order:

1. **Telescope** (`telescope.nvim`) -- uses `find_files` scoped to your notes path
2. **fzf-lua** (`fzf-lua`) -- uses `files` scoped to your notes path
3. **Fallback** -- uses `vim.ui.select` with a flat list of all notes

No additional configuration is needed. Whichever picker is installed gets used with its default settings.

### Keymaps

The plugin does not set any keymaps by default. You can add your own:

```lua
vim.keymap.set("n", "<leader>nn", "<cmd>nota<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>ns", "<cmd>notasearch<cr>", { desc = "Search notes" })
```

## Directory Structure

Notes are organized by year, month, and day. Each day gets its own directory, allowing multiple notes per day:

```
notes_path/
  2026/
    04/
      14/
        2026-04-14-standup.md
      15/
        2026-04-15-meeting_notes.md
        2026-04-15-project_ideas.md
```

## Requirements

- Neovim >= 0.8
- Optional: `telescope.nvim` or `fzf-lua` for fuzzy search (falls back to `vim.ui.select`)

## License

MIT
