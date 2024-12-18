-- TODO: Discount, Extract info about members

-- PEOPLE -----------------------------------------------------------

-- Table: Countries
create table Countries (
    CountryID INT Primary Key,
    CountryName Nvarchar(50)
);

-- assume: Cities have unique postal code
-- Table: Cities
CREATE TABLE Cities (
    CityID INT PRIMARY KEY,
    City NVARCHAR(100) NOT NULL,
    CountryID int NOT NULL foreign key references Countries(CountryID),
    PostalCode NVARCHAR(20) NOT NULL
);


-- assume phone number like has 9 digits
-- Table: Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL foreign key references Cities(CityID),
    BirthDate DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL unique CHECK (Email like '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL unique check (len(PhoneNumber) = 9 and ISNUMERIC(PhoneNumber)),
);






-- Table: EmployeeFunctions
CREATE TABLE EmployeeFunctions (
  	EmployeeFunctionID INT PRIMARY KEY,
  	EmployeeFunctionName NVARCHAR(100) not null
);


-- Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50),
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL FOREIGN KEY REFERENCES Cities(CityID),
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL unique check (len(PhoneNumber) = 9 and ISNUMERIC(PhoneNumber)),
    EmployeeFunctionID INT NOT NULL FOREIGN KEY REFERENCES EmployeeFunctions(EmployeeFunctionID)
);


-- Table: Translators
CREATE TABLE Translators (
    TranslatorID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL FOREIGN KEY REFERENCES Cities(CityID),
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL CHECK (HireDate > BirthDate),
    Email NVARCHAR(100) NOT NULL UNIQUE CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE CHECK (LEN(PhoneNumber) = 9 AND ISNUMERIC(PhoneNumber))
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID INT PRIMARY KEY,
    LanguageName NVARCHAR(50) NOT NULL
);
-- assume:Translator knows only one foreign language
-- Table: TranslatorLanguages
CREATE TABLE TranslatorLanguages (
    TranslatorID INT NOT NULL,
    LanguageID INT NOT NULL,
    PRIMARY KEY (TranslatorID, LanguageID),
    FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID),
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID)
);



-- WEBINARS -----------------------------------------------------------


-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID INT PRIMARY KEY,
    LecturerID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID) ON DELETE SET NULL, -- Lecturer is mandatory; if deleted, set to NULL
    TranslatorID INT FOREIGN KEY REFERENCES Translators(TranslatorID) ON DELETE SET NULL, -- Translator is optional; if deleted, set to NULL
    WebinarTitle NVARCHAR(255) NOT NULL,
    WebinarDescription NVARCHAR(MAX), -- Optional; description is not mandatory
    WebinarDate DATE NOT NULL,
    WebinarPrice MONEY CHECK (WebinarPrice >= 0) NOT NULL, -- Price cannot be negative
    RecordingLink NVARCHAR(300), -- Optional; recording link may or may not be provided
    LanguageID INT NOT NULL FOREIGN KEY REFERENCES Languages(LanguageID) ON DELETE CASCADE -- Language is mandatory; if language deleted, remove related webinars
);

-- Table: WebinarAccess
CREATE TABLE WebinarAccess (
    StudentID INT NOT NULL,
    WebinarID INT NOT NULL,
    AvailableUntil DATE NOT NULL, -- Ensure the access expiration date is provided
    PRIMARY KEY (StudentID, WebinarID), -- Composite key
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE, -- If student is deleted, access is also removed
    FOREIGN KEY (WebinarID) REFERENCES Webinars(WebinarID) ON DELETE CASCADE -- If webinar is deleted, access is also removed
);


-- COURSES -----------------------------------------------------------


-- Table: Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseTitle NVARCHAR(255) NOT NULL,
    CourseDescription NVARCHAR(MAX),
    CoursePrice MONEY CHECK (CoursePrice >= 0) NOT NULL,
    CourseSupervisorID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID) ON DELETE SET NULL -- If supervisor is deleted, set to NULL,
);

-- Table: CourseParticipants
CREATE TABLE CourseParticipants (
    CourseID INT NOT NULL,
    StudentID INT NOT NULL,
    PRIMARY KEY (StudentID, CourseID), -- Ensures a student cannot be enrolled multiple times in the same course
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE, -- If a student is deleted, remove their course enrollments
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE -- If a course is deleted, remove all enrollments
);


-- Table: CourseModules
CREATE TABLE CourseModules (
    ModuleID INT PRIMARY KEY,
    CourseID INT NOT NULL,
    LecturerID INT NOT NULL,
    ModuleTitle NVARCHAR(255) NOT NULL,
    ModuleDate DATE NOT NULL,
    LanguageID INT NOT NULL,
    TranslatorID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE, -- If course is deleted, remove associated modules
    FOREIGN KEY (LecturerID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL, -- If lecturer is deleted, set to NULL
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID) ON DELETE CASCADE, -- If language is deleted, remove associated modules
    FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID) ON DELETE SET NULL -- If translator is deleted, set to NULL
);


