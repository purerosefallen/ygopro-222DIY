--Stars 整装待发·T
local m=50008881
local cm=_G["c"..m]
function cm.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetDescription(aux.Stringid(50008881,0))
    e1:SetCountLimit(1,50008881)
    e1:SetCost(c50008881.drcost)
    e1:SetTarget(c50008881.drtg)
    e1:SetOperation(c50008881.drop)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetDescription(aux.Stringid(50008881,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,50008881)
    e2:SetCost(c50008881.thcost)
    e2:SetTarget(c50008881.thtg)
    e2:SetOperation(c50008881.thop)
    c:RegisterEffect(e2)
end
function c50008881.filter(c)
    return (((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x50b))
        or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x50b))) and not c:IsCode(50008881)
         and c:IsAbleToRemoveAsCost()
end
function c50008881.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008881.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008881.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008881.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50008881.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
---

function c50008881.thfilter(c)
    return c:IsSetCard(0x50b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c50008881.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50008881.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50008881.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50008881.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50008881.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
