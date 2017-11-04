--伽蓝堂纱罗
local m=10901001
local cm=_G["c"..m]
function cm.initial_effect(c)
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
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(cm.spcon)
    c:RegisterEffect(e4)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(m,1))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(cm.condition)
    e7:SetTarget(cm.destg)
    e7:SetOperation(cm.desop)
    c:RegisterEffect(e7)
end
function cm.sumcon(e)
    return Duel.GetTurnCount()>4
end
function cm.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x234)
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnCount()<5
end
function cm.drfilter(c)
    return c:IsFaceup() and c:IsCode(10901003)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
