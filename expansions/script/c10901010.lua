--流放
local m=10901010
local cm=_G["c"..m]
function cm.initial_effect(c)
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
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)    
end
function cm.disable(e,c)
    return c==e:GetHandler()
end
function cm.sumcon(e)
    return Duel.GetTurnCount()<5
end
function cm.drfilter(c)
    return c:IsFaceup() and c:IsCode(10901008)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.filter(c)
    return c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
