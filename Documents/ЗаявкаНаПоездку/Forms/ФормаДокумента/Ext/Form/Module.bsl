﻿
&НаСервере
Процедура ОтклонитьНаСервере()
	Объект.СтатусЗаявки = Перечисления.СтатусыЗаявки.Отклонена;
	КонецПроцедуры
	
	
&НаКлиенте
Процедура Отклонить(Команда)
	ОтклонитьНаСервере();    
	ЭтаФорма.Записать();  
	ЭтаФорма.Закрыть();
КонецПроцедуры


&НаСервере
Процедура ОдобритьНаСервере() 
	// меняем статус
	Объект.СтатусЗаявки = Перечисления.СтатусыЗаявки.Принята;	
	ИзменяемаяПоездка = Объект.Поездка.ПолучитьОбъект(); 
	// уменьшаем свободные места 
	ИзменяемаяПоездка.СвободныеМеста = ИзменяемаяПоездка.СвободныеМеста - 1;
	// добавляем пассажира
   	НовыйПассажир = ИзменяемаяПоездка.Пассажиры.Добавить();
  	НовыйПассажир.Пассажир = Объект.Пассажир; 
	ИзменяемаяПоездка.Записать(); 
	
КонецПроцедуры


&НаКлиенте
Процедура Одобрить(Команда)   
	Если ПолучитьСвободныеМеста(Объект.Поездка) = 0 Тогда
		ОтклонитьВсеЗаявкиНаПоездку(); 
	Иначе 
		Если ПолучитьСвободныеМеста(Объект.Поездка) = 1 Тогда 
			ОдобритьНаСервере();
			ЭтаФорма.Записать();
			ОтклонитьВсеЗаявкиНаПоездку();
		Иначе 
			ОдобритьНаСервере();
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.Записать();
	ЭтаФорма.Закрыть();
КонецПроцедуры


&НаСервере
Функция НаПроездкуЕстьМеста ()
    Возврат Объект.Поездка.СвободныеМеста > 0;
КонецФункции   

 
&НаСервере
Процедура ОтклонитьВсеЗаявкиНаПоездку() 	
	ТекстЗапроса = "ВЫБРАТЬ ДокументЗаявкаНаПоездку.Ссылка КАК Ссылка ИЗ Документ.ЗаявкаНаПоездку КАК ДокументЗаявкаНаПоездку ГДЕ ДокументЗаявкаНаПоездку.СтатусЗаявки = &СтатусЗаявки И ДокументЗаявкаНаПоездку.Поездка = &Поездка" ;
    Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СтатусЗаявки", Перечисления.СтатусыЗаявки.Новая);
	Запрос.УстановитьПараметр("Поездка", Объект.Поездка);
	ЗаявкиНаПоездку = Запрос.Выполнить().Выбрать();
	Пока ЗаявкиНаПоездку.Следующий() Цикл
		ТекПоездка = ЗаявкиНаПоездку.Ссылка.ПолучитьОбъект();     
		Если ТекПоездка.СтатусЗаявки <> Перечисления.СтатусыЗаявки.Принята Тогда
			ТекПоездка.СтатусЗаявки = Перечисления.СтатусыЗаявки.Отклонена;  
			ТекПоездка.Записать();
		КонецЕсли;
	КонецЦикла;   	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПользовательЯвляетсяПассажиром() И НЕ ЗначениеЗаполнено(Объект.Пассажир) Тогда
		Объект.Пассажир = ПолучитьИмяПассажира();
		Объект.СтатусЗаявки = ПолучитьСтатусЗаявкиНовый();
	Иначе
		Элементы.КомандаОткрытьФормуВыбораПоездки.Видимость = Ложь;
	КонецЕсли;	
КонецПроцедуры      


&НаСервереБезКонтекста
Функция ПолучитьИмяПассажира()
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().Имя;	
КонецФункции


&НаСервереБезКонтекста
Функция ПолучитьСтатусЗаявкиНовый()
	Возврат Перечисления.СтатусыЗаявки.Новая;
КонецФункции


&НаСервереБезКонтекста
Функция ПользовательЯвляетсяПассажиром()
	Возврат РольДоступна("Пассажир");	
КонецФункции


&НаКлиенте
Процедура КомандаОткрытьФормуВыбораПоездки(Команда)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Завершена", Ложь);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОписаниеВыбора = Новый ОписаниеОповещения("ОбработатьВыборПоездки", ЭтаФорма);
	ОткрытьФорму("Документ.Поездка.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОписаниеВыбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры         


&НаСервере
Функция ЕстьЗаявкаНаПоездку(Поездка)
	СписокПоездокСЗаявками = Новый Массив;
    Запрос = Новый Запрос("ВЫБРАТЬ Документ.ЗаявкаНаПоездку.Поездка ИЗ Документ.ЗаявкаНаПоездку ГДЕ Пассажир = &Пассажир");
    Запрос.УстановитьПараметр("Пассажир", ПолучитьИмяПассажира());
    РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
    Пока Выборка.Следующий() Цикл
        СписокПоездокСЗаявками.Добавить(Выборка.Поездка);
	КонецЦикла;
	Возврат НЕ СписокПоездокСЗаявками.Найти(Поездка) = Неопределено;
КонецФункции


&НаКлиенте
Процедура ОбработатьВыборПоездки(РезультатЗакрытия, ДопПараметры) Экспорт
	Если Не ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	Если ПолучитьСвободныеМеста(РезультатЗакрытия) = 0 Тогда
		Предупреждение("В этой поездке нет свободных мест");
		Объект.Поездка = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если НЕ ДостаточноСредствНаБалансе(РезультатЗакрытия) Тогда
		Предупреждение("Недостаточно средств на балансе");
		Объект.Поездка = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если ЕстьЗаявкаНаПоездку(РезультатЗакрытия) Тогда
		Предупреждение("Вы уже подавали заявку на эту поездку");
		Объект.Поездка = Неопределено;
		Возврат;
	КонецЕсли;
	
	Объект.Поездка = РезультатЗакрытия;
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьСвободныеМеста(Поездка)
	Возврат Поездка.СвободныеМеста;
КонецФункции


&НаСервереБезКонтекста
Функция ДостаточноСредствНаБалансе(Поездка)
	Возврат РегистрыНакопления.БалансПассажиров.ПолучитьБаланс() >= Поездка.СтоимостьПоездки
КонецФункции
