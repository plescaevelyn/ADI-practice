#! /bin/bash

number=0
for item in ./*.txt
do
	number=$(( ++number ))
done

echo "$number .txt files found in the present directory."
