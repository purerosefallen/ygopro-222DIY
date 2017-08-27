--空間女神 聖靈法師
function c80005022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80005022.synfilter,5,2)
	c:EnableReviveLimit()  
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80005022,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,80005022)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c80005022.cost)
	e1:SetTarget(c80005022.target)
	e1:SetOperation(c80005022.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c80005022.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80005022.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5) 
	--disable spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c80005022.sumlimit)
	c:RegisterEffect(e7)  
end
function c80005022.tgtg(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_SPELLCASTER)
end
function c80005022.synfilter(c)
	return c:GetTextAttack()==-2 and c:GetTextDefense()==-2 and c:IsRace(RACE_SPELLCASTER)
end
function c80005022.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLevelAbove(7)
end
function c80005022.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)*500
end
function c80005022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80005022.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeck()
end
function c80005022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80005022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80005022.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c80005022.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80005022.operation(e,tp,eg,ep,ev,re,r,rp)
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