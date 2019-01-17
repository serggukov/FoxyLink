﻿Перем РезультатыСравненияТаблиц Экспорт;
Перем СтатусыРезультатаТестирования Экспорт;
Перем ПараметрыОтчетаУФ;
Перем ОтчетВРежимеУФ;
Перем ЭтоLinux;
Перем ИмяТекущейСборки;
Перем ДобавлятьКИмениСценарияУсловияВыгрузки;
Перем РазницаВМилисекундахМеждуЮниксИНачалЭпохи;

// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "Аллюр2Отчет");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры
// } Plugin interface

Функция ПолучитьРезультатПрохожденияТестовСценария(СтрСтроки)
	
	РезультатПрохожденияТестовСценария = Неопределено;
	
	Если ОтчетВРежимеУФ Тогда
		ИДВМассиве                         = ПараметрыОтчетаУФ.МассивИДСтрокиДерева.Найти(СтрСтроки.ИДСтроки);
		Если ИДВМассиве <> Неопределено Тогда
			РезультатПрохожденияТестовСценария = ПараметрыОтчетаУФ.МассивРезультатПрохожденияТестовСценария[ИДВМассиве];
		КонецЕсли;
	Иначе
		РезультатПрохожденияТестовСценария = СтрСтроки.РезультатПрохожденияТестовСценария;
	КонецЕсли;
	
	Возврат РезультатПрохожденияТестовСценария;

КонецФункции

//{Отчет Allure2

Процедура ЗаписатьСтатусВШагИлиСценарий2(ОбъектДляЗаписи,Статус)
	Если Статус = "Success" Тогда
		ОбъектДляЗаписи.status = "passed";
	ИначеЕсли Статус = "Pending" Тогда
		ОбъектДляЗаписи.status = "pending";
	ИначеЕсли Статус = "Failed" Тогда
		ОбъектДляЗаписи.status = "failed";
	ИначеЕсли Статус = "Skipped" Тогда
		ОбъектДляЗаписи.status = "skipped";
	Иначе	
		ОбъектДляЗаписи.status = "skipped";
	КонецЕсли; 
	

КонецПроцедуры

Процедура ДобавитьМетку2(СписокМеток,name,value, СписокПереопределяемый = Неопределено)
	Если СписокПереопределяемый <> Неопределено И ТипЗнч(СписокПереопределяемый) = Тип("СписокЗначений") Тогда
		Если СписокПереопределяемый.НайтиПоЗначению(name) <> Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Метка       = Новый Структура("name, value");
	Метка.name  = name;
	Метка.value = value;
	
	// Сделано специально, т.к. некоторые метки берут в отчет Превые, 
	// поэтому из сценария мы ставим их в начало, перед фичей.
	СписокМеток.Вставить(0, Метка);
	
КонецПроцедуры

Функция УбратьСимволыДляКорректногоОтчетаAllure2(Знач Стр)
	Стр = СтрЗаменить(Стр,".","_");
	Возврат Стр;
КонецФункции	

Функция ПолучитьПрефиксИмениСценария2(ДобавлятьКИмениСценарияУсловияВыгрузки = Ложь)
	
	Если ДобавлятьКИмениСценарияУсловияВыгрузки Тогда 
		Если ЗначениеЗаполнено(ИмяТекущейСборки) Тогда
			Возврат "(" + УбратьСимволыДляКорректногоОтчетаAllure2(ИмяТекущейСборки) + ") ";
		КонецЕсли;	 
	КонецЕсли;
	
	Возврат "";
	
КонецФункции	

