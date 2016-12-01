function format_date(date) {
    if (date != "")
        if ((date.substr(2, 1) == ".") && (date.substr(5, 1) == "."))
            return date.substr(6, 4) + "" + date.substr(3, 2) + "" + date.substr(0, 2) + "";
        else return date;
    return "";
}

function ExportToExcelClient(pShowCooperate, pShowBuy,
    pDateRecordFrom, pDateRecordTo, pDateTransferFrom, pDateTransferTo, pDateAcceptFrom, pDateAcceptTo,
    pItem, pDescription, pRepeated, pTemaNIOKR, pVend, pVendN, pChecker, pScrap, pLot, pWaitWork, pWaitANP, pWaitWorkDay, pWaitANPDay, pShowOnlyLocQCD, pShowOnlyLocWork, pUM)
    {
    //каталог временных файлов
    var temp_folder = "";
    var oWshShell = new ActiveXObject("WScript.Shell");
    var oEnvUser = oWshShell.Environment("User");
    var oEnvProcess = oWshShell.Environment("Process");
    if (temp_folder == "")
        temp_folder = oWshShell.ExpandEnvironmentStrings("%TEMP%");
    if (temp_folder == "")
        temp_folder = oWshShell.ExpandEnvironmentStrings("%TMP%");
    if (temp_folder == "")
        temp_folder = oEnvUser("TEMP");
    if (temp_folder == "")
        temp_folder = oEnvUser("TMP");
    if (temp_folder == "")
        temp_folder = oEnvProcess("TEMP");
    if (temp_folder == "")
        temp_folder = oEnvProcess("TMP");
    if (temp_folder == "") {
        alert("Файл не может быть создан, так как в переменных окружения не найден временный каталог. Обратитесь за помощью к системному администратору.");
        return (1);
    }
    oEnvProcess = null;
    oEnvUser = null;

    //маска файла
    var cur_date = new Date();
    var d = cur_date.getDate();
    var m = cur_date.getMonth() + 1;
    var y = cur_date.getFullYear();
    var s = '' + y + '' + (m <= 9 ? '0' + m : m) + '' + (d <= 9 ? '0' + d : d);
    y = null;
    m = null;
    d = null;
    cur_date = null;

    //перенос файла
    var filename = temp_folder + "\\QCD_" + s + ".xlsm";
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var i = 0;
    while (fso.FileExists(filename)) {
        i += 1;
        if (i > 9999) {
            alert("Превышен счетчик документов.");
            return (2);
        }
        filename = temp_folder + "\\QCD_" + s + "_(" + i + ").xlsm";
    }
    i = null;
    s = null;
    //alert("the filename is <"+filename+">");
    fso.CopyFile("N:\\Installs\\Elektron\\Common\\SyteLine\\QCDStatistics.xlsm", filename);

    //открытие файла
    var xl = new ActiveXObject("Excel.Application");
    xl.visible = true;
    xl.DisplayAlerts = false;
    xl.UserControl = false;

    success = oWshShell.AppActivate(xl);
    if (success) {
        oWshShell.sendkeys("% r")  //...restore window
        oWshShell.sendkeys("%")  //...send ALT to close system window
    }
    var wb = xl.Workbooks.Open(filename);
    wb.Sheets(1).Name = "Общая База";
    wb.Sheets(1).Cells(1, 1).Select;

    //передача параметров
    if (wb.Sheets.Count > 1) {
        wb.Sheets.Item("params").Cells(1, 2).Value = pShowCooperate;//@pShowCooperate
        wb.Sheets.Item("params").Cells(2, 2).Value = pShowBuy;//@pShowBuy
        wb.Sheets.Item("params").Cells(3, 2).Value = format_date(pDateRecordFrom);//@pDateRecordFrom
        wb.Sheets.Item("params").Cells(4, 2).Value = format_date(pDateRecordTo);//@pDateRecordTo
        wb.Sheets.Item("params").Cells(5, 2).Value = format_date(pDateTransferFrom);//@pDateTransferFrom
        wb.Sheets.Item("params").Cells(6, 2).Value = format_date(pDateTransferTo);//@pDateTransferTo
        wb.Sheets.Item("params").Cells(7, 2).Value = format_date(pDateAcceptFrom);//@pDateAcceptFrom
        wb.Sheets.Item("params").Cells(8, 2).Value = format_date(pDateAcceptTo);//@pDateAcceptTo
        wb.Sheets.Item("params").Cells(9, 2).Value = pItem;//@pItem
        wb.Sheets.Item("params").Cells(10, 2).Value = pDescription;//@pDescription
        wb.Sheets.Item("params").Cells(11, 2).Value = pRepeated;//@pRepeated
        wb.Sheets.Item("params").Cells(12, 2).Value = pTemaNIOKR;//@pTemaNIOKR
        wb.Sheets.Item("params").Cells(13, 2).Value = pVend;//@pVend
        wb.Sheets.Item("params").Cells(14, 2).Value = pVendN;//@pVendN
        wb.Sheets.Item("params").Cells(15, 2).Value = pChecker;//@pChecker
        wb.Sheets.Item("params").Cells(16, 2).Value = pScrap;//@pScrap
        wb.Sheets.Item("params").Cells(17, 2).Value = pLot;//@pLot
        wb.Sheets.Item("params").Cells(18, 2).Value = pWaitWork;//@pWaitWork
        wb.Sheets.Item("params").Cells(19, 2).Value = pWaitANP;//@pWaitANP
        wb.Sheets.Item("params").Cells(20, 2).Value = pWaitWorkDay;//@pWaitWorkDay
        wb.Sheets.Item("params").Cells(21, 2).Value = pWaitANPDay;//@pWaitANPDay
        wb.Sheets.Item("params").Cells(22, 2).Value = "";//@Infobar
        wb.Sheets.Item("params").Cells(23, 2).Value = pShowOnlyLocQCD;//@pShowOnlyLocQCD
        wb.Sheets.Item("params").Cells(24, 2).Value = pShowOnlyLocWork;//@pShowOnlyLocWork
        wb.Sheets.Item("params").Cells(25, 2).Value = pUM;//@pUM
    }

    //запуск макроса
    xl.run("JIIViewer");
    //xl.run("DeleteModule");
    wb = null;
    xl = null;

    filename = null;
    fso = null;
    oWshShell = null;
    temp_folder = null;
}