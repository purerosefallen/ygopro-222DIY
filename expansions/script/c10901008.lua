--Never Island
local m=10901008
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
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e9:SetCode(EFFECT_SELF_DESTROY)
    e9:SetRange(LOCATION_FZONE)
    e9:SetCondition(cm.descon)
    c:RegisterEffect(e9)  
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
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.dscon)
    e4:SetTarget(cm.destg)
    e4:SetOperation(cm.desop)
    c:RegisterEffect(e4)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
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
    return Duel.GetTurnCount()<5
end
function cm.descon(e)
    return Duel.GetTurnCount()>9
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
        Duel.Draw(p,ct+1,REASON_EFFECT)
    end
end
function cm.dscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
    if g:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end
