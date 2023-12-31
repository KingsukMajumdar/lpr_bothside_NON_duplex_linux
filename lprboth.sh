#!/bin/bash
#using a small shell script we can use (in Linux e.g Arch/Ubuntu/Garuda ) a non duplexing printer
#e.g. HP LaserJet 1020 Plus for both sides printing without thinking odd/even pages ..
#Date: Sunday 31 December 2023 12:04:59 PM IST
#Version: v0
#Last update: Sunday 31 December 2023 2:04:59 PM IST
#MIT License
#Copyright (c) 2023 Kingsuk Majumdar
#
#
# your machine(Linux: Arch/Ubuntu/Garuda) must have cups, pdftk, ImageMagick, BashShell
#
#
# Instructions (working in bash shell ONLY):

# 1. Give lprboth.sh executable permissions, for example: chmod +x <filename> i.e. chmod +x lprboth.sh
# 2. Open the terminal (in a Bash shell).
# 3. Run this shell file, i.e., ./lprboth.sh.
# 4. Follow the instructions in the terminal.
# NB: DO NOT ROTATE, DO NOT FLIP
# Thank you to Mr. Kinshuk Sengupta, Dr Abhijit Banerjee and Ms. Sohini for  this linux journy.
# ref Book: UNIX : Concepts and Applications | 4th Edition  by Sumitabha Das (https://amzn.eu/d/hvPuQlR)
#
#
# Read the name of the pdf file which is going to be printed
# To get USER name
username=$(whoami)
#Destination path variables and other variables
TEMP_pdf="TEMP.pdf"
blank_pdf="blank.pdf"
output_pdf="Final.pdf"
PathOf_pdf="/home/$username/Desktop/lprbothdirtemp/"
echo "Write the PDF file name (along with path if NOT in the same directory) which you wish to print"
read Source_pdf
# destination path variables with PDF name
PathWith_pdf="$PathOf_pdf$TEMP_pdf"
#
#
#create a directory at Desktop as lpkmdirtemp and move this Source_pdf file
mkdir "$PathOf_pdf"
cp "$Source_pdf" "$PathWith_pdf"
cd "$PathOf_pdf"
#to create a blank.pdf
convert xc:none -page A4 "$blank_pdf"
#
#
#count the total pages of the print PDF say original_pdf
PageNumber=$(pdftk "$TEMP_pdf" dump_data | grep "NumberOfPages:"| cut -d' ' -f2)
#
#
# Check if the original PDF has an odd number of pages
if [ $(( $PageNumber % 2 )) -eq 1 ]; then
    echo "Adding a blank page at the end..."
    pdftk "$TEMP_pdf" "$blank_pdf" cat output "$output_pdf"
    ((PageNumber++))
else
    echo "The original PDF already has an even number of pages.\n"
    pdftk "$TEMP_pdf" cat output "$output_pdf"
fi
#
#
echo "Hence insert total "$((PageNumber/2))" pages in your printer"
#
#
# Create odd pages pdf
pdftk "$output_pdf" cat odd output OddPages.pdf
# Create Temp even pages pdf
pdftk "$output_pdf" cat  even  output TempEvenPages.pdf
pdftk TempEvenPages.pdf cat  end-1south  output EvenPages.pdf
#
#
#start actual printing in your NON duplex printer say HP LaserJet 1020 plus
echo "Press any key to start printing"
read
lpr EvenPages.pdf
echo "One side printing done.... reinsert pages (DO NOT ROTATE, DO NOT FLIP) and press any key to continue..."
read 
echo "wait and watch...."
lpr OddPages.pdf
echo "Thank you Shree Garuda Linux...!!!"
cd ..
rm -r ~/Desktop/lpkmdirtemp
# To detele the all temp variables
unset -v PageNumber
unset -v original_pdf
unset -v blank_pdf
unset -v output_pdf
unset -v PathOf_pdf
unset -v PathWith_pdf
unset -v TEMP_pdf
unset -v username
 
