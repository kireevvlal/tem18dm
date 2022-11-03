#include <QDateTime>
#include "diagnostics.h"

Diagnostics::Diagnostics(DataStore* storage, QBitArray trsoob)
{
    _storage = storage;
    _tr_soob = trsoob;
    _ports_state = 0;
    _msec = QDateTime::currentDateTime().toMSecsSinceEpoch();
}
//--------------------------------------------------------------------------------
void Diagnostics::APSignalization() {

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
            _tr_soob[32] = 0;
            _tr_soob[33] = 0;
            _tr_soob[34] = 0;
            _tr_soob[35] = 0;
        }
        return;
    }
    if (!_riz_cu.snh) {
        if (_riz_cu.rss == 2) {
            _riz_cu.rss = _storage->Byte("USTA_Outputs_1") & 16;
            return;
        }
        _riz_cu.rss = _storage->Byte("USTA_Outputs_1") & 16;
        if (_riz_cu.rss)
            return;
        _riz_cu.snh = true;
    }
    if ( _storage->Byte("USTA_Outputs_1") & 16) { // RSI - 1
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
        _storage->Int16("DIAG_Rplus", 1);
         _tr_soob[32] = 1;
    } else
         _tr_soob[32] = 0;
    if (_riz_cu.Up > u - 1) { // Зем -
        _storage->Int16("DIAG_Rminus", 1);
         _tr_soob[33] = 1;
    } else
         _tr_soob[33] = 0;
    if (_tr_soob[32] || _tr_soob[33])
        return;
    u = 666 * (u - _riz_cu.Up - _riz_cu.Um);
    r = u / _riz_cu.Up;
    if (r < 2)
        _storage->Int16("DIAG_Rminus", 1);
    else
        if (r > 997)
            _storage->Int16("DIAG_Rminus", 998);
        else
            _storage->Int16("DIAG_Rminus", r);
    r = u / _riz_cu.Um;
    if (r < 2)
        _storage->Int16("DIAG_Rplus", 1);
    else
        if (r > 997)
            _storage->Int16("DIAG_Rplus", 998);
        else
            _storage->Int16("DIAG_Rplus", r);
    if (_storage->Int16("DIAG_Rplus") < 250)
        _tr_soob[34] = 1;
    else
        _tr_soob[34] = 0;
    if (_storage->Int16("DIAG_Rminus") < 250)
        _tr_soob[35] = 1;
    else
        _tr_soob[35] = 0;
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
            _storage->UInt32("DIAG_Motoresurs", _storage->UInt32("DIAG_Motoresurs") + 1); // increment motoresurs
            if (_storage->Byte("USTA_Inputs_2") & 64) { // КВ контроль возбуждения
                _storage->UInt32("DIAG_Tt", _storage->UInt32("DIAG_Tt") + 1); // increment время работы в тяге
                _a_diz += (float)_storage->Int16("DIAG_Pg") / 3600;
                _storage->UInt32("DIAG_Adiz", _a_diz * 10); // полезная работа
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
