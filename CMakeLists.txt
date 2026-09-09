cmake_minimum_required(VERSION 3.20)
project(SomcoKeyboard VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Place the example executable and the keyboard platform plugin in one tree
# ("bin/platforminputcontexts") so the plugin is found next to the executable.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# Support both Qt 6 and Qt 5 from the same build files.
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Qml Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Qml Quick REQUIRED)

message(STATUS "Qt found: ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")

if(QT_VERSION_MAJOR EQUAL 6)
  # Since Qt 6.10 the private modules must be requested explicitly.
  if(QT_VERSION VERSION_GREATER_EQUAL "6.10")
    set(QT_NO_PRIVATE_MODULE_WARNING ON)
    find_package(Qt6 REQUIRED COMPONENTS GuiPrivate QuickPrivate)
  endif()

  if(QT_KNOWN_POLICY_QTP0001)
    qt_policy(SET QTP0001 NEW)
  endif()
  if(QT_KNOWN_POLICY_QTP0004)
    qt_policy(SET QTP0004 NEW)
  endif()

  qt_standard_project_setup()
endif()

option(BUILD_SOMCO_KEYBOARD_EXAMPLE "Build Somco Keyboard example" ON)
option(INSTALL_AS_QT_PLUGIN "Install as Qt platform plugin addon to Qt installation" OFF)
set(INSTALL_PLUGINSDIR "" CACHE PATH "Custom installation directory for plugins (optional)")

if(BUILD_SOMCO_KEYBOARD_EXAMPLE)
  add_subdirectory(example)
endif()

add_subdirectory(src)

if(QT_VERSION_MAJOR EQUAL 6)
  qt_finalize_project()
endif()
