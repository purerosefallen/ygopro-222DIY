--吸血鬼 奇犽
function c50000057.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c50000057.linkfilter,2)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetCondition(c50000057.indescon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --cannot be target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c50000057.indescon)
    e3:SetValue(c50000057.tgval)
    c:RegisterEffect(e3)
    --attack up
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_CONTROL)
    e4:SetDescription(aux.Stringid(50000057,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,50000057)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,0x1c0)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c50000057.cost)
    e4:SetTarget(c50000057.controltg)
    e4:SetOperation(c50000057.controlop)
    c:RegisterEffect(e4)
    --to grave
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetOperation(c50000057.regop)
    c:RegisterEffect(e5) 
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(50000057,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCondition(c50000057.spcon)
    e6:SetTarget(c50000057.sptg)
    e6:SetOperation(c50000057.spop)
    c:RegisterEffect(e6)
end
---
function c50000057.tgval(e,re,rp)
    return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c50000057.indescon(e)
    return e:GetHandler():GetLinkedGroup():FilterCount(c50000057.linkfilter,nil)>0
end
function c50000057.linkfilter(c)
    return c:IsSetCard(0x50c)
end
---
function c50000057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c50000057.controltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c50000057.controlop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
    end
end
---
function c50000057.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(50000057)~=0
end
function c50000057.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(50000057,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50000057.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000057.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
        Duel.SpecialSummonComplete()
    end
end