CREATE TABLE book (
   book_id INT AUTO_INCREMENT PRIMARY KEY,
   author_id INT,
   title VARCHAR(255),
   isbn INT,
   available BOOL,
   genre_id INT
);

CREATE TABLE author (
   author_id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   birthday DATE,
   deathday DATE
);

CREATE TABLE patron (
   patron_id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   loan_id INT
);

CREATE TABLE reference_books (
   reference_id INT AUTO_INCREMENT PRIMARY KEY,
   edition INT,
   book_id INT,
   FOREIGN KEY (book_id)
      REFERENCES book(book_id)
      ON UPDATE SET NULL
      ON DELETE SET NULL
);

INSERT INTO reference_books(edition, book_id)
VALUE (5,32);

CREATE TABLE genre (
   genre_id INT PRIMARY KEY,
   genres VARCHAR(100)
);

CREATE TABLE loan (
   loan_id INT AUTO_INCREMENT PRIMARY KEY,
   patron_id INT,
   date_out DATE,
   date_in DATE,
   book_id INT,
   FOREIGN KEY (book_id)
      REFERENCES book(book_id)
      ON UPDATE SET NULL
      ON DELETE SET NULL
);

#Warm up queries
SELECT title, isbn 
FROM book 
WHERE genre_id IN (SELECT genre_id from genre where genres = 'Mystery');

SELECT b.title, a.first_name, a.last_name 
FROM book b INNER JOIN author a ON b.author_id = a.author_id 
WHERE a.deathday IS NULL;

#Loan out a book
UPDATE book SET available=0 WHERE title='The Brutal Telling';

UPDATE book SET available=0 WHERE title='The Golden Compass';

UPDATE book SET available=0 WHERE title='Still Life'

UPDATE book SET available=0 WHERE title='Romeo and Juliet';
COMMIT;


INSERT INTO loan (patron_id, date_out, book_id) VALUES (6, CURDATE() , 26);

INSERT INTO loan (patron_id, date_out, book_id) VALUES (4, CURDATE() , 3);

INSERT INTO loan (patron_id, date_out, book_id) VALUES (8, CURDATE() , 22);

INSERT INTO loan (patron_id, date_out, book_id) VALUES (21, CURDATE() , 2);
COMMIT;


UPDATE patron SET loan_id = (SELECT MAX(loan_id) FROM loan) 
WHERE patron_id = 6; 

UPDATE patron SET loan_id = (SELECT MAX(loan_id) FROM loan) 
WHERE patron_id = 4;

UPDATE patron SET loan_id = (SELECT MAX(loan_id) FROM loan) 
WHERE patron_id = 8; 

UPDATE patron SET loan_id = (SELECT MAX(loan_id) FROM loan) 
WHERE patron_id = 21; 
COMMIT;

#Check a book back in
UPDATE book SET available = 1 
WHERE title='The Brutal Telling';

UPDATE loan SET date_in = CURDATE() 
WHERE loan_id = 1;

UPDATE patron SET patron.loan_id = null 
WHERE patron_id = 6 and (SELECT date_in FROM loan WHERE date_in is not null);

#Wrap up query
SELECT p.first_name, p.last_name, g.genres 
FROM loan l INNER JOIN patron p ON p.patron_id = l.patron_id 
INNER JOIN book b ON l.book_id = b.book_id 
INNER JOIN genre g ON b.genre_id = g.genre_id
WHERE l.date_in IS NULL;