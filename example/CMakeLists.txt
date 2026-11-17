cmake_minimum_required(VERSION 3.20)
project(SomcoKeyboard_example VERSION 1.0 LANGUAGES CXX)

if(QT_VERSION_MAJOR EQUAL 6)
  qt_add_executable(${PROJECT_NAME} WIN32 MACOSX_BUNDLE main.cpp qml.qrc icons/icons.qrc)
else()
  # Qt 5 targeting; AUTORCC (enabled in the top-level CMakeLists.txt) compiles
  # the .qrc files that are listed as sources.
  add_executable(${PROJECT_NAME} WIN32 MACOSX_BUNDLE main.cpp qml.qrc icons/icons.qrc)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE QT_DEPRECATED_WARNINGS)

target_link_libraries(${PROJECT_NAME} PRIVATE
  Qt::Core
  Qt::Gui
  Qt::Quick
)

if(QT_VERSION_MAJOR EQUAL 6)
  install(
    TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

  qt6_generate_deploy_app_script(TARGET ${PROJECT_NAME} OUTPUT_SCRIPT deploy_script
                                NO_UNSUPPORTED_PLATFORM_ERROR)
  install(SCRIPT ${deploy_script})
endif()
