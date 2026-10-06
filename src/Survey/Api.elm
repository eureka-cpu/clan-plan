module Survey.Api exposing (submit)

import Flags exposing (Flags)
import Http
import Json.Encode as Encode
import Survey.Types exposing (AnswerStep, FlatAnswers)


encodeAnswerStep : AnswerStep -> Encode.Value
encodeAnswerStep step =
    Encode.object
        [ ( "questionId", Encode.string step.questionId )
        , ( "choiceId", Encode.string step.choiceId )
        , ( "choiceLabel", Encode.string step.choiceLabel )
        ]


encodeMaybeString : Maybe String -> Encode.Value
encodeMaybeString maybeValue =
    case maybeValue of
        Just value ->
            Encode.string value

        Nothing ->
            Encode.null


encodeNonEmptyString : String -> Encode.Value
encodeNonEmptyString value =
    if String.isEmpty (String.trim value) then
        Encode.null

    else
        Encode.string (String.trim value)


encodePayload : FlatAnswers -> List AnswerStep -> String -> String -> String -> Encode.Value
encodePayload flat orderedHistory respondentName productName comment =
    Encode.object
        [ ( "target_type", encodeMaybeString flat.targetType )
        , ( "sub_target", encodeMaybeString flat.subTarget )
        , ( "pricing_or_ownership", encodeMaybeString flat.pricingOrOwnership )
        , ( "brand_archetype", encodeMaybeString flat.brandArchetype )
        , ( "ai_centrality", encodeMaybeString flat.aiCentrality )
        , ( "free_monetization", encodeMaybeString flat.freeMonetization )
        , ( "respondent_name", encodeNonEmptyString respondentName )
        , ( "product_name", encodeNonEmptyString productName )
        , ( "general_comment", encodeNonEmptyString comment )
        , ( "answer_path", Encode.list encodeAnswerStep orderedHistory )
        ]


{-| `history` must be passed in the order the respondent actually answered
(oldest first) — callers that accumulate it by prepending need to reverse
before calling this.
-}
submit : Flags -> FlatAnswers -> List AnswerStep -> String -> String -> String -> (Result Http.Error () -> msg) -> Cmd msg
submit flags flat history respondentName productName comment toMsg =
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "apikey" flags.supabaseAnonKey
            , Http.header "Authorization" ("Bearer " ++ flags.supabaseAnonKey)
            , Http.header "Prefer" "return=minimal"
            ]
        , url = flags.supabaseUrl ++ "/rest/v1/responses"
        , body = Http.jsonBody (encodePayload flat history respondentName productName comment)
        , expect = Http.expectWhatever toMsg
        , timeout = Nothing
        , tracker = Nothing
        }
