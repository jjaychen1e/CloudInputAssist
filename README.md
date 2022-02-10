# CloudInputAssist

## Introduction 介绍

一个 `macOS` 辅助应用程序，用于使用云输入法（例如谷歌云输入法）API 提供辅助的候选词结果。

## Motivation 动机

使用不联网的本地输入法时，长句的候选词往往不太理想，尤其是使用双拼输入时。这种情况下，借助一些输入法的云计算 `API`，可以获得较为准确的候选词。

## Usage 使用方法

虽然工具使用了图形化界面，但是并不是一个标准的 `macOS` `app`，而是一个命令行程序（因为这样无需签名即可分发）。暂时没有任何第三方依赖，直接编译运行即可（`macOS 12` 及以上可用）。

```
swift run
```

运行后，当你输入中文时，程序会记录你的按键，尝试同步你的输入缓冲区内容，并在左下角展示 `API` 返回的计算结果。目前，只支持**小鹤双拼**键位，只接入了谷歌云输入法的 `API`，上屏快捷键为 `F12`（某些情况下可能与 `Chrome` 开发者工具呼出快捷键冲突）。

https://user-images.githubusercontent.com/31304335/153425836-3d15dea6-b7b0-414b-b55b-10dd66d7ed80.mov

## Known issues 已知问题

-  `Safari` 由于苹果限制，无法模拟按键（但是内容会到剪切板，可自行 `Eascape` 清空输入法缓冲区后粘贴）
-  `Chrome` Web 控件可能会出现内容已上屏，但是输入法缓冲区仍在的问题（可自行 `Eascape` 清空输入法缓冲区）
-  基于 `Electron` 开发的应用拦截 `CGEvent` 做快捷键，可能与模拟按键冲突
