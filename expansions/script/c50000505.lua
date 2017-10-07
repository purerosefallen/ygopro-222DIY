--呼唤神星的灵女
function c50000505.initial_effect(c)
    --link summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c50000505.linkcon)
    e0:SetOperation(c50000505.linkop)
    e0:SetValue(SUMMON_TYPE_LINK)
    c:RegisterEffect(e0)
    c:EnableReviveLimit()
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000505,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,50000505)
    e1:SetCondition(c50000505.spcon)
    e1:SetTarget(c50000505.thtg)
    e1:SetOperation(c50000505.thop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(c50000505.incon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(c50000505.inval)
    c:RegisterEffect(e3)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetTarget(c50000505.disable)
    c:RegisterEffect(e4)
    --atk&def
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SET_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetValue(0)
    e5:SetTarget(c50000505.ad)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_SET_DEFENSE)
    c:RegisterEffect(e6)
end
function c50000505.disable(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and(c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function c50000505.ad(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) 
end
---
function c50000505.linkfilter1(c,lc,tp)
    return c:IsFaceup() and c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN) and c:IsCanBeLinkMaterial(lc) and Duel.IsExistingMatchingCard(c50000505.linkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function c50000505.linkfilter2(c,lc,mc,tp)
    local mg=Group.FromCards(c,mc)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TOKEN) and c:IsCanBeLinkMaterial(lc) and not c:IsRace(mc:GetRace()) and not c:IsAttribute(mc:GetAttribute())  and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c50000505.linkcon(e,c)
    if c==nil then return true end
    if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c50000505.linkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c50000505.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectMatchingCard(tp,c50000505.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
    local g2=Duel.SelectMatchingCard(tp,c50000505.linkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
---
function c50000505.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c50000505.thfilter(c)
    return c:IsSetCard(0x50e) and c:IsAbleToHand()
end
function c50000505.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000505.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c50000505.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50000505.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--
function c50000505.incon(e)
    return e:GetHandler():GetLinkedGroupCount()>0
end
function c50000505.inval(e,re,r,rp)
    return rp~=e:GetHandlerPlayer()
end