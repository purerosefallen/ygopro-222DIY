--星彩的天使
local m=10902005
local cm=_G["c"..m]
function cm.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(3064425,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.eqcon)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)   
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)   
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(59755122,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(cm.spcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(cm.discon)
    e4:SetOperation(cm.disop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,m)
    e5:SetTarget(cm.sptg)
    e5:SetOperation(cm.spop)
    c:RegisterEffect(e5)
end
function cm.filter(c)
    return c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(cm.eqlimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(cm.efilter)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
end
function cm.eqlimit(e,c)
    return c:IsFaceup()
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
        and te:IsActiveType(TYPE_MONSTER)
end
function cm.seqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x235)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    local c=e:GetHandler()
    return ep~=tp and c:GetSummonLocation()==LOCATION_SZONE and not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsType(TYPE_SPELL)) and loc==LOCATION_HAND 
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
function cm.scfilter(c,g)
    return g:IsContains(c) and c:IsSetCard(0x235) and c:IsFaceup()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local cg=e:GetHandler():GetColumnGroup()
    if chkc then return chkc:IsOnField() and cm.scfilter(chkc,cg) end
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.scfilter,1,nil,cg) end
    local g=Duel.SelectReleaseGroup(tp,cm.scfilter,1,1,nil,cg)
    Duel.Release(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
