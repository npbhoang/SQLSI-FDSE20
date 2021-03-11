module SQLSI exposing (main, objectModelView)

import Model.MyObjectModel as MyObjectModel
import Model.MyQueryReturned as MyQueryReturned
import Model.Content as Content
import Http.Request as Request
import AutoExpand exposing (State(..))
import Browser
import Color
import Json.Encode as Encode
import Html exposing (Html, Attribute, div, text, a, i, br, ul, li, button, pre, code, input, table, th, tr, td, h3, img)
import Html.Attributes exposing (style, placeholder, href, target, src, width, height, value, disabled, class)
import Html.Events exposing (onClick, onInput)
import Http exposing (Error(..))
import Material.Icons as Filled exposing (bookmarks, delete, person_add)
import Material.Icons.Types exposing (Coloring(..))
import String exposing (isEmpty)
import SyntaxHighlight exposing (useTheme, oneDark, elm, toBlockHtml)

type alias MyObjectModelResponse =
    { om : MyObjectModel.MyObjectModel
    , errorMessageForOM : Maybe String
    , queryAreaState : AutoExpand.State
    , query : String
    , caller : String
    , role : String
    , scenario : String
    , policy : String
    , myqueryReturn : MyQueryReturned.MyQueryReturned
    , errorMessageForQuery : Maybe String
    , newStudentId : String
    , newStudentName : String
    , newStudentEmail : String
    , newStudentIsValid : Bool
    , studentNameStyle : String
    , studentIdStyle : String
    , studentEmailStyle: String
    , newLecturerId : String
    , newLecturerName : String
    , newLecturerEmail : String
    , lecturerNameStyle : String
    , lecturerIdStyle : String
    , lecturerEmailStyle: String
    , newLecturerIsValid : Bool
    , newEnrollmentStudents : String
    , newEnrollmentLecturers : String
    , enrollmentStudentsStyle : String
    , enrollmentLecturersStyle : String
    , newEnrollmentIsValid : Bool
    , mySQLSchema : String
    , mySQLPolicy : String
    }

type Msg
    = GETAllDataHttpRequest
    | GETAllData_DataReceived (Result Http.Error MyObjectModel.MyObjectModel)
    | POSTExecuteQueryHttpRequest
    | POSTExecuteQuery_DataReceived (Result Http.Error MyQueryReturned.MyQueryReturned)
    | GETResetScenario
    | GETResetScenario_DataReceived (Result Http.Error MyObjectModel.MyObjectModel)
    | UPDATEMySQLSchemaSQL
    | UPDATEMySQLSchemaJSON
    | UPDATEMyPolicyTextual
    | UPDATEMyPolicyJSON
    | POSTNewStudent
    | POSTNewStudent_DataReceived (Result Http.Error MyObjectModel.Student)
    | DELETEStudent String
    | StudentDeleted (Result Http.Error MyObjectModel.StudentList)
    | POSTNewLecturer
    | POSTNewLecturer_DataReceived (Result Http.Error MyObjectModel.Lecturer)
    | DELETELecturer String
    | LecturerDeleted (Result Http.Error MyObjectModel.LecturerList)
    | POSTNewEnrollment
    | POSTNewEnrollment_DataReceived (Result Http.Error MyObjectModel.Enrollment)
    | DELETEEnrollment String String
    | EnrollmentDeleted (Result Http.Error MyObjectModel.EnrollmentList)
    | AutoExpandInput { state : AutoExpand.State, textValue : String }
    | CallerChange String
    | RoleChange String
    | ScenarioChange String
    | PolicyChange String
    | NewStudentIdChange String
    | NewStudentNameChange String
    | NewStudentEmailChange String
    | NewLecturerIdChange String
    | NewLecturerNameChange String
    | NewLecturerEmailChange String
    | NewEnrollmentStudentsChange String
    | NewEnrollmentLecturersChange String


config : AutoExpand.Config Msg
config =
    AutoExpand.config
        { onInput = AutoExpandInput
        , padding = 10
        , lineHeight = 30
        , minRows = 2
        , maxRows = 10
        }
        |> AutoExpand.withAttribute (class "autoExpand-style")
        |> AutoExpand.withAttribute (placeholder "Input your SQL query here!")


