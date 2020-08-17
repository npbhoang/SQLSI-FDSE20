module Model.MyQueryReturned exposing (..)

import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)

type alias MyEntryReturned =
    { attribute : String
    , value : String
    }

type alias MyColumnReturned =
    { entry : List MyEntryReturned }


type alias MyRowReturned =
    { cols : MyColumnReturned }


type alias MyQueryReturned =
    { attributes : List String
    , records : List MyRowReturned
    }

myEntryReturnedDecoder : Decoder MyEntryReturned
myEntryReturnedDecoder =
    Decode.succeed MyEntryReturned
        |> Json.Decode.Pipeline.required "key" string
        |> Json.Decode.Pipeline.required "value" string


myEntryReturnedListDecoder : Decoder (List MyEntryReturned)
myEntryReturnedListDecoder =
    Decode.list myEntryReturnedDecoder


myColumnReturnedDecoder : Decoder MyColumnReturned
myColumnReturnedDecoder =
    Decode.succeed MyColumnReturned
        |> Json.Decode.Pipeline.required "entry" myEntryReturnedListDecoder


myRowReturnedDecoder : Decoder MyRowReturned
myRowReturnedDecoder =
    Decode.succeed MyRowReturned
        |> Json.Decode.Pipeline.required "cols" myColumnReturnedDecoder


myRowReturnedListDecoder : Decoder (List MyRowReturned)
myRowReturnedListDecoder =
    Decode.list myRowReturnedDecoder


myAttributeListDecoder : Decoder (List String)
myAttributeListDecoder =
    Decode.list Decode.string


myQueryReturnedDecoder : Decoder MyQueryReturned
myQueryReturnedDecoder =
    Decode.succeed MyQueryReturned
        |> Json.Decode.Pipeline.required "headers" myAttributeListDecoder
        |> Json.Decode.Pipeline.required "rows" myRowReturnedListDecoder