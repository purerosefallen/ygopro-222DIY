--灵装之星宿精灵
local m=50000512
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x50e),2)
    c:EnableReviveLimit()
    --IMMUNE
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetValue(c50000512.efilter)
    e1:SetTarget(c50000512.tgtg)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000512,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,50000512)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCost(c50000512.cost)
    e2:SetTarget(c50000512.target)
    e2:SetOperation(c50000512.operation)
    c:RegisterEffect(e2)
end
function c50000512.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c50000512.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP+TYPE_SPELL) 
end

function c50000512.cfilter(c)
    return c:IsSetCard(0x50e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c50000512.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000512.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50000512.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50000512.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000512.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
        Duel.SpecialSummonComplete()
    end
end
