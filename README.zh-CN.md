# 🎹 SomcoKeyboard 中文说明

[English](README.md) | **简体中文**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Built with Qt](https://img.shields.io/badge/Built%20with-Qt-41CD52?logo=qt)](https://qt.io)

![SomcoKeyboard](./assets/SomcoKeyboard.png)

**基于 QML 的嵌入式屏幕虚拟键盘（Qt 5.15 / Qt 6 双支持）**

---

## 项目简介

SomcoKeyboard 是一个轻量、可商用的 QML 虚拟键盘，以 **Qt QPA 平台输入上下文插件**（platforminputcontexts plugin）的形式工作：应用只需设置 `QT_IM_MODULE=somcokeyboard`，任何获得焦点的输入框都会自动弹出该键盘，无需逐个输入框绑定。适用于医疗设备、工业 HMI 等嵌入式 Linux 场景。

- 🎨 内置亮 / 暗两套主题，支持完全自定义
- 🌍 20+ 语言布局（拉丁 / 西里尔 / 希腊字母），可扩展
- ⚡ 面向嵌入式优化，资源占用小
- 🔗 Qt 5.15 与 Qt 6（同一套源码，CMake 自动探测）

---

## 目录结构：改界面请先看这张表

```
SomcoKeyboard/
├── CMakeLists.txt                 # 顶层构建脚本（Qt 5 / Qt 6 自动探测）
├── somcokeyboard.pro              # qmake 构建入口（src + example）
├── example/
│   ├── main.cpp                   #   设置 QT_IM_MODULE=somcokeyboard、addImportPath(":/")
│   └── main.qml                   #   InputPanel 的完整用法演示
└── src/
    ├── VirtualKeyboardInputContextPlugin.*   # QPA 插件入口（system=="somcokeyboard" 时启用）
    ├── VirtualKeyboardInputContext.*         # 输入上下文：把按键事件送进焦点控件
    ├── DeclarativeInputEngine.*              # InputEngine 单例：大小写/符号状态、语言布局注册表
    ├── KeyboardTheme.h / .cpp                # 主题数据对象：颜色/字体/图标属性定义（权威清单）
    ├── ThemeManager.h / .cpp                 # ThemeManager 单例：管理可用主题与当前主题
    ├── EnterKeyAction*                       # Enter 键行为附加属性
    ├── icons/
    │   ├── light/  dark/                     #   按键 SVG 图标（两套）
    │   └── icons.qrc                         #   图标资源打包清单
    └── qml/                       # ★ 键盘的全部界面都在这里 ★
        ├── InputPanel.qml         # 键盘根面板：默认主题、高度/边距/间距、布局加载逻辑
        ├── Key.qml                # ★ 所有按键的基类：样式、按压效果、长按、按下预览
        ├── ShiftKey.qml  EnterKey.qml  SpaceKey.qml  BackspaceKey.qml
        ├── SymbolKey.qml  HideKey.qml  LanguageKey.qml      # 功能键（均继承 Key）
        ├── KeyPopup.qml           # 按键按下时的气泡预览
        ├── AlternativeKeysPopup.qml   # 长按弹出的备选字符弹窗
        ├── EnLayout.qml  DeLayout.qml  FrLayout.qml …     # 各语言字母布局
        ├── QwertyLayout.qml       # 通用 QWERTY 模板（注册表未直接引用，可作新布局起点）
        └── SymbolLayout.qml  DigitsLayout.qml             # 符号键盘 / 数字键盘
```

---

## 🎯 修改键盘界面：改哪里？

按"想改什么"查表（绝大部分改动只涉及 `src/qml/`，改完重新编译插件即可）：

| 想改的效果 | 去哪里改 |
|---|---|
| 颜色、字体、图标（换肤） | `src/qml/InputPanel.qml` 里的 `lightTheme` / `darkTheme`；或在应用侧传入自定义 `themes` |
| 某语言键盘的按键排布、增删按键 | `src/qml/对应语言 Layout.qml`（英文是 `EnLayout.qml`） |
| 所有按键的通用样式与交互（圆角、按压变暗、长按、预览） | `src/qml/Key.qml` |
| 某个功能键（Shift / 回车 / 空格 / 退格 / 符号 / 收起 / 语言） | `src/qml/` 下同名文件：`ShiftKey.qml`、`EnterKey.qml`、`SpaceKey.qml`、`BackspaceKey.qml`、`SymbolKey.qml`、`HideKey.qml`、`LanguageKey.qml` |
| 键盘整体：高度、边距、间距、底色 | `src/qml/InputPanel.qml` |
| 按下时的气泡预览 | `src/qml/KeyPopup.qml` |
| 长按备选字符弹窗 | `src/qml/AlternativeKeysPopup.qml` |
| 符号键盘 / 数字键盘 | `src/qml/SymbolLayout.qml` / `src/qml/DigitsLayout.qml` |
| 按键图标 | `src/icons/light/*.svg`、`src/icons/dark/*.svg` + `src/icons/icons.qrc` |
| 新增一种语言 | 见下文「新增语言布局」（QML + C++ 注册表两处） |
| 按键如何写入文本框（输入行为） | C++ 层：`src/DeclarativeInputEngine.cpp` 的 `virtualKeyClick()`、`src/VirtualKeyboardInputContext.cpp` |
| 主题可调属性有哪些 | `src/KeyboardTheme.h` 的 `Q_PROPERTY` 清单 |

### 1. 改颜色 / 字体 / 图标（主题）

默认的两套主题**直接写在 `src/qml/InputPanel.qml` 里**（`KeyboardTheme { id: lightTheme }` / `{ id: darkTheme }`）：

```qml
KeyboardTheme {
    id: lightTheme
    themeName: "defaultLight"
    backgroundColor: "#C2D4EA"            // 键盘底色
    btnBackgroundColor: "#DEECFB"         // 普通按键颜色
    btnSpecialBackgroundColor: "#ADC3DB"  // Shift/退格等功能键颜色
    btnEnterBackgroundColor: "#1DCA9B"    // 回车键颜色
    btnTextColor: "#000000"               // 按键文字颜色
    btnTextFontFamily: "Inter"
    btnTextFontSize: 21
    backspaceIcon: "qrc:/icons/SomcoKeyboard/light/keyboard_backspace.svg"
    // 另有 enterIcon / shiftOn/OffIcon / capsLockIcon / hideKeyboardIcon / languageIcon / spaceIcon
}
```

- 只想改本仓库的默认外观 → 直接改这两个对象；
- 作为库集成、不想动源码 → 在应用侧传自定义主题（见下文「自定义主题」）。注意：**一旦提供 `themes`，内置默认主题不会再自动加入**。
- 全部可调属性以 `src/KeyboardTheme.h` 为准（4 个背景色 + 文字色 + 字体 + 8 个图标路径）。

### 2. 改按键布局（增、删、改按键）

每种语言一个独立 QML 文件，如英文 `src/qml/EnLayout.qml`。布局就是普通的 `ColumnLayout` + 每行一个 `RowLayout`：

```qml
Key {
    btnKey: Qt.Key_E          // 发送给输入引擎的 Qt 键值
    text: "e"                 // 显示并上屏的字符
    alternativeKeys: "êëèé"   // 长按 800ms 弹出的备选字符
    weight: 70                // 行内相对宽度（同行按键按 weight 比例分配）
    inputPanelRef: root.inputPanel
}
```

`Key.qml` 常用属性速查：

| 属性 | 作用 |
|---|---|
| `btnKey` | Qt 键值（如 `Qt.Key_A`、`Qt.Key_Space`） |
| `text` / `btnDisplayedText` | 实际字符 / 仅用于显示的文本（空格键显示为空、回车键显示 "Enter"） |
| `alternativeKeys` | 长按备选字符（字符串，逐字符弹出） |
| `weight` | 行内相对宽度 |
| `btnBackground` / `btnIcon` / `btnIconSize` | 单键覆盖颜色与图标 |
| `functionKey` | 功能键：不产生字符、不影响大小写状态 |
| `showPreview` | 是否显示按下气泡 |
| `repeatable` | 长按连发（退格键即此实现） |

QML 是数据驱动的，改布局不需要动任何 C++ 代码。

### 3. 改按键通用样式 / 交互

所有按键（含各功能键）都继承 `src/qml/Key.qml`，改一处全局生效：

- 圆角：`background: Rectangle { radius: 8 }`
- 按压变暗：`onPressedChanged` 中 `opacity = 0.7`
- 按下气泡：`onPressed` → `inputPanelRef.showKeyPopup(key)`
- 长按备选：`longPressTimer`（800ms）→ `showAlternativesKeyPopup(key)`
- 文字大小写自动跟随 `InputEngine.uppercase`

### 4. 改键盘整体（高度 / 边距 / 间距 / 底色）

都在 `src/qml/InputPanel.qml`：

| 位置 | 说明 |
|---|---|
| `height: 340` | 键盘总高度 |
| `spacing` / `margins`（默认 16） | 键间距 / 键盘内边距，应用侧也可直接对 `InputPanel` 赋值覆盖 |
| `keyboardRect` 及其内层 `Rectangle` | 键盘背景色与圆角（颜色来自主题） |
| `loadLettersLayout()` | 语言布局的 `Loader` 加载逻辑（含回退到 `EnLayout`） |

### 5. 新增语言布局（以匈牙利语 Hu 为例）

需要 QML 和 C++ 注册表两处配合，共 4 步：

1. 新建 `src/qml/HuLayout.qml`（复制 `EnLayout.qml` 或 `QwertyLayout.qml` 后修改按键）；
2. 在 `src/DeclarativeInputEngine.h` 的 `enum InputLayouts` 中加入 `Hu`；
3. 在 `src/DeclarativeInputEngine.cpp` 的 `layoutFiles` 哈希表中登记：
   ```cpp
   {DeclarativeInputEngine::Hu, {"HuLayout", "Magyar", "Szóköz"}},
   ```
   三个字段分别是：布局 QML 文件名（不带 `.qml`）、语言显示名、空格键文案；
4. 使用时启用：`InputPanel { availableLanguageLayouts: ["En", "Hu"] }`。

> 加载机制：`InputPanel.qml` 的 `loadLettersLayout()` 调用 `InputEngine.fileOfLayout("Hu")` 得到 `"HuLayout"`，再用 `Loader` 加载 `HuLayout.qml`。多种语言可共用同一布局文件（如 `LtSrHrBsLayout.qml` 同时服务拉丁波斯尼亚语 / 克罗地亚语 / 拉丁塞尔维亚语）。`langDescription` / `spaceIdentifier` 会随布局传给 `Loader`，属预留接口。

### 6. 改图标

图标编译期打包进插件：源文件在 `src/icons/light/` 与 `src/icons/dark/`，由 `src/icons/icons.qrc` 以 `/icons/SomcoKeyboard` 前缀打包。新增 / 替换 SVG 后需同步更新 `icons.qrc`，主题中通过 `qrc:/icons/SomcoKeyboard/light/xxx.svg` 引用。

### 7. 改输入行为（进阶，C++ 层）

- 按键 → 文本：`src/DeclarativeInputEngine.cpp` 的 `virtualKeyClick()`
- 与焦点控件的桥接（预编辑文本、 surrounding text 等）：`src/VirtualKeyboardInputContext.cpp`
- 回车键行为：`EnterKeyAction` 附加属性（`EnterKeyAction.hpp/.cpp`），布局 QML 中可用 `InputContext.inputItem.EnterKeyAction.*`

---

## 🚀 快速开始

### 构建

CMake（Qt 6 / Qt 5.15 通用，自动探测版本）：

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
# 如需指定 Qt 安装：cmake -B build -DCMAKE_PREFIX_PATH=/opt/Qt/6.7.2/gcc_64
cmake --build build
./build/bin/SomcoKeyboard_example    # 示例程序
```

构建产物布局：`build/bin/SomcoKeyboard_example` + `build/bin/platforminputcontexts/libsomcokeyboard*.so`（插件在可执行文件旁即可被 QPA 发现）。

CMake 选项：

| 选项 | 默认 | 说明 |
|---|---|---|
| `BUILD_SOMCO_KEYBOARD_EXAMPLE` | `ON` | 是否构建示例 |
| `INSTALL_AS_QT_PLUGIN` | `OFF` | 安装到 Qt 安装目录的插件目录 |
| `INSTALL_PLUGINSDIR` | 空 | 自定义插件安装目录 |

qmake 方式：

```bash
qmake somcokeyboard.pro && make
```

### 集成到你的项目

1. 以 Git 子模块引入，并在 CMake 中 `add_subdirectory(3rdParty/SomcoKeyboard)`；
2. 在构造 `QGuiApplication` **之前**设置：
   ```cpp
   qputenv("QT_IM_MODULE", QByteArray("somcokeyboard"));
   ```
3. 保证插件能被 QPA 找到（可执行文件旁的 `platforminputcontexts/` 目录，或 Qt 插件目录；`make install` 会同时装到 `<prefix>/<libdir>/platforminputcontexts` 与 `<prefix>/plugins/platforminputcontexts`）；
4. QML 中使用：
   ```qml
   import QtQuick.SomcoKeyboard 1.0

   InputPanel {
       id: inputPanel
       z: 99
       y: Qt.inputMethod.visible ? parent.height - height : parent.height
       width: parent.width
       Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
   }
   ```
   若 `import` 无法解析，补一句 `engine.addImportPath(":/")`（QML 模块内嵌于插件资源中，参见 `example/main.cpp`）。

### InputPanel 可配置属性

| 属性 | 默认值 | 说明 |
|---|---|---|
| `availableLanguageLayouts` | `["En", "Pl", "Uk"]` | 可用语言列表（语言键仅在多于 1 种时可用） |
| `languageLayout` | `"En"` | 当前语言 |
| `themes` | 空 | 自定义主题列表；提供后内置主题不再自动加入 |
| `themeName` | 首个可用主题 | 当前主题名 |
| `spacing` / `margins` | 16 / 16 | 键间距 / 内边距 |
| `autoCapitalize` | `false` | 句首自动大写（内部属性，可用） |
| `active`（只读） | — | 键盘是否可见（同 `Qt.inputMethod.visible`） |

---

## 🎨 主题切换与自定义

```qml
// 切换内置主题
InputPanel { themeName: "defaultDark" }

// 自定义主题（完整替换）
InputPanel {
    themeName: "myTheme"
    themes: [
        KeyboardTheme {
            themeName: "myTheme"
            backgroundColor: "#222222"
            btnBackgroundColor: "#333333"
            btnSpecialBackgroundColor: "#444444"
            btnEnterBackgroundColor: "#1DCA9B"
            btnTextColor: "#FFFFFF"
            btnTextFontFamily: "Inter"
            btnTextFontSize: 21
        }
    ]
}
```

---

## 🌍 支持的语言

| 语言 | 代码 | 布局文件 |
|---|---|---|
| 波斯尼亚语（西里尔） | CyBs | `CySrBsLayout.qml` |
| 波斯尼亚语（拉丁） | LtBs | `LtSrHrBsLayout.qml` |
| 克罗地亚语 | Hr | `LtSrHrBsLayout.qml` |
| 捷克语 | Cs | `CsLayout.qml` |
| 丹麦语 | Da | `DaLayout.qml` |
| 荷兰语 | Nl | `NlLayout.qml` |
| 英语 | En | `EnLayout.qml` |
| 芬兰语 | Fi | `FiLayout.qml` |
| 法语 | Fr | `FrLayout.qml` |
| 德语 | De | `DeLayout.qml` |
| 希腊语 | El | `ElLayout.qml` |
| 意大利语 | It | `ItLayout.qml` |
| 波兰语 | Pl | `PlLayout.qml` |
| 葡萄牙语 | Pt | `PtLayout.qml` |
| 俄语 | Ru | `RuLayout.qml` |
| 塞尔维亚语（西里尔） | CySr | `CySrBsLayout.qml` |
| 塞尔维亚语（拉丁） | LtSr | `LtSrHrBsLayout.qml` |
| 西班牙语 | Es | `EsLayout.qml` |
| 瑞典语 | Sv | `SvLayout.qml` |
| 土耳其语 | Tr | `TrLayout.qml` |
| 乌克兰语 | Uk | `UkLayout.qml` |

---

## ❓ 常见问题

- **改了 QML 没生效？** 所有 QML 以 qrc 资源形式编译进插件二进制，修改后必须重新编译插件，并确认应用加载的是新编译的 `libsomcokeyboard*.so`（检查插件搜索路径、清理旧文件）。
- **语言切换键不见了？** `LanguageKey` 只在 `availableLanguageLayouts.length > 1` 时可用。
- **提供自定义主题后内置主题没了？** 设计如此：传入 `themes` 后默认主题不会自动加入，需要的话把内置主题定义一并放进列表。
- **`src/qml/qmldir` 需要维护吗？** 不需要。CMake 构建下该文件不参与打包（Qt 6 由 `qt_add_qml_module` 生成，Qt 5 由 CMake 生成）。
- **新增布局时报 "Missing layout" 或 "not supported"？** `InputLayouts` 枚举与 `layoutFiles` 注册表必须成对添加，见上文第 5 节。

---

## 许可与致谢

MIT 许可，详见 [LICENSE](LICENSE)。项目源自 Uwe Kindler 的 VirtualKeyboard 与 Andrea Ricchi 的 CuteKeyboard，由 Somco Software 维护。贡献指南与公司介绍见[英文版 README](README.md)。
