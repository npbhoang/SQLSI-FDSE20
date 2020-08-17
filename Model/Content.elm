module Model.Content exposing (nakedPolicy, jsonPolicy, sqlSchema, jsonSchema)

nakedPolicy : String
nakedPolicy = """Any lecturer can know its students.
Any lecturer can know his/her own email, as well as the emails of his/her students.
Any lecturer can know its colleagues’ emails, where two lecturers are colleagues if there is at least one student enrolled with both of them. 
Any lecturer can know its colleagues.
"""

jsonPolicy : String
jsonPolicy = """[
	{
		"roles": [
			"Lecturer"
		],
		"actions": [
			"read"
		],
		"resources": [
			{
				"association": "Enrollment"
			}
		],
		"auth": [
			{
				"ocl": "klecturers = kcaller",
				"sql": "klecturers = kcaller"
			},
			{
				"ocl": "kcaller.students->exists(s|s=kstudents)",
				"sql": "EXISTS (SELECT 1 FROM Enrollment WHERE lecturers = kcaller AND kstudents = students)"
			}
		]
	},
	{
		"roles": [
			"Lecturer"
		],
		"actions": [
			"read"
		],
		"resources": [
			{
				"entity": "Student",
				"attribute": "email"
			}
		],
		"auth": [
			{
				"ocl": "kcaller.students->exists(s|s = kself)",
				"sql": "EXISTS (SELECT 1 FROM Enrollment WHERE lecturers = kcaller AND kself = students)"
			}
		]
	},
	{
		"roles": [
			"Lecturer"
		],
		"actions": [
			"read"
		],
		"resources": [
			{
				"entity": "Lecturer",
				"attribute": "email"
			}
		],
		"auth": [
			{
				"ocl": "kcaller = kself",
				"sql": "kcaller = kself"
			},
			{
				"ocl": "kcaller.students->exists(s|s.lecturers->exists(l|l=kself))",
				"sql": "EXISTS (SELECT 1 FROM Enrollment e1 JOIN Enrollment e2 ON e1.students = e2.students WHERE e1.lecturers = kcaller AND e2.lecturers = kself)"
			}
		]
	}
] 
"""

sqlSchema : String
sqlSchema = """ DROP TABLE IF EXISTS Student;
    CREATE TABLE Student(
        student_id VARCHAR(500) PRIMARY KEY,
        name VARCHAR(500) UNIQUE,
        email VARCHAR(500) UNIQUE
    );

    DROP TABLE IF EXISTS Lecturer;
    CREATE TABLE Lecturer(
        lecturer_id VARCHAR(500) PRIMARY KEY,
        name VARCHAR(500) UNIQUE,
        email VARCHAR(500) UNIQUE
    );

    DROP TABLE IF EXISTS Enrollment;
    CREATE TABLE Enrollment(
        students varchar(250),
        lecturers varchar(250),
        CONSTRAINT lecturer_fk
        FOREIGN KEY (lecturers) REFERENCES Lecturer (lecturer_id),
        CONSTRAINT sstudent_fk
        FOREIGN KEY (students) REFERENCES Student (student_id)
    );"""

jsonSchema : String
jsonSchema = """[
    {
        "class": "Lecturer",
        "attributes": [
            {
                "name": "email",
                "type": "String"
            }
        ],
        "ends": [
            {
                "association": "Enrollment",
                "name": "students",
                "target": "Student",
                "opp": "lecturers",
                "mult": "*"
            }
        ]
    },
    {
        "class": "Student",
        "attributes": [
            {
                "name": "email",
                "type": "String"
            }
        ],
        "ends": [
            {
                "association": "Enrollment",
                "name": "lecturers",
                "target": "Lecturer",
                "opp": "students",
                "mult": "*"
            }
        ]
    }
]"""