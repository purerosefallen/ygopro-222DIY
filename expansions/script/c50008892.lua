--Stars 真绪·开幕
local m=50008892
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --rm
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008892,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,50008892)
    e1:SetCost(c50008892.cost)   
    e1:SetCondition(c50008892.rmcon)
    e1:SetTarget(c50008892.rmtg)
    e1:SetOperation(c50008892.rmop)
    c:RegisterEffect(e1)  
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008892,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008892.thcost)
    e2:SetTarget(c50008892.thtg)
    e2:SetOperation(c50008892.thop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008892.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008892,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008892.spcon)
    e4:SetTarget(c50008892.sptg)
    e4:SetOperation(c50008892.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008892.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008892.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008892.costfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008892.costfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008892.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function c50008892.filter(c)
    return c:IsAbleToRemove()
end
function c50008892.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c50008892.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50008892.filter,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c50008892.filter,tp,0,LOCATION_GRAVE,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c50008892.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
---
function c50008892.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008892.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008892.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008892.thfilter(c)
    return c:IsSetCard(0x50b) and c:IsAbleToHand()
end
function c50008892.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local dg=Duel.GetMatchingGroup(c50008892.thfilter,tp,LOCATION_DECK,0,nil)
        return dg:GetClassCount(Card.GetCode)>=3
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50008892.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c50008892.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg3=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.ConfirmCards(1-tp,sg1)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local cg=sg1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        sg1:RemoveCard(tc)
        Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
    end
end
---
function c50008892.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008892,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008892.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008892)>0
end
function c50008892.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008892)
end
function c50008892.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end