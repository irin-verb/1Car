﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.Пассажир = ПолучитьИмяПассажира(); 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяПассажира()
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().Имя;	
КонецФункции