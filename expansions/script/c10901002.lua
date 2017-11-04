--枢都夏莲
local m=10901002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --summon limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetCondition(cm.sumcon)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6) 
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(21297224,0))
    e7:SetCategory(CATEGORY_RECOVER)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(cm.target)
    e7:SetOperation(cm.operation)
    c:RegisterEffect(e7)   
end
function cm.sumcon(e)
    return Duel.GetTurnCount()>4
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0x234) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