view : MyObjectModelResponse -> Html Msg
view model =
    div [ class "div-main-background" ]
        [ annoucementView model
        , navView model
        , mainContentView model
        , footerView model
        ]


annoucementView : MyObjectModelResponse -> Html Msg
annoucementView _ =
    div
        [ class "div-header-noti-background"
        ]
        [ i [ class "i-logo" ]
            [ Filled.bookmarks 16 (Color <| Color.rgb 96 181 204)
            ]
        , text "10 Mar: Update ready for the submission version in SNCS-2021!"
        ]


navView : MyObjectModelResponse -> Html Msg
navView model =
    div []
        [ introductoryView model
        , titleView model
        ]


introductoryView : MyObjectModelResponse -> Html Msg
introductoryView model =
    div
        [ class "div-header-intro-breakline" ]
        [ div [ class "div-header-intro-left-content" ]
            [ text "Vietnamese-German University" ]
        , div
            [ class "div-header-intro-center-content" ]
            [ a
                [ href "https://github.com/SE-at-VGU/SQLSI"
                , target "_blank"
                ]
                [ img [ class "github-logo" ] []
                ]
            ]
        ]


titleView : MyObjectModelResponse -> Html Msg
titleView model =
    div []
        [ div
            [ class "div-title" ]
            [ text "SQLSI" ]
        , div
            [ class "div-sub-title" ]
            [ text "SQL Security Injector" ]
        ]


mainContentView : MyObjectModelResponse -> Html Msg
mainContentView model =
    div [ class "div-main-content-background" ]
        [ leftMainDiv model
        , middleMainDiv model
        , rightMainDiv model
        ]


leftMainDiv : MyObjectModelResponse -> Html Msg
leftMainDiv model =
    div [ class "div-left-main-content-background" ] []

rightMainDiv : MyObjectModelResponse -> Html Msg
rightMainDiv model =
    div [ class "div-right-main-content-background" ] []

middleMainDiv : MyObjectModelResponse -> Html Msg
middleMainDiv model =
    div
        [ class "div-main-main-content-background" ]
        [ div [] [ introductionContentView model ]
        , div [ class "div-content-main-content", style "margin" "5% 5% 5px 5%"] [
            text "Please, be aware that SQLSI is an on-going research project. SQLSI does not cover yet the full SQL language. In particular, it covers the JOIN clause, WHERE clause and sub-select as described in the manuscripts."
            , br [] []
            , text "The database instance depicts scenario VGU#2 in the manuscript. Note that, the fields inlcude unique constraints and delete does not allow cascading."
        ]
        -- , div [ style "margin" "1%" ] [ objectModelView model ]
        , div [ style "margin" "1%" ] [
            img [ src "VGU2c.png", style "width" "50%"
                    , style "align-items" "center"
                    , style "display" "block"
                    , style "margin-left" "auto"
                    , style "margin-right" "auto" 
            ] []
        ]
        , div [ style "padding-top" "10px", style "background-color" "white" ] [ queryView model ]
        ]


introductionContentView : MyObjectModelResponse -> Html Msg
introductionContentView model =
    div
        [ class "div-content-main-content" ]
        [ div [ style "margin" "5%" ] [ 
            text "This web service is intended for readers of our manuscripts:"
            , ul [] [
                li [ style "font-weight" "500" ] [ text "A model-driven approach for enforcing fine-grained access control authorization for SQL queries" ]
                ]
            , text "In particular, the contextual model is fixed on the model University, as described in our manuscripts, namely:"
        ]
        , div [ class "div-code-example" ] [ sqlSchemaView model ]
        , div [ style "margin" "5%" ] [ 
            text "The security policy is fixed on the policy SecVGU#C, as described in our manuscripts, namely:"
        ]
        , div [ class "div-code-example" ] [ sqlPolicyView model ]
        ]

sqlPolicyView : MyObjectModelResponse -> Html Msg
sqlPolicyView model =
    div []
        [ button 
            [ class "button-code-inline"
            , onClick UPDATEMyPolicyTextual ] [ text "TEXTUAL" ]
        , button 
            [ class "button-code-inline"
            , onClick UPDATEMyPolicyJSON ] [ text "JSON" ]
        , div [style "padding" "10px 5% 10px 5%", style "overflow" "auto" ] [
        useTheme oneDark
        , elm model.mySQLPolicy
            |> Result.map (toBlockHtml (Just 1))
            |> Result.withDefault
                (pre [] [ code [] [ text model.mySQLPolicy ]])
        ]
    ]

