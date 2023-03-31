function isDateValid(dateString) {
    ("date  -d" dateString " +%Y-%m-%d 2>/dev/null") | getline inputDate
    close(("date -d " dateString " +%Y-%m-%d"))

    if(inputDate==dateString) {
        return "true"
    } else {
        return "false"
    }
}

BEGIN {
    len=split(columnIndexs,columnIndexsArr," ")
    split(_isRequiredValidationArray,isRequiredValidationArr," ")
    split(_lengthValidationArray,lengthValidationArr," ")
    split(_minLengthValidationArray,minLengthValidationArr," ")
    split(_maxLengthValidationArray,maxLengthValidationArr," ")
    split(_typeValidationArray,typeValidationArr," ")
}

NR == 1 { 
    split($0,columnsArr,FS) 
}

function printMessage(errorType, row, column) {
    if(errorType=="required") {
        print "Mandatory field missing in column \"" (isHeaderPresent=="true" ? columnsArr[column] : column) "\" and row \"" (isHeaderPresent=="true" ? (row-1) : row) "\"\n"
    }
    if(errorType=="length") {
        print "Length mismatch in column \"" (isHeaderPresent=="true" ? columnsArr[column] : column) "\" and row \"" (isHeaderPresent=="true" ? (row-1) : row) "\""
        print "Required length: " lengthValidationArr[column] ", Current length: " length($column) "\n"
    }
    if(errorType=="maxLength"){
        print "Field length greater than maxLength in column \"" (isHeaderPresent=="true" ? columnsArr[column] : column) "\" and row \"" (isHeaderPresent=="true" ? (row-1) : row) "\""
        print "Max length: " maxLengthValidationArr[column] ", Current length: " length($column) "\n"
    }
    if(errorType=="minLength"){
        print "Field length lesser than minLength in column \"" (isHeaderPresent=="true" ? columnsArr[column] : column) "\" and row \"" (isHeaderPresent=="true" ? (row-1) : row) "\""
        print "Min length: " minLengthValidationArr[column] ", Current length: " length($column) "\n"
    }
    if(errorType=="type"){
        print "Type mismatch in column \"" (isHeaderPresent=="true" ? columnsArr[column] : column) "\" and row \"" (isHeaderPresent=="true" ? (row-1) : row) "\"\n"
    }
}

function isTypeValid(type,value) {
    if(type=="number") {
        if(value ~ /^(([0-9]*.[0-9]+)|[0-9]+)$/) {
            return "true"
        } else {
            return "false"
        }
    }
    if(type=="email") {
        if(value ~ /^[a-z][a-z0-9.]+@[a-z]+.[a-z]+$/) {
            return "true"
        } else {
             return "false"
        }
    }
    if(type=="string") {
        return "true"
    }
    if(type=="phoneNumber") {
        if(value ~ /^((+[0-9]{10,12})|([0-9]{10}))$/) {
            return "true"
        } else {
            return "false"
        }
    }
    if(type=="date") {
        if(value ~ /^((0?[1-9])|([12][0-9])|30|31)\/((0?[1-9])|(1[0-2]))\/(([0-9]{4})|([0-9]{2}))$/) {
            return "true"
        } else {
            return "false"
        }
    }
}


{
    if(isHeaderPresent!="true" || NR!=1) {
        for(i=1;i<=len;i++) {
            if(isRequiredValidationArr[i] == "true") {
                if($columnIndexsArr[i]=="" || $columnIndexsArr[i]=="\n" || $columnIndexsArr[i]=="\r") {
                    printMessage("required",NR,columnIndexsArr[i]);
                    continue
                }
            } else {
                if($columnIndexsArr[i]=="" || $columnIndexsArr[i]=="\n" || $columnIndexsArr[i]=="\r")
                    continue;
            }
            if(lengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) != lengthValidationArr[i]){
                    printMessage("length",NR,columnIndexsArr[i]);
                }
            }
            if(maxLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) > maxLengthValidationArr[i]){
                    printMessage("maxLength",NR,columnIndexsArr[i])
                }
            }
            if(minLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) < minLengthValidationArr[i]){
                    printMessage("minLength",NR,columnIndexsArr[i])
                }
            }
            if(typeValidationArr[i] != "null") {
                if(isTypeValid(typeValidationArr[i],$columnIndexsArr[i])!="true") {
                    printMessage("type",NR,columnIndexsArr[i])
                }
            }
        }
    }
}
