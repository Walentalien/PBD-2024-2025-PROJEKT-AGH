use u_oliinyk

-- Table: Students
CREATE TABLE Students (
    UserID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    SecondName NVARCHAR(50),
    LastName NVARCHAR(50),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Country NVARCHAR(100),
    PostalCode NVARCHAR(20),
    BirthDate DATE,
    Email NVARCHAR(100),
    TelephoneNumber NVARCHAR(20)
);

-- Table: Employees
CREATE TABLE Employees (
    UserID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    SecondName NVARCHAR(50),
    LastName NVARCHAR(50),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Country NVARCHAR(100),
    PostalCode NVARCHAR(20),
    BirthDate DATE,
    Email NVARCHAR(100),
    TelephoneNumber NVARCHAR(20),
    Func NVARCHAR(100)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID INT PRIMARY KEY,
    LecturerID INT FOREIGN KEY REFERENCES Students(UserID),
    WebinarDate DATE,
    WebinarTitle NVARCHAR(255),
    WebinarDescription NVARCHAR(MAX),
    WebinarPrice DECIMAL(10, 2),
    Recording NVARCHAR(MAX),
    TranslatorID INT FOREIGN KEY REFERENCES Students(UserID)
);

-- Table: WebinarParticipants
CREATE TABLE WebinarParticipants (
    ParticipantID INT,
    WebinarID INT,
    PRIMARY KEY (ParticipantID, WebinarID),
    FOREIGN KEY (ParticipantID) REFERENCES Students(UserID),
    FOREIGN KEY (WebinarID) REFERENCES Webinars(WebinarID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    LecturerID INT FOREIGN KEY REFERENCES Students(UserID),
    CourseTitle NVARCHAR(255),
    CourseDescription NVARCHAR(MAX),
    CoursePrice DECIMAL(10, 2),
    Recording NVARCHAR(MAX),
    TranslatorID INT FOREIGN KEY REFERENCES Students(UserID)
);

-- Table: CourseParticipants
CREATE TABLE CourseParticipants (
    ParticipantID INT,
    CourseID INT,
    PRIMARY KEY (ParticipantID, CourseID),
    FOREIGN KEY (ParticipantID) REFERENCES Students(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