sqlSchemaView : MyObjectModelResponse -> Html Msg
sqlSchemaView model =
    div [ ]
        [ button 
            [ class "button-code-inline"
            , onClick UPDATEMySQLSchemaSQL ] [ text "SQL" ]
        , button 
            [ class "button-code-inline"
            , onClick UPDATEMySQLSchemaJSON ] [ text "JSON" ]
        , div [style "padding" "10px 5% 10px 5%", style "overflow" "auto" ] [
        useTheme oneDark
        , elm model.mySQLSchema
            |> Result.map (toBlockHtml (Just 1))
            |> Result.withDefault
                (pre [] [ code [] [ text model.mySQLSchema ]])
        ]
    ]

objectModelView : MyObjectModelResponse -> Html Msg
objectModelView model =
    div []
        [ objectModelViewOrErrorView model
        ]

queryView : MyObjectModelResponse -> Html Msg
queryView model =
    div []
        [ div
            [ style "text-align" "left"
            , style "font-size" "20px"
            , style "padding" "10px 10px 10px 10px"
            , style "border-radius" "5px"
            , style "color" "black"
            ]
            [ div [ style "padding-left" "10%" ]
                [ input
                    [ style "border" "1px black solid"
                    , style "width" "100px"
                    , style "padding" "10px"
                    , style "padding-left" "10px"
                    , style "background-color" "white"
                    , style "font-size" "16px"
                    , style "font-family" "Courier"
                    , style "border-radius" "5px"
                    , style "text-align" "center"
                    , placeholder "caller"
                    , value model.caller
                    , onInput CallerChange
                    ]
                    []
                ]
            ]
        , div [ style "text-align" "center", style "padding" "10px 0px 10px 0px" ] [ AutoExpand.view config model.queryAreaState model.query ]
        , div [ style "text-align" "center" ]
            [ button [ style "width" "100px", style "height" "40px", style "border-radius" "5px", onClick POSTExecuteQueryHttpRequest ] 
            [ text "Execute!" ]
            , button [ style "margin-left" "10px", style "width" "150px", style "height" "40px", disabled True, style "border-radius" "5px"
            , onClick GETResetScenario ] [ text "Reset Scenario!" ]
            ]
        , div [ style "text-align" "center", style "padding" "10px" ] [ queryResultViewOrErrorView model ]
        ]


queryResultViewOrErrorView : MyObjectModelResponse -> Html Msg
queryResultViewOrErrorView model =
    case model.errorMessageForQuery of
        Just message ->
            viewError message (style "color" "black")

        Nothing ->
            viewMyQueryResult model.myqueryReturn


viewMyQueryResult : MyQueryReturned.MyQueryReturned -> Html Msg
viewMyQueryResult model =
    div [ style "text-align" "center" ]
        [ table [] 
            ([ viewTableHeaders model.attributes ] ++ List.map viewRecord model.records)
        ]


viewValue : MyQueryReturned.MyEntryReturned -> Html Msg
viewValue entry =
    th [] [ text entry.value ]


viewRecord : MyQueryReturned.MyRowReturned -> Html Msg
viewRecord row =
    tr []
        (List.map viewValue row.cols.entry)


viewTableHeaders : List String -> Html Msg
viewTableHeaders attributes =
    tr []
        (List.map viewTableHeader attributes)


viewTableHeader : String -> Html Msg
viewTableHeader attribute =
    th []
        [ text attribute ]


objectModelViewOrErrorView : MyObjectModelResponse -> Html Msg
objectModelViewOrErrorView model =
    case model.errorMessageForOM of
        Just message ->
            viewError message (style "color" "black")

        Nothing ->
            viewMyObjectModel model


viewError : String -> Attribute Msg -> Html Msg
viewError errorMessageString backgroundColor =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
    div [ backgroundColor ]
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessageString)
        ]


