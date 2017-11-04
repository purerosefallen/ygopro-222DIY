--御原凛音
local m=10901000
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
    --flip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)   
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(cm.condition)
    e5:SetCountLimit(1,m)
    e5:SetTarget(cm.destg)
    e5:SetOperation(cm.desop)
    c:RegisterEffect(e5) 
end
function cm.sumcon(e)
    return Duel.GetTurnCount()>4
end
function cm.filter(c)
    return c:IsSetCard(0x234) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.drfilter(c)
    return c:IsFaceup() and c:IsCode(10901003)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
