# **Help Page**
-- Made with ❤ by **Alex He**
## Overview
This software runs on MySQL server and provides simple functionality and graphic user interface to demonstrate a possible library management system. It's still under preview, so any sort of bug is possible. With this piece of modernly designed software, you can:

- Search for books given any combination of info.
- Add borrow records and return books.
- Register new library cards.

In this help page, we will go through all the pages and provide simple tutorial as for how to test and use this software.
## Home Page
This is the first page that will appear when you open up the software. The greeting on the screen **will** change according to your system time settings.
## Find Page
This is the page where you can search for all the books in the library records. On the top bar it displays how many relevant records there are. On the middle part there are all the records found. The "Clear All Boxes" button on the bottom will clear all the input boxes, which are used for inputting conditions for the records. Note that there are **no** submit buttons and the records will update automatically as you input conditions. After finding your desired book, please remember its **index** number in order to borrow it out later.
## Borrow Page
This is the page where you enter the book index and the card ID to borrow out a particular book. If one of the required inputs are missing, a `ERROR` will show up. The borrowing algorithm includes checking the stock number of the book and the validity of the card ID. If both are correct and the database is available at the moment, it will insert a record and return a borrow ID, which will show up on the `SUCCESS` indicator. You don't have to remember the borrow ID as it serves no part in the returning process. It's worth mentioning that a card ID and a book ID can be related to multiple borrow records, and for each time it will be given a unique borrow ID, and they will all be displayed in the "Return" page.
## Return Page
This is the page where you find borrow records. Just like the "Find" page, you are able to use four conditions to filter the records. Note that there are some basic logic behind the constraints of these filters. First is that they all have to be integers, or no result will show at all. Second is that "Borrow Date" has to be 8 digits in length, or no result will show either. The "Clear All Boxes" button also serves the same role as the "Find" page. There is an indicator of how many records found at the top of the screen. The main central part is where the records are, you can scroll horizontally. On the "Return Info" column, there are indicators on whether a row of borrow record has been returned yet. If yes, there will be a "Returned" label. If no, there will a button that you can click to return the book. After clicking on the button, it should be changed to "Returned" as well.
## Add Page
This is the page where you enter the info of a book and add that book to the library records, which can then be immediately seen through the find page. Note that there are a few requirements of the info. First is that none of the input boxes should be empty. Second is that "Publisher Year" should be an integer, "Price" should be a decimal, "Total Count" and "Stock" are integers as well, with "Total Count" not less than "Stock". When any of the above conditions are not met, a `ERROR` will appear indicating the adding process has failed. When a record is successfully inserted, a `SUCCESS` will appear along with the new ID for this record. Note that a duplicated input will not actually result in a new record in the database, so the ID will be the same.
## Register
This is the page for registering new library cards with given "Name", "Department" and "Type", with the last one being either "Teacher" or "Student". The requirement includes any text box shouldn't be empty, and the type should be valid. After clicking "Submit", the program will check the constraints, and insert into the database. Note that if the insertion is duplicated, the action won't fail, instead it will return the ID for the given sequence so that for every "Name", "Department" and "Type", the card ID would be unique. You can also utilize this functionality to check your card ID before borrowing out a book.
## Credits
This project is built solely by **Alex He** from scratch using MySQL, Flutter and Markdown. For questions and bug report, feel free to contact me at alexhe12345678@gmail.com.