viewMyObjectModel : MyObjectModelResponse -> Html Msg
viewMyObjectModel omResponse =
    div
        [ style "display" "block"
        ]
        [ div
            [ style "height" "100%"
            ]
            [ h3 [ style "text-align" "center" ] [ text "Student" ]
            , table
                []
                ([ viewStudentTableHeader ]
                    ++ List.map viewStudent omResponse.om.students
                    -- ++ [addNewStudentView omResponse.newStudentId 
                    -- omResponse.newStudentName omResponse.newStudentEmail omResponse.newStudentIsValid
                    -- omResponse.studentIdStyle omResponse.studentNameStyle omResponse.studentEmailStyle]
                )
            ]
        , div
            [ style "height" "100%"
            ]
            [ h3 [ style "text-align" "center" ] [ text "Lecturer" ]
            , table
                []
                ([ viewLecturerTableHeader ] 
                ++ List.map viewLecturer omResponse.om.lecturers
                -- ++ [addNewLecturerView omResponse.newLecturerId 
                -- omResponse.newLecturerName omResponse.newLecturerEmail omResponse.newLecturerIsValid
                -- omResponse.lecturerIdStyle omResponse.lecturerNameStyle omResponse.lecturerEmailStyle]
                )
            ]
        , div
            [ style "padding" "5px"
            ]
            [ h3 [ style "text-align" "center" ] [ text "Enrollment" ]
            , table
                []
                ([ viewEnrollmentTableHeader ] 
                ++ List.map viewEnrollment omResponse.om.enrollments
                -- ++ [addNewEnrollmentView omResponse.newEnrollmentStudents 
                -- omResponse.newEnrollmentLecturers omResponse.newEnrollmentIsValid
                -- omResponse.enrollmentStudentsStyle omResponse.enrollmentLecturersStyle]
                )
            ]
        ]

addNewStudentView : String -> String -> String -> Bool -> String -> String -> String -> Html Msg
addNewStudentView id name email newStudentIsValid studentIdStyle studentNameStyle studentEmailStyle =
    tr []
        [ td []
            [ input [ style "color" studentIdStyle, placeholder "id", value id, onInput NewStudentIdChange ] [] ]
        , td []
            [ input [  style "color" studentNameStyle, placeholder "name", value name, onInput NewStudentNameChange ] [] ]
        , td []
            [ input [  style "color" studentEmailStyle, placeholder "email", value email, onInput NewStudentEmailChange ] [] ]
        , td [ ]
            [ button [ style "margin" "0px", onClick POSTNewStudent, disabled (not newStudentIsValid) ] [
                i [ ]
                    [ Filled.person_add 16 (Color <| Color.rgb 0 0 0) ]
            ] ]
        ]

addNewLecturerView : String -> String -> String -> Bool -> String -> String -> String -> Html Msg
addNewLecturerView id name email newLecturerIsValid lecturerIdStyle lecturerNameStyle lecturerEmailStyle =
    tr []
        [ td []
            [ input [ style "color" lecturerIdStyle, style "width" "100px", style "height" "28px", placeholder "id", value id, onInput NewLecturerIdChange ] [] ]
        , td []
            [ input [ style "color" lecturerNameStyle, style "width" "100px", style "height" "28px", placeholder "name", value name, onInput NewLecturerNameChange ] [] ]
        , td []
            [ input [ style "color" lecturerEmailStyle, style "width" "100px", style "height" "28px", placeholder "email", value email, onInput NewLecturerEmailChange ] [] ]
        , td [ ]
            [ button [ style "height" "28px", style "margin" "0px", onClick POSTNewLecturer, disabled (not newLecturerIsValid) ] [ 
                i [ ]
                    [ Filled.person_add 16 (Color <| Color.rgb 0 0 0) ]
            ] ]
        ]

addNewEnrollmentView : String -> String -> Bool -> String -> String -> Html Msg
addNewEnrollmentView students lecturers newEnrollmentIsValid enrollmentStudentsStyle enrollmentLecturersStyle =
    tr []
        [ td []
            [ input [ style "color" enrollmentStudentsStyle, style "width" "100px", style "height" "28px", placeholder "students", value students, onInput NewEnrollmentStudentsChange ] [] ]
        , td []
            [ input [ style "color" enrollmentLecturersStyle, style "width" "100px", style "height" "28px", placeholder "lecturers", value lecturers, onInput NewEnrollmentLecturersChange ] [] ]
        , td [ ]
            [ button [ style "height" "28px", style "margin" "0px", onClick POSTNewEnrollment, disabled (not newEnrollmentIsValid) ] [ 
                i [ ]
                    [ Filled.person_add 16 (Color <| Color.rgb 0 0 0) ]
            ] ]
        ]

