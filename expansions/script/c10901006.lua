--卡莲·克鲁兹
local m=10901006
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
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,m)
    e4:SetCondition(cm.damcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1)
    e5:SetCondition(cm.damcon)
    e5:SetTarget(cm.damtg)
    e5:SetOperation(cm.damop)
    c:RegisterEffect(e5)
end
function cm.sumcon(e)
    return Duel.GetTurnCount()<5
end
function cm.drfilter(c)
    return c:IsFaceup() and c:IsCode(10901008)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.desfilter(c)
    return c:IsFaceup()
end
function cm.desfilter2(c,e)
    return cm.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and cm.desfilter(chkc) end
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
        local tg=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_ONFIELD,nil) 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectTarget(tp,cm.desfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,1000,REASON_EFFECT,true)
    Duel.Damage(tp,1000,REASON_EFFECT,true)
    Duel.RDComplete()
end
