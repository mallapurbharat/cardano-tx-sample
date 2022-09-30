```
When
    [Case
        (Deposit
            (Role "Buyer")
            (Role "Buyer")
            (Token "" "")
            (AddValue
                (ConstantParam "Price")
                (ConstantParam "MediationFee")
            )
        )
        (When
            [Case
                (Deposit
                    (Role "Mediator")
                    (Role "Mediator")
                    (Token "" "")
                    (ConstantParam "Price")
                )
                (When
                    [Case
                        (Deposit
                            (Role "Seller")
                            (Role "Seller")
                            (Token "" "")
                            (AddValue
                                (ConstantParam "Price")
                                (ConstantParam "MediationFee")
                            )
                        )
                        (When
                            [Case
                                (Choice
                                    (ChoiceId
                                        "Everything is alright"
                                        (Role "Buyer")
                                    )
                                    [Bound 0 0]
                                )
                                (Pay
                                    (Role "Buyer")
                                    (Account (Role "Seller"))
                                    (Token "" "")
                                    (ConstantParam "Price")
                                    Close 
                                ), Case
                                (Choice
                                    (ChoiceId
                                        "Report problem"
                                        (Role "Buyer")
                                    )
                                    [Bound 1 1]
                                )
                                (When
                                    [Case
                                        (Choice
                                            (ChoiceId
                                                "Confirm problem"
                                                (Role "Seller")
                                            )
                                            [Bound 1 1]
                                        )
                                        Close , Case
                                        (Choice
                                            (ChoiceId
                                                "Dispute problem"
                                                (Role "Seller")
                                            )
                                            [Bound 0 0]
                                        )
                                        (When
                                            [Case
                                                (Choice
                                                    (ChoiceId
                                                        "Dismiss claim"
                                                        (Role "Mediator")
                                                    )
                                                    [Bound 0 0]
                                                )
                                                (Pay
                                                    (Role "Buyer")
                                                    (Party (Role "Seller"))
                                                    (Token "" "")
                                                    (ConstantParam "Price")
                                                    (Pay
                                                        (Role "Buyer")
                                                        (Party (Role "Mediator"))
                                                        (Token "" "")
                                                        (ConstantParam "MediationFee")
                                                        Close 
                                                    )
                                                ), Case
                                                (Choice
                                                    (ChoiceId
                                                        "Confirm problem"
                                                        (Role "Mediator")
                                                    )
                                                    [Bound 1 1]
                                                )
                                                (Pay
                                                    (Role "Seller")
                                                    (Party (Role "Buyer"))
                                                    (Token "" "")
                                                    (ConstantParam "Price")
                                                    (Pay
                                                        (Role "Seller")
                                                        (Party (Role "Mediator"))
                                                        (Token "" "")
                                                        (ConstantParam "MediationFee")
                                                        Close 
                                                    )
                                                )]
                                            (TimeParam "Mediation deadline")
                                            (Pay
                                                (Role "Mediator")
                                                (Account (Role "Buyer"))
                                                (Token "" "")
                                                (DivValue
                                                    (ConstantParam "Price")
                                                    (Constant 2)
                                                )
                                                (Pay
                                                    (Role "Mediator")
                                                    (Account (Role "Seller"))
                                                    (Token "" "")
                                                    (DivValue
                                                        (ConstantParam "Price")
                                                        (Constant 2)
                                                    )
                                                    (Pay
                                                        (Role "Seller")
                                                        (Account (Role "Buyer"))
                                                        (Token "" "")
                                                        (ConstantParam "Price")
                                                        Close 
                                                    )
                                                )
                                            )
                                        )]
                                    (TimeParam "Complaint response deadline")
                                    Close 
                                )]
                            (TimeParam "Complaint deadline")
                            Close 
                        )]
                    (TimeParam "SellerDepositDeadline")
                    Close 
                )]
            (TimeParam "MediatorDepositDeadline")
            Close 
        )]
    (TimeParam "Payment deadline")
    Close 
```
