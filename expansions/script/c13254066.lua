--飞球之天界
function c13254066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,13254066)
	e2:SetTarget(c13254066.target)
	e2:SetOperation(c13254066.activate)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c13254066.reptg)
	e3:SetOperation(c13254066.repop)
	c:RegisterEffect(e3)
	
end
function c13254066.filter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13254066.disfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c13254066.thfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c13254066.thfilter1(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c13254066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c13254066.thfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c13254066.filter,tp,LOCATION_HAND,0,1,nil) and g:IsExists(c13254066.thfilter1,1,nil,g) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c13254066.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetMatchingGroupCount(c13254066.disfilter,p,LOCATION_HAND,0,nil)<1 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(p,c13254066.disfilter,p,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)~=1 then return end
	local g=Duel.GetMatchingGroup(c13254066.thfilter,p,LOCATION_DECK,0,nil)
	local tg=g:Filter(c13254066.thfilter1,nil,g)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
	local hg=tg:Select(p,1,1,nil)
	local hc=tg:Filter(Card.IsCode,hg:GetFirst(),hg:GetFirst():GetCode()):GetFirst()
	hg:AddCard(hc)
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-p,hg)
end
function c13254066.repfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254066.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c13254066.repfilter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(13254066,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c13254066.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c13254066.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
