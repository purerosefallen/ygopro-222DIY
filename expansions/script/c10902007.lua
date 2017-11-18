--星彩的背弃者
local m=10902007
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,3)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.discon)
    e2:SetCost(cm.discost)
    e2:SetTarget(cm.distg)
    e2:SetOperation(cm.disop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10441498,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_RELEASE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.thcon)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(cm.distarget)
    e4:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e4)    
end
function cm.distarget(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and not (c:GetEquipCount()~=0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x235))
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x235) and c:IsAbleToGraveAsCost()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.ngfilter(c,g)
    return c:IsType(TYPE_MONSTER) and g:IsContains(c) and not c:IsDisabled()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.ngfilter,1,nil,lg) end
    local g=Duel.SelectReleaseGroup(tp,cm.ngfilter,1,1,nil,lg)
    Duel.Release(g,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.thfilter2(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:IsSetCard(0x235)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.thfilter2,1,e:GetHandler(),tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local lp=Duel.GetLP(1-tp)
    Duel.SetLP(1-tp,lp-1000)
end
