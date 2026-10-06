module Survey.View exposing
    ( viewError
    , viewQuestion
    , viewReview
    , viewSubmitted
    , viewSubmitting
    )

import Html exposing (Html, button, div, h1, li, p, text, textarea, ul)
import Html.Attributes exposing (class, rows, value)
import Html.Events exposing (onClick, onInput)
import Survey.Graph exposing (Choice, QuestionNode)
import Survey.Types exposing (AnswerStep)


viewQuestion :
    { onChoice : Choice -> msg
    , onBack : msg
    , showBack : Bool
    }
    -> QuestionNode
    -> Html msg
viewQuestion config node =
    div [ class "screen" ]
        [ h1 [] [ text node.prompt ]
        , p [ class "question-context" ] [ text node.description ]
        , div [ class "choices" ] (List.map (viewChoiceButton config.onChoice) node.choices)
        , if config.showBack then
            div [ class "actions" ] [ button [ onClick config.onBack ] [ text "Back" ] ]

          else
            text ""
        ]


viewChoiceButton : (Choice -> msg) -> Choice -> Html msg
viewChoiceButton onChoice choice =
    button [ class "choice-button", onClick (onChoice choice) ]
        [ div [ class "choice-label" ] [ text choice.label ]
        , div [ class "choice-context" ] [ text choice.description ]
        ]


viewReview :
    { orderedHistory : List AnswerStep
    , pitch : Maybe String
    , comment : String
    , onCommentInput : String -> msg
    , onBack : msg
    , onSubmit : msg
    }
    -> Html msg
viewReview config =
    div [ class "screen" ]
        [ h1 [] [ text "Review your answers" ]
        , case config.pitch of
            Just sentence ->
                p [ class "pitch-sentence" ] [ text sentence ]

            Nothing ->
                text ""
        , ul [ class "answer-path" ] (List.map viewAnswerStep config.orderedHistory)
        , p [] [ text "Anything else you'd like to add? (optional)" ]
        , textarea [ value config.comment, onInput config.onCommentInput, rows 4 ] []
        , div [ class "actions" ]
            [ button [ onClick config.onBack ] [ text "Back" ]
            , button [ class "primary", onClick config.onSubmit ] [ text "Submit" ]
            ]
        ]


viewAnswerStep : AnswerStep -> Html msg
viewAnswerStep step =
    li [] [ text step.choiceLabel ]


viewSubmitting : Html msg
viewSubmitting =
    div [ class "screen" ] [ h1 [] [ text "Submitting..." ] ]


viewSubmitted : msg -> Html msg
viewSubmitted onRestart =
    div [ class "screen" ]
        [ h1 [] [ text "Thank you!" ]
        , p [] [ text "Your answers have been recorded." ]
        , div [ class "actions" ] [ button [ onClick onRestart ] [ text "Answer again" ] ]
        ]


viewError :
    { message : String
    , onEdit : msg
    , onRetry : msg
    }
    -> Html msg
viewError config =
    div [ class "screen error" ]
        [ h1 [] [ text "Something went wrong" ]
        , p [] [ text config.message ]
        , div [ class "actions" ]
            [ button [ onClick config.onEdit ] [ text "Back to review" ]
            , button [ class "primary", onClick config.onRetry ] [ text "Try again" ]
            ]
        ]
