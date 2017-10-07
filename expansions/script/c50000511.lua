--灵装之星宿骑士
local m=50000511
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
    --link summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c50000511.linkcon)
    e0:SetOperation(c50000511.linkop)
    e0:SetValue(SUMMON_TYPE_LINK)
    c:RegisterEffect(e0)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000511,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,50000511)
    e1:SetTarget(c50000511.sptg)
    e1:SetOperation(c50000511.spop)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000511,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCountLimit(1,500005111)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c50000511.discon)
    e2:SetTarget(c50000511.distg)
    e2:SetOperation(c50000511.disop)
    c:RegisterEffect(e2)
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c50000511.atkval)
    c:RegisterEffect(e3)
end

function c50000511.linkfilter(c,lc,tp)
    return c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
end
function c50000511.linkcheck(g,tp,lc)
    return aux.LCheckGoal(tp,g,lc,2,g:GetCount()) and g:IsExists(function(c)
        return c:IsSetCard(0x50e) and not g:IsExists(Card.IsType,1,c,TYPE_TOKEN)
    end,1,nil)
end
function c50000511.linkcon(e,c)
    if c==nil then return true end 
    if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c50000511.linkfilter,tp,LOCATION_MZONE,0,nil,c)
    return Senya.CheckGroup(g,c50000511.linkcheck,nil,2,4,tp,c)
end
function c50000511.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c50000511.linkfilter,tp,LOCATION_MZONE,0,nil,c)
    local g1=Senya.SelectGroup(tp,0,g,c50000511.linkcheck,nil,2,4,tp,c)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
---
function c50000511.spfilter(c,e,tp,zone)
    return c:IsSetCard(0x50e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c50000511.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local zone=e:GetHandler():GetLinkedZone()
        return zone~=0 and Duel.IsExistingMatchingCard(c50000511.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50000511.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone()
    if zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50000511.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
--
function c50000511.discon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetMutualLinkedGroupCount()>=2
    and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c50000511.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c50000511.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c50000511.atkval(e,c)
    return c:GetLinkedGroupCount()*400
end