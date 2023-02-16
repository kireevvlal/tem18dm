//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
// key buttons
function getKey(key) {
    var ret = 0;
    if (moduleType == 1) {
        switch (key) {
        case Qt.Key_0: ret = "0"; break
        case Qt.Key_1: ret = "1"; break
        case Qt.Key_2: ret = "2"; break
        case Qt.Key_3: ret = "3"; break
        case Qt.Key_4: ret = "4"; break
        case Qt.Key_5: ret = "5"; break
        case Qt.Key_6: ret = "6"; break
        case Qt.Key_7: ret = "7"; break
        case Qt.Key_8: ret = "8"; break
        case Qt.Key_9: ret = "9"; break
        case Qt.Key_A: ret = "AUS"; break
        case Qt.Key_B: ret = "S"; break
        case Qt.Key_C: ret = "I"; break
        case Qt.Key_D: ret = "St"; break
        case Qt.Key_E: ret = "V>0"; break
        case Qt.Key_F: ret = "V=0"; break
        case Qt.Key_G: ret = "CONTRAST"; break
        case Qt.Key_H: ret = "BRIGHTNESS"; break
        case Qt.Key_I: ret = "UD"; break
        case Qt.Key_Backspace: ret = "C"; break
        case Qt.Key_Left: ret = "LEFT"; break
        case Qt.Key_Right: ret = "RIGHT"; break
        case Qt.Key_Up: ret = "UP"; break
        case Qt.Key_Down: ret = "DOWN"; break
        case Qt.Key_Return: ret = "E"; break
        case 16777249: ret = "SPECIAL"; break
        case 16777251: ret = "SPECIAL"; break
        }
    } else if (moduleType == 2) {
        switch (key) {
        case Qt.Key_0: ret = "0"; break
        case Qt.Key_1: ret = "1"; break
        case Qt.Key_2: ret = "2"; break
        case Qt.Key_3: ret = "3"; break
        case Qt.Key_4: ret = "4"; break
        case Qt.Key_5: ret = "5"; break
        case Qt.Key_6: ret = "6"; break
        case Qt.Key_7: ret = "7"; break
        case Qt.Key_8: ret = "8"; break
        case Qt.Key_9: ret = "9"; break
        case Qt.Key_F1: ret = "AUS"; break
        case Qt.Key_F2: ret = "S"; break
        case Qt.Key_F3: ret = "I"; break
        case Qt.Key_F4: ret = "St"; break
        case Qt.Key_F5: ret = "V>0"; break
        case Qt.Key_F6: ret = "V=0"; break
        case Qt.Key_F7: ret = "CONTRAST"; break
        case Qt.Key_F8: ret = "BRIGHTNESS"; break
        case Qt.Key_F9: ret = "UD"; break
        case Qt.Key_C: ret = "C"; break
        case Qt.Key_Left: ret = "LEFT"; break
        case Qt.Key_Right: ret = "RIGHT"; break
        case Qt.Key_Up: ret = "UP"; break
        case Qt.Key_Down: ret = "DOWN"; break
        case Qt.Key_E: ret = "E"; break
        }
    }
    return ret;
}
//--------------------------------------------------------------------------------
// гасим-гасим все экраны
function opacityNul()  {

    kdr_Vzb.opacity = 0;
    kdr_Mot.opacity = 0;
    kdr_AvProgrev.opacity = 0;
    kdr_Bos.opacity = 0;
    kdr_TED.opacity = 0;
    kdr_Svz.opacity = 0;
    kdr_Toplivo.opacity = 0;
    kdr_Masl.opacity = 0;
    kdr_Ohl.opacity = 0;
    kdr_TrLs.opacity = 0;
    kdr_Dizl.opacity = 0;

    kdr_Reostat.opacity = 0;
    kdr_Nastroika.opacity = 0;

    kdr_TI_TXA.opacity = 0;
    kdr_TI_TCM.opacity = 0;
    kdr_USTA_DskrVihodi.opacity = 0;
    kdr_USTA_DskrVh.opacity = 0;
    kdr_USTA_Analog.opacity = 0;

    kdr_BEL_DskrVihodi.opacity = 0;
    kdr_BEL_DskrVh.opacity = 0;
    kdr_BEL_Analog.opacity = 0;

    kdr_Main_small.opacity = 0;
    kdr_Develop.opacity = 0;

}
//--------------------------------------------------------------------------------
// switch section number if valid
function setSection(section) {
    if (!kdr_TrLs.opacity) {
        if ((section == 1 && is_links) || (section == 2 && is_slave)) {
            current_section = section
            oBf.setSection(section)
            return true;
        }
    }
    return false;
}
