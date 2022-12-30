#include "control.h"
#include "vktoolstypes.h"

Control::Control(DataStore* storage, DataStore* secstore)
{
    _storage[0] = storage;
    _storage[1] = secstore;
    KdrNum = 0;
    MinTC[0] = MinTC[1] = MaxTC[0] = MaxTC[1] = AvgTC[0] = AvgTC[1] = 0;
    for (int i = 0; i < 6; i++)
        DeltaTC[0][i] = DeltaTC[1][i] = 0;
//    _kdr_masl_flags = _kdr_tpl_flags = _kdr_ohl_flags = _kdr_bos_flags = _kdr_vzb_flags = _kdr_ted_flags = 0;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrMasl(int section) //
{
    qint8 kdr_masl_flags;
    QBitArray* trflags = _storage[section]->Bits("PROG_TrSoob");
    kdr_masl_flags = (!trflags->at(13)) ? 0 : 1;
    kdr_masl_flags = (!trflags->at(14)) ? kdr_masl_flags  & nobit1 : kdr_masl_flags | 2;
    return kdr_masl_flags;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrTpl(int section) //
{
    return (!_storage[section]->Bit("PROG_TrSoob", 40)) ? 0 : 1;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrOhl(int section) //
{
    qint8 kdr_ohl_flags;
    QBitArray* trflags = _storage[section]->Bits("PROG_TrSoob");
    kdr_ohl_flags = (!trflags->at(15) && ! trflags->at(17)) ? 0 : 1;
    kdr_ohl_flags = (!trflags->at(15)) ? kdr_ohl_flags  & nobit1 : kdr_ohl_flags | 2;
    kdr_ohl_flags = (!trflags->at(17)) ? kdr_ohl_flags  & nobit2 : kdr_ohl_flags | 4;
    return kdr_ohl_flags;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrBos(int section) //
{
    qint8 kdr_bos_flags;
    QBitArray* trflags = _storage[section]->Bits("PROG_TrSoob");
    kdr_bos_flags = _storage[section]->Bit("USTA_Outputs", USTA_OUTPUTS_RSI) ? 1 : 2;
    kdr_bos_flags = (!trflags->at(12)) ? kdr_bos_flags & nobit2 : kdr_bos_flags | 4;
    kdr_bos_flags = (!trflags->at(26)) ? kdr_bos_flags  & nobit3 : kdr_bos_flags | 8;
    kdr_bos_flags = (!trflags->at(32) && !trflags->at(34)) ? kdr_bos_flags  & nobit4 : kdr_bos_flags | 16;
    kdr_bos_flags = (!trflags->at(33) && !trflags->at(35)) ? kdr_bos_flags  & nobit5 : kdr_bos_flags | 32;
    kdr_bos_flags = (!trflags->at(34)) ? kdr_bos_flags  & nobit6 : kdr_bos_flags | 64;
    kdr_bos_flags = (!trflags->at(35)) ? kdr_bos_flags  & nobit7 : kdr_bos_flags | 128;
    return kdr_bos_flags;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrVzb(int section) //
{
    qint8 kdr_vzb_flags;
    QBitArray* trflags = _storage[section]->Bits("PROG_TrSoob");
    kdr_vzb_flags = _storage[section]->Bit("USTA_Inputs", USTA_INPUTS_KV) ? 1 : 0;
    kdr_vzb_flags = (!trflags->at(24)) ? kdr_vzb_flags & nobit1 : kdr_vzb_flags | 2;
    kdr_vzb_flags = (!trflags->at(25)) ? kdr_vzb_flags  & nobit2 : kdr_vzb_flags | 4;
    return kdr_vzb_flags;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrTed(int section) //
{
    qint8 kdr_ted_flags = 0;
    QBitArray* bits = _storage[section]->Bits("USTA_Inputs");
    kdr_ted_flags = !bits->at(USTA_INPUTS_RET) ? kdr_ted_flags & nobit0 : kdr_ted_flags | 1;
    kdr_ted_flags = !bits->at(USTA_INPUTS_OM1) ? kdr_ted_flags & nobit1 : kdr_ted_flags | 2;
    kdr_ted_flags = !bits->at(USTA_INPUTS_OM2) ? kdr_ted_flags & nobit2 : kdr_ted_flags | 4;
    return kdr_ted_flags;
}
//--------------------------------------------------------------------------------
qint8 Control::KdrSmlMain(int section) //
{
    qint8 kdr_smlmain_flags = 0;
    QBitArray* bits = _storage[section]->Bits("USTA_Outputs");
    kdr_smlmain_flags = (bits->at(USTA_OUTPUTS_OP1) ? 1 : 0) + (bits->at(USTA_OUTPUTS_OP2) ? 2 : 0);
    return kdr_smlmain_flags;
}
//--------------------------------------------------------------------------------
void Control::CalculateTC() {
    int summ, i, tc[6];
    tc[0] = _storage[0]->Int16("IT_THA19");
    tc[1] = _storage[0]->Int16("IT_THA21");
    tc[2] = _storage[0]->Int16("IT_THA23");
    tc[3] = _storage[0]->Int16("IT_THA12");
    tc[4] = _storage[0]->Int16("IT_THA10");
    tc[5] = _storage[0]->Int16("IT_THA8");
    MinTC[0] = MaxTC[0] = summ = tc[0];
    for (i = 1; i < 6; i++) {
        if (tc[i] < MinTC[0])
            MinTC[0] = tc[i];
        if (tc[i] > MaxTC[0])
            MaxTC[0] = tc[i];
        summ += tc[i];
    }
    AvgTC[0] = summ / 6;
    for (i = 0; i < 6; i++)
        DeltaTC[0][i] = tc[i] - AvgTC[0];
}
//--------------------------------------------------------------------------------