-- Table: OnlineAsynchronousModules
CREATE TABLE OnlineAsynchronousModules (
    ModuleID INT PRIMARY KEY,
    VideoLink NVARCHAR(MAX) NOT NULL, -- Video link is mandatory for asynchronous modules
    FOREIGN KEY (ModuleID) REFERENCES CourseModules(ModuleID) ON DELETE CASCADE -- If module is deleted, remove associated asynchronous content
);
-- Table: OnlineSynchronousModules
CREATE TABLE OnlineSynchronousModules (
    ModuleID INT PRIMARY KEY,
    MeetingLink NVARCHAR(MAX) NOT NULL, -- Meeting link is mandatory
    RecordingLink NVARCHAR(MAX), -- Recording link is optional
    FOREIGN KEY (ModuleID) REFERENCES CourseModules(ModuleID) ON DELETE CASCADE -- If module is deleted, remove associated synchronous content
);

-- Table: StationaryModules
CREATE TABLE StationaryModules (
    ModuleID INT PRIMARY KEY,
    Room NVARCHAR(20) NOT NULL, -- Room is mandatory
    RoomCapacity INT NOT NULL CHECK (RoomCapacity > 0), -- Room capacity must be positive
    FOREIGN KEY (ModuleID) REFERENCES CourseModules(ModuleID) ON DELETE CASCADE -- If module is deleted, remove associated stationary content
);

-- Table: CourseModulePresence
CREATE TABLE CourseModulePresence (
    ModuleID INT NOT NULL,
    StudentID INT NOT NULL,
    Presence INT CHECK (Presence IN (0, 1)), -- Presence should be either 0 (absent) or 1 (present)
    PRIMARY KEY (ModuleID, StudentID), -- Composite key
    FOREIGN KEY (ModuleID) REFERENCES CourseModules(ModuleID) ON DELETE CASCADE, -- If module is deleted, remove presence records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove their presence records
);


-- STUDIES -----------------------------------------------------------


-- Table: Studies
CREATE TABLE Studies (
    StudyID INT PRIMARY KEY,
    StudyTitle NVARCHAR(255) NOT NULL,
    StudyDescription NVARCHAR(MAX),
    StudySupervisorID INT NOT NULL,
    AdvancePaymentPrice MONEY CHECK (AdvancePaymentPrice >= 0) NOT NULL,
    FOREIGN KEY (StudySupervisorID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL -- If supervisor is deleted, set to NULL
);

-- Table: Subjects
CREATE TABLE Subjects (
    StudyID INT NOT NULL, -- Study association is mandatory
    SubjectID INT PRIMARY KEY,
    SubjectSupervisorID INT NOT NULL, -- Subject supervisor is mandatory
    SubjectTitle NVARCHAR(255) NOT NULL, -- Subject title is mandatory
    SubjectDescription NVARCHAR(MAX), -- Optional description
    SubjectSemester INT NOT NULL, -- Semester is mandatory
    FOREIGN KEY (StudyID) REFERENCES Studies(StudyID) ON DELETE CASCADE, -- If study is deleted, remove related subjects
    FOREIGN KEY (SubjectSupervisorID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL -- If supervisor is deleted, set to NULL
);


-- Table: StudySubjects
CREATE TABLE SubjectParticipants (
    SubjectID INT NOT NULL,
    StudentID INT NOT NULL,
    SubjectGrade FLOAT, -- Subject grade, optional at the time of creation
    PRIMARY KEY (SubjectID, StudentID), -- Composite key ensures a student can't participate in a subject more than once
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID) ON DELETE CASCADE, -- If subject is deleted, remove participation records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove participation records
);

--???
-- Table: SubjectGrades
-- assume maximum grade is 100
CREATE TABLE SubjectGrades (
    SubjectID INT NOT NULL,
    StudentID INT NOT NULL,
    SubjectGrade INT CHECK (SubjectGrade >= 0 AND SubjectGrade <= 100), -- Enforcing valid grade range
    PRIMARY KEY (SubjectID, StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID) ON DELETE CASCADE, -- If subject is deleted, remove grade records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove grade records
);

-- Table: StudiesGrades
CREATE TABLE StudiesGrades (
    StudyID INT NOT NULL,
    StudentID INT NOT NULL,
    StudyGrade INT CHECK (StudyGrade >= 0 AND StudyGrade <= 100),
    PRIMARY KEY (StudyID, StudentID),
    FOREIGN KEY (StudyID) REFERENCES Studies(StudyID) ON DELETE CASCADE, -- If study is deleted, remove grade records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove grade records
);

CREATE TABLE Internship (
    InternshipID INT PRIMARY KEY,
    StudyID INT NOT NULL,
    StartDate DATE NOT NULL CHECK (StartDate >= GETDATE()), -- Ensures internship can't start in the past
    FOREIGN KEY (StudyID) REFERENCES Studies(StudyID) ON DELETE CASCADE -- If study is deleted, remove related internship
);


-- Table: InternshipPresence
CREATE TABLE InternshipPresence (
    InternshipID INT NOT NULL,
    StudentID INT NOT NULL,
    Presence INT CHECK (Presence IN (0, 1)), -- Presence should be 0 (absent) or 1 (present)
    PRIMARY KEY (InternshipID, StudentID),
    FOREIGN KEY (InternshipID) REFERENCES Internship(InternshipID) ON DELETE CASCADE, -- If internship is deleted, remove presence records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove presence records
);

-- Table: StudyMeetings
CREATE TABLE StudyMeetings (
    StudyMeetingID INT PRIMARY KEY,
    SubjectID INT NOT NULL,
    LecturerID INT NOT NULL,
    MeetingTitle NVARCHAR(255) NOT NULL,
    MeetingPrice MONEY CHECK (MeetingPrice >= 0) NOT NULL,
    MeetingDate DATE NOT NULL,
    LanguageID INT NOT NULL,
    TranslatorID INT,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID) ON DELETE CASCADE, -- If subject is deleted, remove related meetings
    FOREIGN KEY (LecturerID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL, -- If lecturer is deleted, set to NULL
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID) ON DELETE CASCADE, -- If language is deleted, remove related meetings
    FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID) ON DELETE SET NULL -- If translator is deleted, set to NULL
);


