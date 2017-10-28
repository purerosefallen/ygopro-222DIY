--LA Da'ath 刻薄的卡麥兒
function c1200047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfba),4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200047,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c1200047.cost)
	e1:SetTarget(c1200047.target)
	e1:SetOperation(c1200047.operation)
	c:RegisterEffect(e1)
end
function c1200047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1200047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c1200047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0) then return false end
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if (tc:IsSetCard(0xfba) or tc:IsSetCard(0xfbc)) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	if not (tc:IsSetCard(0xfba) or tc:IsSetCard(0xfbc)) then Duel.Overlay(e:GetHandler(),Group.FromCards(tc)) end
end