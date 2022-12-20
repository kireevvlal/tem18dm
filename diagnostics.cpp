#include <QDateTime>
#include <QtMath>
#include "diagnostics.h"
#include "tem18dm.h"

Diagnostics::Diagnostics(DataStore* storage, float ptmax)
{
    _storage = storage;
    _pt_max = ptmax;
    _ports_state = 0;
    _msec = QDateTime::currentDateTime().toMSecsSinceEpoch();
}
//--------------------------------------------------------------------------------
void Diagnostics::APSignalization(int pkm) {
    int uu[9] = { 0, 210, 335, 430, 525, 630, 755, 850, 945 };
    int ii[9] = { 0, 735, 1272, 1575, 1985, 1995, 1995, 1995, 1995 };
    _storage->SetBit("PROG_TrSoob", 16, (_storage->Float("IT_TSM3") > 68.9) ? true : false);
    _storage->SetBit("PROG_TrSoob", 17, (_storage->Float("IT_TSM6") > 86.9) ? true : false);
    _storage->SetBit("PROG_TrSoob", 18, _storage->Bit("USTA_Inputs", USTA_INPUTS_OBTM) ? true : false);
    _storage->SetBit("PROG_TrSoob", 10, _storage->Bit("USTA_Inputs", USTA_INPUTS_RZ) ? true : false);
    _storage->SetBit("PROG_TrSoob", 11, _storage->Bit("USTA_Inputs", USTA_INPUTS_URV) ? true : false);
    _storage->SetBit("PROG_TrSoob", 14, false);
    _storage->SetBit("PROG_TrSoob", 15, false);
    if ((_ports_state & 4) && _storage->Bit("USTA_Inputs", USTA_INPUTS_KV) && (pkm > 4)) {// PKM 4-8
        if ((_storage->Float("IT_TSM3") < 45) && (_storage->Float("IT_TSM3") > -50))
            _storage->SetBit("PROG_TrSoob", 14, true);
        if ((_storage->Float("IT_TSM6") < 45) && (_storage->Float("IT_TSM6") > -50))
            _storage->SetBit("PROG_TrSoob", 15, true);
    }
    _storage->SetBit("PROG_TrSoob", 12, false);
    _storage->SetBit("PROG_TrSoob", 26, false);
    _storage->SetBit("PROG_TrSoob", 13, false);
    _storage->SetBit("PROG_TrSoob", 40, false);
    _storage->SetBit("PROG_TrSoob", 24, false);
    _storage->SetBit("PROG_TrSoob", 25, false);
    if (_ports_state & 2) {
        if (_storage->Float("USTA_Ubs_filtr") > 70  && _storage->Float("USTA_Iakb") < 1)
            _storage->SetBit("PROG_TrSoob", 12, true); // заряд АКБ
        if (qFabs(_storage->Float("USTA_Ubs_filtr")) - 75 > 5)
            _storage->SetBit("PROG_TrSoob", 26, true); // неиспр. рег. U
        if (_storage->Int16("USTA_N") >= 250) {
            if (_storage->Float("USTA_Po_diz") < 1.7 ||  (_storage->Int16("USTA_N") > 800 && _storage->Float("USTA_Po_diz") < 4))
                _storage->SetBit("PROG_TrSoob", 13, true); // Давление масла ниже нормы
            if (_storage->Float("USTA_Pf_tnvd") < _pt_max ||  _storage->Float("USTA_Pf_ftot") < _pt_max)
                _storage->SetBit("PROG_TrSoob", 40, true); // Давление масла ниже нормы
            if (_storage->Bit("USTA_Inputs", USTA_INPUTS_KV) && pkm >= 3) {
                if (_storage->Float("USTA_Ug_filtr") > uu[pkm - 1] || _storage->Float("USTA_Ig_filtr") > ii[pkm - 1])
                    _storage->SetBit("PROG_TrSoob", 24, true);
                else {
                    if (_storage->Float("USTA_Ug_filtr") < 1 || _storage->Float("USTA_Ig_filtr") < 1)
                        if (_storage->Float("USTA_Ugol_uvvg") > 120) {
                            if ((int)(_storage->Float("USTA_Ivzb_gen")) > 0)
                                _storage->SetBit("PROG_TrSoob", 25, true);
                            else
                                _storage->SetBit("PROG_TrSoob", 24, true);
                        }
                }
            }
        }
    }
}
//--------------------------------------------------------------------------------
void Diagnostics::RizCU(int pkm) {
    float r, u;
    u = _storage->Float("USTA_Ubs_filtr");
    if (u < 40 || !(_ports_state & 2) || !((pkm == 1) || (pkm == 2))) { // add PKM not position
        _riz_cu.tp = _riz_cu.tm = 0;
        _riz_cu.Up = _riz_cu.Um = 0;
        _riz_cu.snh = false;
        _riz_cu.rss = 2;
        if (!(_ports_state & 2)) {
            _storage->SetBit("PROG_TrSoob", 32, 0);
            _storage->SetBit("PROG_TrSoob", 33, 0);
            _storage->SetBit("PROG_TrSoob", 34, 0);
            _storage->SetBit("PROG_TrSoob", 35, 0);
        }
        return;
    }
    if (!_riz_cu.snh) {
        if (_riz_cu.rss == 2) {
            _riz_cu.rss = _storage->Bit("USTA_Outputs", USTA_OUTPUTS_RSI);
            return;
        }
        _riz_cu.rss = _storage->Bit("USTA_Outputs", USTA_OUTPUTS_RSI);
        if (_riz_cu.rss)
            return;
        _riz_cu.snh = true;
    }
    if (_storage->Bit("USTA_Outputs", USTA_OUTPUTS_RSI)) { // RSI - 1
        _riz_cu.tm = 0;
        if (_riz_cu.tp == 0) {
            _riz_cu.tp = QDateTime::currentDateTime().toMSecsSinceEpoch();
            return;
        }
        if (QDateTime::currentDateTime().toMSecsSinceEpoch() - _riz_cu.tp < 9000)
            return;
        _riz_cu.tp = 0;
        _riz_cu.Up = abs(_storage->Int16("USTA_Ucu"));
        if (_riz_cu.Up < 1 || _riz_cu.Um < 1)
            return;
    } else  {// RSI - 0
        _riz_cu.tp = 0;
        if (_riz_cu.tm == 0) {
            _riz_cu.tm = QDateTime::currentDateTime().toMSecsSinceEpoch();
            return;
        }
        if (QDateTime::currentDateTime().toMSecsSinceEpoch() - _riz_cu.tm < 9000)
            return;
        _riz_cu.tm = 0;
        _riz_cu.Um = abs(_storage->Int16("USTA_Ucu"));
        if (_riz_cu.Up < 1 || _riz_cu.Um < 1)
            return;
    }
    if (_riz_cu.Um > u - 1) { // Зем+
        _storage->SetInt16("DIAG_Rplus", 1);
         _storage->SetBit("PROG_TrSoob", 32, 1);
    } else
         _storage->SetBit("PROG_TrSoob", 32, 0);
    if (_riz_cu.Up > u - 1) { // Зем -
        _storage->SetInt16("DIAG_Rminus", 1);
         _storage->SetBit("PROG_TrSoob", 33, 1);
    } else ;
         _storage->SetBit("PROG_TrSoob", 33, 0);
    if (_storage->Bit("PROG_TrSoob", 32) || _storage->Bit("PROG_TrSoob", 33))
        return;
    u = 666 * (u - _riz_cu.Up - _riz_cu.Um);
    r = u / _riz_cu.Up;
    if (r < 2)
        _storage->SetInt16("DIAG_Rminus", 1);
    else
        if (r > 997)
            _storage->SetInt16("DIAG_Rminus", 998);
        else
            _storage->SetInt16("DIAG_Rminus", r);
    r = u / _riz_cu.Um;
    if (r < 2)
        _storage->SetInt16("DIAG_Rplus", 1);
    else
        if (r > 997)
            _storage->SetInt16("DIAG_Rplus", 998);
        else
            _storage->SetInt16("DIAG_Rplus", r);
    if (_storage->Int16("DIAG_Rplus") < 250)
        _storage->SetBit("PROG_TrSoob", 34, 1);
    else
        _storage->SetBit("PROG_TrSoob", 34, 0);
    if (_storage->Int16("DIAG_Rminus") < 250)
        _storage->SetBit("PROG_TrSoob", 35, 1);
    else
        _storage->SetBit("PROG_TrSoob", 35, 0);
}
//--------------------------------------------------------------------------------
void Diagnostics::Motoresurs() {
    qint64 currtime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 diff;
    int n = _storage->Int16("USTA_N");
    if (n >= 99) {
        diff = currtime - _msec;
        if (diff >= 1000) {
            _msec = currtime;
            _storage->SetUInt32("DIAG_Motoresurs", _storage->UInt32("DIAG_Motoresurs") + 1); // increment motoresurs
            if (_storage->Bit("USTA_Inputs", USTA_INPUTS_KV)) { // КВ контроль возбуждения
                _storage->SetUInt32("DIAG_Tt", _storage->UInt32("DIAG_Tt") + 1); // increment время работы в тяге
                _a_diz += (float)_storage->Int16("DIAG_Pg") / 3600;
                _storage->SetUInt32("DIAG_Adiz", _a_diz * 10); // полезная работа
            }
        }
    }
}
//--------------------------------------------------------------------------------
void Diagnostics::Connections(QMap<QString, ThreadSerialPort*> serialPorts) {
    for (QMap<QString, ThreadSerialPort*>::iterator i = serialPorts.begin(); i != serialPorts.end(); i++)
        if (i.key() == "BEL") {
            if (i.value()->isOpen())
                _ports_state |= 1;
            else _ports_state &= nobit0;
        } else
            if (i.key() == "USTA") {
                if (i.value()->isOpen())
                    _ports_state |= 2;
                else _ports_state &= nobit1;
            } else
                if (i.key() == "IT") {
                    if (i.value()->isOpen())
                        _ports_state |= 4;
                    else _ports_state &= nobit2;
                } else
                    if (i.key() == "MSS") {
                        if (i.value()->isOpen())
                            _ports_state |= 8;
                        else _ports_state &= nobit3;
                    }
}
