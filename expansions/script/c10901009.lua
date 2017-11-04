--阿瓦隆的突袭
local m=10901009
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
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.chtg)
    e1:SetOperation(cm.chop)
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
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,0,LOCATION_HAND)>0 end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(tp,1)
    Duel.SendtoGrave(sg,REASON_EFFECT)
end
