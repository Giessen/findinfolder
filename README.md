# Find in Folder - Plugin for [micro editor](https://micro-editor.github.io)
Support searching for a term recursively in all files in all directories from the point the micro-editor was opened.

## Installation

### Prerequisites
You need to install [ripgrep](https://github.com/BurntSushi/ripgrep), [bat](https://github.com/sharkdp/bat) and [fzf](https://github.com/junegunn/fzf) to use this plugin.

### Settings
Add this repo as a **pluginrepos** option in the **~/.config/micro/settings.json** file (it is necessary to restart the micro after this change):
```json
{
  "pluginrepos": [
      "https://gitlab.com/taconi/micro-findinfolder/-/raw/main/repo.json"
  ]
}
```

### Install
In your micro editor press **Ctrl-e** and run command:
```
> plugin install findinfolder
```

## Usage
You can use pre-set keyboard **Alt-f** or open command mode **Ctrl-e** and type **findinfolder**.
