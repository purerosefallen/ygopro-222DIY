--Stars 真夏·T
local m=50008884
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008884,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,50008884)
    e1:SetCost(c50008884.cost)
    e1:SetCondition(c50008884.remcon)
    e1:SetTarget(c50008884.remtg)
    e1:SetOperation(c50008884.remop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008884,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetCost(c50008884.spcost)
    e2:SetTarget(c50008884.sptg1)
    e2:SetOperation(c50008884.spop1)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008884.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008884,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008884.spcon)
    e4:SetTarget(c50008884.sptg)
    e4:SetOperation(c50008884.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008884.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008884.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008884.costfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008884.costfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008884.remcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c50008884.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1e)
end
function c50008884.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local sg=Group.CreateGroup()
    if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        sg:Merge(sg1)
    end
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
---
function c50008884.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008884.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008884.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008884.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x50b) and not c:IsCode(50008884)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50008884.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c50008884.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and Duel.IsExistingTarget(c50008884.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c50008884.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50008884.spop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
---
function c50008884.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008884,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008884.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008884)>0
end
function c50008884.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008884)
end
function c50008884.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end