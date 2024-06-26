﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    ЗначениеОтбора = Новый Структура;
    СтруктураПоездка = Новый Структура;
    СтруктураПоездка.Вставить("Водитель", ПолучитьИмяВодителя());
    ЗначениеОтбора.Вставить("Поездка", СтруктураПоездка);
	ЗначениеОтбора.Вставить("СтатусЗаявки", ПолучитьСтатусЗаявкиНовый());
    ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
    ОткрытьФорму("Документ.ЗаявкаНаПоездку.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры


&НаСервере
Функция ПолучитьИмяВодителя()
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().Имя;	
КонецФункции

&НаСервере
Функция ПолучитьСтатусЗаявкиНовый()
	Возврат Перечисления.СтатусыЗаявки.Новая;
КонецФункции
