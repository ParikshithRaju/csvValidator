#!/bin/bash

getColumnIndexByString () {
    cnt=1;
    arrayOfColumnNames="$(echo ${1:0:-1}| tr ',' ' ')"
    searchEle=${2:1:-1};
    for el in $arrayOfColumnNames
    do
        if [[ $el == $searchEle ]];
        then
            echo $cnt;
            break;
        else
            ((++cnt))
        fi
    done
}

keysToBeValidated="$(cat $2 | jq "keys_unsorted" | tr ',' ' ' | tr ':' ' ')";
arrayOfKeys=${keysToBeValidated:2:-2};
for key in $arrayOfKeys
do
    columnSchema="$(jq ".${key}" $2)";
    isRequiredTrue="$(echo $columnSchema | jq '.required')";
    requiredLength="$(echo $columnSchema | jq '.length')";
    echo "Validating column $key"
    columnsInCSV="$(sed -n '1p' $1)";
    columnIndex="$(getColumnIndexByString $columnsInCSV $key)";
    if [[ $isRequiredTrue == "true" ]];
    then
        awk -F ',' -v Index=$columnIndex '($Index == "" || $Index == "\n" || $Index == "\r") {print "Required field error in row " NR}' $1
    fi
    if [[ $requiredLength != "null" ]];
    then
        awk -F ',' -v Index=$columnIndex -v requiredLength=$requiredLength '(NR > 1 && length($Index) != requiredLength) {print "Length error in row " NR}' $1
    fi
done
