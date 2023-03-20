
function printMessage(errorType, row, column) {
    if(errorType=="required") {
        print "Required field error: " "(" (isHeaderPresent=="true" ? (row-1) : row) "," column ")";
    }
    if(errorType=="length") {
        print "Length validation error:  " "(" (isHeaderPresent=="true" ? (row-1) : row) "," column ")";
    }
    if(errorType=="maxLength"){
            print "Max length error: " "(" (isHeaderPresent=="true" ? (row-1) : row) "," column ")";
    }
    if(errorType=="minLength"){
            print "Min length error: " "(" (isHeaderPresent=="true" ? (row-1) : row) "," column ")";
    }
    if(errorType=="type"){
        print "Type error: " "(" (isHeaderPresent=="true" ? (row-1) : row) "," column ")";
    }
}

function isTypeValid(type,value) {
    if(type=="interger") {
        if(value ~ /^[0-9]{1,10}$/) {
            return "true"
        } else {
            return "false"
        }
    }
    if(type=="decimal") {
        if(value ~ /^[0-9]{,10}\.[0-9]{1,10}$/) {
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
    if(type=="date") {
        return "true"
    }
    if(type=="phoneNumber") {
        return "true"
    }
    }
}

{
    if(isHeaderPresent!="true" || NR!=1) {
        len=split(columnIndexs,columnIndexsArr," ")
        split(_isRequiredValidationArray,isRequiredValidationArr," ")
        split(_lengthValidationArray,lengthValidationArr," ")
        split(_minLengthValidationArray,minLengthValidationArr," ")
        split(_maxLengthValidationArray,maxLengthValidationArr," ")
        split(_typeValidationArray,typeValidationArr," ")
        for(i=1;i<=len;i++) {
            if(isRequiredValidationArr[i] == "true") {
                if($columnIndexsArr[i]=="" || $columnIndexsArr[i]=="\n" || $columnIndexsArr[i]=="\r") {
                    printMessage("required",NR,columnIndexsArr[i]);
                    continue
                }
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
