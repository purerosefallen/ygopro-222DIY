--乐园之岛
local m=10901003
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --disable
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_FZONE)
    e0:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e0:SetTarget(cm.disable)
    e0:SetCondition(cm.sumcon)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e0)    
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(cm.drtg)
    e3:SetOperation(cm.drop)
    c:RegisterEffect(e3) 
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(cm.target)
    e4:SetValue(cm.indct)
    c:RegisterEffect(e4) 
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e5=e2:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=e2:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
end
function cm.disable(e,c)
    return c==e:GetHandler()
end
function cm.sumcon(e)
    return Duel.GetTurnCount()>4
end
function cm.drfilter(c)
    return c:IsSetCard(0x234) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(p,cm.drfilter,p,LOCATION_HAND,0,1,63,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-p,g)
        local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(p)
        Duel.BreakEffect()
        Duel.Draw(p,ct,REASON_EFFECT)
    end
end
function cm.target(e,c)
    return c:IsSetCard(0x234)
end
function cm.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE)~=0 then
        return 1
    else return 0 end
end
function cm.filter(c)
    return c:IsSetCard(0x234) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
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

