module Survey.Types exposing
    ( AnswerStep
    , Field(..)
    , FlatAnswers
    , Phase(..)
    , emptyFlatAnswers
    , setField
    )


type Field
    = TargetType
    | SubTarget
    | PricingOrOwnership
    | BrandArchetype
    | AiCentrality
    | FreeMonetization
    | WhyPay


type alias AnswerStep =
    { questionId : String
    , choiceId : String
    , choiceLabel : String
    , field : Maybe Field
    }


type alias FlatAnswers =
    { targetType : Maybe String
    , subTarget : Maybe String
    , pricingOrOwnership : Maybe String
    , brandArchetype : Maybe String
    , aiCentrality : Maybe String
    , freeMonetization : Maybe String
    , whyPay : Maybe String
    }


emptyFlatAnswers : FlatAnswers
emptyFlatAnswers =
    { targetType = Nothing
    , subTarget = Nothing
    , pricingOrOwnership = Nothing
    , brandArchetype = Nothing
    , aiCentrality = Nothing
    , freeMonetization = Nothing
    , whyPay = Nothing
    }


setField : Field -> String -> FlatAnswers -> FlatAnswers
setField field value flat =
    case field of
        TargetType ->
            { flat | targetType = Just value }

        SubTarget ->
            { flat | subTarget = Just value }

        PricingOrOwnership ->
            { flat | pricingOrOwnership = Just value }

        BrandArchetype ->
            { flat | brandArchetype = Just value }

        AiCentrality ->
            { flat | aiCentrality = Just value }

        FreeMonetization ->
            { flat | freeMonetization = Just value }

        WhyPay ->
            { flat | whyPay = Just value }


type Phase
    = Asking String
    | Review
    | Submitting
    | Submitted
    | SubmitFailed String