Функция ПолучитьОписаниеСценарияАллюр2()
	Перем СтруктураРезультата;
	
	GUID             = Новый УникальныйИдентификатор();
	СтруктураРезультата = Новый Структура(); //"uuid, historyId, name, status, parameters, labels, links, attachments");
	СтруктураРезультата.Вставить("uuid", Строка(GUID));
	СтруктураРезультата.Вставить("historyId", Неопределено);
	СтруктураРезультата.Вставить("name", Неопределено);
	СтруктураРезультата.Вставить("fullName", Неопределено);
	СтруктураРезультата.Вставить("start", Неопределено);
	СтруктураРезультата.Вставить("stop", Неопределено);
	СтруктураРезультата.Вставить("statusDetails",  Новый Структура("known, muted,flaky", Ложь, Ложь, Ложь));
	СтруктураРезультата.Вставить("status", Неопределено);
	СтруктураРезультата.Вставить("stage", "finished"); // Внятного описания, зачем это в каждом сценарии нет. 
	СтруктураРезультата.Вставить("steps", Новый Массив());
	СтруктураРезультата.Вставить("parameters", Новый Массив());
	СтруктураРезультата.Вставить("labels", Новый Массив());
	СтруктураРезультата.Вставить("links", Новый Массив());
	СтруктураРезультата.Вставить("attachments", Новый Массив());
	СтруктураРезультата.Вставить("description", Неопределено);
	
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ПолучитьОписаниеКонтекстныхШаговАллюр2()
	Перем СтруктураРезультата;
	
	СтруктураРезультата = Новый Структура("uuid, name, description, children, befores, start, stop");
	СтруктураРезультата.Вставить("befores", Новый Массив());
	СтруктураРезультата.Вставить("children", Новый Массив());

		
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ПолучитьОписаниеШагаАллюр2()
	Перем СтруктураРезультата;
	
	СтруктураРезультата = Новый Структура("name, start, stop, status, stage");
	СтруктураРезультата.Вставить("statusDetails",  Новый Структура("known, muted,flaky", Ложь, Ложь, Ложь));
	СтруктураРезультата.Вставить("parameters", Новый Массив());
	СтруктураРезультата.Вставить("attachments", Новый Массив());
	СтруктураРезультата.Вставить("steps", Новый Массив());
		
	Возврат СтруктураРезультата;

КонецФункции

Процедура ЗаписатьОписаниеАллюр2(Строка, СтруктураВыгрузки)
	
	ДополнительноеОписание = Строка.ДополнительныеДанные;
	Если ТипЗнч(ДополнительноеОписание) = Тип("Структура") И ДополнительноеОписание.Свойство("description") Тогда
		СтруктураВыгрузки.Вставить("description", ДополнительноеОписание["description"]);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьФайлКШагуАллюр2(СтруктураШага, Имя, ИмяФайла, Тип = "image/png")
	
	attachment = Новый Структура("name, source, type");
	attachment.name    = Имя;
	attachment.source  = ИмяФайла;
	attachment.type	= Тип;
	
	СтруктураШага.attachments.Добавить(attachment);

КонецПроцедуры

