--Stars 游木·开幕
local m=50008891
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --sp
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008891,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,50008891)
    e1:SetCost(c50008891.cost)   
    e1:SetCondition(c50008891.spcon1)
    e1:SetTarget(c50008891.sptg1)
    e1:SetOperation(c50008891.spop1)
    c:RegisterEffect(e1)  
    --deck check
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008891,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008891.checkcost)
    e2:SetTarget(c50008891.checktg)
    e2:SetOperation(c50008891.checkop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008891.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008891,3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008891.spcon)
    e4:SetTarget(c50008891.sptg)
    e4:SetOperation(c50008891.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008891.checkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008891.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008891.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008891.checktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ccount = 3
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ccount  end
end
function c50008891.checkfilter(c,e,tp)
    return c:IsSetCard(0x50b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c50008891.checkop(e,tp,eg,ep,ev,re,r,rp)
    local ccount = 3
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ccount then return end
    local g=Duel.GetDecktopGroup(tp,ccount)
    Duel.ConfirmCards(tp,g)
    if g:IsExists(c50008891.checkfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(50008891,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,c50008891.checkfilter,1,1,nil,e,tp)
        if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoGrave(sg,REASON_RULE)
        end
        Duel.ShuffleDeck(tp)
    else Duel.SortDecktop(tp,tp,ccount) end
end
---
function c50008891.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008891.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008891.costfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008891.costfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008891.spfilter(c,e,tp)
    return c:IsSetCard(0x50b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50008891.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c50008891.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and Duel.IsExistingMatchingCard(c50008891.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50008891.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50008891.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
---
function c50008891.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008891,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008891.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008891)>0
end
function c50008891.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008891)
end
function c50008891.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end