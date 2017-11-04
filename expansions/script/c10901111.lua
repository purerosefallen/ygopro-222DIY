--御原玖音
local m=10901111
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_MZONE)
    e0:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e0:SetTarget(cm.disable)
    e0:SetCondition(cm.sumcon)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e0)      
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x234))
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)   
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetTarget(cm.distarget)
    c:RegisterEffect(e3) 
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(cm.effectfilter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(cm.effectfilter)
    c:RegisterEffect(e5) 
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,0))
    e6:SetCategory(CATEGORY_DISABLE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_CHAINING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(cm.discon)
    e6:SetCost(cm.cost)
    e6:SetTarget(cm.distg)
    e6:SetOperation(cm.disop)
    c:RegisterEffect(e6)
end
function cm.disable(e,c)
    return c==e:GetHandler()
end
function cm.sumcon(e)
    return Duel.GetTurnCount()<10
end
function cm.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    return p==tp and te:IsActiveType(TYPE_SPELL)
end
function cm.distarget(e,c)
    return c:IsType(TYPE_SPELL)
end
function cm.costfilter(c)
    return c:IsSetCard(0x234) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return Duel.IsChainDisablable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateEffect(ev)
end