Процедура ДобавитьСкриншотыКШагуАллюр2(СтруктураВыгрузки, РезультатПрохожденияТестовСценария)
	
	Если РезультатПрохожденияТестовСценария.Свойство("МассивСкриншотов") Тогда
		//значит есть скриншоты
		
		Для каждого СтруктураСкриншот Из РезультатПрохожденияТестовСценария.МассивСкриншотов Цикл
			ДобавитьФайлКШагуАллюр2(СтруктураВыгрузки, "screenshot", СтруктураСкриншот.ИмяФайла, "image/png")
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьФайлыКШагуАллюр2(СтруктураВыгрузки, РезультатПрохожденияТестовСценария, МассивXMLОтчетаAllure)
	
	Если РезультатПрохожденияТестовСценария.Свойство("СписокФайлов") Тогда
		Для каждого СтруктураФайл Из РезультатПрохожденияТестовСценария.СписокФайлов Цикл
			РеальноеИмяФайла = СтруктураФайл.Значение.ИмяФайла;
			Если СтруктураФайл.Значение.Свойство("ДвоичныеДанные") Тогда
				
				ФайлОбъект = Новый Файл(Строка(СтруктураФайл.Значение.ИмяФайла) );
				РеальноеИмяФайла = Строка(Новый УникальныйИдентификатор()) + "-attachment"+ФайлОбъект.Расширение;
				
				СтруткутаДляФайлаXML = Новый Структура;
				СтруткутаДляФайлаXML.Вставить("РеальноеИмяФайла", РеальноеИмяФайла); //"" + GUID +"-container.json");				
				СтруткутаДляФайлаXML.Вставить("ФайлXMLДвоичныеДанные", СтруктураФайл.Значение.ДвоичныеДанные);
				МассивXMLОтчетаAllure.Добавить(СтруткутаДляФайлаXML);
			КонецЕсли;
			
			ТипФайла = Неопределено;
			СтруктураФайл.Значение.Свойство("ТипФайла", ТипФайла);
			Если ТипФайла = Неопределено Тогда
				ТипФайла = "text/plain";
			КонецЕсли;
			ДобавитьФайлКШагуАллюр2(СтруктураВыгрузки, СтруктураФайл.Значение.ИмяФайла, РеальноеИмяФайла, ТипФайла)
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьВыполнениеШагаАллюр2(МассивШагов, ДеревоТестов, РезультатыПрохождения, СоответствиеГрупп, МассивXMLОтчетаAllure)
	Перем ШагВложенный;	
	МассивШаговДобавления = МассивШагов;
	СтрокаВыполнения = ДеревоТестов.Строки.Найти(РезультатыПрохождения.ИДСтроки, "ИДСтроки", Истина);
	Если СтрокаВыполнения <> Неопределено Тогда
		Если СоответствиеГрупп.Получить("ТекущийИДСтрокиШагСценарий") <> СтрокаВыполнения.Родитель.ИДСтроки Тогда
			Если СоответствиеГрупп.Получить("УдалятьРодителейПриСмене") = Истина Тогда
				СоответствиеГрупп.Вставить(СоответствиеГрупп.Получить("ТекущийИДСтрокиШагСценарий"), Неопределено);
				СоответствиеГрупп.Вставить("ТекущийИДСтрокиШагСценарий", СтрокаВыполнения.Родитель.ИДСтроки);
			КонецЕсли;
		КонецЕсли;
		Если СтрокаВыполнения.Родитель.Тип = "ШагСценарий" Тогда
			Если СоответствиеГрупп.Получить(СтрокаВыполнения.Родитель.ИДСтроки) = Неопределено Тогда 
				ШагВложенный = ПолучитьОписаниеШагаАллюр2();
				ШагВложенный.name  = Строка(СтрокаВыполнения.Родитель.Имя);
				ШагВложенный.stage = "finished";
				ЗаписатьСтатусВШагИлиСценарий2(ШагВложенный, РезультатыПрохождения.Статус);
				МассивШагов.Добавить(ШагВложенный);
				СоответствиеГрупп.Вставить(СтрокаВыполнения.Родитель.ИДСтроки, ШагВложенный);
			Иначе
				ШагВложенный = СоответствиеГрупп.Получить(СтрокаВыполнения.Родитель.ИДСтроки);
			КонецЕсли;
			МассивШаговДобавления = ШагВложенный.steps;
		КонецЕсли;
	КонецЕсли;
	
	Шаг = ПолучитьОписаниеШагаАллюр2();
	Шаг.name  = Строка(РезультатыПрохождения.Имя);
	Если РезультатыПрохождения.ВремяНачала <> Неопределено Тогда
		Шаг.start = (РезультатыПрохождения.ВремяНачала - РазницаВМилисекундахМеждуЮниксИНачалЭпохи);
		Шаг.stop  = (РезультатыПрохождения.ВремяОкончания - РазницаВМилисекундахМеждуЮниксИНачалЭпохи);
	КонецЕсли;
	Шаг.stage = "finished";
	
	Если СтрокаВыполнения <> Неопределено Тогда	
		Счетчик = 1;
		Для каждого Элемент из СтрокаВыполнения.ЗначенияПараметров Цикл
			ИмяПараметра = "Парам"+Счетчик;
			Счетчик = Счетчик + 1;
			Шаг["parameters"].Добавить(Новый Структура("name, value", ИмяПараметра, Элемент.Значение.Значение));
		КонецЦикла;
		
		МассивПараметров = Новый Массив();		
		Если СтрокаВыполнения.ШагСПараметрамиВТаблице = Истина Тогда
			СтрокаCSV = "";
			ПарамТаблица = Новый Массив;
			ПодчиненныеСтроки = СтрокаВыполнения.Строки;
			Для каждого СтрокиТаблицы Из ПодчиненныеСтроки Цикл
				Если ЗначениеЗаполнено(СтрокиТаблицы.Тип) Тогда
					//значит это уже не строка таблицы
					Прервать;
				КонецЕсли;	 
				
				СтруктураПарамТаблица = Новый Структура;
				
				Если (СтрокиТаблицы.СтрокаПараметровШагаВВидеТаблицы <> Истина) ИЛИ (НЕ ЗначениеЗаполнено(СтрокиТаблицы.Имя)) Тогда
					ПарамТаблица = Новый Массив;
					МассивПараметров.Добавить(ПарамТаблица);
					Продолжить;
				КонецЕсли;	 
				
				НомерКолонки = 0;
				Для каждого Колонка Из СтрокиТаблицы.ПараметрыТаблицы Цикл
					НомерКолонки       = НомерКолонки + 1;
					СтруктураПараметра = Колонка.Значение;
					Значение           = Строка(СтруктураПараметра.Значение);
					СтрокаCSV = СтрокаCSV + ?(НомерКолонки = 1, "", ",") + """" + СтрЗаменить(Значение, """", """""") + """";
					СтруктураПарамТаблица.Вставить("Кол" + НомерКолонки, Значение);
				КонецЦикла;
				
				ПарамТаблица.Добавить(СтруктураПарамТаблица);
				СтрокаCSV = СтрокаCSV + Символы.ПС;
			КонецЦикла;
			
			Если ПарамТаблица.Количество() > 0 Тогда
				МассивПараметров.Добавить(ПарамТаблица);
			КонецЕсли;
			
			Если МассивПараметров.Количество() > 0 Тогда
				РеальноеИмяФайла = Строка(Новый УникальныйИдентификатор) + "-attachment.csv";
				
				ВременноеИмяФайла = ПолучитьИмяВременногоФайла("csv");
				Запись = Новый ЗаписьТекста;
				Запись.Открыть(ВременноеИмяФайла);
				Запись.Записать(СтрокаCSV);
				Запись.Закрыть();
				
				ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ВременноеИмяФайла);
				СтруткутаДляФайлаXML = Новый Структура;
				СтруткутаДляФайлаXML.Вставить("РеальноеИмяФайла", Строка(РеальноеИмяФайла)); //"" + GUID +"-container.json");				
				СтруткутаДляФайлаXML.Вставить("ФайлXMLДвоичныеДанные", ДвоичныеДанныеФайла);
				МассивXMLОтчетаAllure.Добавить(СтруткутаДляФайлаXML);
				УдалитьФайлы(ВременноеИмяФайла);
				ДобавитьФайлКШагуАллюр2(Шаг, "table", РеальноеИмяФайла, "text/csv");
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ДобавитьФайлыКШагуАллюр2(Шаг, РезультатыПрохождения, МассивXMLОтчетаAllure);
	
	ЗаписатьСтатусВШагИлиСценарий2(Шаг, РезультатыПрохождения.Статус);
	Если ((РезультатыПрохождения.Статус = "Failed") ИЛИ (РезультатыПрохождения.Статус = "Pending")) 
		И РезультатыПрохождения.Свойство("ОписаниеОшибки") Тогда
		Шаг.Вставить("statusDetails", 
			Новый Структура("known, muted, flaky, message, trace", 
							Ложь, Ложь, Ложь, РезультатыПрохождения.ОписаниеОшибки, "")
		);
	КонецЕсли; 
	
	МассивШаговДобавления.Добавить(Шаг);
	Если ШагВложенный <> Неопределено Тогда
		Если ШагВложенный.start = Неопределено ИЛИ ШагВложенный.start > Шаг.start Тогда
			ШагВложенный.start = Шаг.start;
		КонецЕсли;
		
		Если ШагВложенный.stop = Неопределено ИЛИ ШагВложенный.stop <  Шаг.stop Тогда
			ШагВложенный.stop = Шаг.stop;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьОбъектВJson(СтруктураОбъекта, ИмяФайла, МассивXMLОтчетаAllure) 
	Перем ВременноеИмяФайла,ЗаписьJSON, ПараметрыЗаписиJSON, ДвоичныеДанныеФайла, СтруткутаДляФайлаXML;
 
	ВременноеИмяФайла = ПолучитьИмяВременногоФайла("json");
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON( ,Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписьJSON.ОткрытьФайл(ВременноеИмяФайла, , ,ПараметрыЗаписиJSON);
	
	ЗаписатьJSON(ЗаписьJSON, СтруктураОбъекта); 
	ЗаписьJSON.Закрыть();
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ВременноеИмяФайла);
	СтруткутаДляФайлаXML = Новый Структура;
	СтруткутаДляФайлаXML.Вставить("РеальноеИмяФайла", Строка(ИмяФайла)); //"" + GUID +"-container.json");				
	СтруткутаДляФайлаXML.Вставить("ФайлXMLДвоичныеДанные", ДвоичныеДанныеФайла);
	МассивXMLОтчетаAllure.Добавить(СтруткутаДляФайлаXML);
	УдалитьФайлы(ВременноеИмяФайла);
	
