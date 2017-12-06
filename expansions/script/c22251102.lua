--惊喜还是惊吓？
function c22251102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22251102,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(2,22251102+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22251102.cost)
	e1:SetTarget(c22251102.target)
	e1:SetOperation(c22251102.activate)
	c:RegisterEffect(e1)
	--ind
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22251102,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22251102.cost2)
	e2:SetTarget(c22251102.tg)
	e2:SetOperation(c22251102.op)
	c:RegisterEffect(e2)
end
c22251102.named_with_Riviera=1
function c22251102.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22251102.filter(c)
	return c22251102.IsRiviera(c) and c:IsAbleToGrave()
end
function c22251102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251102.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c22251102.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,22251102,0,0,0)
	local flag=Duel.GetFlagEffect(tp,22251102)
	if flag%3~=0 then
		e:SetLabel(0)
	else
		e:SetLabel(1)
	end
end
function c22251102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=Duel.GetFlagEffect(tp,22251102)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c22251102.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif e:GetLabel()==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		while Duel.GetFieldGroupCount(p,LOCATION_HAND,0)>2 do
			Duel.DiscardHand(p,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		end
	end
end
function c22251102.costfilter(c)
	return c:IsCode(22251102) and c:IsAbleToDeckAsCost()
end
function c22251102.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22251102.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>1 end
	local rg=g:RandomSelect(tp,2)
	Duel.SendtoDeck(rg,nil,1,REASON_COST)
end
function c22251102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22251102.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if c22251102.IsRiviera(tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsSummonable(true,e,0) then
			if Duel.SelectYesNo(tp,aux.Stringid(22251102,2)) then
				Duel.Summon(tp,tc,true,nil,0)
			else 
				Duel.ConfirmCards(1-tp,tc)
				Duel.ShuffleHand(tp)
			end
		elseif not (c22251102.IsRiviera(tc) and tc:IsType(TYPE_MONSTER)) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end