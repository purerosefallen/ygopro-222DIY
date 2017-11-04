--万年的重逢
local m=10901012
local cm=_G["c"..m]
function cm.initial_effect(c)
    --disable
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_SZONE)
    e0:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e0:SetTarget(cm.disable)
    e0:SetCondition(cm.sumcon)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e0) 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)    
end
function cm.disable(e,c)
    return c==e:GetHandler()
end
function cm.sumcon(e)
    return Duel.GetTurnCount()<10
end
function cm.filter(c,e,tp)
    return c:IsCode(10901000) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.posfilter(c)
    return not c:IsPosition(POS_FACEUP_DEFENSE) and not c:IsType(TYPE_LINK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnCount()<10 then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEDOWN_DEFENSE)~=0 then
        Duel.BreakEffect()
        local g2=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        Duel.ChangePosition(g2,POS_FACEUP_DEFENSE)
    end
end

