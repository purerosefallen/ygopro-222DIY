--梦之咲·学院
local m=50008888
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,50008888+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c50008888.rmop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008888.thcost)
    e2:SetTarget(c50008888.thtg)
    e2:SetOperation(c50008888.thop)
    c:RegisterEffect(e2)
end
function c50008888.rmfilter(c)
    return c:IsSetCard(0x50b) and c:IsAbleToRemove()
end
function c50008888.rmop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c50008888.rmfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50008888,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c50008888.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tg=g:GetFirst()
        if tg==nil then return end
        Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
        if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
         local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_REMOVED)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
        e1:SetCondition(c50008888.thcon1)
        e1:SetOperation(c50008888.thop1)
        e1:SetLabel(0)
        tg:RegisterEffect(e1)
    end
end
function c50008888.thcon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c50008888.thop1(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    e:GetHandler():SetTurnCounter(ct)
    if ct==0 then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    else e:SetLabel(0) end
end
---
function c50008888.costfilter(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008888.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008888.costfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008888.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008888.thfilter(c)
    return c:IsSetCard(0x50b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50008888.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008888.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50008888.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50008888.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
