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

keysToBeValidated="$(cat $2 | jq ".columnsToBeValidated | keys_unsorted" | tr ',' ' ' | tr ':' ' ')";
arrayOfKeys=${keysToBeValidated:2:-2};
isHeaderPresent="$(cat $2 | jq ".isHeaderPresent")"
declare -a columnIndexesOfColumnsToBeValidated
declare -a isRequiredValidationArray
declare -a lengthValidationArray
keyIndex=1
for key in $arrayOfKeys
do
    columnSchema="$(jq ".columnsToBeValidated.${key}" $2)";
    isRequiredTrue="$(echo $columnSchema | jq '.required')";
    requiredLength="$(echo $columnSchema | jq '.length')";
    minLength="$(echo $columnSchema | jq '.minLength')";
    maxLength="$(echo $columnSchema | jq '.maxLength')";
    columnsInCSV="$(sed -n '1p' $1)";
    if [[ $isHeaderPresent == "true" ]];
    then
        columnIndex="$(getColumnIndexByString $columnsInCSV $key)";
    else
        columnIndex=${key:1:-1}
    fi
    columnIndexesOfColumnsToBeValidated[keyIndex]=$columnIndex;
    isRequiredValidationArray[keyIndex]=$isRequiredTrue
    lengthValidationArray[keyIndex]=$requiredLength
    maxLengthValidationArray[keyIndex]=$maxLength
    minLengthValidationArray[keyIndex]=$minLength
    (( ++keyIndex ))
done
columnIndexs=${columnIndexesOfColumnsToBeValidated[@]}
_isRequiredValidationArray=${isRequiredValidationArray[@]}
_lengthValidationArray=${lengthValidationArray[@]}
_maxLengthValidationArray=${maxLengthValidationArray[@]}
_minLengthValidationArray=${minLengthValidationArray[@]}

awk -F , -v isHeaderPresent="$isHeaderPresent" -v columnIndexs="$columnIndexs" -v _isRequiredValidationArray="$_isRequiredValidationArray" -v _lengthValidationArray="$_lengthValidationArray" -v _maxLengthValidationArray="$_maxLengthValidationArray" -v _minLengthValidationArray="$_minLengthValidationArray" -f schemaValidator.awk $1
