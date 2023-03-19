{
    if(NR != 1) {
        len=split(columnIndexs,columnIndexsArr," ")
        split(_isRequiredValidationArray,isRequiredValidationArr," ")
        split(_lengthValidationArray,lengthValidationArr," ")
        split(_minLengthValidationArray,minLengthValidationArr," ")
        split(_maxLengthValidationArray,maxLengthValidationArr," ")
        for(i=1;i<=len;i++) {
            if(isRequiredValidationArr[i] == "true") {
                if($columnIndexsArr[i]=="" || $columnIndexsArr[i]=="\n" || $columnIndexsArr[i]=="\r") {
                    print "Required field error in column " columnIndexsArr[i] " and row " NR
                    continue
                }
            }
            if(lengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) != lengthValidationArr[i]){
                    print "Length validation error in column " columnIndexsArr[i] " and row " NR
                }
            }
            if(maxLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) > maxLengthValidationArr[i]){
                    print "Max length error in column " columnIndexsArr[i] " and row " NR
                }
            }
            if(minLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) < minLengthValidationArr[i]){
                    print "Min length error in column " columnIndexsArr[i] " and row " NR
                }
            }
        }
    }
}
