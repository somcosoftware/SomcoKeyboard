
file(GLOB_RECURSE HEADERS *.h *.hpp)
file(GLOB_RECURSE SOURCES *.cpp)
file(GLOB_RECURSE QML_FILES qml/*.qml)

if(QT_VERSION_MAJOR EQUAL 6)
  # -------------------------------------------------------------------------
  # Qt 6: use the official QML module CMake API. It compiles the QML files,
  # generates the module's qmldir/qmltypes and registers the C++ types marked
  # with QML_ELEMENT / QML_SINGLETON / QML_ATTACHED.
  # -------------------------------------------------------------------------
  foreach(_file ${QML_FILES})
    cmake_path(GET _file FILENAME _fileName)
    set_source_files_properties(${_file} PROPERTIES QT_RESOURCE_ALIAS ${_fileName})
  endforeach()

  qt_add_qml_module(
    ${PROJECT_NAME}
    URI "QtQuick.SomcoKeyboard"
    VERSION 1.0
    PLUGIN_TARGET ${PROJECT_NAME}
    RESOURCE_PREFIX "/"
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/QtQuick/SomcoKeyboard"
    CLASS_NAME "VirtualKeyboardInputContextPlugin"
    SOURCES
      ${HEADERS}
      ${SOURCES}
    QML_FILES
      ${QML_FILES}
    RESOURCES
      icons/icons.qrc
      somcokeyboard.json
    NO_GENERATE_PLUGIN_SOURCE
  )
else()
  # -------------------------------------------------------------------------
  # Qt 5: build the QPA platform input context plugin manually (mirrors the
  # qmake build in src.pro). The QML types are registered at runtime by
  # VirtualKeyboardInputContext, so the QML documents only have to be made
  # reachable on the QML import path.
  # -------------------------------------------------------------------------
  add_library(${PROJECT_NAME} SHARED
    ${HEADERS}
    ${SOURCES}
  )

  # Embed the keyboard icons into the plugin.
  qt5_add_resources(_icons_srcs icons/icons.qrc)

  # Export the QML documents and a qmldir as Qt resources so that both
  # "import QtQuick.SomcoKeyboard" and the internal "import SomcoKeyboard"
  # (used by the keyboard's own QML documents) resolve through the ":/"
  # import path, exactly like the Qt 6 build.
  set(_qml_out "${CMAKE_CURRENT_BINARY_DIR}/qml-module")
  file(MAKE_DIRECTORY "${_qml_out}")

  # Qmldir of the public module, plus a stub module for the internal import.
  file(WRITE "${_qml_out}/qmldir" "module QtQuick.SomcoKeyboard\nInputPanel 1.0 InputPanel.qml\n")
  file(WRITE "${_qml_out}/qmldir-internal" "module SomcoKeyboard\n")

  set(_qtquick_qrc "${_qml_out}/QtQuick_SomcoKeyboard.qrc")
  set(_qtquick_rcc "<RCC>\n  <qresource prefix=\"/QtQuick/SomcoKeyboard\">\n")
  string(APPEND _qtquick_rcc "    <file alias=\"qmldir\">${_qml_out}/qmldir</file>\n")
  foreach(_file ${QML_FILES})
    cmake_path(GET _file FILENAME _fileName)
    string(APPEND _qtquick_rcc "    <file alias=\"${_fileName}\">${_file}</file>\n")
  endforeach()
  string(APPEND _qtquick_rcc "  </qresource>\n</RCC>\n")
  file(WRITE "${_qtquick_qrc}" "${_qtquick_rcc}")

  set(_internal_qrc "${_qml_out}/SomcoKeyboard.qrc")
  set(_internal_rcc "<RCC>\n  <qresource prefix=\"/SomcoKeyboard\">\n")
  string(APPEND _internal_rcc "    <file alias=\"qmldir\">${_qml_out}/qmldir-internal</file>\n")
  string(APPEND _internal_rcc "  </qresource>\n</RCC>\n")
  file(WRITE "${_internal_qrc}" "${_internal_rcc}")

  qt5_add_resources(_qml_srcs "${_qtquick_qrc}" "${_internal_qrc}")
  target_sources(${PROJECT_NAME} PRIVATE ${_icons_srcs} ${_qml_srcs})
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE
  Qt::Core
  Qt::Gui
  Qt::GuiPrivate
  Qt::Quick
  Qt::Qml
  Qt::QuickPrivate
)

set_target_properties(${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME somcokeyboard
  DEBUG_POSTFIX d
)

if(INSTALL_PLUGINSDIR)
  message(STATUS "${PROJECT_NAME} will be installed to custom directory: ${INSTALL_PLUGINSDIR}/platforminputcontexts")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${INSTALL_PLUGINSDIR}/platforminputcontexts"
  )
elseif(INSTALL_AS_QT_PLUGIN)
  message(STATUS "${PROJECT_NAME} will be installed as Qt plugin addon: ${Qt${QT_VERSION_MAJOR}_DIR}/../../../plugins/platforminputcontexts")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${Qt${QT_VERSION_MAJOR}_DIR}/../../../plugins/platforminputcontexts"
  )
else()
  message(STATUS "${PROJECT_NAME} will be installed next to executable: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforminputcontexts")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforminputcontexts"
  )
endif()


# ---------------------------------------------------------------------------
# 安装规则（路径不硬编码：均用 GNUInstallDirs / Qt 约定相对布局）
#
# SomcoKeyboard 插件安装两份：
#   1) <prefix>/${CMAKE_INSTALL_LIBDIR}/platforminputcontexts/（默认 lib/…）
#      —— 与其他库集中管理；
#   2) <prefix>/plugins/platforminputcontexts/
#      —— Qt 约定插件目录。Qt 的 QPA 插件发现机制只扫描：
#      a) Qt 插件路径（qt.conf 的 Prefix=.. 时即 <prefix>/plugins，linuxdeployqt
#         打包后正是此布局）；b) 可执行文件同级的 platforminputcontexts/。
#      lib/ 下的那份 QPA 不会主动搜索，故必须有一份落在 a) 或 b)。
#      （linuxdeployqt 只搬运 Qt 自带插件，不会带上本第三方插件，需自行装入。）
# 插件内嵌 QtQuick.SomcoKeyboard / SomcoKeyboard 两个 QML 模块的 qrc 资源，
# 插件被 QPA 加载后 import 方可解析，因此只需安装插件本体即可。
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/platforminputcontexts
    RUNTIME DESTINATION ${CMAKE_INSTALL_LIBDIR}/platforminputcontexts
)
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION plugins/platforminputcontexts
    RUNTIME DESTINATION plugins/platforminputcontexts
)
