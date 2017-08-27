--不老不死の欲望
function c114001097.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114001097,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,114001097)
	e2:SetTarget(c114001097.gtg)
	e2:SetOperation(c114001097.gop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(114001097,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c114001097.thcon)
	e3:SetCost(c114001097.thcost)
	e3:SetTarget(c114001097.thtg)
	e3:SetOperation(c114001097.thop)
	c:RegisterEffect(e3)
end
function c114001097.filter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsLevelBelow(5)
end
function c114001097.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001097.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c114001097.gop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=5
	local sg=Duel.GetMatchingGroup(c114001097.filter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()==0 then return end
	local tg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		lv=lv-tc:GetLevel()
		sg:Remove(Card.IsLevelAbove,nil,lv+1)
		tg:AddCard(tc)
	until sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(114001097,2))
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
function c114001097.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER):GetCount()>=5
end
function c114001097.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
--stone determine
function c114001097.IsKeyT(c,f,v)
	local f=f or Card.GetCode
	local t={f(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.Philosopher then return true end --and (not v or m.XiangYuan_name_keyrune==v)
	end
	return false
end
--
function c114001097.filter2(c)
	return ( c114001097.IsKeyT(c) or c:IsCode(80831721) ) and c:IsAbleToHand()
end
function c114001097.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001097.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114001097.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114001097.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end