--盗骸者
function c22201101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22201101.cost)
	e1:SetTarget(c22201101.target)
	e1:SetOperation(c22201101.activate)
	c:RegisterEffect(e1)
end
function c22201101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	local rc=rg:GetFirst()
	if rc:IsType(TYPE_MONSTER) then e:SetLabel(1)
	elseif rc:IsType(TYPE_SPELL) then e:SetLabel(2)
	elseif rc:IsType(TYPE_TRAP) then e:SetLabel(3)
	else e:SetLabel(0)
	end
end
function c22201101.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22201101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c22201101.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22201101.tgfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c22201101.tgfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if e:GetLabel()==1 then Duel.SetChainLimit(c22201101.chainlimit1)
		elseif e:GetLabel()==2 then Duel.SetChainLimit(c22201101.chainlimit2)
		elseif e:GetLabel()==3 then Duel.SetChainLimit(c22201101.chainlimit3)
		end
	end
end
function c22201101.chainlimit1(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function c22201101.chainlimit2(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_SPELL)
end
function c22201101.chainlimit3(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_TRAP)
end
function c22201101.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
	--if tc:IsLocation(LOCATION_HAND) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c22201101.drcon)
		e2:SetTarget(c22201101.drtg)
		e2:SetOperation(c22201101.drop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e3,tp)
	--end
end
function c22201101.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject()) and ep==tp
end
function c22201101.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22201101.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end