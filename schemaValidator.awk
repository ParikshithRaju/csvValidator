function printMessage(errorType, row, column) {
    if(errorType=="required") {
        print "Required field error: " "(" row "," column ")";
    }
    if(errorType=="length") {
        print "Length validation error:  " "(" row "," column ")";
    }
    if(errorType=="maxLength"){
        print "Max length error: " "(" row "," column ")";
    }
    if(errorType=="minLength"){
        print "Min length error: " "(" row "," column ")";
    }
}

{
    if(isHeaderPresent!="true" || NR!=1) {
        len=split(columnIndexs,columnIndexsArr," ")
        split(_isRequiredValidationArray,isRequiredValidationArr," ")
        split(_lengthValidationArray,lengthValidationArr," ")
        split(_minLengthValidationArray,minLengthValidationArr," ")
        split(_maxLengthValidationArray,maxLengthValidationArr," ")
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
        }
    }
}
