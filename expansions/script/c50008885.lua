--Stars 游木·T
local m=50008885
local cm=_G["c"..m]
function cm.initial_effect(c)   
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetDescription(aux.Stringid(50008885,0))
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,50008885)
    e1:SetCost(c50008885.cost)
    e1:SetTarget(c50008885.sptg1)
    e1:SetOperation(c50008885.spop1)
    c:RegisterEffect(e1)
    --rm
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008885,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,500088851)
    e2:SetTarget(c50008885.sptg2)
    e2:SetOperation(c50008885.spop2)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008885.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008885,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008885.spcon)
    e4:SetTarget(c50008885.sptg)
    e4:SetOperation(c50008885.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008885.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008885.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008885.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008885.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008885.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50008885.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
---
function c50008885.spfilter2(c,e,tp)
    return c:IsSetCard(0x50b)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c50008885.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50008885.spfilter2(chkc,e,tp) end
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and Duel.IsExistingTarget(c50008885.spfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c50008885.spfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50008885.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
---
function c50008885.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) and rc:IsSetCard(0x50b) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008885,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008885.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008885)>0
end
function c50008885.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008885)
end
function c50008885.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
