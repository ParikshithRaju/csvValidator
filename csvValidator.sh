#!/bin/bash

source jsonParser.sh $1 $2

columnIndexs=${columnIndexesOfColumnsToBeValidated[@]}
_isRequiredValidationArray=${isRequiredValidationArray[@]}
_lengthValidationArray=${lengthValidationArray[@]}
_maxLengthValidationArray=${maxLengthValidationArray[@]}
_minLengthValidationArray=${minLengthValidationArray[@]}
_typeValidationArray=${typeValidationArray[@]}

gawk -F $delimiter -v isHeaderPresent="$isHeaderPresent" -v columnIndexs="$columnIndexs" -v _isRequiredValidationArray="$_isRequiredValidationArray" -v _lengthValidationArray="$_lengthValidationArray" -v _maxLengthValidationArray="$_maxLengthValidationArray" -v _minLengthValidationArray="$_minLengthValidationArray" -v _typeValidationArray="$_typeValidationArray" -f schemaValidator.awk $1