footerView : MyObjectModelResponse -> Html Msg
footerView model =
    div
        [ class "div-footer-background" ]
        [ div
            [ style "float" "left"
            , style "color" "black"
            , style "padding-top" "18px"
            , style "padding-left" "10%"
            , style "width" "50%"
            , style "font-weight" "200"
            , style "font-family" "Times New Roman"
            , style "font-size" "1.4vw"
            ]
            [ text "@ 2020 Hoang Nguyen. Built in Elm Programming Language. All Rights Reserved."
            ]
        , div
            [ style "display" "inline-block"
            , style "margin" "0 auto"
            , style "padding-top" "7px"
            , style "width" "20%"
            , style "float" "center"
            , style "text-align" "center"
            ]
            [ a
                [ href "https://elmprogramming.com/"
                , target "_blank"
                ]
                [ img [ src "elm-logo.svg", width 93, height 38, style "color" "black" ] []
                ]
            ]
        ]


viewStudentTableHeader : Html Msg
viewStudentTableHeader =
    tr []
        [ th [  ]
            [ text "Student_id" ]
        , th [  ]
            [ text "name" ]
        , th [  ]
            [ text "email" ]
        , th [ style "border" "0" ] []
        ]


viewLecturerTableHeader : Html Msg
viewLecturerTableHeader =
    tr []
        [ th [  ]
            [ text "Lecturer_id" ]
        , th [  ]
            [ text "name" ]
        , th [  ]
            [ text "email" ]
        , th [ style "border" "0" ] []
        ]


viewEnrollmentTableHeader : Html Msg
viewEnrollmentTableHeader =
    tr []
        [ th [  ]
            [ text "students" ]
        , th [  ]
            [ text "lecturers" ]
        , th [ style "border" "0" ] []
        ]


viewStudent : MyObjectModel.Student -> Html Msg
viewStudent student =
    tr []
        [ td [ style "font-family" "Courier", style "overflow" "hidden" ]
            [ text student.id ]
        , td [ style "font-family" "Courier", style "overflow" "hidden" ]
            [ text student.name ]
        , td [ style "font-family" "Courier", style "overflow" "hidden" ]
            [ text student.email ]
        , td [ style "width" "34px" ]
            [ button [ style "width" "32px", style "height" "30px", style "margin" "0px", onClick (DELETEStudent student.id) ] [ 
                i [ ]
                    [ Filled.delete 16 (Color <| Color.rgb 0 0 0) ]
             ] ]
        ]


viewLecturer : MyObjectModel.Lecturer -> Html Msg
viewLecturer lecturer =
    tr []
        [ td [style "font-family" "Courier" ]
            [ text lecturer.id ]
        , td [ style "font-family" "Courier" ]
            [ text lecturer.name ]
        , td [ style "font-family" "Courier" ]
            [ text lecturer.email ]
        , td [ ]
            [ button [ style "height" "28px", style "margin" "0px", onClick (DELETELecturer lecturer.id) ] [ 
                i [ ]
                    [ Filled.delete 16 (Color <| Color.rgb 0 0 0) ]
             ] ]
        ]


viewEnrollment : MyObjectModel.Enrollment -> Html Msg
viewEnrollment enrollment =
    tr []
        [ td [ style "font-family" "Courier" ]
            [ text enrollment.students ]
        , td [ style "font-family" "Courier" ]
            [ text enrollment.lecturers ]
        , td [ ]
            [ button [ style "height" "28px", style "margin" "0px", onClick (DELETEEnrollment enrollment.students enrollment.lecturers) ] [ 
                i [ ]
                    [ Filled.delete 16 (Color <| Color.rgb 0 0 0) ]
             ] ]
        ]

getAllDataCommand : Cmd Msg
getAllDataCommand =
    Http.get
        { url = Request.getAllDataCommandURL
        , expect = Http.expectJson GETAllData_DataReceived MyObjectModel.myObjectModelDecoder
        }

getResetCommand : Cmd Msg
getResetCommand =
    Http.get
        { url = Request.getResetCommandURL
        , expect = Http.expectJson GETResetScenario_DataReceived MyObjectModel.myObjectModelDecoder
        }

