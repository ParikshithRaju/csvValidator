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
                    print "Required field error :" "("columnIndexsArr[i] "," NR ")"
                    
                    outputArr["required " i]=columnIndexsArr[i] " " NR
                    continue
                }
            }
            if(lengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) != lengthValidationArr[i]){
                    print "Length validation error: " "(" columnIndexsArr[i] "," NR ")"
                    outputArr["length " i]=columnIndexsArr[i] " " NR
                }
            }
            if(maxLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) > maxLengthValidationArr[i]){
                    print "Max length error " "(" columnIndexsArr[i] "," NR ")"
                    outputArr["maxLength " i]=columnIndexsArr[i] " " NR
                }
            }
            if(minLengthValidationArr[i] != "null") {
                if(length($columnIndexsArr[i]) < minLengthValidationArr[i]){
                    print "Min length error " "(" columnIndexsArr[i] "," NR ")"
                    outputArr["minLength " i]=columnIndexsArr[i] " " NR
                }
            }
        }
        for(var in outputArr) {
            print var " " outputArr[var]
        }
    }
}
