--Show·Stars 昴流
local m=50008896
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x50b),6,3)
    c:EnableReviveLimit()
    --negate activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008896,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,50008896)
    e1:SetCondition(c50008896.necon)
    e1:SetCost(c50008896.necost)
    e1:SetTarget(c50008896.netg)
    e1:SetOperation(c50008896.neop)
    c:RegisterEffect(e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008896.cost)
    e2:SetTarget(c50008896.tg)
    e2:SetOperation(c50008896.op)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008896.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008896,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008896.spcon)
    e4:SetTarget(c50008896.sptg)
    e4:SetOperation(c50008896.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008896.necon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c50008896.necost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,3)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008896.netg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c50008896.neop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
    end
end
---
function c50008896.costfilter(c)
    return c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008896.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008896.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008896.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008896.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end

function c50008896.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c50008896.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50008896.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c50008896.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end

function c50008896.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
    end
end
---
function c50008896.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008896,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008896.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008896)>0
end
function c50008896.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008896)
end
function c50008896.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end