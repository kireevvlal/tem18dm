QT += quick
QT += serialport
QT       += multimedia

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    control.cpp \
    diagnostics.cpp \
        main.cpp \
        processor.cpp \
        registrator.cpp \
        saver.cpp \
    slave.cpp

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
    error.wav \
    qml/ExtBeadItem.qml \
    qml/ExtBeads.qml \
    qml/ExtCircularGauge.qml \
    qml/ExtGauge.qml \
    qml/Gauge/edit.png \
    qml/Kdr_Analog.qml \
    qml/Kdr_AvProgrev.qml \
    qml/Kdr_Bos.qml \
    qml/Kdr_DateTime.qml \
    qml/Kdr_Develop.qml \
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
    qml/USODiskrt.qml \
    qml/scripts.js

HEADERS += \
    control.h \
    diagnostics.h \
    processor.h \
    registrator.h \
    saver.h \
    slave.h \
    tem18dm.h \
    zapuso.h

win32:INCLUDEPATH += D:/Development/Qt/vktoolslib
unix:INCLUDEPATH += /home/kont/develop/vktoolslib

win32:LIBS+=  D:/Development/Qt/vktoolslib/vktreexml.lib
win32:LIBS+=  D:/Development/Qt/vktoolslib/vkserialport.lib
win32:LIBS+=  D:/Development/Qt/vktoolslib/vkdatastore.lib
unix:LIBS += -L/home/kont/develop/vktoolslib -lvktreexml
unix:LIBS += -L/home/kont/develop/vktoolslib -lvkserialport
unix:LIBS += -L/home/kont/develop/vktoolslib -lvkdatastore

win32:RC_FILE = ico.rc