КонецПроцедуры

Процедура ОбойтиДеревоДляОтчетаАллюр2(Дерево, ДеревоТестов)
	
	Для каждого СтрСтроки Из Дерево.Строки Цикл
		Если      СтрСтроки.Тип = "Фича" Тогда
			
			ОбойтиДеревоДляОтчетаАллюр2(СтрСтроки, ДеревоТестов); //, СтруктураВыгрузки, ТекущаяФича, СписокСценариев, СписокШагов);
			
			
		ИначеЕсли (СтрСтроки.Тип = "Сценарий") или (СтрСтроки.Тип = "Пример") Тогда
			Если (СтрСтроки.ДопТип = "Контекст") Тогда
				//его не неадо добавлять в отчет, т.к. этот сценарий включается в каждый сценарий
				
			ИначеЕсли (СтрСтроки.ДопТип = "СтруктураСценария") или (СтрСтроки.Строки.Количество() = 0) Тогда
				//его не неадо добавлять в отчет, т.к. этот сценарий явно не выполняется
				ОбойтиДеревоДляОтчетаАллюр2(СтрСтроки, ДеревоТестов); //, СтруктураВыгрузки, ТекущаяФича, СписокСценариев, СписокШагов);
			Иначе
				
				РезультатПрохожденияТестовСценария = ПолучитьРезультатПрохожденияТестовСценария(СтрСтроки);				 
				Если РезультатПрохожденияТестовСценария = Неопределено Тогда
					Продолжить;
				КонецЕсли;
	
				
				GUID             = Новый УникальныйИдентификатор();
				СтруктураВыгрузки = ПолучитьОписаниеСценарияАллюр2();
				СтруктураВыгрузки.Вставить("uuid", Строка(GUID));			
								
				ПрефиксИмениСценария = ПолучитьПрефиксИмениСценария2(ДобавлятьКИмениСценарияУсловияВыгрузки);
				
				СтрокаФичи = СтрСтроки.Родитель;
				Если СтрСтроки.Тип = "Пример" Тогда
					СтруктураВыгрузки.name	= ПрефиксИмениСценария + СтрСтроки.Родитель.Родитель.Имя + " №" + (СтрСтроки.Родитель.Строки.Индекс(СтрСтроки));
					СтрокаФичи		= СтрСтроки.Родитель.Родитель.Родитель;
				Иначе	
					СтруктураВыгрузки.name     = ПрефиксИмениСценария + СтрСтроки.Имя;
				КонецЕсли;
				СтруктураВыгрузки.historyId = СтрокаФичи.Имя + "." +  СтруктураВыгрузки.name;
				
				ЗаписатьОписаниеАллюр2(СтрокаФичи, СтруктураВыгрузки);
				ЗаписатьОписаниеАллюр2(СтрСтроки, СтруктураВыгрузки);
												
				СтруктураВыгрузки.Вставить("start", (РезультатПрохожденияТестовСценария.ВремяНачала - РазницаВМилисекундахМеждуЮниксИНачалЭпохи));
				СтруктураВыгрузки.Вставить("stop", (РезультатПрохожденияТестовСценария.ВремяОкончания - РазницаВМилисекундахМеждуЮниксИНачалЭпохи));	
				
				МассивШаговBefore = Новый Массив();
				Если СтрСтроки.ДопТип = "СтруктураСценария" Тогда
					ОбойтиДеревоДляОтчетаАллюр2(СтрСтроки, ДеревоТестов) //, СтруктураВыгрузки, ТекущаяФича, СписокСценариев, СписокШагов);
				Иначе
					СоответствиеГрупп = Новый Соответствие;
					МассивШаговДляЗаполнения = СтруктураВыгрузки.steps;
					Если СтрСтроки.Тип = "Пример" Тогда
						Шаг = ПолучитьОписаниеШагаАллюр2();
						Шаг.name = СтрСтроки.Имя;
						ЗаписатьСтатусВШагИлиСценарий2(Шаг, СтрСтроки.Статус);
						МассивШаговДляЗаполнения = Шаг.steps;
						СтруктураВыгрузки.steps.Добавить(Шаг);
					КонецЕсли;

					Для каждого СтрРезультатПрохожденияТестовШагов Из РезультатПрохожденияТестовСценария.РезультатПрохожденияТестовШагов Цикл
						
						Если СтрРезультатПрохожденияТестовШагов.ЭтоШагКонтекста Тогда
							МассивШаговBefore.Добавить(СтрРезультатПрохожденияТестовШагов);
						Иначе
														
							ЗаписатьВыполнениеШагаАллюр2(
								МассивШаговДляЗаполнения,
								ДеревоТестов,
								СтрРезультатПрохожденияТестовШагов,
								СоответствиеГрупп, 
								ПараметрыОтчетаУФ.МассивXMLОтчетаAllure
							);
							ВложенныеШаги = Неопределено;
							Если СтрРезультатПрохожденияТестовШагов.Свойство("ВложенныеШаги", ВложенныеШаги) 
								И ТипЗнч(ВложенныеШаги) = Тип("Массив") Тогда
								ТекущийШагРезультата = МассивШаговДляЗаполнения.Получить(МассивШаговДляЗаполнения.ВГраница());
								Для каждого СтрПрохожденияВложенныхШагов из ВложенныеШаги Цикл
									ЗаписатьВыполнениеШагаАллюр2(
										ТекущийШагРезультата.steps,
										ДеревоТестов,
										СтрПрохожденияВложенныхШагов,
										СоответствиеГрупп, 
										ПараметрыОтчетаУФ.МассивXMLОтчетаAllure
									);
								КонецЦикла;
							КонецЕсли;
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;	 
				
				
				ЗаписатьСтатусВШагИлиСценарий2(СтруктураВыгрузки, СтрСтроки.Статус);
				
				Если (СтрСтроки.Статус = "Failed") или (СтрСтроки.Статус = "Pending") Тогда
					СтруктураВыгрузки.Вставить("statusDetails", 
						Новый Структура("known, muted, flaky, message, trace", 
										Ложь, Ложь, Ложь, РезультатПрохожденияТестовСценария.ОписаниеОшибки, "")
					);
				КонецЕсли; 
				
				ДобавитьСкриншотыКШагуАллюр2(СтруктураВыгрузки, РезультатПрохожденияТестовСценария);
				
				СисИнформация = Новый СистемнаяИнформация;
				СписокМетокПереопределяемый = Новый СписокЗначений;
				Если РезультатПрохожденияТестовСценария.Свойство("СписокМеток") Тогда
					СписокМетокПереопределяемый = РезультатПрохожденияТестовСценария["СписокМеток"];
				КонецЕсли;
				
				СписокСсылок = Новый СписокЗначений;
				Если РезультатПрохожденияТестовСценария.Свойство("СписокСсылок") Тогда
					СписокСсылок = РезультатПрохожденияТестовСценария["СписокСсылок"];
				КонецЕсли;
				
				Для каждого СсылкаUrl из СписокСсылок Цикл
					ОписаниеСсылки = Новый Структура("name,url,type");
					ОписаниеСсылки.name = СсылкаUrl.Значение.name;
					ОписаниеСсылки.url = СсылкаUrl.Значение.url;
					ОписаниеСсылки.type = СсылкаUrl.Значение.type;
					
					СтруктураВыгрузки.links.Добавить(ОписаниеСсылки);					
				КонецЦикла;
				
				МассивТегов = Новый Массив();
				ЗначениеМеткиStory = СтрСтроки.Имя;
				Если СтрокаФичи.Тип = "Фича" Тогда
					ДополнительноеОписаниеФичи = СтрокаФичи.ДополнительныеДанные;
					Если ТипЗнч(ДополнительноеОписаниеФичи) = Тип("Структура") И ДополнительноеОписаниеФичи.Свойство("name") Тогда
						ЗначениеМеткиStory = ДополнительноеОписаниеФичи["name"];
					КонецЕсли;
					
					Если ТипЗнч(ДополнительноеОписаниеФичи) = Тип("Структура") И ДополнительноеОписаниеФичи.Свойство("tags") Тогда
						МассивТегов = ДополнительноеОписаниеФичи["tags"];
					КонецЕсли;
					
				КонецЕсли;

				ФайлФичи = Новый Файл(СтрокаФичи.ПолныйПуть);
				ПутьФичи = Новый Файл(ФайлФичи.Путь);
				КаталогФичи = ПутьФичи.ИмяБезРасширения;
				
				СписокМеток =  СтруктураВыгрузки.labels;
				
				ДобавитьМетку2(СписокМеток, "story", ЗначениеМеткиStory, СписокМетокПереопределяемый); 
				ДобавитьМетку2(СписокМеток, "feature",СтрокаФичи.Имя, СписокМетокПереопределяемый);
				ДобавитьМетку2(СписокМеток, "host", СисИнформация.ВерсияОС, СписокМетокПереопределяемый);
				ДобавитьМетку2(СписокМеток, "package", КаталогФичи, СписокМетокПереопределяемый);
				
				Для каждого Тег из МассивТегов Цикл
					ДобавитьМетку2(СписокМеток, "tag", Тег.Тег, СписокМетокПереопределяемый);
				КонецЦикла;
				
				Для каждого ЭлементМетки из СписокМетокПереопределяемый Цикл
					ДобавитьМетку2(СписокМеток, ЭлементМетки.Значение, ЭлементМетки.Представление);
				КонецЦикла;
				
				
				СписокМетокПереопределяемый = Новый СписокЗначений;
				Если СтрСтроки.Строки.Количество() > 0 Тогда
					РезультатПрохожденияТестовСценария = ПолучитьРезультатПрохожденияТестовСценария(СтрСтроки.Строки[0]);
					Если РезультатПрохожденияТестовСценария <> Неопределено И РезультатПрохожденияТестовСценария.Свойство("СписокМеток") Тогда
						СписокМетокПереопределяемый = РезультатПрохожденияТестовСценария["СписокМеток"];
					КонецЕсли;
				КонецЕсли;			
				
				Для каждого ЭлементМетки из СписокМетокПереопределяемый Цикл
					ДобавитьМетку2(СписокМеток, ЭлементМетки.Значение, ЭлементМетки.Представление);
				КонецЦикла;
								
				РеальноеИмяФайла = "" + GUID +"-result.json";
				ЗаписатьОбъектВJson(СтруктураВыгрузки, РеальноеИмяФайла, ПараметрыОтчетаУФ.МассивXMLОтчетаAllure);
				
				Если МассивШаговBefore.Количество() > 0 Тогда
					СтруктураШаговКонтекста = ПолучитьОписаниеКонтекстныхШаговАллюр2();
					СтруктураШаговКонтекста.uuid = Строка(Новый УникальныйИдентификатор);
					СтруктураШаговКонтекста.name = "Контекст_"+СтруктураВыгрузки.name;
					СтруктураШаговКонтекста.description =  "";
					СтруктураШаговКонтекста.children.Добавить(Строка(GUID));
					СтруктураШаговКонтекста.Вставить("befores", Новый Массив());
					
					ВремяНачала = 0;
					ВремяОкончания = 0;
					СоответствиеГрупп = Новый Соответствие;
					СоответствиеГрупп.Вставить("УдалятьРодителейПриСмене", Истина);
					Для Сч = 0 По МассивШаговBefore.ВГраница() Цикл
						
						ЭлементМассива = МассивШаговBefore.Получить(Сч);
						
						ЗаписатьВыполнениеШагаАллюр2(
								СтруктураШаговКонтекста.befores,
								ДеревоТестов,
								ЭлементМассива,
								СоответствиеГрупп, 
								ПараметрыОтчетаУФ.МассивXMLОтчетаAllure
						);

					КонецЦикла;
					РеальноеИмяФайла = "" + GUID +"-container.json";
					ЗаписатьОбъектВJson(СтруктураШаговКонтекста, РеальноеИмяФайла, ПараметрыОтчетаУФ.МассивXMLОтчетаAllure);
				КонецЕсли;
				
			КонецЕсли; 
		ИначеЕсли СтрСтроки.Тип = "Шаг" Тогда
			Если СтрСтроки.Родитель.ДопТип = "СтруктураСценария" Тогда
				//его не неадо добавлять в отчет, т.к. этот сценарий явно не выполняется
				ОбойтиДеревоДляОтчетаАллюр2(СтрСтроки, ДеревоТестов); //,Фабрика,ТекущаяФича,СписокСценариев,СписокШагов);
			Иначе	
			КонецЕсли; 
		Иначе	
			ОбойтиДеревоДляОтчетаАллюр2(СтрСтроки, ДеревоТестов); 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

