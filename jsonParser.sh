#!/bin/bash

space_removed_json=$(cat $2 | tr -d '\r\n\t')
trimmed_json=$(cat $2 | tr -d '\r\n\t')

getColumnIndexByString () {
    cnt=1
    if [[ $3 == "," ]]
    then
        arrayOfColumnNames="$(echo $1 | tr "$3" ",")"
    else
        arrayOfColumnNames="$(echo $1)"
    fi
    searchEle=$2;
    IFS=','
    for el in arrayOfColumnNames
    do
        if [[ $el == $searchEle ]];
        then
            echo $cnt
            break;
        else
            ((++cnt))
        fi
    done
}

getValueOfPropertyLevelOne () {
    param="$(echo $1 | tr -d '"')"
    output="$(echo $2 | grep -oP "\"$param\" *: *((\".*?\")|(.*?))," | cut -d ':' -f 2 | tr -d '"')"
    if [[ $output == "" ]]
    then
        echo "null"
    else
        echo ${output}
    fi
}

getValueOfPropertyWithQoutes () {
    param="$(echo $1 | tr -d '"')"
    output="$(echo $2 | grep -oP "\"$param\" *: *(\".*?\")," | cut -d ':' -f 2 | tr -d '"')"
    if [[ $output == "" ]]
    then
        echo "null"
    else
        echo ${output}
    fi
}

getColumnKeysToBeValidated () {
    keysOutput="$(echo $trimmed_json | grep -oP "\"columnsToBeValidated\" *: *{.*?}[^,]" | grep -oP "\"[a-zA-Z 0-9_\-\/]*\" *: *{" | tr -d ':{"' | tr ' ' '\ ' tr '\n' '#')"
    echo ${keysOutput//"columnsToBeValidated"/}
}


keysToBeValidated="$(cat $2 | jq ".columnsToBeValidated | keys_unsorted" | tr ',' ' ' | tr ':' ' ')";
arrayOfKeys=${keysToBeValidated:2:-2};
isHeaderPresent="$(getValueOfPropetyWithQoutes "isHeaderPresent" $space_removed_json)";

delimiterInJson="$(getValueOfPropertyWithQoutes "delimiter" $space_removed_json)"

if [[ $delimiterInJson == "null" ]];
then
    delimiter=","
else
    delimiter=$delimiterInJson
fi
declare -a columnIndexesOfColumnsToBeValidated
declare -a isRequiredValidationArray
declare -a lengthValidationArray
declare -a typeValidationArray
declare -a minLengthValidationArray
declare -a maxLengthValidationArray

keyIndex=1
IFS="#"
for key in $arrayOfKeys
do
    if [[ $key == "" ]]
    then
        continue;
    fi
    key=${key::-1}
    columnSchema="$(jq ".columnsToBeValidated.${key}" $2)";
    isRequiredTrue="$(echo $columnSchema | jq '.required')";
    requiredLength="$(echo $columnSchema | jq '.length')";
    minLength="$(echo $columnSchema | jq '.minLength')";
    maxLength="$(echo $columnSchema | jq '.maxLength')";
    typeVal="$(echo $columnSchema | jq '.type')";
    requiredLength="$(getValueOfPropertyWithQoutes "")"
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
    typeValidationArray[keyIndex]=${typeVal:1:-1}
    (( ++keyIndex ))
done
