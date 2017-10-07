--Show·Stars 游木
local m=50008895
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_RITUAL),6,2)
    c:EnableReviveLimit()
    --handes
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008895,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,50008895)
    e1:SetCost(c50008895.hdcost)
    e1:SetTarget(c50008895.hdtg)
    e1:SetOperation(c50008895.hdop)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50008895,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1e0)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008895.descost)
    e2:SetTarget(c50008895.destg)
    e2:SetOperation(c50008895.desop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008895.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008895,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008895.spcon)
    e4:SetTarget(c50008895.sptg)
    e4:SetOperation(c50008895.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008895.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,3)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008895.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c50008895.hdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(1-tp,1)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
----
function c50008895.costfilter(c)
    return c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008895.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008895.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008895.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008895.desfilter(c)
    return c:IsFaceup() and c:IsAttackAbove(0)
end
function c50008895.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008895.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c50008895.desfilter,tp,0,LOCATION_MZONE,nil)
    local dg=g:GetMaxGroup(Card.GetAttack)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c50008895.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c50008895.desfilter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local dg=g:GetMaxGroup(Card.GetAttack)
        Duel.Destroy(dg,REASON_EFFECT)
    end
end
---
function c50008895.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008895,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008895.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008895)>0
end
function c50008895.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008895)
end
function c50008895.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end