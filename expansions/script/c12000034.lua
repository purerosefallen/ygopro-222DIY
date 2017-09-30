--奇迹糕点 提拉米苏
function c12000034.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfbe),4,2)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000034,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,12000034)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12000034.cost)
	e1:SetTarget(c12000034.target)
	e1:SetOperation(c12000034.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000034,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12000134)
	e2:SetCondition(c12000034.discon)
	e2:SetTarget(c12000034.distg)
	e2:SetOperation(c12000034.disop)
	c:RegisterEffect(e2)
end
function c12000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12000034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,0,LOCATION_GRAVE)>0 
	end
end
function c12000034.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5)
	local slv=Duel.GetFieldGroupCount(1-tp,0,LOCATION_GRAVE)
	local checkm=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	g:Remove(Card.IsLevelAbove,nil,slv+1)
	if g:GetCount()>0 and checkm>0 and slv>0 then
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			g:RemoveCard(tc)
			slv=slv-tc:GetLevel()
			Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
			g:Remove(Card.IsLevelAbove,nil,slv+1)
		until g:GetCount()==0 or slv<=0 or not Duel.SelectYesNo(tp,aux.Stringid(12000034,2))
	end
end
function c12000034.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c12000034.filter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToDeck()
end
function c12000034.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c12000034.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12000034.filter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12000034.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c12000034.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
