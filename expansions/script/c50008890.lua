--Stars 北斗·开幕
local m=50008890
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50008890,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,50008890)
    e1:SetCost(c50008890.cost)   
    e1:SetCondition(c50008890.drcon)
    e1:SetTarget(c50008890.drtg)
    e1:SetOperation(c50008890.drop)
    c:RegisterEffect(e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c50008890.rmdrcost)
    e2:SetTarget(c50008890.rmdrtg)
    e2:SetOperation(c50008890.rmdrop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_REMOVE)
    e3:SetOperation(c50008890.spreg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50008890,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c50008890.spcon)
    e4:SetTarget(c50008890.sptg)
    e4:SetOperation(c50008890.spop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c50008890.rmdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008890.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008890.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008890.filter(c)
    return c:IsFaceup() and c:IsAbleToDeck()
end
function c50008890.sfilter(c,tp)
    return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function c50008890.rmdrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c50008890.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c50008890.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c50008890.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50008890.rmdrop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(c50008890.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
    if g:IsExists(c50008890.sfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
---
function c50008890.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50b) and c:IsAbleToRemoveAsCost()
end
function c50008890.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008890.costfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008890.costfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008890.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c50008890.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c50008890.drop(e,tp,eg,ep,ev,re,r,rp)
    local d1=Duel.Draw(tp,1,REASON_EFFECT)
    local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
    if d1==0 or d2==0 then return end
end
---
function c50008890.handcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c50008890.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c50008890.handop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(tp,1)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end
---
function c50008890.spreg(e,tp,eg,ep,ev,re,r,rp)
    if not re then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if c:IsReason(REASON_COST) then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(50008890,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
function c50008890.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(50008890)>0
end
function c50008890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():ResetFlagEffect(50008890)
end
function c50008890.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end