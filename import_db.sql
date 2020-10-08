
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes; 
DROP TABLE IF EXISTS replies; 
DROP TABLE IF EXISTS question_follows; 
DROP TABLE IF EXISTS questions; 
DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author INTEGER NOT NULL,

    FOREIGN KEY (author) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    subject_question INTEGER NOT NULL,
    parent_reply INTEGER,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (subject_question) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id) 
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (question_id) REFERENCES questions(id) ,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO 
    users (fname, lname)
VALUES
    ('Jorge', 'Jungle'),
    ('Tomas', 'Train'),
    ('Guy', 'Fernandez');

INSERT INTO 
    questions (title, body, author)
VALUES
    ('Where are the Wild Things?', 'I am wondering where all the Wild Things are',1),
    ('Trains?', 'How fast can a super fast train go?', 2),
    ('Trains 2.0', 'I have 6 oranges and am going 55 mph, How many trians of force do I have?', 2),
    ('Dollars', 'Wait you guys are getting paid?',3);


INSERT INTO 
    question_follows (user_id, question_id)
VALUES
    (1, 2),
    (1, 3),
    (1,4),
    (2,1),
    (3,1),
    (3,3);

INSERT INTO 
    replies (body, subject_question, user_id)
VALUES
    ('I Think that the wild things are in the Jungle', 1, 2),
    ('Super Fast', 2, 1),
    ('Yes',4,2);

INSERT INTO 
    replies (body, subject_question,parent_reply, user_id)
VALUES
    ('Thanks!! That is super helpfull',1,1,1),
    ('That is not helpfull Tom!',2,2,2),
    ('I think he ment that one Jungle...',2,5,3);

INSERT INTO 
    question_likes (question_id, user_id)
VALUES 
    (1,2),
    (3,1),
    (4,1),
    (3,2),
    (4,2);