-- Table: StudyMeetingPresence
CREATE TABLE StudyMeetingPresence (
    StudyMeetingID INT NOT NULL,
    StudentID INT NOT NULL,
    Presence INT CHECK (Presence IN (0, 1)), -- Presence should be 0 (absent) or 1 (present)
    PRIMARY KEY (StudyMeetingID, StudentID), -- Composite key to track unique student-meeting combinations
    FOREIGN KEY (StudyMeetingID) REFERENCES StudyMeetings(StudyMeetingID) ON DELETE CASCADE, -- If study meeting is deleted, remove presence records
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE -- If student is deleted, remove presence records
);


-- Table: OnlineAsynchronousMeetings
CREATE TABLE OnlineAsynchronousMeetings (
    StudyMeetingID INT PRIMARY KEY,
    VideoLink NVARCHAR(MAX) NOT NULL, -- Video link is mandatory for asynchronous meetings
    FOREIGN KEY (StudyMeetingID) REFERENCES StudyMeetings(StudyMeetingID) ON DELETE CASCADE -- If meeting is deleted, remove related online content
);


-- Table: OnlineSynchronousMeetings
CREATE TABLE OnlineSynchronousMeetings (
	StudyMeetingID INT PRIMARY KEY FOREIGN KEY REFERENCES StudyMeetings(StudyMeetingID),
  	MeetingLink NVARCHAR(MAX),
  	RecordingLink NVARCHAR(MAX)
);

-- Table: StationaryMeetings
CREATE TABLE StationaryMeetings (
	StudyMeetingID INT PRIMARY KEY FOREIGN KEY REFERENCES StudyMeetings(StudyMeetingID),
  	Room NVARCHAR(20),
  	RoomCapacity INT
);


-- ORDERS -----------------------------------------------------------


-- Table: Orders
CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
  	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
  	AlreadyPaidValue MONEY CHECK (AlreadyPaidValue >= 0),
  	OrderDate DATE
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
	ProductID INT PRIMARY KEY,
  	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
  	PaidDate DATE
);

-- Table: OrderedWebinars
CREATE TABLE OrderedWebinars (
	ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES OrderDetails(ProductID),
  	WebinarID INT FOREIGN KEY REFERENCES Webinars(WebinarID)
);

-- Table: OrderedCourses
CREATE TABLE OrderedCourses (
	ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES OrderDetails(ProductID),
  	CourseID INT FOREIGN KEY REFERENCES Courses(CourseID)
);

-- Table: OrderedStudies
CREATE TABLE OrderedStudies (
	ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES OrderDetails(ProductID),
  	StudyID INT FOREIGN KEY REFERENCES Studies(StudyID)
);

-- Table: OrderedStudyMeetings
CREATE TABLE OrderedStudyMeetings (
	ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES OrderDetails(ProductID),
  	StudyMeetingID INT FOREIGN KEY REFERENCES StudyMeetings(StudyMeetingID)
);
