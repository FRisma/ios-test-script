#!/bin/sh

runXcodeTests() {
	for singleProjectPath in "${projects[@]}"; do

		#Parse project name and project directoy
		dir=$(dirname "$singleProjectPath")
		project=$(basename "$singleProjectPath")
		
		#Move into the project dir and run the tests
		cd "$dir"
		resolveDependenciesForProject "$dir"
		runTestsForProject "$project"
		cd -

	done
}

getXcodeProjectsFromPath() {
	echo "iOS projects path: $1"
	projects=( $(find "$1" -name "*.xcodeproj" -type d) )
}

resolveDependenciesForProject() {
	echo "Running pod install"
	#pod _0.39_ install
}

runTestsForProject() {
	#First we get the schemes for the project
	scheme=( $(xcodebuild -list | awk 'f{print;f=0} /Schemes:/{f=1}') )
	if [ -z "$scheme" ]
	then
		echo "El proyecto "$1" NO tiene scheme" > /dev/fd/2
		return
	fi
	echo "Esquema del proyecto: $1 --> $scheme"

	#We run the tests
	#sudo xcodebuild -workspace $1.xcworkspace -scheme $scheme build 2>&1 | tee results.txt
}

projects=

#Fill projects variable
getXcodeProjectsFromPath .

#XcodeTest
runXcodeTests

