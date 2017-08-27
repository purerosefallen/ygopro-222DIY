--口袋妖怪 太阳精灵
function c80000034.initial_effect(c)
c:SetUniqueOnField(1,0,80000034)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,80000000,c80000034.ffilter,1,true,false) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,80000034+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80000034.cost)
	e1:SetTarget(c80000034.target)
	e1:SetOperation(c80000034.activate)
	c:RegisterEffect(e1) 
	Duel.AddCustomActivityCounter(80000034,ACTIVITY_SPSUMMON,c80000034.counterfilter)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c80000034.reptg)
	c:RegisterEffect(e3)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(c80000034.sumlimit)
	c:RegisterEffect(e7)
end
function c80000034.counterfilter(c)
	return c:IsSetCard(0x2d0)
end
function c80000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c80000034.splimit(e,c)
	return not c:IsSetCard(0x2d0)
end
function c80000034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) and Duel.CheckLPCost(tp,1000) end
	if Duel.SelectYesNo(tp,aux.Stringid(80000034,3)) then
		Duel.PayLPCost(tp,1000)
		return true
	else return false end
end
function c80000034.ffilter(c)
	return c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c80000034.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function c80000034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c80000034.filter(c)
	return c:IsSetCard(0x2d0)
end
function c80000034.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,2)
	local g=Duel.GetDecktopGroup(p,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c80000034.filter,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,sg)
				Duel.ShuffleHand(p)
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(p)
	end
end