#include "control.h"
#include "vktoolstypes.h"

Control::Control(DataStore* storage, QBitArray trsoob)
{
    _storage = storage;
    _tr_soob = trsoob;
    KdrNum = 0;
    MinTC = MaxTC = AvgTC = 0;
    _kdr_masl_flags = _kdr_tpl_flags = _kdr_ohl_flags = _kdr_bos_flags = _kdr_vzb_flags = _kdr_ted_flags = 0;
}
//--------------------------------------------------------------------------------
void Control::KdrMasl() //
{
    _kdr_masl_flags = (!_tr_soob[13]) ? _kdr_masl_flags & nobit0 : _kdr_masl_flags | 1;
    _kdr_masl_flags = (!_tr_soob[14]) ? _kdr_masl_flags  & nobit1 : _kdr_masl_flags | 2;
//    _kdr_masl_flags = (!_tr_soob[13]) ? _kdr_masl_flags & nobit2 : _kdr_masl_flags | 4;
//    _kdr_masl_flags = (!_tr_soob[14]) ? _kdr_masl_flags  & nobit3 : _kdr_masl_flags | 8;
}
//--------------------------------------------------------------------------------
void Control::KdrTpl() //
{
    _kdr_tpl_flags = (!_tr_soob[40]) ? 0 : 1;
}
//--------------------------------------------------------------------------------
void Control::KdrOhl() //
{
    _kdr_ohl_flags = (!_tr_soob[15] && !_tr_soob[17]) ? 0 : 1;
    _kdr_ohl_flags = (!_tr_soob[15]) ? _kdr_ohl_flags  & nobit1 : _kdr_ohl_flags | 2;
    _kdr_ohl_flags = (!_tr_soob[17]) ? _kdr_ohl_flags  & nobit2 : _kdr_ohl_flags | 4;
}
//--------------------------------------------------------------------------------
void Control::KdrBos() //
{
    qint8 byte = _storage->Byte("USTA_Outputs_1");
    _kdr_bos_flags = (byte & 16) ? 1 : 2;
    _kdr_bos_flags = (!_tr_soob[12]) ? _kdr_bos_flags & nobit2 : _kdr_bos_flags | 4;
    _kdr_bos_flags = (!_tr_soob[26]) ? _kdr_bos_flags  & nobit3 : _kdr_bos_flags | 8;
    _kdr_bos_flags = (!_tr_soob[32] && !_tr_soob[34]) ? _kdr_bos_flags  & nobit4 : _kdr_bos_flags | 16;
    _kdr_bos_flags = (!_tr_soob[33] && !_tr_soob[35]) ? _kdr_bos_flags  & nobit5 : _kdr_bos_flags | 32;
    _kdr_bos_flags = (!_tr_soob[34]) ? _kdr_bos_flags  & nobit6 : _kdr_bos_flags | 64;
    _kdr_bos_flags = (!_tr_soob[35]) ? _kdr_bos_flags  & nobit7 : _kdr_bos_flags | 128;
}
//--------------------------------------------------------------------------------
void Control::KdrVzb() //
{
    _kdr_vzb_flags = (_storage->Byte("USTA_Inputs_2") & 32) ? 1 : 0;
    _kdr_vzb_flags = (!_tr_soob[24]) ? _kdr_vzb_flags & nobit1 : _kdr_vzb_flags | 2;
    _kdr_vzb_flags = (!_tr_soob[25]) ? _kdr_vzb_flags  & nobit2 : _kdr_vzb_flags | 4;
}
//--------------------------------------------------------------------------------
void Control::KdrTed() //
{
    qint8 byte = _storage->Byte("USTA_Inputs_3");
    _kdr_ted_flags = !(byte & 32) ? _kdr_vzb_flags & nobit0 : _kdr_vzb_flags | 1;
//    _kdr_ted_flags = !(byte & 32) ? _kdr_vzb_flags & nobit1 : _kdr_vzb_flags | 2;
//    _kdr_ted_flags = !(byte & 32) ? _kdr_vzb_flags & nobit2 : _kdr_vzb_flags | 4;
//    _kdr_ted_flags = !(byte & 32) ? _kdr_vzb_flags & nobit3 : _kdr_vzb_flags | 8;
    _kdr_ted_flags = !(byte & 4) ? _kdr_vzb_flags & nobit1 : _kdr_vzb_flags | 2;
    _kdr_ted_flags = !(byte & 8) ? _kdr_vzb_flags & nobit2 : _kdr_vzb_flags | 4;
}
//--------------------------------------------------------------------------------
void Control::CalculateTC() {
    int summ, i, tc[6];
    tc[0] = _storage->Int16("IT_THA19");
    tc[1] = _storage->Int16("IT_THA21");
    tc[2] = _storage->Int16("IT_THA23");
    tc[3] = _storage->Int16("IT_THA12");
    tc[4] = _storage->Int16("IT_THA10");
    tc[5] = _storage->Int16("IT_THA8");
    MinTC = MaxTC = summ = tc[0];
    for (i = 1; i < 6; i++) {
        if (tc[i] < MinTC)
            MinTC = tc[i];
        if (tc[i] > MaxTC)
            MaxTC = tc[i];
        summ += tc[i];
    }
    AvgTC = summ / 6;
    for (i = 0; i < 6; i++)
        DeltaTC[i] = tc[i] - AvgTC;
}
//--------------------------------------------------------------------------------
void Control::Execute()
{
//    switch (KdrNum) {
//    case 126: KdrBos(); break;
//    case 127: KdrVzb(); break;
//    }
}
