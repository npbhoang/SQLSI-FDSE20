module Model.MyObjectModel exposing (..)

import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import List exposing (member, map)
import String exposing (isEmpty)

type alias Student =
    { id : String
    , name : String
    , email : String
    }


type alias Lecturer =
    { id : String
    , name : String
    , email : String
    }


type alias Enrollment =
    { students : String
    , lecturers : String
    }


type alias MyObjectModel =
    { students : List Student
    , lecturers : List Lecturer
    , enrollments : List Enrollment
    }

studentDecoder : Decoder Student
studentDecoder =
    Decode.succeed Student
        |> Json.Decode.Pipeline.required "id" string
        |> Json.Decode.Pipeline.required "name" string
        |> Json.Decode.Pipeline.required "email" string

studentsDecoder : Decoder StudentList
studentsDecoder =
    Decode.succeed StudentList
        |> Json.Decode.Pipeline.required "students" studentListDecoder

studentListDecoder : Decoder (List Student)
studentListDecoder =
    Decode.list studentDecoder


lecturerDecoder : Decoder Lecturer
lecturerDecoder =
    Decode.succeed Lecturer
        |> Json.Decode.Pipeline.required "id" string
        |> Json.Decode.Pipeline.required "name" string
        |> Json.Decode.Pipeline.required "email" string

lecturersDecoder : Decoder LecturerList
lecturersDecoder =
    Decode.succeed LecturerList
        |> Json.Decode.Pipeline.required "lecturers" lecturerListDecoder

lecturerListDecoder : Decoder (List Lecturer)
lecturerListDecoder =
    Decode.list lecturerDecoder


enrollmentDecoder : Decoder Enrollment
enrollmentDecoder =
    Decode.succeed Enrollment
        |> Json.Decode.Pipeline.required "students" string
        |> Json.Decode.Pipeline.required "lecturers" string

enrollmentsDecoder : Decoder EnrollmentList
enrollmentsDecoder =
    Decode.succeed EnrollmentList
        |> Json.Decode.Pipeline.required "enrollments" enrollmentListDecoder

enrollmentListDecoder : Decoder (List Enrollment)
enrollmentListDecoder =
    Decode.list enrollmentDecoder


myObjectModelDecoder : Decoder MyObjectModel
myObjectModelDecoder =
    Decode.succeed MyObjectModel
        |> Json.Decode.Pipeline.required "students" studentListDecoder
        |> Json.Decode.Pipeline.required "lecturers" lecturerListDecoder
        |> Json.Decode.Pipeline.required "enrollments" enrollmentListDecoder

type alias StudentList = 
    {students : List Student}

type alias LecturerList = 
    {lecturers : List Lecturer}

type alias EnrollmentList = 
    {enrollments : List Enrollment}

addNewStudent : Student -> MyObjectModel -> MyObjectModel
addNewStudent newStudent om =
    { students = om.students ++ [newStudent]
    , lecturers = om.lecturers
    , enrollments = om.enrollments
    }

addNewLecturer : Lecturer -> MyObjectModel -> MyObjectModel
addNewLecturer newLecturer om =
    { students = om.students
    , lecturers = om.lecturers ++ [newLecturer]
    , enrollments = om.enrollments
    }

addNewEnrollment : Enrollment -> MyObjectModel -> MyObjectModel
addNewEnrollment newEnrollment om =
    { students = om.students
    , lecturers = om.lecturers 
    , enrollments = om.enrollments ++ [newEnrollment]
    }

buildNewStudent : StudentList -> MyObjectModel -> MyObjectModel
buildNewStudent newStudents om =
    { students = newStudents.students
    , lecturers = om.lecturers
    , enrollments = om.enrollments
    }
buildNewLecturer : LecturerList -> MyObjectModel -> MyObjectModel
buildNewLecturer newLecturers om =
    { students = om.students
    , lecturers = newLecturers.lecturers
    , enrollments = om.enrollments
    }
buildNewEnrollment : EnrollmentList -> MyObjectModel -> MyObjectModel
buildNewEnrollment newEnrollments om =
    { students = om.students
    , lecturers = om.lecturers
    , enrollments = newEnrollments.enrollments
    }

studentEncoder : String -> String -> String -> Encode.Value
studentEncoder id name email =
    Encode.object [ ( "id", Encode.string id ), ( "name", Encode.string name ), ( "email", Encode.string email ) ]

lecturerEncoder : String -> String -> String -> Encode.Value
lecturerEncoder id name email =
    Encode.object [ ( "id", Encode.string id ), ( "name", Encode.string name ), ( "email", Encode.string email ) ]

enrollmentEncoder : String -> String -> Encode.Value
enrollmentEncoder students lecturers =
    Encode.object [ ( "students", Encode.string students ), ( "lecturers", Encode.string lecturers ) ]

getStudentId : Student -> String
getStudentId student = student.id 

checkStudentIdUnique : String -> List Student -> Bool
checkStudentIdUnique id list =
    let ids = List.map getStudentId list
    in not (isEmpty id) && not (member id ids)

getStudentName : Student -> String
getStudentName student = student.name

checkStudentNameUnique  : String -> List Student -> Bool
checkStudentNameUnique  name list =
    let names = List.map getStudentName list
    in not (member name names)

getStudentEmail : Student -> String
getStudentEmail student = student.email

checkStudentEmailUnique  : String -> List Student -> Bool
checkStudentEmailUnique  email list =
    let emails = List.map getStudentEmail list
    in not (member email emails)

getLecturerId : Lecturer -> String
getLecturerId lecturer = lecturer.id 

checkLecturerIdUnique  : String -> List Lecturer -> Bool
checkLecturerIdUnique  id list =
    let ids = List.map getLecturerId list
    in not (isEmpty id) && not (member id ids)

getLecturerName : Lecturer -> String
getLecturerName lecturer = lecturer.name

checkLecturerNameUnique : String -> List Lecturer -> Bool
checkLecturerNameUnique name list =
    let names = List.map getLecturerName list
    in not (member name names)

getLecturerEmail : Lecturer -> String
getLecturerEmail lecturer = lecturer.email

checkLecturerEmailUnique  : String -> List Lecturer -> Bool
checkLecturerEmailUnique  email list =
    let emails = List.map getLecturerEmail list
    in not (member email emails)

getEnrollmentStudents : Enrollment -> String
getEnrollmentStudents enrollment = enrollment.students

getEnrollmentLecturers : Enrollment -> String
getEnrollmentLecturers enrollment = enrollment.lecturers

checkEnrollmentUnique  : String -> String -> List Enrollment -> Bool
checkEnrollmentUnique  students lecturers list =
    let studentList = List.map getEnrollmentStudents list
        lecturerList = List.map getEnrollmentLecturers list
    in not (member students studentList) && not (member lecturers lecturerList)

checkStudentUnique : String -> String -> String -> List Student -> Bool
checkStudentUnique id name email list =
    checkStudentIdUnique id list && checkStudentNameUnique name list && checkStudentEmailUnique email list

checkLecturerUnique : String -> String -> String -> List Lecturer -> Bool
checkLecturerUnique id name email list =
    checkLecturerIdUnique id list && checkLecturerNameUnique name list && checkLecturerEmailUnique email list