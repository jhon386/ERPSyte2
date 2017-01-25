// JavaScript Date Format
// http://blog.stevenlevithan.com/archives/date-time-format

function zKdDateFormat(date) {
    try {

        var dd = date.getDate();
        var mm = date.getMonth() + 1;

        return [
            (dd > 9 ? '' : '0') + dd,
            (mm > 9 ? '' : '0') + mm,
            date.getFullYear()
        ].join('.');

    } catch (e) {
        return ' Произошла ошибка: ' + e.name + ' ' + e.message;
    }
}

function zKdDateTimeFormat(date) {
    try {

        var dd = date.getDate();
        var mm = date.getMonth() + 1;
        var hh = date.getHours();
        var nn = date.getMinutes();
        var ss = date.getSeconds();

        return [
            (dd > 9 ? '' : '0') + dd,
            (mm > 9 ? '' : '0') + mm,
            date.getFullYear()
        ].join('.') +
        ' ' +
        [
            (hh > 9 ? '' : '0') + hh,
            (nn > 9 ? '' : '0') + nn,
            (ss > 9 ? '' : '0') + ss
        ].join(':');

    } catch (e) {
        return ' Произошла ошибка: ' + e.name + ' ' + e.message;
    }
}