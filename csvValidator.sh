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
declare -a columnIndexesOfColumnsToBeValidated
declare -a isRequiredValidationArray
declare -a lengthValidationArray
keyIndex=1
for key in $arrayOfKeys
do
    columnSchema="$(jq ".${key}" $2)";
    isRequiredTrue="$(echo $columnSchema | jq '.required')";
    requiredLength="$(echo $columnSchema | jq '.length')";
    columnsInCSV="$(sed -n '1p' $1)";
    columnIndex="$(getColumnIndexByString $columnsInCSV $key)";
    columnIndexesOfColumnsToBeValidated[keyIndex]=$columnIndex;
    isRequiredValidationArray[keyIndex]=$isRequiredTrue
    lengthValidationArray[keyIndex]=$requiredLength
    (( ++keyIndex ))
done
columnIndexs=${columnIndexesOfColumnsToBeValidated[@]}
_isRequiredValidationArray=${isRequiredValidationArray[@]}
_lengthValidationArray=${lengthValidationArray[@]}

awk -F , -v columnIndexs="$columnIndexs" -v _isRequiredValidationArray="$_isRequiredValidationArray" -v _lengthValidationArray="$_lengthValidationArray" -f schemaValidator.awk $1