Процедура СформироватьОтчетАллюр2(СтруктураОФ, ДеревоТестовПарам, 
		ИмяСборки, ДобавлятьКСценариюУсловияВыгрузки) Экспорт

	Перем СтарыйКаталог, ИмяФайла;
	
	ОтчетВРежимеУФ = Ложь;
	
	Если СтруктураОФ = Неопределено Тогда
		ВызватьИсключение "Не поддерживаем ОФ";
	Иначе
		ИмяТекущейСборки = ИмяСборки;
		ОтчетВРежимеУФ = Истина;
		ПараметрыОтчетаУФ    = СтруктураОФ;
		ДобавлятьКИмениСценарияУсловияВыгрузки = ДобавлятьКСценариюУсловияВыгрузки;
		
		МассивXMLОтчетаAllure = Новый Массив;
		СтруктураОФ.Вставить("МассивXMLОтчетаAllure",МассивXMLОтчетаAllure);
				
	КонецЕсли;	 
	
	СтруктураВыгрузки = Новый Структура;
	ОбойтиДеревоДляОтчетаАллюр2(ДеревоТестовПарам, ДеревоТестовПарам);
	
КонецПроцедуры

РазницаВМилисекундахМеждуЮниксИНачалЭпохи = 62135596800000;

//}Отчет Allure2