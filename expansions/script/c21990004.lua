--奇迹 新星辉煌之夜
function c21990004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21990004+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c21990004.activate)
	c:RegisterEffect(e1)
	if not c21990004.global_check then
		c21990004.global_check=true
		c21990004[0]=0
		c21990004[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21990004.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c21990004.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c21990004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsType(TYPE_QUICKPLAY) and not tc:IsCode(21990004) then
			c21990004[tc:GetControler()]=c21990004[tc:GetControler()]+1
		end
		tc=eg:GetNext()
	end
end
function c21990004.clear(e,tp,eg,ep,ev,re,r,rp)
	c21990004[0]=0
	c21990004[1]=0
end
function c21990004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c21990004.effcon)
	e3:SetOperation(c21990004.effop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c21990004.effcon(e,tp,eg,ep,ev,re,r,rp)
	return c21990004[e:GetHandler():GetControler()]>0
end
function c21990004.filter(c)
	return (c:IsSetCard(0xa219) or c:IsSetCard(0x9219)) and c:IsAbleToHand() and not c:IsCode(21990004)
end
function c21990004.effop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c21990004.filter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and c21990004[e:GetHandler():GetControler()]>0 and Duel.SelectYesNo(tp,aux.Stringid(21990004,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local g2=Duel.GetMatchingGroup(c21990004.filter,tp,LOCATION_GRAVE,0,nil)
	if g2:GetCount()>0 and c21990004[e:GetHandler():GetControler()]>1 and Duel.SelectYesNo(tp,aux.Stringid(21990004,1)) then
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
	if c21990004[e:GetHandler():GetControler()]>2 and Duel.SelectYesNo(tp,aux.Stringid(21990004,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end