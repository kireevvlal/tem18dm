QT += quick
QT += serialport

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        datastore.cpp \
        inputpacket.cpp \
        main.cpp \
        outputpacket.cpp \
        parameter.cpp \
        processor.cpp \
        registrator.cpp \
        threadserialport.cpp \
        treexml.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    ../build-tem18dm-Desktop_Qt_5_15_2_MSVC2019_64bit-Debug/debug/config.xml \
    ../build-tem18dm-Desktop_Qt_5_15_2_MSVC2019_64bit-Debug/debug/diagnostic.xml \
    ../build-tem18dm-Desktop_Qt_5_15_2_MSVC2019_64bit-Debug/debug/registration.xml \
    ../build-tem18dm-Desktop_Qt_5_15_2_MSVC2019_64bit-Debug/debug/serialports.xml \
    qml/ExtBeadItem.qml \
    qml/ExtBeads.qml \
    qml/ExtCircularGauge.qml \
    qml/ExtGauge.qml \
    qml/Gauge/edit.png \
    qml/Kdr_Analog.qml \
    qml/Kdr_AvProgrev.qml \
    qml/Kdr_Bos.qml \
    qml/Kdr_Dizl.qml \
    qml/Kdr_Dskrt.qml \
    qml/Kdr_Foot.qml \
    qml/Kdr_FtBEL.qml \
    qml/Kdr_FtDzl.qml \
    qml/Kdr_FtElektr.qml \
    qml/Kdr_FtTI.qml \
    qml/Kdr_FtUso.qml \
    qml/Kdr_FtUsta.qml \
    qml/Kdr_LedError.qml \
    qml/Kdr_Masl.qml \
    qml/Kdr_Mot.qml \
    qml/Kdr_Nstr.qml \
    qml/Kdr_Ohl.qml \
    qml/Kdr_Privet.qml \
    qml/Kdr_Reo.qml \
    qml/Kdr_Svz.qml \
    qml/Kdr_Ted.qml \
    qml/Kdr_Tpl.qml \
    qml/Kdr_Tre.qml \
    qml/Kdr_Trl.qml \
    qml/Kdr_Vzb.qml \
    qml/Kdr_smlMain.qml \
    qml/LedIndicator.qml \
    qml/PrBar.qml \
    qml/TInd.qml \
    qml/TPKM.qml \
    qml/TRegm.qml \
    qml/TRevers.qml \
    qml/USOAnalog.qml \
    qml/USODiskrt.qml

HEADERS += \
    datastore.h \
    extratypes.h \
    inputpacket.h \
    outputpacket.h \
    parameter.h \
    processor.h \
    registrator.h \
    threadserialport.h \
    treexml.h \
    zapuso.h

win32:RC_FILE = ico.rc
