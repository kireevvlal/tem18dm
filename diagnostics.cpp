#include <QDateTime>
#include <QtMath>
//#include <QDebug>
#include "diagnostics.h"
#include "tem18dm.h"


Diagnostics::Diagnostics(DataStore* storage, LcmSettings *settings)
{
    _storage = storage;
    _settings = settings;
//    _ports_state = 0;
    _date_time = QDateTime::currentDateTime();
    _msec = _date_time.toMSecsSinceEpoch();
    _motoresurs = _time_propulsion = 0;
    _it_packs = 0;
    _sp_is_bytes.resize(4);
}
//--------------------------------------------------------------------------------
void Diagnostics::Init() {
    _motoresurs = _storage->UInt32("DIAG_Motoresurs") * 1000;
    _time_propulsion = _storage->UInt32("DIAG_Tt") * 1000;
}
//--------------------------------------------------------------------------------
void Diagnostics::IncrementITPacks() {
    if (_it_packs < 4)
        _it_packs++;
}
//--------------------------------------------------------------------------------
void Diagnostics::RefreshDT() {
    _date_time = QDateTime::currentDateTime();
}
//--------------------------------------------------------------------------------
void Diagnostics::APSignalization(int pkm) {
    float pt_min = _settings->ElInjection ? 4.0 : 0.5;
    int uu[9] = { 0, 335, 430, 525, 630, 755, 850, 945, 945 }; // { 0, 210, 335, 430, 525, 630, 755, 850, 945 };
    int ii[9] = { 0, 735, 1272, 1575, 1985, 1995, 1995, 1995, 1995 };
    _storage->SetBit("PROG_TrSoob", 16, (_storage->Float("IT_TSM3") > 68.9) ? true : false);
    _storage->SetBit("PROG_TrSoob", 17, (_storage->Float("IT_TSM6") > 86.9) ? true : false);
    _storage->SetBit("PROG_TrSoob", 18, _storage->Bit("USTA_Inputs", USTA_INPUTS_OBTM) ? true : false);
    _storage->SetBit("PROG_TrSoob", 10, _storage->Bit("USTA_Inputs", USTA_INPUTS_RZ) ? true : false);
    _storage->SetBit("PROG_TrSoob", 11, _storage->Bit("USTA_Inputs", USTA_INPUTS_URV) ? true : false);
    _storage->SetBit("PROG_TrSoob", 14, false);
    _storage->SetBit("PROG_TrSoob", 15, false);
    if (_storage->Bit("DIAG_Connections", CONN_IT) && _storage->Bit("USTA_Inputs", USTA_INPUTS_KV) && (pkm > 4)) {// PKM 4-8
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
    if (_storage->Bit("DIAG_Connections", CONN_USTA)) {
        if (_storage->Float("USTA_Ubs_filtr") > 70  && _storage->Float("USTA_Iakb") < 1)
            _storage->SetBit("PROG_TrSoob", 12, true); // заряд АКБ
        if (_storage->Bit("DIAG_Connections", CONN_USTA) && qFabs(_storage->Float("USTA_Ubs_filtr") - 75) > 5)
            _storage->SetBit("PROG_TrSoob", 26, true); // неиспр. рег. U
        if (_storage->Int16("USTA_N") >= 250) {
            if (_storage->Float("USTA_Po_diz") < 1.7 ||  (_storage->Int16("USTA_N") > 800 && _storage->Float("USTA_Po_diz") < 4))
                _storage->SetBit("PROG_TrSoob", 13, true); // Давление масла ниже нормы
            if (_storage->Float("USTA_Pf_tnvd") < pt_min ||  _storage->Float("USTA_Pf_ftot") < pt_min)
                _storage->SetBit("PROG_TrSoob", 40, true); // Давление масла ниже нормы
            if (_storage->Bit("USTA_Inputs", USTA_INPUTS_KV) && pkm >= 3) {
//                if (_storage->Float("USTA_Ug_filtr") > uu[pkm - 1] || _storage->Float("USTA_Ig_filtr") > ii[pkm - 1])
                if ((_storage->Float("USTA_Ug_filtr") > (float)_storage->Int16("USTA_N") * 1.3) || (_storage->Float("USTA_Ig_filtr") > ii[pkm - 1]))
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
    u = fabs(_storage->Float("USTA_Ubs_filtr"));
    if (u < 40 || !_storage->Bit("DIAG_Connections", CONN_USTA) || !((pkm == 1) || (pkm == 2))) { // add PKM not position
        _riz_cu.tp = _riz_cu.tm = 0;
        _riz_cu.Up = _riz_cu.Um = 0;
        _riz_cu.snh = false;
        _riz_cu.rss = 2;
        if (!_storage->Bit("DIAG_Connections", CONN_USTA)) {
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
        if (_riz_cu.rss == _storage->Bit("USTA_Outputs", USTA_OUTPUTS_RSI))
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
    } else  {       // RSI - 0
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
    } else
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
bool Diagnostics::Motoresurs() {
    qint64 currtime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 diff;
    int n = _storage->Int16("USTA_N");
    if (n >= 99) {
        diff = currtime - _msec;
        if (diff >= 1000) {
            _msec = currtime;
            if (diff < 2000) {
                _motoresurs += diff;
                _storage->SetUInt32("DIAG_Motoresurs", _motoresurs / 1000); // set motoresurs
                if (_storage->Bit("USTA_Inputs", USTA_INPUTS_KV)) { // КВ контроль возбуждения
                    _time_propulsion += diff;
                    _storage->SetUInt32("DIAG_Tt", _time_propulsion / 1000); // set время работы в тяге
                    _a_diz += (float)_storage->Int16("DIAG_Pg") / 3600;
                    _storage->SetUInt32("DIAG_Adiz", _a_diz * 10); // полезная работа
                }
                return true;
            }
        }
    } else
        _msec = currtime;
    return false;
}
//--------------------------------------------------------------------------------
void Diagnostics::ResetMotoresurs() {
    _motoresurs = _time_propulsion = 0;
    _a_diz = 0;
    _storage->SetUInt32("DIAG_Motoresurs", 0); // reset motoresurs
    _storage->SetUInt32("DIAG_Tt", 0); // set время работы в тяге
    _storage->SetUInt32("DIAG_Adiz", 0); // reset полезная работа
}
//--------------------------------------------------------------------------------
void Diagnostics::Connections(QMap<QString, ExtSerialPort*> serialPorts, Registrator* reg, SlaveLcm* slave) {
    for (QMap<QString, ExtSerialPort*>::iterator i = serialPorts.begin(); i != serialPorts.end(); i++) {
        ExtSerialPort* port = i.value();
        // ports state and errors counters
        if (i.key() == "BEL") {
            if (port->isOpen())
                _storage->SetBit("DIAG_Portstates", CONN_BEL, 1);
            else _storage->SetBit("DIAG_Portstates", CONN_BEL, 0);
            _sp_error_counters[0] = port->ErrorsCount();
            _sp_is_bytes.setBit(0, port->IsBytes());
        } else
            if (i.key() == "USTA") {
                if (port->isOpen())
                    _storage->SetBit("DIAG_Portstates", CONN_USTA, 1);
                else _storage->SetBit("DIAG_Portstates", CONN_USTA, 0);
                _sp_error_counters[1] = port->ErrorsCount();
                _sp_is_bytes.setBit(1, port->IsBytes());
            } else
                if (i.key() == "IT") {
                    if (port->isOpen())
                        _storage->SetBit("DIAG_Portstates", CONN_IT, 1);
                    else _storage->SetBit("DIAG_Portstates", CONN_IT, 0);
                    _sp_error_counters[2] = port->ErrorsCount();
                    _sp_is_bytes.setBit(2, port->IsBytes());
                } else
                    if (i.key() == "MSS") {
                        if (port->isOpen())
                            _storage->SetBit("DIAG_Portstates", CONN_MSS, 1);
                        else _storage->SetBit("DIAG_Portstates", CONN_MSS, 0);
                        _sp_error_counters[3] = port->ErrorsCount();
                        _sp_is_bytes.setBit(3, port->IsBytes());
                    }
        // connections state
        if (i.key() == "BEL") {
            port->OutData.SetByteParameter("BEL_SIGNALIZATION",
                 ((_storage->Float("IT_TSM4") >= 40) ? 1 : 0) + (_storage->Bit("USTA_Inputs", USTA_INPUTS_PKM18) ? 2 : 0));
            if (_storage->Bit("DIAG_Connections", CONN_BEL)) {
                if (!port->IsExchange())
                    OnLostBel(port, reg, slave);
            } else {
                if (port->IsExchange()) {
                    _storage->SetBit("DIAG_Connections", CONN_BEL, 1);
//                    qDebug() << "Restore BEL";
                }
            }
        }
        else if (i.key() == "USTA") {
            port->OutData.SetByteParameter("USTA_RSI", _storage->Bit("DIAG_Connections", CONN_BEL) ? 1 : 0);
            port->OutData.SetByteParameter("USTA_SIGNALIZATION", (_storage->Bit("PROG_TrSoob", 17) ? 1 : 0) + (_storage->Bit("PROG_TrSoob", 16) ? 2 : 0));
            if (_storage->Bit("DIAG_Connections", CONN_USTA)) {
                if (!port->IsExchange())
                    OnLostUsta(port, reg, slave);
            } else {
                if (port->IsExchange()) {
                    _storage->SetBit("DIAG_Connections", CONN_USTA, 1);
//                    qDebug() << "Restore USTA";
                }
            }
        }
        else if (i.key() == "IT") {
            if (_storage->Bit("DIAG_Connections", CONN_IT)) {
                if (!port->IsExchange())
                    OnLostIt(port, reg, slave);
            } else {
                if (port->IsExchange()) {
                    if (_it_packs >= 4) // должно прийти 4 пакета
                        _storage->SetBit("DIAG_Connections", CONN_IT, 1);
//                    qDebug() << "Restore IT";
                }
            }
        }
        else if  (i.key() == "MSS") {
            port->OutData.SetData(0, 580, slave->Outdata());
            if (_storage->Bit("DIAG_Connections", CONN_MSS)) {
                if (!port->IsExchange()) {
                    _storage->ClearSpData(port);
                    _storage->SetBit("DIAG_Connections", CONN_MSS, 0);
//                    qDebug() << "Lost MSS";
                }
            } else {
                if (port->IsExchange()) {
                    _storage->SetBit("DIAG_Connections", CONN_MSS, 1);
//                    qDebug() << "Restore MSS";
                }
            }
        }
    }
}
//--------------------------------------------------------------------------------
void Diagnostics::OnLostBel(ExtSerialPort* port, Registrator* reg, SlaveLcm* slave) {
    QByteArray arr(8, 0);
    _storage->ClearSpData(port);
    _storage->SetBit("DIAG_Connections", CONN_BEL, 0);
    // в 0
    reg->UpdateRecord(338, 8, arr.mid(0, 8)); // дискретные (+ ПКМ)
    slave->UpdatePacket(0, 8, arr.mid(0, 8)); // дискретные (+ ПКМ)
    _storage->SetByte("PROG_Reversor", 0);
//    qDebug() << "Lost BEL";
}
//--------------------------------------------------------------------------------
void Diagnostics::OnLostUsta(ExtSerialPort* port, Registrator* reg, SlaveLcm* slave) {
    QByteArray arr(80, 0);
    _storage->ClearSpData(port);
    _storage->SetBit("DIAG_Connections", CONN_USTA, 0);
    // в 0
    reg->UpdateRecord(0, 80, arr.mid(0, 80));  // аналоговые
    reg->UpdateRecord(332, 6, arr.mid(0, 6)); // дискретные
    slave->UpdatePacket(8, 80, arr.mid(0, 80));  // аналоговые
    slave->UpdatePacket(88, 6, arr.mid(0, 6));
//    qDebug() << "Lost USTA";
}
//--------------------------------------------------------------------------------
void Diagnostics::OnLostIt(ExtSerialPort* port, Registrator* reg, SlaveLcm* slave) {
    QByteArray arr(96, 0);
    _it_packs = 0;
    _storage->ClearSpData(port);
    _storage->SetBit("DIAG_Connections", CONN_IT, 0);
    // в 0
    reg->UpdateRecord(80, 96, arr.mid(0, 96));
    slave->UpdatePacket(96, 96, arr.mid(0, 96));
//    qDebug() << "Lost IT";
}
//--------------------------------------------------------------------------------
