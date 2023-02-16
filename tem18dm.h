#ifndef TEM18DM_H
#define TEM18DM_H
#include <QObject>
#include <QMap>
#include <QBitArray>
#include "extserialport.h"

// Тип дисплейногот модуля (по необходимости)
#define ATRONIC
//#define ATRONIC_UNIX
//#define TPK

//#ifdef Q_OS_UNIX
//#define ATRONIC_UNIX
//#endif
// номера индексов в словарях битовых массивов
#define CONN_BEL  0 // Наличие связи с БЭЛ
#define CONN_USTA 1 // Наличие связи с УСТА
#define CONN_IT   2 // Наличие связи с ТИ
#define CONN_MSS  3 // Наличие связи с другой секцией

#define USTA_OUTPUTS_OP1  0 // ВШ1 Ослабление поля 1
#define USTA_OUTPUTS_OP2  1 // ВШ1 Ослабление поля 2
#define USTA_OUTPUTS_VZT  2 // ВЗТ
#define USTA_OUTPUTS_RET  3 // РЭТ р. экстр. тормоза
#define USTA_OUTPUTS_RSI  4 // РСИ р.сопротивления изоляции
#define USTA_OUTPUTS_BOKS  5 // боксование
#define USTA_OUTPUTS_PERV  6 // перегрев воды
#define USTA_OUTPUTS_PERM 7 // перегрев масла

#define USTA_INPUTS_RU2  0 // РУ2 2 ПКМ
#define USTA_INPUTS_VT1  1 // ВТ1
#define USTA_INPUTS_VT2  2 // ВТ2
#define USTA_INPUTS_VT3  3 // ВТ3
#define USTA_INPUTS_VT4  4 // ВТ4
#define USTA_INPUTS_KV  5 // контроль возбуждения
#define USTA_INPUTS_PKM18  6 // 1-8 ПКМ
#define USTA_INPUTS_RZ  7 // реле земли
#define USTA_INPUTS_URV  8 // ДРУ уровень воды
#define USTA_INPUTS_UPRP  9 // Упр о.п. управление переходами
#define USTA_INPUTS_OM1  10 // ОМ1 отключатель моторов
#define USTA_INPUTS_OM2  11 // ОМ2 отключатель моторов
#define USTA_INPUTS_BELEDT  12 // ЭТ выход БЭЛ ЭДТ
#define USTA_INPUTS_RET  13 // РЭТ по сх.ю КВТ 1,2
#define USTA_INPUTS_OBTM  14 //  обрыв ТМ (РУ15)
#define USTA_INPUTS_OTPT  15 // пуск дизеля (КМ1)

struct LcmSettings {
    QString Number; // номер локомотива
    int PressureSensors; // номинал двух датчиков давления
    bool ElInjection; // электронный впрыск
    int SoundVolume; // громкость звука (%)
    LcmSettings() { Number = "0000"; PressureSensors = 16; ElInjection = false; SoundVolume = 100; }
};

#endif // TEM18DM_H
