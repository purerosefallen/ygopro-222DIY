--被侵蚀的星之援军
function c50000504.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(c50000504.linkfilter),2)
    c:EnableReviveLimit()
    --move
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50000504,0))    
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c50000504.movecost)
    e1:SetTarget(c50000504.seqtg)
    e1:SetOperation(c50000504.seqop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000504,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,50000504)
    e2:SetCondition(c50000504.thcon)
    e2:SetTarget(c50000504.thtg)
    e2:SetOperation(c50000504.thop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50000504,0))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCondition(c50000504.tdcon)
    e3:SetTarget(c50000504.tdtg)
    e3:SetOperation(c50000504.tdop)
    c:RegisterEffect(e3)
end
function c50000504.cfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c50000504.movecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000504.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c50000504.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c50000504.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local scount=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if scount==0 then return end
    return true
end
function c50000504.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler() 
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
    local nseq=0
    if s==1 then nseq=0
    elseif s==2 then nseq=1
    elseif s==4 then nseq=2
    elseif s==8 then nseq=3
    else nseq=4 end
    Duel.MoveSequence(c,nseq)
end
--
function c50000504.linkfilter(c,e)
    return c:IsFaceup() and c:IsSetCard(0x50e) and c:IsType(TYPE_MONSTER)
end
---
function c50000504.thfilter(c)
    return c:IsSetCard(0x50e) and c:IsAbleToHand()
end
function c50000504.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000504.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c50000504.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50000504.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
---
function c50000504.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c50000504.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50000504.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
    local ct=e:GetHandler():GetMutualLinkedGroupCount()
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50000504.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end