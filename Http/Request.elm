module Http.Request exposing (..)

getAllDataCommandURL : String
getAllDataCommandURL = "http://localhost:8080/sqlsirest/rest/default"

getResetCommandURL : String
getResetCommandURL = "http://localhost:8080/sqlsirest/rest/default/reset"

executeQueryCommandURL : String
executeQueryCommandURL = "http://localhost:8080/sqlsirest/rest/default/execute"

createNewStudentURL : String
createNewStudentURL = "http://localhost:8080/sqlsirest/rest/default/insert/student"

createNewLecturerURL : String
createNewLecturerURL = "http://localhost:8080/sqlsirest/rest/default/insert/lecturer"

createNewEnrollmentURL : String
createNewEnrollmentURL = "http://localhost:8080/sqlsirest/rest/default/insert/enrollment"

deleteStudentURL : String
deleteStudentURL = "http://localhost:8080/sqlsirest/rest/default/delete/student"

deleteLecturerURL : String
deleteLecturerURL = "http://localhost:8080/sqlsirest/rest/default/delete/lecturer"

deleteEnrollmentURL : String
deleteEnrollmentURL = "http://localhost:8080/sqlsirest/rest/default/delete/enrollment"

