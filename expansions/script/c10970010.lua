--搜寻魔术
function c10970010.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetCondition(c10970010.condition)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c10970010.cost)
    e2:SetTarget(c10970010.target)
    e2:SetOperation(c10970010.operation)
    c:RegisterEffect(e2)  
end
function c10970010.filter(c)
    return c:IsType(TYPE_FIELD) and c:IsDiscardable()
end
function c10970010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10970010.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c10970010.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c10970010.cfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x2233) or c:IsCode(10970000))
end
function c10970010.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c10970010.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10970010.thfilter(c)
    return c:IsSetCard(0x233) and c:IsAbleToHand()
end
function c10970010.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10970010.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10970010.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10970010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleDeck(tp)
    end
end
