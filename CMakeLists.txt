cmake_minimum_required(VERSION 3.15)

project(POKERTH)

option(CMAKE_AUTORCC "" ON)
option(CMAKE_AUTOUIC "" ON)
option(CMAKE_AUTOMOC "" ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

list(APPEND CMAKE_AUTOUIC_SEARCH_PATHS "uics/")
list(APPEND CMAKE_AUTOUIC_SEARCH_PATHS "src/gui/qt")
list(APPEND CMAKE_AUTOUIC_SEARCH_PATHS "src/gui/qt/gui_800x480")

if(GUI_800_480)
    add_definitions(-DGUI_800x480)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FindBoost)
include(FindGSasl)
include(FindMySQL)

find_package(Boost REQUIRED COMPONENTS iostreams random thread filesystem program_options)
find_package(GSasl REQUIRED)
find_package(SQLite3 REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(SDL REQUIRED)
find_package(SDL_mixer REQUIRED)
find_package(CURL REQUIRED)
find_package(MySQL REQUIRED)
find_package(Protobuf REQUIRED)
    protobuf_generate_cpp(PROTOBUF_GEN_SRC PROTOBUF_GEN_HDRS
    chatcleaner.proto pokerth.proto
    PROTOC_OUT_DIR  ${CMAKE_SOURCE_DIR}/src/third_party/protobuf)
find_package(Qt6 REQUIRED COMPONENTS Core Sql Xml WebSockets Qml Quick QuickControls2 Widgets Svg Network LinguistTools REQUIRED)

# @TODO: better use a FindCurl.cmake file?
add_library(LibCurl INTERFACE IMPORTED)
set_target_properties(LibCurl PROPERTIES
INTERFACE_INCLUDE_DIRECTORIES "${CURL_INCLUDE_DIRS}")
if(WIN32)
    target_link_libraries(LibCurl INTERFACE "${CURL_LIBRARY}")
else()
    set_target_properties(LibCurl PROPERTIES
        INTERFACE_LINK_LIBRARIES "${CURL_LIBRARY}")
endif()


# POKERTH.lib

set(POKERTH_LIB_SRC 
    src/engine/game.cpp 
    src/session.cpp 
    src/playerdata.cpp 
    src/config/configfile.cpp 
    src/engine/boardinterface.cpp 
    src/engine/enginefactory.cpp 
    src/engine/handinterface.cpp 
    src/engine/playerinterface.cpp 
    src/engine/berointerface.cpp 
    src/gui/guiinterface.cpp 
    src/core/common/thread.cpp 
    src/core/common/crypthelper.cpp 
    src/core/common/avatarmanager.cpp 
    src/core/common/pokerthexception.cpp 
    src/engine/local_engine/cardsvalue.cpp 
    src/engine/local_engine/localboard.cpp 
    src/engine/local_engine/localenginefactory.cpp 
    src/engine/local_engine/localhand.cpp 
    src/engine/local_engine/localplayer.cpp 
    src/engine/local_engine/localberopreflop.cpp 
    src/engine/local_engine/localberoflop.cpp 
    src/engine/local_engine/localberoturn.cpp 
    src/engine/local_engine/localberoriver.cpp 
    src/engine/local_engine/localberopostriver.cpp 
    src/engine/local_engine/localbero.cpp 
    src/engine/local_engine/localexception.cpp 
    src/engine/local_engine/arraydata.cpp 
    src/engine/log.cpp 
    src/engine/network_engine/clientboard.cpp 
    src/engine/network_engine/clientenginefactory.cpp 
    src/engine/network_engine/clienthand.cpp 
    src/engine/network_engine/clientplayer.cpp 
    src/engine/network_engine/clientbero.cpp 
    src/net/common/chatcleanermanager.cpp 
    src/net/common/chatcleanercallback.cpp 
    src/net/common/clientcallback.cpp 
    src/net/common/clientcontext.cpp 
    src/net/common/clientstate.cpp 
    src/net/common/clientthread.cpp 
    src/net/common/downloadhelper.cpp 
    src/net/common/downloaderthread.cpp 
    src/net/common/netpacket.cpp 
    src/net/common/netpacketvalidator.cpp 
    src/net/common/senderhelper.cpp 
    src/net/common/sendercallback.cpp 
    src/net/common/serverexception.cpp 
    src/net/common/serveracceptinterface.cpp 
    src/net/common/serveracceptwebhelper.cpp 
    src/net/common/servergame.cpp 
    src/net/common/servergamestate.cpp 
    src/net/common/serverlobbythread.cpp 
    src/net/common/serverbanmanager.cpp 
    src/net/common/servercallback.cpp 
    src/net/common/serveradminbot.cpp 
    src/net/common/serverlobbybot.cpp 
    src/net/common/serverircbotcallback.cpp 
    src/net/common/sessiondata.cpp 
    src/net/common/sessiondatacallback.cpp 
    src/net/common/sessionmanager.cpp 
    src/net/common/socket_startup.cpp 
    src/net/common/clientexception.cpp 
    src/net/common/netcontext.cpp 
    src/net/common/netexception.cpp 
    src/net/common/irccallback.cpp 
    src/net/common/servermanager.cpp 
    src/net/common/transferhelper.cpp 
    src/net/common/uploaderthread.cpp 
    src/net/common/uploadhelper.cpp 
    src/gui/generic/serverguiwrapper.cpp 
    src/gui/qttoolsinterface.cpp 
    src/net/common/sendbuffer.cpp 
    src/net/common/asiosendbuffer.cpp 
    src/net/common/websendbuffer.cpp 
    src/net/common/receivebuffer.cpp 
    src/net/common/asioreceivebuffer.cpp 
    src/net/common/webreceivebuffer.cpp 
    src/net/common/uploadcallback.cpp)

if(ANDROID)
    list(APPEND POKERTH_LIB_SRC "src/engine/local_engine/tools_android.cpp")
else()
    list(APPEND POKERTH_LIB_SRC "src/engine/local_engine/tools.cpp")
endif()

add_library(pokerth_lib STATIC "${POKERTH_LIB_SRC}")

target_include_directories(pokerth_lib PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_lib PUBLIC
    src
    src/engine src/engine/local_engine src/engine/network_engine
    src/gui src/gui/qt src/gui/qt/qttools src/gui/qt/gametable
    src/net
    src/config
    src/core
    src/third_party/websocketpp)

target_link_libraries(pokerth_lib PUBLIC "${SQLite3_LIBRARIES}")
target_link_libraries(pokerth_lib PUBLIC "${GSASL_LIBRARIES}")
target_link_libraries(pokerth_lib PUBLIC "${Boost_LIBRARIES}")
target_link_libraries(pokerth_lib PUBLIC "${OPENSSL_LIBRARIES}")
target_link_libraries(pokerth_lib PRIVATE Qt6::Xml)

target_compile_options(pokerth_lib PUBLIC -fexceptions -frtti)
target_compile_definitions(pokerth_lib PUBLIC ENABLE_IPV6 HAVE_OPENSSL BOOST_FILESYSTEM_DEPRECATED MYSQLPP_MYSQL_HEADERS_BURIED)


# POKERTH.dbofficial

file(GLOB POKERTH_DBOFFICIAL_SRC src/dbofficial/*.cpp)

add_library(pokerth_dbofficial "${POKERTH_DBOFFICIAL_SRC}")

target_include_directories(pokerth_dbofficial PRIVATE "${MYSQLPP_INCLUDE_DIR}")
target_include_directories(pokerth_dbofficial PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_dbofficial PUBLIC src/)


# POKERTH.db

file(GLOB POKERTH_DB_SRC src/db/common/*.cpp)

add_library(pokerth_db "${POKERTH_DB_SRC}")

target_include_directories(pokerth_db PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_db PUBLIC src/)


# POKERTH.protocol

add_library(pokerth_protocol "${PROTOBUF_GEN_SRC}")

target_include_directories(pokerth_protocol PRIVATE "${Protobuf_INCLUDE_DIR}")
target_include_directories(pokerth_protocol PUBLIC "src/third_party/protobuf")

target_link_libraries(pokerth_protocol PUBLIC "${Protobuf_LIBRARIES}")

set_property(SOURCE src/third_party/protobuf/chatcleaner.pb.cc PROPERTY SKIP_AUTOGEN ON)
set_property(SOURCE src/third_party/protobuf/chatcleaner.pb.h PROPERTY SKIP_AUTOGEN ON)
set_property(SOURCE src/third_party/protobuf/pokerth.pb.cc PROPERTY SKIP_AUTOGEN ON)
set_property(SOURCE src/third_party/protobuf/pokerth.pb.h PROPERTY SKIP_AUTOGEN ON)


# POKERTH.client ... Qt Widgets Client

set(POKERTH_CLIENT_SRC src/pokerth.cpp 
    src/gui/qt/chattools/chattools.cpp 
    src/gui/qt/guiwrapper.cpp 
    src/gui/qt/qttools/qttoolswrapper.cpp 
    src/gui/qt/qttools/qthelper/qthelper.cpp 
    src/gui/qt/gametable/gametableimpl.cpp 
    src/gui/qt/gametable/mycardspixmaplabel.cpp 
    src/gui/qt/gametable/mysetlabel.cpp 
    src/gui/qt/gametable/myactionbutton.cpp 
    src/gui/qt/gametable/mystatuslabel.cpp 
    src/gui/qt/gametable/myslider.cpp 
    src/gui/qt/gametable/myavatarlabel.cpp 
    src/gui/qt/gametable/myrighttabwidget.cpp 
    src/gui/qt/gametable/mylefttabwidget.cpp 
    src/gui/qt/gametable/startsplash/startsplash.cpp 
    src/gui/qt/gametable/log/guilog.cpp 
    src/gui/qt/aboutpokerth/aboutpokerthimpl.cpp 
    src/gui/qt/connecttoserverdialog/connecttoserverdialogimpl.cpp 
    src/gui/qt/createnetworkgamedialog/createnetworkgamedialogimpl.cpp 
    src/gui/qt/createinternetgamedialog/createinternetgamedialogimpl.cpp 
    src/gui/qt/joinnetworkgamedialog/joinnetworkgamedialogimpl.cpp 
    src/gui/qt/newlocalgamedialog/newgamedialogimpl.cpp 
    src/gui/qt/settingsdialog/settingsdialogimpl.cpp 
    src/gui/qt/settingsdialog/myavatarbutton.cpp 
    src/gui/qt/settingsdialog/myhpavatarbutton.cpp 
    src/gui/qt/settingsdialog/selectavatardialog/selectavatardialogimpl.cpp 
    src/gui/qt/settingsdialog/selectavatardialog/myavatarlistitem.cpp 
    src/gui/qt/settingsdialog/manualblindsorderdialog/manualblindsorderdialogimpl.cpp 
    src/gui/qt/startnetworkgamedialog/startnetworkgamedialogimpl.cpp 
    src/gui/qt/startwindow/startwindowimpl.cpp 
    src/gui/qt/styles/gametablestylereader.cpp 
    src/gui/qt/styles/carddeckstylereader.cpp 
    src/gui/qt/changecontentdialog/changecontentdialogimpl.cpp 
    src/gui/qt/changecompleteblindsdialog/changecompleteblindsdialogimpl.cpp 
    src/gui/qt/mymessagedialog/mymessagedialogimpl.cpp 
    src/gui/qt/gamelobbydialog/gamelobbydialogimpl.cpp 
    src/gui/qt/gamelobbydialog/mygamelisttreewidget.cpp 
    src/gui/qt/timeoutmsgbox/timeoutmsgboximpl.cpp 
    src/net/common/net_helper_client.cpp 
    src/core/common/loghelper_client.cpp 
    src/gui/qt/gametable/mychancelabel.cpp 
    src/gui/qt/serverlistdialog/serverlistdialogimpl.cpp 
    src/gui/qt/gametable/mytimeoutlabel.cpp 
    src/gui/qt/gametable/mynamelabel.cpp 
    src/gui/qt/settingsdialog/mystylelistitem.cpp 
    src/gui/qt/gamelobbydialog/mygamelistsortfilterproxymodel.cpp 
    src/gui/qt/internetgamelogindialog/internetgamelogindialogimpl.cpp 
    src/engine/local_engine/replay.cpp 
    src/gui/qt/gamelobbydialog/mynicklistsortfilterproxymodel.cpp 
    src/net/common/servermanagerfactoryclient.cpp 
    src/gui/qt/gametable/mycashlabel.cpp 
    src/gui/qt/sound/soundevents.cpp 
    src/gui/qt/sound/sdlplayer.cpp
    src/gui/qt/mymessagebox/mymessagebox.cpp 
    src/gui/qt/logfiledialog/logfiledialog.cpp)

if(ANDROID)
    list(APPEND POKERTH_CLIENT_SRC "src/gui/qt/resources/pokerth_android.qrc")
else()
    list(APPEND POKERTH_CLIENT_SRC "src/gui/qt/resources/pokerth.qrc")
endif()

file(GLOB QTSINGLEAPPLICATION_SRC src/third_party/qtsingleapplication/*.cpp src/third_party/qtlockedfile/qtlockedfile.cpp)

if(UNIX)
    set(QTSINGLEAPPLICATION_SRC "${QTSINGLEAPPLICATION_SRC};src/third_party/qtlockedfile/qtlockedfile_unix.cpp")
elseif(WIN32)
    set(QTSINGLEAPPLICATION_SRC "${QTSINGLEAPPLICATION_SRC};src/third_party/qtlockedfile/qtlockedfile_win.cpp")
endif()

add_executable(pokerth_client "${POKERTH_CLIENT_SRC}" "${QTSINGLEAPPLICATION_SRC}")

target_include_directories(pokerth_client PUBLIC src/third_party/qtsingleapplication src/third_party/qtlockedfile)
target_include_directories(pokerth_client PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_client PRIVATE "${SDL_MIXER_INCLUDE_DIRS}")
target_include_directories(pokerth_client PUBLIC "uics/")
target_include_directories(pokerth_client PUBLIC
    src 
    src/engine 
    src/gui 
    src/net 
    src/engine/local_engine 
    src/engine/network_engine 
    src/config 
    src/gui/qt 
    src/gui/qt/connecttoserverdialog 
    src/core 
    src/gui/qt/sound 
    src/gui/qt/qttools 
    src/gui/qt/chattools 
    src/gui/qt/qttools/qthelper 
    src/gui/qt/gametable 
    src/gui/qt/gametable/startsplash 
    src/gui/qt/gametable/log 
    src/gui/qt/aboutpokerth 
    src/gui/qt/createnetworkgamedialog 
    src/gui/qt/createinternetgamedialog 
    src/gui/qt/joinnetworkgamedialog 
    src/gui/qt/newlocalgamedialog 
    src/gui/qt/settingsdialog 
    src/gui/qt/settingsdialog/selectavatardialog 
    src/gui/qt/settingsdialog/manualblindsorderdialog 
    src/gui/qt/startnetworkgamedialog 
    src/gui/qt/startwindow 
    src/gui/qt/serverlistdialog 
    src/gui/qt/styles 
    src/gui/qt/changecontentdialog 
    src/gui/qt/changecompleteblindsdialog 
    src/gui/qt/internetgamelogindialog 
    src/gui/qt/mymessagedialog 
    src/gui/qt/gamelobbydialog 
    src/gui/qt/timeoutmsgbox 
    src/gui/qt/logfiledialog 
    src/gui/qt/mymessagebox/)

target_link_libraries(pokerth_client PUBLIC LibCurl)
target_link_libraries(pokerth_client PUBLIC "${SDL_LIBRARIES}" "${SDL_MIXER_LIBRARIES}")
target_link_libraries(pokerth_client PRIVATE Qt6::Core Qt6::Gui Qt6::Sql Qt6::Xml Qt6::Widgets Qt6::Network)
target_link_libraries(pokerth_client PUBLIC pokerth_lib)
target_link_libraries(pokerth_client PUBLIC pokerth_db)
target_link_libraries(pokerth_client PUBLIC pokerth_protocol)

install(TARGETS pokerth_client DESTINATION /usr/bin)
install(DIRECTORY data DESTINATION /usr/share/pokerth)
install(FILES pokerth.desktop DESTINATION /usr/share/applications)
install(FILES pokerth.png DESTINATION /usr/share/pixmaps)


# POKERTH.qml-client ... unfinisihed

set(POKERTH_QML_CLIENT_SRC src/pokerth.cpp
    src/core/common/loghelper_client.cpp
    src/core/common/qttools/qthelper/qthelper.cpp
    src/core/common/qttools/qttoolswrapper.cpp
    src/core/common/qttoolsinterface.cpp
    src/gui/qt6-qml/cpp/retranslate.cpp
    src/gui/qt6-qml/cpp/settingsxmlhandler.cpp)

qt_add_resources(POKERTH_QML_CLIENT_SRC src/gui/qt6-qml/qml.qrc)

set(QML_FILES
    src/gui/qt6-qml/pokerth.qml
    src/gui/qt6-qml/components/CustomCheckBox.qml
    src/gui/qt6-qml/components/CustomComboBox.qml
    src/gui/qt6-qml/components/CustomTabBar.qml
    src/gui/qt6-qml/components/CustomToggle.qml
    src/gui/qt6-qml/components/GamePlayerBox.qml
    src/gui/qt6-qml/components/GamePlayerSelfBox.qml
    src/gui/qt6-qml/components/GuiSettings.qml
    src/gui/qt6-qml/components/InternetGameSettings.qml
    src/gui/qt6-qml/components/LocalGameSettings.qml
    src/gui/qt6-qml/components/LogsSettings.qml
    src/gui/qt6-qml/components/NetworkGameSettings.qml
    src/gui/qt6-qml/components/NicknameAvatarSettings.qml
    src/gui/qt6-qml/components/ResetSettings.qml
    src/gui/qt6-qml/components/SideMenu.qml
    src/gui/qt6-qml/components/SoundSettings.qml
    src/gui/qt6-qml/components/CustomButton.qml
    src/gui/qt6-qml/components/StyleSettings.qml
    src/gui/qt6-qml/pages/AboutPage.qml
    src/gui/qt6-qml/pages/GamePage.qml
    src/gui/qt6-qml/pages/InternetGamePage.qml
    src/gui/qt6-qml/pages/LocalGamePage.qml
    src/gui/qt6-qml/pages/LogsPage.qml
    src/gui/qt6-qml/pages/NetworkGameCreatePage.qml
    src/gui/qt6-qml/pages/NetworkGameEnterPage.qml
    src/gui/qt6-qml/pages/PreLoader.qml
    src/gui/qt6-qml/pages/SettingsPage.qml
    src/gui/qt6-qml/pages/StartPage.qml
    src/gui/qt6-qml/config/StaticData.qml
    src/gui/qt6-qml/config/Parameters.qml)

set(TS_FILES
    src/gui/qt6-qml/i18n/pokerth_de_DE.ts
    src/gui/qt6-qml/i18n/pokerth_fr_FR.ts
    src/gui/qt6-qml/i18n/pokerth_en_US.ts
)

qt_create_translation(TS_FILES ${TS_FILES}
    SOURCES         ${POKERTH_QML_CLIENT_SRC} ${QML_FILES}
    RESOURCE_PREFIX "/i18n"
)

add_executable(pokerth_qml-client "${POKERTH_QML_CLIENT_SRC}")

target_include_directories(pokerth_qml-client PUBLIC
    src
    src/config
    src/core
    src/core/common
    src/core/common/qttools
    src/core/common/qttools/qthelper
    src/gui
    src/gui/qt6-qml/cpp)

target_link_libraries(pokerth_qml-client PUBLIC pokerth_lib)
target_link_libraries(pokerth_qml-client PUBLIC pokerth_protocol)
target_link_libraries(pokerth_qml-client PUBLIC LibCurl)
target_link_libraries(pokerth_qml-client PRIVATE Qt6::Core Qt6::Gui Qt6::Quick Qt6::Qml Qt6::Sql Qt6::Xml Qt6::Svg Qt6::QuickControls2 Qt6::Widgets)

target_compile_definitions(pokerth_qml-client PUBLIC QML_CLIENT)

install(TARGETS pokerth_qml-client DESTINATION /usr/bin)
install(DIRECTORY data DESTINATION /usr/share/pokerth)
install(FILES pokerth_qml.desktop DESTINATION /usr/share/applications)
install(FILES pokerth.png DESTINATION /usr/share/pixmaps)


# POKERTH.dedicated_server

set(POKERTH_SERVER_SRC src/pokerth_server.cpp
    src/gui/qt/qttools/nonqttoolswrapper.cpp
    src/gui/qt/qttools/nonqthelper/nonqthelper.cpp
    src/net/common/net_helper_server.cpp
    src/core/common/loghelper_server.cpp
    src/net/common/ircthread.cpp
    src/net/common/servermanagerirc.cpp
    src/net/common/servermanagerfactoryserver.cpp
    src/core/linux/convhelper.cpp)

add_executable(pokerth_dedicated_server "${POKERTH_SERVER_SRC}" )

target_include_directories(pokerth_dedicated_server PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_dedicated_server PUBLIC
    src 
    src/engine 
    src/gui
    src/gui/qt
    src/gui/qt/qttools
    src/gui/qt/qttools/nonqthelper
    src/net 
    src/engine/local_engine 
    src/engine/network_engine 
    src/config 
    src/core)

target_link_libraries(pokerth_dedicated_server PUBLIC LibCurl)
target_link_libraries(pokerth_dedicated_server PUBLIC -lircclient)
target_link_libraries(pokerth_dedicated_server PUBLIC pokerth_lib)
target_link_libraries(pokerth_dedicated_server PUBLIC pokerth_db)
target_link_libraries(pokerth_dedicated_server PUBLIC pokerth_protocol)
target_link_libraries(pokerth_dedicated_server PRIVATE Qt6::Xml)

target_compile_definitions(pokerth_dedicated_server PUBLIC POKERTH_DEDICATED_SERVER)

install(TARGETS pokerth_dedicated_server DESTINATION /usr/bin)

# POKERTH.official_server

set(POKERTH_OFFICIAL_SERVER_SRC src/pokerth_server.cpp
    src/dbofficial/asyncdbcreategame.cpp
    src/dbofficial/asyncdbgameplace.cpp
    src/dbofficial/asyncdbupdatescore.cpp
    src/dbofficial/asyncdbquery.cpp
    src/dbofficial/serverdbthread.cpp
    src/dbofficial/serverdbfactoryinternal.cpp
    src/dbofficial/singleasyncdbquery.cpp
    src/dbofficial/compositeasyncdbquery.cpp
    src/dbofficial/querycontext.cpp
    src/dbofficial/asyncdbendgame.cpp
    src/dbofficial/asyncdblogin.cpp
    src/dbofficial/asyncdbreportavatar.cpp
    src/dbofficial/asyncdbreportgame.cpp
    src/dbofficial/asyncdbavatarblacklist.cpp
    src/dbofficial/asyncdbadminplayers.cpp
    src/dbofficial/asyncdbblockplayer.cpp
    src/dbofficial/asyncdbplayerlastgames.cpp
    src/dbofficial/dbidmanager.cpp
    src/gui/qt/qttools/nonqttoolswrapper.cpp
    src/gui/qt/qttools/nonqthelper/nonqthelper.cpp
    src/net/common/net_helper_server.cpp
    src/core/common/loghelper_server.cpp
    src/net/common/ircthread.cpp
    src/net/common/servermanagerirc.cpp
    src/net/common/servermanagerfactoryserver.cpp
    src/core/linux/convhelper.cpp)

add_executable(pokerth_official_server "${POKERTH_OFFICIAL_SERVER_SRC}" )

target_include_directories(pokerth_official_server PRIVATE "${Boost_INCLUDE_DIRS}")
target_include_directories(pokerth_official_server PUBLIC "${MYSQLPP_INCLUDE_DIR}")
target_include_directories(pokerth_official_server PUBLIC
    src 
    src/engine 
    src/gui
    src/gui/qt
    src/gui/qt/qttools
    src/gui/qt/qttools/nonqthelper
    src/net 
    src/engine/local_engine 
    src/engine/network_engine 
    src/config 
    src/core)

target_link_libraries(pokerth_official_server PUBLIC LibCurl)
target_link_libraries(pokerth_official_server PUBLIC -lircclient)
target_link_libraries(pokerth_official_server PUBLIC "${MYSQLPP_LIBRARIES}")
target_link_libraries(pokerth_official_server PUBLIC pokerth_dbofficial)
target_link_libraries(pokerth_official_server PUBLIC pokerth_lib)
target_link_libraries(pokerth_official_server PUBLIC pokerth_db)
target_link_libraries(pokerth_official_server PUBLIC pokerth_protocol)
target_link_libraries(pokerth_official_server PRIVATE Qt6::Xml)

target_compile_definitions(pokerth_official_server PUBLIC POKERTH_OFFICIAL_SERVER POKERTH_DEDICATED_SERVER)

install(TARGETS pokerth_official_server DESTINATION /usr/bin)


# POKERTH.chatcleaner

set(POKERTH_CHATCLEANER_SRC src/chatcleaner/chatcleaner.cpp
	src/chatcleaner/cleanerserver.cpp
	src/chatcleaner/messagefilter.cpp
	src/chatcleaner/badwordcheck.cpp
	src/chatcleaner/textfloodcheck.cpp
	src/chatcleaner/cleanerconfig.cpp
	src/chatcleaner/capsfloodcheck.cpp
	src/chatcleaner/letterrepeatingcheck.cpp
	src/chatcleaner/urlcheck.cpp)

add_executable(pokerth_chatcleaner "${POKERTH_CHATCLEANER_SRC}" )

target_include_directories(pokerth_chatcleaner PUBLIC
    src/
	src/chatcleaner/
	src/net/)

target_link_libraries(pokerth_chatcleaner PUBLIC pokerth_lib)
target_link_libraries(pokerth_chatcleaner PUBLIC pokerth_protocol)
target_link_libraries(pokerth_chatcleaner PUBLIC "${Protobuf_LIBRARIES}")
target_link_libraries(pokerth_chatcleaner PRIVATE Qt6::Xml Qt6::Network)

install(TARGETS pokerth_chatcleaner DESTINATION /usr/bin)
