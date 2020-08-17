module Model.MyObjectModel exposing (..)

import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode

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