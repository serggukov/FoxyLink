﻿
// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { API
// Функция - удалить элементы по отбору
//
// Параметры:
//  ТипМетаданного	 - Строка	 - Например, "Справочник", "Документ"
//  видМетаданного	 - Строка	 - Например, "Контрагенты"
//  Отбор			 - Структура -
//
//	ВозвращаемоеЗначение - Число - количество удаленных элементов
//
&НаКлиенте
Процедура УдалитьЭлементыМетаданного(Знач ТипМетаданного, Знач ВидМетаданного, Отбор = Неопределено) Экспорт
	УдалитьЭлементыМетаданногоСервер(ТипМетаданного, ВидМетаданного, Отбор);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеЭлементыСправочника(Знач ИмяСпр) Экспорт
	УдалитьЭлементыМетаданного("Справочник", ИмяСпр);
КонецПроцедуры
// } API

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Процедура УдалитьЭлементыМетаданногоСервер(Знач ТипМетаданного, Знач ВидМетаданного, Отбор = Неопределено) Экспорт
	ЭтотОбъектНаСервере().УдалитьЭлементыМетаданного(ТипМетаданного, ВидМетаданного, Отбор);
КонецПроцедуры
// } Helpers