queryEncoder : String -> Encode.Value
queryEncoder query =
    Encode.object [ ( "query", Encode.string query ) ]


executeQueryCommand : String -> String -> String -> String -> String -> Cmd Msg
executeQueryCommand caller role scenario policy query =
    Http.request
        { method = "POST"
        , headers = []
        , url = Request.executeQueryCommandURL
                ++ "?caller="
                ++ caller
                ++ "&role="
                ++ role
                ++ "&scenario="
                ++ scenario
                ++ "&policy="
                ++ policy
        , body = Http.jsonBody (queryEncoder query)
        , expect = Http.expectJson POSTExecuteQuery_DataReceived MyQueryReturned.myQueryReturnedDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

createNewStudent : String -> String -> String -> Cmd Msg
createNewStudent id name email =
    Http.request
        { method = "POST"
        , headers = []
        , url = Request.createNewStudentURL
        , body = Http.jsonBody (MyObjectModel.studentEncoder id name email)
        , expect = Http.expectJson POSTNewStudent_DataReceived MyObjectModel.studentDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

createNewLecturer : String -> String -> String -> Cmd Msg
createNewLecturer id name email =
    Http.request
        { method = "POST"
        , headers = []
        , url = Request.createNewLecturerURL
        , body = Http.jsonBody (MyObjectModel.lecturerEncoder id name email)
        , expect = Http.expectJson POSTNewLecturer_DataReceived MyObjectModel.lecturerDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

createNewEnrollment : String -> String -> Cmd Msg
createNewEnrollment students lecturers =
    Http.request
        { method = "POST"
        , headers = []
        , url = Request.createNewEnrollmentURL
        , body = Http.jsonBody (MyObjectModel.enrollmentEncoder students lecturers)
        , expect = Http.expectJson POSTNewEnrollment_DataReceived MyObjectModel.enrollmentDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

deleteStudent : String -> Cmd Msg
deleteStudent id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = Request.deleteStudentURL ++ "/" ++ id
        , body = Http.emptyBody
        , expect = Http.expectJson StudentDeleted MyObjectModel.studentsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

deleteLecturer : String -> Cmd Msg
deleteLecturer id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = Request.deleteLecturerURL ++ "/" ++ id
        , body = Http.emptyBody
        , expect = Http.expectJson LecturerDeleted MyObjectModel.lecturersDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

deleteEnrollment : String -> String -> Cmd Msg
deleteEnrollment students lecturers =
    Http.request
        { method = "POST"
        , headers = []
        , url = Request.deleteEnrollmentURL
        , body = Http.jsonBody (MyObjectModel.enrollmentEncoder students lecturers)
        , expect = Http.expectJson EnrollmentDeleted MyObjectModel.enrollmentsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

update : Msg -> MyObjectModelResponse -> ( MyObjectModelResponse, Cmd Msg )
update msg omResponse =
    case msg of
        GETAllDataHttpRequest ->
            ( omResponse, getAllDataCommand )

        GETAllData_DataReceived (Ok myModel) ->
            ( { omResponse
                | om = myModel
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        GETAllData_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

        GETResetScenario ->
            ( omResponse, getResetCommand )

        GETResetScenario_DataReceived (Ok myModel) ->
            ( { omResponse
                | om = myModel
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        GETResetScenario_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

        POSTExecuteQueryHttpRequest ->
            ( omResponse, executeQueryCommand omResponse.caller omResponse.role omResponse.scenario omResponse.policy omResponse.query )

        POSTExecuteQuery_DataReceived (Ok myModel) ->
            ( { omResponse
                | myqueryReturn = myModel
                , errorMessageForQuery = Nothing
              }
            , Cmd.none
            )

        POSTExecuteQuery_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForQuery = Just ("Sorry! There is something wrong with the input SQL. Please contact the authors for explanation or bug report!" ++ "\n" ++ buildErrorMessage httpError)
              }
            , Cmd.none
            )

        POSTNewStudent ->
            ( omResponse, createNewStudent omResponse.newStudentId omResponse.newStudentName omResponse.newStudentEmail )

        POSTNewStudent_DataReceived (Ok myStudent) ->
            ( { omResponse
                | newStudentId = ""
                , newStudentName = ""
                , newStudentEmail = ""
                , om = MyObjectModel.addNewStudent myStudent omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        POSTNewStudent_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

        DELETEStudent studentId ->
            ( omResponse, deleteStudent studentId )

        StudentDeleted (Ok myStudents) ->
            ( { omResponse
                | om = MyObjectModel.buildNewStudent myStudents omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        StudentDeleted (Err error) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage error)
              }
            , Cmd.none
            )

        POSTNewLecturer ->
            ( omResponse, createNewLecturer omResponse.newLecturerId omResponse.newLecturerName omResponse.newLecturerEmail )

        POSTNewLecturer_DataReceived (Ok myLecturer) ->
            ( { omResponse
                | newLecturerId = ""
                , newLecturerName = ""
                , newLecturerEmail = ""
                , om = MyObjectModel.addNewLecturer myLecturer omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        POSTNewLecturer_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

        DELETELecturer lecturerId ->
            ( omResponse, deleteLecturer lecturerId )

        LecturerDeleted (Ok myLectures) ->
            ( { omResponse
                | om = MyObjectModel.buildNewLecturer myLectures omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        LecturerDeleted (Err error) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage error)
              }
            , Cmd.none
            )

        POSTNewEnrollment ->
            ( omResponse, createNewEnrollment omResponse.newEnrollmentStudents omResponse.newEnrollmentLecturers )

        POSTNewEnrollment_DataReceived (Ok myEnrollment) ->
            ( { omResponse
                | newEnrollmentStudents = ""
                , newEnrollmentLecturers = ""
                , om = MyObjectModel.addNewEnrollment myEnrollment omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        POSTNewEnrollment_DataReceived (Err httpError) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )

        DELETEEnrollment students lecturers ->
            ( omResponse, deleteEnrollment students lecturers )

        EnrollmentDeleted (Ok myEnrollments) ->
            ( { omResponse
                | om = MyObjectModel.buildNewEnrollment myEnrollments omResponse.om
                , errorMessageForOM = Nothing
              }
            , Cmd.none
            )

        EnrollmentDeleted (Err error) ->
            ( { omResponse
                | errorMessageForOM = Just (buildErrorMessage error)
              }
            , Cmd.none
            )

        AutoExpandInput { state, textValue } ->
            ( { omResponse
                | queryAreaState =
                    if isEmpty textValue then
                        AutoExpand.initState config

                    else
                        state
                , query = textValue
              }
            , Cmd.none
            )

        CallerChange newCaller ->
            ( { omResponse
                | caller = newCaller
              }
            , Cmd.none
            )

        RoleChange newRole ->
            ( { omResponse
                | role = newRole
              }
            , Cmd.none
            )

        ScenarioChange newScenario ->
            ( { omResponse
                | scenario = newScenario
              }
            , Cmd.none
            )

        PolicyChange newPolicy ->
            ( { omResponse
                | policy = newPolicy
              }
            , Cmd.none
            )

        NewStudentIdChange newId ->
            ( { omResponse
                | newStudentId = newId
                , newStudentIsValid = MyObjectModel.checkStudentUnique newId omResponse.newStudentName omResponse.newStudentEmail omResponse.om.students
                , studentIdStyle = if MyObjectModel.checkStudentIdUnique newId omResponse.om.students then "black" else "red"
              }
            , Cmd.none
            )

        NewStudentNameChange newName ->
            ( { omResponse
                | newStudentName = newName
                , newStudentIsValid = MyObjectModel.checkStudentUnique omResponse.newStudentId newName omResponse.newStudentEmail omResponse.om.students
                , studentNameStyle = if MyObjectModel.checkStudentNameUnique newName omResponse.om.students then "black" else "red"
              }
            , Cmd.none
            )
        
        NewStudentEmailChange newEmail ->
            ( { omResponse
                | newStudentEmail = newEmail
                , newStudentIsValid = MyObjectModel.checkStudentUnique omResponse.newStudentId omResponse.newStudentName newEmail omResponse.om.students
                , studentEmailStyle = if MyObjectModel.checkStudentEmailUnique newEmail omResponse.om.students then "black" else "red"
              }
            , Cmd.none
            )

        NewLecturerIdChange newId ->
            ( { omResponse
                | newLecturerId = newId
                , newLecturerIsValid = MyObjectModel.checkLecturerUnique newId omResponse.newLecturerName omResponse.newLecturerEmail omResponse.om.lecturers
                , lecturerIdStyle = if MyObjectModel.checkLecturerIdUnique newId omResponse.om.lecturers then "black" else "red"
              }
            , Cmd.none
            )

        NewLecturerNameChange newName ->
            ( { omResponse
                | newLecturerName = newName
                , newLecturerIsValid = MyObjectModel.checkLecturerUnique omResponse.newLecturerId newName omResponse.newLecturerEmail omResponse.om.lecturers
                , lecturerNameStyle = if MyObjectModel.checkLecturerNameUnique newName omResponse.om.lecturers then "black" else "red"
              }
            , Cmd.none
            )
        
        NewLecturerEmailChange newEmail ->
            ( { omResponse
                | newLecturerEmail = newEmail
                , newLecturerIsValid = MyObjectModel.checkLecturerUnique omResponse.newLecturerId omResponse.newLecturerName newEmail omResponse.om.lecturers
                , lecturerEmailStyle = if MyObjectModel.checkLecturerEmailUnique newEmail omResponse.om.lecturers then "black" else "red"
              }
            , Cmd.none
            )

        NewEnrollmentStudentsChange newStudents ->
            ( { omResponse
                | newEnrollmentStudents = newStudents
                , newEnrollmentIsValid = MyObjectModel.checkEnrollmentUnique newStudents omResponse.newEnrollmentLecturers omResponse.om.enrollments
                , enrollmentStudentsStyle = if MyObjectModel.checkEnrollmentUnique newStudents omResponse.newEnrollmentLecturers omResponse.om.enrollments 
                then "black" else "red"
              }
            , Cmd.none
            )

        NewEnrollmentLecturersChange newLecturers ->
            ( { omResponse
                | newEnrollmentLecturers = newLecturers
                , newEnrollmentIsValid = MyObjectModel.checkEnrollmentUnique omResponse.newEnrollmentStudents newLecturers omResponse.om.enrollments
                , enrollmentLecturersStyle = if MyObjectModel.checkEnrollmentUnique omResponse.newEnrollmentStudents newLecturers omResponse.om.enrollments 
                then "black" else "red"
              }
            , Cmd.none
            )

        UPDATEMySQLSchemaSQL ->
            ( { omResponse
                | mySQLSchema = Content.sqlSchema
              }
            , Cmd.none
            )
        
        UPDATEMySQLSchemaJSON ->
            ( { omResponse
                | mySQLSchema = Content.jsonSchema
              }
            , Cmd.none
            )

        UPDATEMyPolicyTextual ->
            ( { omResponse
                | mySQLPolicy = Content.nakedPolicy
              }
            , Cmd.none
            )

        UPDATEMyPolicyJSON ->
            ( { omResponse
                | mySQLPolicy = Content.jsonPolicy
              }
            , Cmd.none
            )



buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


init : () -> ( MyObjectModelResponse, Cmd Msg )
init _ =
    ( { om =
            { students = []
            , lecturers = []
            , enrollments = []
            }
      , errorMessageForOM = Nothing
      , queryAreaState = AutoExpand.initState config
      , query = ""
      , caller = ""
      , role = "Lecturer"
      , scenario = "custom"
      , policy = "SecVGU#C"
      , errorMessageForQuery = Nothing
      , myqueryReturn =
            { attributes = []
            , records = []
            }
      , newStudentId = ""
      , newStudentName = ""
      , newStudentEmail = ""   
      , newStudentIsValid = False   
      , newLecturerId = ""
      , newLecturerName = ""
      , newLecturerEmail = ""
      , newLecturerIsValid = False
      , newEnrollmentStudents = ""
      , newEnrollmentLecturers = ""
      , newEnrollmentIsValid = False
      , mySQLSchema = Content.sqlSchema
      , mySQLPolicy = Content.nakedPolicy
      , studentNameStyle = "black"
      , studentIdStyle = "black"
      , studentEmailStyle = "black"
    , lecturerNameStyle = "black"
    , lecturerIdStyle = "black"
    , lecturerEmailStyle = "black"
    , enrollmentStudentsStyle = "black"
    , enrollmentLecturersStyle = "black"
      }
    , getResetCommand
    )


main : Program () MyObjectModelResponse Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
