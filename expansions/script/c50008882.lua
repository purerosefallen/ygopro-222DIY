--Stars 北斗·T
local m=50008882
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetDescription(aux.Stringid(50008880,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,50008882)
    e1:SetCost(c50008882.cost)
    e1:SetTarget(c50008882.destg)
    e1:SetOperation(c50008882.desop)
    c:RegisterEffect(e1)
    --rm
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008880,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,500088821)
    e2:SetTarget(c50008882.rmtg)
    e2:SetOperation(c50008882.rmop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008882.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008882,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008882.spcon)
    e4:SetTarget(c50008882.sptg)
    e4:SetOperation(c50008882.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end

function c50008882.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008882.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008882.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008882.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008882.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c50008882.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c50008882.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c50008882.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c50008882.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50008882.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
---
function c50008882.rmfilter(c)
    return c:IsSetCard(0x50b) and c:IsType(TYPE_SPELL+TYPE_TRAP)
        and c:IsAbleToRemove()
end
function c50008882.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008882.rmfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c50008882.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008882.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
---
function c50008882.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) and rc:IsSetCard(0x50b) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008882,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008882.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008882)>0
end
function c50008882.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008882)
end
function c50008882.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
