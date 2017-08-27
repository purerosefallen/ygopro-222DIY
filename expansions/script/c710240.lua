--失落的圣遗物
function c710240.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,710240)
	e1:SetTarget(c710240.thtg)
	e1:SetOperation(c710240.thop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c710240.eqcost)
	e2:SetTarget(c710240.eqtg)
	e2:SetOperation(c710240.eqop)
	c:RegisterEffect(e2)
end

c710240.is_named_with_Relic=1
function c710240.IsRelic(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_Relic
end

function c710240.thfilter1(c)
	return c710240.IsRelic(c) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c710240.thfilter2(c)
	return c710240.IsRelic(c) and c:IsType(TYPE_EQUIP)
end
function c710240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c710240.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c710240.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c710240.thfilter2,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local cg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			cg:Merge(sg)
		end
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=cg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			cg:RemoveCard(tc)
		end
		Duel.SendtoGrave(cg,REASON_EFFECT)
	end
end

function c710240.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c710240.eqfilter(c,ec)
	return c710240.IsRelic(c) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c710240.eqfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(c710240.eqfilter,tp,LOCATION_GRAVE,0,1,nil,c) 
end
function c710240.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c710237.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) 
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c710240.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local h=Duel.SelectMatchingCard(tp,c710240.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(710240,1))
	local g=Duel.SelectMatchingCard(tp,c710240.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,h:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tc=g:GetFirst()
	Duel.Equip(tp,tc,h:GetFirst())
end
