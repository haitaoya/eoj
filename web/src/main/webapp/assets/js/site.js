String.prototype.format = function() {
    var newStr = this, i = 0;
    while (/%s/.test(newStr)) {
        newStr = newStr.replace("%s", arguments[i++])
    }
    return newStr;
}

/* Format DateTime for different locales */
function getFormatedDateString(dateTime, locale) {
    var dateObject = new Date(dateTime),
        dateString = dateObject.toString();

    if ( locale == 'en_US' ) {
        dateString = dateObject.toString('MMM d, yyyy h:mm:ss tt');
    } else if ( locale == 'zh_CN' ) {
        dateString = dateObject.toString('yyyy-M-dd HH:mm:ss');
    }
    return dateString;
}

